From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC] replace dm hw handlers with scsi handlers
Date: Thu, 12 Oct 2006 15:18:30 -0500
Message-ID: <1160684310.4163.4.camel@madmax>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is the same patch (as far as approach and design goes)
as before with some modifications and updates to Jen's
cmd_type code and I tried converting Ed's newer EMC code
which is a lot more complicated (sends multiple commands for
failover) to make sure it looks like it could work. Ed' does
this look ok and will work for all that you need it to. I
converted your code pretty closely. There were some bugs
in the patch posted to dm-devel where you called
dm_pg_init_compelete multiple times on the same pg_init
which I do think is right (I did not copy that). And let
me just make sure I saw the code, right, and that you
could need to do a inquiry, mode select and then another
inquiry.

This patch is a rough outline of what we could do. I do not
think the code completely works today (I will try to get
access to a clarriion box in a soon so I can try it out).
There are some issues with how the cmd_type stuff should
work that I am not sure about (See TODOs in patch for more
details). But as I said the last go around, dm-multipath
just sticks a activate device cmd_type request into
the lower level devices queue. The LLD (scsi in this case)
then will call into some scsi_device_template that is
specific to the hw and that module will do whatever commands
it needs to do. When it is finished it notifies scsi-ml
that is is done and scsi-ml passes the activate device cmd_type request
and its result upwards until in this case dm-mutlipath
gets it back and fails the path groups or tries another
path in the group or whatever it wants to do.

For the scsi_emc_clariion module, I still need to add in
some interface so we can configure the device for
different tresspass commands (Ed or Hannes what did you say was
a safe default for these boxes). Again some of the emc check sense
code is a little stupid in that it does the same thing as
scsi-ml. I kept that in there as an example of how it would
work for when we want different behavior.

Changes since v1:

