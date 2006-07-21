From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH RFC] move scsi parts of dm hw handlers to scsi
	layer
Date: Fri, 21 Jul 2006 07:20:17 -0400
Message-ID: <1153480817.8030.15.camel@max>
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
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

Currently dm-multipath has what it calls hw_handlers that contain hw
details and currently those handlers can be used to failover storage
works, LSI/Engenio RDAC mode, and EMC Clariion boxes. This code is a
little strange in dm-multipath and they are doing scsi no good (think
about problems initializing scsi disks/paths when they are in a passive
path that requires explicit/manual activation and we retry over and over
and over).

The patch below begins to push the scsi hw handler code down to the scsi
layer. I only began to covert dm-emc.c and it only hooks in at the sense
decoding in scsi_error.c. I wanted to make sure I was going about the
module loading and binding correctly. With a new target bus we could do
some driver model stuff instead, but I was not sure if that was
appropriate for this?

Next up would be to get Jens's cmd type tree and work on the message
passing code.

And this patch currently does not work since I do not have a Clariion
box and I do not know what to match for the {vendor, model} tuple. I
think it was something like DCG or DGC and the model had different RAID
strings depending on how it was setup and could have some other string
if it did not use RAID. If you have a Clariion or you work for EMC and
happen to know this info could you pass those strings to me?

This patch was made over 2.6.18-r2 since I screwed up my git trees and I
cannot seem to download them from where I am at.

diff -Naurp linux-2.6.18-rc2/drivers/scsi/Kconfig linux-2.6.18-rc2.work/drivers/scsi/Kconfig
--- linux-2.6.18-rc2/drivers/scsi/Kconfig	2006-07-15 17:53:08.000000000 -0400
+++ linux-2.6.18-rc2.work/drivers/scsi/Kconfig	2006-07-21 06:44:58.000000000 -0400
@@ -244,6 +244,17 @@ config SCSI_SAS_ATTRS
 
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
 
diff -Naurp linux-2.6.18-rc2/drivers/scsi/Makefile linux-2.6.18-rc2.work/drivers/scsi/Makefile
--- linux-2.6.18-rc2/drivers/scsi/Makefile	2006-07-15 17:53:08.000000000 -0400
+++ linux-2.6.18-rc2.work/drivers/scsi/Makefile	2006-07-21 06:40:42.000000000 -0400
@@ -138,6 +138,7 @@ obj-$(CONFIG_SCSI_SATA_ULI)	+= libata.o 
 obj-$(CONFIG_SCSI_SATA_MV)	+= libata.o sata_mv.o
 obj-$(CONFIG_SCSI_PDC_ADMA)	+= libata.o pdc_adma.o
 obj-$(CONFIG_SCSI_HPTIOP)	+= hptiop.o
+obj-$(CONFIG_SCSI_CLARIION)	+= scsi_emc_clariion.o
 
 obj-$(CONFIG_ARM)		+= arm/
 
diff -Naurp linux-2.6.18-rc2/drivers/scsi/scsi.c linux-2.6.18-rc2.work/drivers/scsi/scsi.c
--- linux-2.6.18-rc2/drivers/scsi/scsi.c	2006-07-15 17:53:08.000000000 -0400
+++ linux-2.6.18-rc2.work/drivers/scsi/scsi.c	2006-07-21 06:29:02.000000000 -0400
@@ -135,6 +135,8 @@ static struct scsi_host_cmd_pool scsi_cm
 };
 
 static DEFINE_MUTEX(host_cmd_pool_mutex);
+static DEFINE_MUTEX(target_driver_mutex);
+static LIST_HEAD(target_driver_list);
 
 static struct scsi_cmnd *__scsi_get_command(struct Scsi_Host *shost,
 					    gfp_t gfp_mask)
@@ -1076,6 +1078,54 @@ int scsi_device_cancel(struct scsi_devic
 }
 EXPORT_SYMBOL(scsi_device_cancel);
 
+
+int scsi_register_target_template(struct scsi_target_template *tmpl)
+{
+	mutex_lock(&target_driver_mutex);
+	list_add_tail(&tmpl->list, &target_driver_list);
+	mutex_unlock(&target_driver_mutex);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(scsi_register_target_template);
+
+void scsi_unregister_target_template(struct scsi_target_template *tmpl)
+{
+	mutex_lock(&target_driver_mutex);
+	list_del(&tmpl->list);
+	mutex_unlock(&target_driver_mutex);
+}
+EXPORT_SYMBOL_GPL(scsi_unregister_target_template);
+
+void scsi_bind_target(struct scsi_target *starget, const unsigned char *vendor,
+		      const unsigned char *model)
+{
+	struct scsi_target_template *tmpl;
+	int rc;
+
+	mutex_lock(&target_driver_mutex);
+	if (starget->stargett)
+		goto done;
+
+	list_for_each_entry(tmpl, &target_driver_list, list) {
+		rc = tmpl->setup(starget, vendor, model);
+		switch (rc) {
+		case SCSI_DRIVER_NO_MATCH:
+			continue;
+		case SCSI_DRIVER_SETUP_FAILED:
+			/* we can limp along without the driver attached */
+			printk(KERN_INFO "Could not bind target driver to "
+			       "%s %s\n", vendor, model);
+			break;
+		case SCSI_DRIVER_SETUP_SUCCESS:
+			starget->stargett = tmpl;
+			break;
+		}
+	}
+
+done:
+	mutex_unlock(&target_driver_mutex);
+}
+
 MODULE_DESCRIPTION("SCSI core");
 MODULE_LICENSE("GPL");
 
diff -Naurp linux-2.6.18-rc2/drivers/scsi/scsi_emc_clariion.c linux-2.6.18-rc2.work/drivers/scsi/scsi_emc_clariion.c
--- linux-2.6.18-rc2/drivers/scsi/scsi_emc_clariion.c	1969-12-31 19:00:00.000000000 -0500
+++ linux-2.6.18-rc2.work/drivers/scsi/scsi_emc_clariion.c	2006-07-21 06:58:03.000000000 -0400
@@ -0,0 +1,199 @@
+/*
+ * Target driver for EMC CLARiiON AX/CX-series hardware.
+ * Based on code from Lars Marowsky-Bree <lmb@suse.de>
+ */
+#include <linux/blkdev.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_eh.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+
+struct clariion_target {
+	/*
+	 * Whether we should send the short trespass command (FC-series)
+	 * or the long version (default for AX/CX CLARiiON arrays).
+	 */
+	unsigned short_trespass;
+	/*
+	 * Whether or not to honor SCSI reservations when initiating a
+	 * switch-over. Default: Don't.
+	 */
+	unsigned hr;
+};
+
+#define TRESPASS_PAGE 0x22
+
+static unsigned char long_trespass[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,		/* Page code */
+	0x09,			/* Page length - 2 */
+	0x81,			/* Trespass code + Honor reservation bit */
+	0xff, 0xff,		/* Trespass target */
+	0, 0, 0, 0, 0, 0	/* Reserved bytes / unknown */
+};
+
+static unsigned char long_trespass_hr[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,		/* Page code */
+	0x09,			/* Page length - 2 */
+	0x01,			/* Trespass code + Honor reservation bit */
+	0xff, 0xff,		/* Trespass target */
+	0, 0, 0, 0, 0, 0	/* Reserved bytes / unknown */
+};
+
+static unsigned char short_trespass[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,		/* Page code */
+	0x02,			/* Page length - 2 */
+	0x81,			/* Trespass code + Honor reservation bit */
+	0xff,			/* Trespass target */
+};
+
+static unsigned char short_trespass_hr[] = {
+	0, 0, 0, 0,
+	TRESPASS_PAGE,		/* Page code */
+	0x02,			/* Page length - 2 */
+	0x01,			/* Trespass code + Honor reservation bit */
+	0xff,			/* Trespass target */
+};
+
+static void clariion_activate_done(void *data, char *sense, int result,
+				   int resid)
+{
+	/*
+	struct request *rq = data;
+
+	 * TODO look at sense and result
+	 * Set some bits on the request for dm-multipath to do something
+	 * smart???
+
+	if (result)
+		scsi_complete_msg(rq, -EIO);
+	else
+		scsi_complete_msg(rq, 0);
+	*/
+}
+
+/* TODO - make configurable */
+#define CLARIION_TMO 30
+#define CLARIION_RETRIES 3
+
+static int clariion_activate(struct scsi_device *sdev, struct request *rq)
+{
+	struct scsi_target *stgt = scsi_target(sdev);
+	struct clariion_target *ctgt = stgt->targetdata;
+	unsigned char *page22;
+	unsigned size;
+	unsigned char cmd[MAX_COMMAND_SIZE];
+
+	if (ctgt->short_trespass) {
+		page22 = ctgt->hr ? short_trespass_hr : short_trespass;
+		size = sizeof(short_trespass);
+	} else {
+		page22 = ctgt->hr ? long_trespass_hr : long_trespass;
+		size = sizeof(long_trespass);
+	}
+
+	memset(cmd, 0, MAX_COMMAND_SIZE);
+	cmd[0] = MODE_SELECT;
+	cmd[1] = 0x10;
+	cmd[2] = size;
+
+	if (scsi_execute_async(sdev, cmd, COMMAND_SIZE(MODE_SELECT),
+				DMA_TO_DEVICE, page22, size, 0, CLARIION_TMO,
+				CLARIION_RETRIES, rq, clariion_activate_done,
+				GFP_ATOMIC))
+		return SCSI_MLQUEUE_DEVICE_BUSY;
+
+	return 0;
+}
+
+static int clariion_check_sense(struct scsi_sense_hdr *sense_hdr)
+{
+	switch (sense_hdr->sense_key) {
+	case NOT_READY:
+		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x03)
+			/* LUN Not Ready - Manual Intervention Required
+			 * indicates this is a passive path.
+			 *
+			 * FIXME: However, if this is seen and EVPD C0
+			 * indicates that this is due to a NDU in
+			 * progress, we should set FAIL_PATH too.
+			 * This indicates we might have to do a SCSI
+			 * inquiry in the end_io path. Ugh. */
+			return FAILED;
+		break;
+	case ILLEGAL_REQUEST:
+		if (sense_hdr->asc == 0x25 && sense_hdr->ascq == 0x01)
+			/* An array based copy is in progress. Do not
+			 * fail the path, do not bypass to another PG,
+			 * do not retry. Fail the IO immediately.
+			 * (Actually this is the same conclusion as in
+			 * the default handler, but lets make sure.) */
+			return FAILED;
+		break;
+	case UNIT_ATTENTION:
+		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
+			/* Unit Attention Code. This is the first IO
+			 * to the new path, so just retry. */
+			return NEEDS_RETRY;
+		break;
+	}
+
+	/* success just means we do not care what scsi-ml does */
+	return SUCCESS;
+}
+
+/* TODO do we need to get some other device info so we can set
+ * what type of command we want to do?????
+ */
+static int clariion_setup(struct scsi_target *stgt,
+			  const unsigned char *vendor,
+			  const unsigned char *model)
+{
+	struct clariion_target *ctgt;
+
+	if (strcmp(vendor, "something") || strcmp(model, "something else"))
+		return SCSI_DRIVER_NO_MATCH;
+
+	ctgt = kzalloc(sizeof(*ctgt), GFP_KERNEL);
+	if (!ctgt)
+		return SCSI_DRIVER_SETUP_FAILED;
+	stgt->targetdata = ctgt;
+	ctgt->hr = 0;
+	ctgt->short_trespass = 0;
+
+	return SCSI_DRIVER_SETUP_SUCCESS;
+}
+
+static void clariion_destroy(struct scsi_target *stgt)
+{
+	struct clariion_target *ctgt = stgt->targetdata;
+	kfree(ctgt);
+}
+
+static struct scsi_target_template clariion_template = {
+	.name		= "EMC CLARiiON target driver",
+	.module		= THIS_MODULE,	
+	.check_sense	= clariion_check_sense,
+	.activate	= clariion_activate,
+	.setup		= clariion_setup,
+	.destroy	= clariion_destroy,
+};
+
+static int __init clariion_init(void)
+{
+	return scsi_register_target_template(&clariion_template);
+}
+
+static void __exit clariion_exit(void)
+{
+	scsi_unregister_target_template(&clariion_template);
+}
+
+module_init(clariion_init);
+module_exit(clariion_exit);
+
+MODULE_DESCRIPTION("EMC CX/AX/FC-family target driver");
+MODULE_AUTHOR("Mike Christie <michaelc@cs.wisc.edu");
+MODULE_LICENSE("GPL");
diff -Naurp linux-2.6.18-rc2/drivers/scsi/scsi_error.c linux-2.6.18-rc2.work/drivers/scsi/scsi_error.c
--- linux-2.6.18-rc2/drivers/scsi/scsi_error.c	2006-07-15 17:53:08.000000000 -0400
+++ linux-2.6.18-rc2.work/drivers/scsi/scsi_error.c	2006-07-21 07:01:47.000000000 -0400
@@ -289,6 +289,7 @@ static inline void scsi_eh_prt_fail_stat
  **/
 static int scsi_check_sense(struct scsi_cmnd *scmd)
 {
+	struct scsi_target *starget = scsi_target(scmd->device);
 	struct scsi_sense_hdr sshdr;
 
 	if (! scsi_command_normalize_sense(scmd, &sshdr))
@@ -297,6 +298,12 @@ static int scsi_check_sense(struct scsi_
 	if (scsi_sense_is_deferred(&sshdr))
 		return NEEDS_RETRY;
 
+	if (starget->stargett && starget->stargett->check_sense) {
+		int rc = starget->stargett->check_sense(&sshdr);
+		if (rc)
+			return rc;
+	}
+
 	/*
 	 * Previous logic looked for FILEMARK, EOM or ILI which are
 	 * mainly associated with tapes and returned SUCCESS.
diff -Naurp linux-2.6.18-rc2/drivers/scsi/scsi_scan.c linux-2.6.18-rc2.work/drivers/scsi/scsi_scan.c
--- linux-2.6.18-rc2/drivers/scsi/scsi_scan.c	2006-07-15 17:53:08.000000000 -0400
+++ linux-2.6.18-rc2.work/drivers/scsi/scsi_scan.c	2006-07-21 07:06:30.000000000 -0400
@@ -288,6 +288,8 @@ static void scsi_target_dev_release(stru
 	struct device *parent = dev->parent;
 	struct scsi_target *starget = to_scsi_target(dev);
 
+	if (starget->stargett && starget->stargett->destroy)
+		starget->stargett->destroy(starget);
 	kfree(starget);
 	put_device(parent);
 }
@@ -911,6 +913,8 @@ static int scsi_probe_and_add_lun(struct
 	/*
 	 * result contains valid SCSI INQUIRY data.
 	 */
+	scsi_bind_target(starget, sdev->vendor, sdev->model);
+
 	if (((result[0] >> 5) == 3) && !(bflags & BLIST_ATTACH_PQ3)) {
 		/*
 		 * For a Peripheral qualifier 3 (011b), the SCSI
diff -Naurp linux-2.6.18-rc2/include/scsi/scsi_device.h linux-2.6.18-rc2.work/include/scsi/scsi_device.h
--- linux-2.6.18-rc2/include/scsi/scsi_device.h	2006-07-15 17:53:08.000000000 -0400
+++ linux-2.6.18-rc2.work/include/scsi/scsi_device.h	2006-07-21 06:22:29.000000000 -0400
@@ -8,6 +8,8 @@
 #include <asm/atomic.h>
 
 struct request_queue;
+struct request;
+struct scsi_target;
 struct scsi_cmnd;
 struct scsi_lun;
 struct scsi_sense_hdr;
@@ -161,6 +163,27 @@ enum scsi_target_state {
 	STARGET_DEL,
 };
 
+enum {
+	SCSI_DRIVER_NO_MATCH,
+	SCSI_DRIVER_SETUP_FAILED,
+	SCSI_DRIVER_SETUP_SUCCESS,
+};
+
+struct scsi_target_template {
+	struct module *module;
+	const char *name;
+	unsigned targetdata_size;
+
+	int (* check_sense)(struct scsi_sense_hdr *);
+	int (* activate)(struct scsi_device *, struct request *);
+	int (* setup)(struct scsi_target *, const unsigned char *vendor,
+		     const unsigned char *model);
+	void (* destroy)(struct scsi_target *);
+
+	/* scsi ml private data */
+	struct list_head list;
+};
+
 /*
  * scsi_target: representation of a scsi target, for now, this is only
  * used for single_lun devices. If no one has active IO to the target,
@@ -178,8 +201,11 @@ struct scsi_target {
 	unsigned int		create:1; /* signal that it needs to be added */
 	unsigned int		pdt_1f_for_no_lun;	/* PDT = 0x1f */
 						/* means no lun present */
-
 	char			scsi_level;
+
+	struct scsi_target_template *stargett;
+	void			*targetdata; /* for the target driver */
+
 	struct execute_work	ew;
 	enum scsi_target_state	state;
 	void 			*hostdata; /* available to low-level driver */
@@ -284,6 +310,10 @@ extern void int_to_scsilun(unsigned int,
 extern const char *scsi_device_state_name(enum scsi_device_state);
 extern int scsi_is_sdev_device(const struct device *);
 extern int scsi_is_target_device(const struct device *);
+extern void scsi_bind_target(struct scsi_target *, const unsigned char *,
+			     const unsigned char *);
+extern void scsi_unregister_target_template(struct scsi_target_template *);
+extern int scsi_register_target_template(struct scsi_target_template *);
 extern int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 			int data_direction, void *buffer, unsigned bufflen,
 			unsigned char *sense, int timeout, int retries,