- Bind per device instead of per target to allow for
per LU failover.
- Merge Ed's updated dm-emc code into scsi_emc_clariion.
- Add basic code to hook into REQ_TYPE_LINUX_BLOCK cmd_type
(must ask Jens if this is how he wanted it).
- Do a partial conversion of dm-mpath.c (hooked dm-mpath.c
in, but all the hw handler code can now be removed (will
do this in a seperate patch to reduce noise)).
- added device_id table to bind devices to modules by.
Must ask Hannes if this is ok because he was set on
compiling this into the kernel and binding off the
devinfo list. The problem with this is that these
scsi hw handlers look like they can get to be a good
size and I do not want to compile it into the kernel
when most people do not need it.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 block/ll_rw_blk.c                |    2 
 drivers/md/dm-mpath.c            |   55 +++++
 drivers/scsi/Kconfig             |   11 +
 drivers/scsi/Makefile            |    1 
 drivers/scsi/scsi.c              |   52 +++++
 drivers/scsi/scsi_emc_clariion.c |  421 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/scsi_error.c        |    9 +
 drivers/scsi/scsi_lib.c          |   45 ++++
 drivers/scsi/scsi_scan.c         |    1 
 drivers/scsi/scsi_sysfs.c        |    3 
 include/linux/blkdev.h           |   12 +
 include/scsi/scsi_cmnd.h         |    1 
 include/scsi/scsi_device.h       |   26 ++
 13 files changed, 634 insertions(+), 5 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index c847e17..af72cab 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -3273,7 +3273,7 @@ static int __end_that_request_first(stru
 	 * for a REQ_BLOCK_PC request, we want to carry any eventual
 	 * sense key with us all the way through
 	 */
-	if (!blk_pc_request(req))
+	if (!blk_pc_request(req) && !blk_linux_request(req))
 		req->errors = 0;
 
 	if (!uptodate) {
diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index d754e0b..10138a5 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -379,10 +379,59 @@ static void dispatch_queued_ios(struct m
 	}
 }
 
+/* TODO rearrange code and cleanup old code in next patch */
+static int fail_path(struct pgpath *pgpath);
+static void bypass_pg(struct multipath *m, struct priority_group *pg,
+		      int bypassed);
+
+static void pg_init_done(struct request *req, int err)
+{
+	struct path *path = req->end_io_data;
+	struct pgpath *pgpath = path_to_pgpath(path);
+	struct priority_group *pg = pgpath->pg;
+	struct multipath *m = pg->m;
+	unsigned long flags;
+
+	/* We insist on failing the path if the PG is already bypassed. */
+	if ((req->errors && pg->bypassed) ||
+	    (req->errors == BLK_ACTIVATE_FAILED))
+		fail_path(pgpath);
+
+	if (req->errors == BLK_ACTIVATE_BYPASS_DEV)
+		bypass_pg(m, pg, 1);
+
+	spin_lock_irqsave(&m->lock, flags);
+	if (req->errors) {
+		m->current_pgpath = NULL;
+		m->current_pg = NULL;
+	} else if (!m->pg_init_required)
+		m->queue_io = 0;
+
+	m->pg_init_in_progress = 0;
+	queue_work(kmultipathd, &m->process_queued_ios);
+	spin_unlock_irqrestore(&m->lock, flags);
+}
+
+static void pg_init(struct path *path)
+{
+	struct request *req;
+
+	req = blk_get_request(bdev_get_queue(path->dev->bdev), 1, GFP_NOIO);
+	if (!req) {
+		/* retry later */
+		dm_pg_init_complete(path, MP_BYPASS_PG);
+		return;
+	}
+
+	req->cmd[0] = REQ_LB_OP_ACTIVATE;
+	req->cmd_type = REQ_TYPE_LINUX_BLOCK;
+	req->end_io_data = path;
+	blk_execute_rq_nowait(req->q, NULL, req, 1, pg_init_done);
+}
+
 static void process_queued_ios(void *data)
 {
 	struct multipath *m = (struct multipath *) data;
-	struct hw_handler *hwh = &m->hw_handler;
 	struct pgpath *pgpath = NULL;
 	unsigned init_required = 0, must_queue = 1;
 	unsigned long flags;
@@ -411,7 +460,7 @@ out:
 	spin_unlock_irqrestore(&m->lock, flags);
 
 	if (init_required)
-		hwh->type->pg_init(hwh, pgpath->pg->bypassed, &pgpath->path);
+		pg_init(&pgpath->path);
 
 	if (!must_queue)
 		dispatch_queued_ios(m);
@@ -954,6 +1003,8 @@ static int bypass_pg_num(struct multipat
 
 /*
  * pg_init must call this when it has completed its initialisation
+ * TODO: This and all the related hw handler code can be removed in
+ * cleanup patches.
  */
 void dm_pg_init_complete(struct path *path, unsigned err_flags)
 {
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9540eb8..65524f2 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -254,6 +254,17 @@ source "drivers/scsi/libsas/Kconfig"
 
 endmenu
 
+menu "SCSI Target Drivers"
+	depends on SCSI
+
+config SCSI_CLARIION
+	tristate "EMC CLARiiON Target Driver"
+	depends on SCSI
+	help
+	  If you have a EMC CLARiiON selec y. Otherwise, say N.
+
+endmenu
+
 menu "SCSI low-level drivers"
 	depends on SCSI!=n
 
diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
index a0a77fd..1526586 100644
--- a/drivers/scsi/Makefile
+++ b/drivers/scsi/Makefile
@@ -128,6 +128,7 @@ obj-$(CONFIG_SCSI_IPR)		+= ipr.o
 obj-$(CONFIG_SCSI_IBMVSCSI)	+= ibmvscsi/
 obj-$(CONFIG_SCSI_HPTIOP)	+= hptiop.o
 obj-$(CONFIG_SCSI_STEX)		+= stex.o
+obj-$(CONFIG_SCSI_CLARIION)	+= scsi_emc_clariion.o
 
 obj-$(CONFIG_ARM)		+= arm/
 
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c59f315..a90c619 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -155,6 +155,8 @@ static struct scsi_host_cmd_pool scsi_cm
 };
 
 static DEFINE_MUTEX(host_cmd_pool_mutex);
+static DEFINE_MUTEX(sdev_template_mutex);
+static LIST_HEAD(sdev_template_list);
 
 static struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost,
 					    gfp_t gfp_mask)
@@ -1088,6 +1090,56 @@ int scsi_device_cancel(struct scsi_devic
 }
 EXPORT_SYMBOL(scsi_device_cancel);
 
+int scsi_register_device_template(struct scsi_device_template *tmpl)
+{
+	mutex_lock(&sdev_template_mutex);
+	list_add_tail(&tmpl->list, &sdev_template_list);
+	mutex_unlock(&sdev_template_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_register_device_template);
+
+void scsi_unregister_device_template(struct scsi_device_template *tmpl)
+{
+	mutex_lock(&sdev_template_mutex);
+	list_del(&tmpl->list);
+	mutex_unlock(&sdev_template_mutex);
+}
+EXPORT_SYMBOL_GPL(scsi_unregister_device_template);
+
+void scsi_bind_device_template(struct scsi_device *sdev)
+{
+	struct scsi_device_template *tmpl;
+	int i;
+
+	mutex_lock(&sdev_template_mutex);
+	if (sdev->sdevt)
+		goto done;
+
+	list_for_each_entry(tmpl, &sdev_template_list, list) {
+		i = 0;
+
+		while (tmpl->id_table[i].vendor != NULL) {
+			struct sdev_id *id = &tmpl->id_table[i++];
+
+			if (!memcmp(id->vendor, sdev->vendor,
+				    sizeof(id->vendor)) &&
+			    !memcmp(id->model, sdev->model,
+				    sizeof(id->model))) {
+				if (tmpl->setup(sdev))
+					printk(KERN_INFO
+					      "Could not bind driver to "
+					      "%s %s\n", id->vendor, id->model);
+				else
+					sdev->sdevt = tmpl;
+				break;
+			}
+		}
+	}
+done:
+	mutex_unlock(&sdev_template_mutex);
+}
+
 MODULE_DESCRIPTION("SCSI core");
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/scsi/scsi_emc_clariion.c b/drivers/scsi/scsi_emc_clariion.c
new file mode 100644
index 0000000..6a1a40e
--- /dev/null
+++ b/drivers/scsi/scsi_emc_clariion.c
@@ -0,0 +1,421 @@
+/*
+ * Target driver for EMC CLARiiON AX/CX-series hardware.
+ * Based on code from Lars Marowsky-Bree <lmb@suse.de>
+ * and Ed Goggin <egoggin@emc.com>.
+ */
+#include <linux/blkdev.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+
+#define CLARIION_TRESPASS_PAGE		0x22
+#define CLARIION_BUFFER_SIZE		0x80
+#define CLARIION_TIMEOUT		(60 * HZ)
+#define CLARIION_UNBOUND_LU		-1
+#define CLARIION_RETRIES		3
+
+struct clariion_sdev {
+        spinlock_t lock;
+	/*
+	 * Use short trespass command (FC-series) or the long version
+	 * (default for AX/CX CLARiiON arrays).
+	 */
+        unsigned short_trespass;
+	/*
+	 * Whether or not (default) to honor SCSI reservations when
+	 * initiating a switch-over.
+	 */
+	unsigned hr;
+	/* I/O buffer for both MODE_SELECT and INQUIRY commands. */
+	char buffer[CLARIION_BUFFER_SIZE];
+	/*
+	 * SCSI sense buffer for commands -- assumes serial issuance
+	 * and completion sequence of all commands for same multipath.
+	 */
+	unsigned char sense[SCSI_SENSE_BUFFERSIZE];
+	/* which SP (A=0,B=1,UNBOUND=-1) is dflt SP for path's mapped dev */
+	int default_sp;
+	/* which SP (A=0,B=1,UNBOUND=-1) is active for path's mapped dev */
+	int current_sp;
+	/*
+	 * flag when set (reset) differentiates get_sp_info after (before)
+	 * pg_init
+	*/
+	int pg_init_sent;
+};
+
+static unsigned char long_trespass[] = {
+	0, 0, 0, 0,
+	CLARIION_TRESPASS_PAGE,	/* Page code */
+	0x09,			/* Page length - 2 */
+	0x81,			/* Trespass code + Honor reservation bit */
+	0xff, 0xff,		/* Trespass target */
+	0, 0, 0, 0, 0, 0	/* Reserved bytes / unknown */
+};
+
+static unsigned char long_trespass_hr[] = {
+	0, 0, 0, 0,
+	CLARIION_TRESPASS_PAGE,	/* Page code */
+	0x09,			/* Page length - 2 */
+	0x01,			/* Trespass code + Honor reservation bit */
+	0xff, 0xff,		/* Trespass target */
+	0, 0, 0, 0, 0, 0	/* Reserved bytes / unknown */
+};
+
+static unsigned char short_trespass[] = {
+	0, 0, 0, 0,
+	CLARIION_TRESPASS_PAGE,	/* Page code */
+	0x02,			/* Page length - 2 */
+	0x81,			/* Trespass code + Honor reservation bit */
+	0xff,			/* Trespass target */
+};
+
+static unsigned char short_trespass_hr[] = {
+	0, 0, 0, 0,
+	CLARIION_TRESPASS_PAGE,	/* Page code */
+	0x02,			/* Page length - 2 */
+	0x01,			/* Trespass code + Honor reservation bit */
+	0xff,			/* Trespass target */
+};
+
+/*
+ * Parse MODE_SELECT cmd reply.
+ */
+static int parse_tresspass_rsp(struct scsi_device *sdev, char *sense,
+			       int result)
+{
+	struct scsi_sense_hdr sshdr;
+	int err = 0;
+
+	if (status_byte(result) == CHECK_CONDITION &&
+	    scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr)) {
+		sdev_printk(KERN_ERR, sdev, "Found valid sense data 0x%2x, "
+			    "0x%2x, 0x%2x while sending CLARiiON trespass "
+			    "command.\n", sshdr.sense_key, sshdr.asc,
+			     sshdr.ascq);
+
+		if ((sshdr.sense_key = 0x05) && (sshdr.asc = 0x04) &&
+		     (sshdr.ascq = 0x00)) {
+			/*
+			 * Array based copy in progress -- do not send
+			 * pg_init or copy will be aborted mid-stream.
+			 */
+			sdev_printk(KERN_INFO, sdev, "Array Based Copy in "
+				    "progress while sending CLARiiON trespass "
+				    "command.\n");
+			err = BLK_ACTIVATE_BYPASS_DEV;
+		} else if ((sshdr.sense_key = 0x02) && (sshdr.asc = 0x04) &&
+			    (sshdr.ascq = 0x03)) {
+			/*
+			 * LUN Not Ready - Manual Intervention Required
+			 * indicates in-progress ucode upgrade (NDU).
+			 */
+			sdev_printk(KERN_INFO, sdev, "Detected in-progress "
+				    "ucode upgrade NDU operation while sending "
+				    "CLARiiON trespass command.\n");
+			err = BLK_ACTIVATE_BYPASS_DEV;
+		} else
+			err = BLK_ACTIVATE_FAILED;
+	} else if (result) {
+		sdev_printk(KERN_ERR, sdev, "Error 0x%x while sending "
+			    "CLARiiON trespass command.\n", result);
+		err = BLK_ACTIVATE_FAILED;
+	}
+
+	return err;
+}
+
+static int execute_sp_info(struct request *req);
+
+static void tresspass_done(void *data, char *sense, int result, int resid)
+{
+	struct request *req = data;
+	struct scsi_device *sdev = req->q->queuedata;
+	struct clariion_sdev *csdev = sdev->sdevt_data;
+	int err_flags;
+
+	err_flags = parse_tresspass_rsp(sdev, sense, result);
+	if (err_flags) {
+		scsi_msg_done(req, err_flags);
+		return;
+	}
+
+	csdev->pg_init_sent = 1;
+	if (execute_sp_info(req))
+		scsi_msg_done(req, BLK_ACTIVATE_RES_TEMP_UNAVAIL);
+}
+
+static int execute_tresspass(struct request *req)
+{
+	struct scsi_device *sdev = req->q->queuedata;
+	struct clariion_sdev *csdev = sdev->sdevt_data;
+	unsigned char *page22;
+	unsigned size;
+	unsigned char cmd[MAX_COMMAND_SIZE];
+
+	if (csdev->short_trespass) {
+		page22 = csdev->hr ? short_trespass_hr : short_trespass;
+		size = sizeof(short_trespass);
+	} else {
+		page22 = csdev->hr ? long_trespass_hr : long_trespass;
+		size = sizeof(long_trespass);
+	}
+
+	memset(cmd, 0, MAX_COMMAND_SIZE);
+	cmd[0] = MODE_SELECT;
+	cmd[1] = 0x10;
+	cmd[4] = size;
+	memcpy(csdev->buffer, page22, size);
+	/*
+	 * TODO; return detailed error values from scsi_execute_async
+	 */
+	if (scsi_execute_async(sdev, cmd, COMMAND_SIZE(MODE_SELECT),
+				DMA_TO_DEVICE, csdev->buffer, size, 0,
+				CLARIION_TIMEOUT, CLARIION_RETRIES, req,
+				tresspass_done, GFP_ATOMIC))
+		return -EAGAIN;
+
+	return 0;
+}
+
+/*
+ * Parse EVPD 0xC0 INQUIRY cmd reply.
+ */
+static int parse_sp_info_rsp(struct scsi_device *sdev, char *sense,
+			     int result, int *default_sp, int *current_sp,
+			     int *new_current_sp)
+{
+	struct clariion_sdev *csdev = sdev->sdevt_data;
+	int err = 0;
+
+	if (result == 0) {
+		/* check for in-progress ucode upgrade (NDU) */
+		if (csdev->buffer[48] != 0) {
+			sdev_printk(KERN_INFO, sdev, "Detected in-progress "
+				   "ucode upgrade NDU operation while finding "
+				    "current active SP.\n");
+			err = BLK_ACTIVATE_BYPASS_DEV;
+		} else {
+			*default_sp = csdev->buffer[5];
+
+			if (csdev->buffer[4] == 2)
+				/* SP for path (in h->buffer[8]) is current */
+				*current_sp = csdev->buffer[8];
+			else {
+				if (csdev->buffer[4] == 1)
+					/* SP for this path is NOT current */
+					if (csdev->buffer[8] == 0)
+						*current_sp = 1;
+					else
+						*current_sp = 0;
+				else
+					/* unbound LU or LUNZ */
+					*current_sp = CLARIION_UNBOUND_LU;
+			}
+			*new_current_sp =  csdev->buffer[8];
+		}
+	} else {
+		struct scsi_sense_hdr sshdr;
+
+		err = BLK_ACTIVATE_FAILED;
+		if (status_byte(result) == CHECK_CONDITION &&
+		    scsi_normalize_sense(sense, SCSI_SENSE_BUFFERSIZE, &sshdr))
+			sdev_printk(KERN_ERR, sdev, "Found valid sense data "
+				    "0x%2x, 0x%2x, 0x%2x while finding current "
+				    "active SP.\n",
+				    sshdr.sense_key, sshdr.asc, sshdr.ascq);
+		else
+			sdev_printk(KERN_ERR, sdev, "Error 0x%x finding "
+				    "current active SP.\n", result);
+	}
+
+	return err;
+}
+
+static void sp_info_done(void *data, char *sense, int result, int resid)
+{
+	struct request *req = data;
+	struct scsi_device *sdev = req->q->queuedata;
+	struct clariion_sdev *csdev = sdev->sdevt_data;
+	int err_flags, default_sp, current_sp, new_current_sp;
+	unsigned long flags;
+
+	err_flags = parse_sp_info_rsp(sdev, sense, result, &default_sp,
+				      &current_sp, &new_current_sp);
+	if (err_flags) {
+		scsi_msg_done(req, err_flags);
+		return;
+	}
+
+	spin_lock_irqsave(&csdev->lock, flags);
+	if (csdev->pg_init_sent) {
+		csdev->default_sp = default_sp;
+		csdev->current_sp = current_sp;
+		csdev->pg_init_sent = 0;
+		spin_unlock_irqrestore(&csdev->lock, flags);
+		scsi_msg_done(req, BLK_ACTIVATE_SUCCESS);
+		return;
+	}
+	spin_unlock_irqrestore(&csdev->lock, flags);
+
+	/*
+	 * Do not issue the actual pg_init request if either (1)
+	 * we do not know the identity of the current SP or (2)
+	 * the prospective new SP is already current.
+	 */
+	if ((current_sp != CLARIION_UNBOUND_LU) &&
+	     (new_current_sp == current_sp)) {
+		spin_lock_irqsave(&csdev->lock, flags);
+		if (csdev->default_sp == CLARIION_UNBOUND_LU) {
+			csdev->default_sp = default_sp;
+			csdev->current_sp = current_sp;
+		}
+		spin_unlock_irqrestore(&csdev->lock, flags);
+
+		/* yet, its as good as doing it */
+		sdev_printk(KERN_INFO, sdev, "Ignoring path group "
+			    "switch-over command for CLARiiON SP%s "
+			    "since mapped device is already "
+			     "initialized.\n", current_sp ? "B" : "A");
+		scsi_msg_done(req, BLK_ACTIVATE_SUCCESS);
+	} else {
+		/* send path initialization request */
+		sdev_printk(KERN_INFO, sdev, "Issuing CLARiiON "
+			   "trespass command to activate SP%s.\n",
+			   new_current_sp ? "B" : "A");
+		if (execute_tresspass(req))
+			scsi_msg_done(req, BLK_ACTIVATE_RES_TEMP_UNAVAIL);
+	}
+}
+
+static int execute_sp_info(struct request *req)
+{
+	struct scsi_device *sdev = req->q->queuedata;
+	struct clariion_sdev *csdev = sdev->sdevt_data;
+	unsigned char cmd[MAX_COMMAND_SIZE];
+
+	memset(cmd, 0, MAX_COMMAND_SIZE);
+	cmd[0] = INQUIRY;
+	cmd[1] = 0x1;
+	cmd[2] = 0xC0;
+	cmd[4] = CLARIION_BUFFER_SIZE;
+	memset(csdev->buffer, 0, CLARIION_BUFFER_SIZE);
+	/*
+	 * TODO; return detailed error values from scsi_execute_async
+	 */
+	if (scsi_execute_async(sdev, cmd, COMMAND_SIZE(INQUIRY),
+				DMA_FROM_DEVICE, csdev->buffer,
+				CLARIION_BUFFER_SIZE, 0,
+				CLARIION_TIMEOUT, CLARIION_RETRIES, req,
+				sp_info_done, GFP_ATOMIC))
+		return -EAGAIN;
+
+	return 0;
+}
+
+static int clariion_activate(struct request *rq)
+{
+	if (execute_sp_info(rq))
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+	return 0;
+}
+
+static int clariion_check_sense(struct scsi_sense_hdr *sense_hdr)
+{
+	switch (sense_hdr->sense_key) {
+	case NOT_READY:
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x03)
+			/*
+			 * LUN Not Ready - Manual Intervention Required
+			 * indicates this is a passive path.
+			 *
+			 * FIXME: However, if this is seen and EVPD C0
+			 * indicates that this is due to a NDU in
+			 * progress, we should set FAIL_PATH too.
+			 * This indicates we might have to do a SCSI
+			 * inquiry in the end_io path. Ugh.
+			 */
+			return FAILED;
+		break;
+	case ILLEGAL_REQUEST:
+		if (sense_hdr->asc == 0x25 && sense_hdr->ascq == 0x01)
+			/*
+			 * An array based copy is in progress. Do not
+			 * fail the path, do not bypass to another PG,
+			 * do not retry. Fail the IO immediately.
+			 * (Actually this is the same conclusion as in
+			 * the default handler, but lets make sure.)
+			 */
+			return FAILED;
+		break;
+	case UNIT_ATTENTION:
+		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
+			/*
+			 * Unit Attention Code. This is the first IO
+			 * to the new path, so just retry.
+			 */
+			return NEEDS_RETRY;
+		break;
+	}
+
+	/* success just means we do not care what scsi-ml does */
+	return SUCCESS;
+}
+
+/*
+ * TODO: need some interface so we can set tress pass values
+ */
+static int clariion_setup(struct scsi_device *sdev)
+{
+	struct clariion_sdev *csdev;
+
+	csdev = kzalloc(sizeof(*csdev), GFP_KERNEL);
+	if (!csdev)
+		return -ENOMEM;
+	sdev->sdevt_data = csdev;
+
+	csdev->default_sp = CLARIION_UNBOUND_LU;
+	csdev->current_sp = CLARIION_UNBOUND_LU;
+
+	return 0;
+}
+
+static void clariion_destroy(struct scsi_device *sdev)
+{
+	struct clariion_sdev *csdev = sdev->sdevt_data;
+	kfree(csdev);
+}
+
+static struct sdev_id clariion_id[] = {
+	{"DGC", "RAID"},
+	{"DGC", "DISK"},
+	{ NULL, NULL },
+};
+
+static struct scsi_device_template clariion_template = {
+	.name		= "EMC CLARiiON target driver",
+	.id_table	= clariion_id,
+	.module		= THIS_MODULE,	
+	.check_sense	= clariion_check_sense,
+	.activate	= clariion_activate,
+	.setup		= clariion_setup,
+	.destroy	= clariion_destroy,
+};
+
+static int __init clariion_init(void)
+{
+	return scsi_register_device_template(&clariion_template);
+}
+
+static void __exit clariion_exit(void)
+{
+	scsi_unregister_device_template(&clariion_template);
+}
+
+module_init(clariion_init);
+module_exit(clariion_exit);
+
+MODULE_DESCRIPTION("EMC CX/AX/FC-family target driver");
+MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu");
+MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index aff1b0c..11b5d68 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -289,6 +289,7 @@ #endif
  **/
 static int scsi_check_sense(struct scsi_cmnd *scmd)
 {
+	struct scsi_device *sdev = scmd->device;
 	struct scsi_sense_hdr sshdr;
 
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
@@ -297,6 +298,14 @@ static int scsi_check_sense(struct scsi_
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
+	if (sdev->sdevt && sdev->sdevt->check_sense) {
+		int rc;
+
+		rc = sdev->sdevt->check_sense(&sshdr);
+		if (rc)
+			return rc;
+	}
+
 	/*
 	 * Previous logic looked for FILEMARK, EOM or ILI which are
 	 * mainly associated with tapes and returned SUCCESS.
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 743f67e..14217b7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1068,6 +1068,22 @@ static int scsi_issue_flush_fn(request_q
 	return -EOPNOTSUPP;
 }
 
+/*
+ * must be called with q->lock held
+ * TODO: rework scsi_end_request so we can share it.
+ */
+void scsi_msg_done(struct request *req, int err)
+{
+	struct request_queue *q = req->q;
+	int uptodate = err ? 0 : 1;
+
+	req->errors = err;
+	end_that_request_chunk(req, uptodate, req->data_len);
+	end_that_request_last(req, uptodate);
+	scsi_run_queue(q);
+}
+EXPORT_SYMBOL_GPL(scsi_msg_done);
+
 static void scsi_blk_pc_done(struct scsi_cmnd *cmd)
 {
 	BUG_ON(!blk_pc_request(cmd->request));
@@ -1166,6 +1182,9 @@ static int scsi_prep_fn(struct request_q
 		
 		/* pull a tag out of the request if we have one */
 		cmd->tag = req->tag;
+	} else if (blk_activate_request(req)) {
+		if (!sdev->sdevt || !sdev->sdevt->activate)
+			goto kill;
 	} else {
 		blk_dump_rq_flags(req, "SCSI bad req");
 		goto kill;
@@ -1244,7 +1263,10 @@ static int scsi_prep_fn(struct request_q
 		blk_plug_device(q);
 	return BLKPREP_DEFER;
  kill:
-	req->errors = DID_NO_CONNECT << 16;
+	if (blk_activate_request(req))
+		req->errors = BLK_ACTIVATE_FAILED;
+	else
+		req->errors = DID_NO_CONNECT << 16;
 	return BLKPREP_KILL;
 }
 
@@ -1406,6 +1428,7 @@ static void scsi_request_fn(struct reque
 	struct Scsi_Host *shost;
 	struct scsi_cmnd *cmd;
 	struct request *req;
+	int rc;
 
 	if (!sdev) {
 		printk("scsi: killing requests for dead queue\n");
@@ -1431,7 +1454,25 @@ static void scsi_request_fn(struct reque
 		 * accept it.
 		 */
 		req = elv_next_request(q);
-		if (!req || !scsi_dev_queue_ready(q, sdev))
+		if (!req)
+			break;
+
+		/*
+		 * TODO: integreate this nicer (possibly more linux block type
+		 * of requests in the future and we do not want checks
+		 * everywhere) and check locking and requeue code
+		 */
+		if (blk_activate_request(req)) {
+			blkdev_dequeue_request(req);
+			spin_unlock_irq(q->queue_lock);
+			rc = sdev->sdevt->activate(req);
+			spin_lock_irq(q->queue_lock);
+			if (rc)
+				blk_requeue_request(q, req);
+			continue;
+		}
+
+		if (!scsi_dev_queue_ready(q, sdev))
 			break;
 
 		if (unlikely(!scsi_device_online(sdev))) {
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 148e24c..ee43c86 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -709,6 +709,7 @@ static int scsi_add_lun(struct scsi_devi
 	sdev->vendor = (char *) (sdev->inquiry + 8);
 	sdev->model = (char *) (sdev->inquiry + 16);
 	sdev->rev = (char *) (sdev->inquiry + 32);
+	scsi_bind_device_template(sdev);
 
 	if (*bflags & BLIST_ISROM) {
 		/*
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index e7fe565..619174e 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -244,6 +244,9 @@ static void scsi_device_dev_release_user
 		sdev->request_queue = NULL;
 	}
 
+	if (sdev->sdevt && sdev->sdevt->destroy)
+		sdev->sdevt->destroy(sdev);
+
 	scsi_target_reap(scsi_target(sdev));
 
 	kfree(sdev->inquiry);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 26f7856..6ea655f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -174,6 +174,15 @@ enum {
 	 */
 	REQ_LB_OP_EJECT	= 0x40,		/* eject request */
 	REQ_LB_OP_FLUSH = 0x41,		/* flush device */
+	REQ_LB_OP_ACTIVATE = 0x42,	/* initialize a device */
+};
+
+/* TODO: where should this go? And add some comments. *//
+enum {
+	BLK_ACTIVATE_SUCCESS,
+	BLK_ACTIVATE_FAILED,
+	BLK_ACTIVATE_BYPASS_DEV,
+	BLK_ACTIVATE_RES_TEMP_UNAVAIL,
 };
 
 /*
@@ -539,6 +548,9 @@ #define blk_fs_request(rq)	((rq)->cmd_ty
 #define blk_pc_request(rq)	((rq)->cmd_type == REQ_TYPE_BLOCK_PC)
 #define blk_special_request(rq)	((rq)->cmd_type == REQ_TYPE_SPECIAL)
 #define blk_sense_request(rq)	((rq)->cmd_type == REQ_TYPE_SENSE)
+#define blk_linux_request(rq)	((rq)->cmd_type == REQ_TYPE_LINUX_BLOCK)
+#define blk_activate_request(rq) (((rq)->cmd_type == REQ_TYPE_LINUX_BLOCK) && \
+				  ((rq)->cmd[0] == REQ_LB_OP_ACTIVATE))
 
 #define blk_noretry_request(rq)	((rq)->cmd_flags & REQ_FAILFAST)
 #define blk_rq_started(rq)	((rq)->cmd_flags & REQ_STARTED)
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index be117f8..664efaa 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -123,6 +123,7 @@ extern void scsi_put_command(struct scsi
 extern void scsi_io_completion(struct scsi_cmnd *, unsigned int);
 extern void scsi_finish_command(struct scsi_cmnd *cmd);
 extern void scsi_req_abort_cmd(struct scsi_cmnd *cmd);
+extern void scsi_msg_done(struct request *req, int err);
 
 extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
 				 size_t *offset, size_t *len);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index ebf31b1..56cd2c1 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -8,9 +8,11 @@ #include <linux/workqueue.h>
 #include <asm/atomic.h>
 
 struct request_queue;
+struct request;
 struct scsi_cmnd;
 struct scsi_lun;
 struct scsi_sense_hdr;
+struct scsi_device_template;
 
 struct scsi_mode_data {
 	__u32	length;
@@ -140,6 +142,9 @@ #define SCSI_DEFAULT_DEVICE_BLOCKED	3
 
 	struct execute_work	ew; /* used to get process context on put */
 
+	struct scsi_device_template *sdevt;
+	void			*sdevt_data;
+
 	enum scsi_device_state sdev_state;
 	unsigned long		sdev_data[0];
 } __attribute__((aligned(sizeof(unsigned long))));
@@ -156,6 +161,24 @@ #define sdev_printk(prefix, sdev, fmt, a
 #define scmd_printk(prefix, scmd, fmt, a...)	\
 	dev_printk(prefix, &(scmd)->device->sdev_gendev, fmt, ##a)
 
+struct sdev_id {
+	char *vendor;
+	char *model;
+};
+
+struct scsi_device_template {
+	struct module *module;
+	const char *name;
+	struct sdev_id *id_table;
+
+	int (* check_sense)(struct scsi_sense_hdr *);
+	int (* activate)(struct request *);
+	int (* setup)(struct scsi_device *);
+	void (* destroy)(struct scsi_device *);
+
+	struct list_head list;
+};
+
 enum scsi_target_state {
 	STARGET_RUNNING = 1,
 	STARGET_DEL,
@@ -284,6 +307,9 @@ extern void int_to_scsilun(unsigned int,
 extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
+extern int scsi_register_device_template(struct scsi_device_template *);
+extern void scsi_unregister_device_template(struct scsi_device_template *);
+extern void scsi_bind_device_template(struct scsi_device *);
 extern int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 			int data_direction, void *buffer, unsigned bufflen,
 			unsigned char *sense, int timeout, int retries,
-- 
1.4.1.1
