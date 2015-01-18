From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 07/11] scsi: move module reference from scsi_host_template to Scsi_Host
Date: Mon, 19 Jan 2015 00:06:05 +0900
Message-ID: <1421593569-5089-8-git-send-email-akinobu.mita@gmail.com>
References: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1421593569-5089-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Vinayak Holikatti <vinholikatti@gmail.com>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, "David S. Miller" <davem@davemloft.net>, Hannes Reinecke <hare@suse.de>, Tejun Heo <tj@kernel.org>, Hans de Goede <hdegoede@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>, Karen Xie <kxie@chelsio.com>, Robert Love <robert.w.love@intel.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <JBottomley@parallels.com>, open-iscsi@googlegroups.com, fcoe-devel@open-fcoe.org, linux-ide@vger.kernel.org, linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

While accessing a scsi_device, the use count of the underlying LLDD
module is incremented.  The module reference is retrieved through
.module field of struct scsi_host_template.

This mapping between scsi_device and underlying LLDD module works well
except some drivers which consist with the core driver and the actual
LLDDs and scsi_host_template is defined in the core driver.  In these
cases, the actual LLDDs can be unloaded even if the scsi_device is
being accessed.

This moves owner module reference from struct scsi_host_template to
struct Scsi_Host, and it is passed through scsi_host_alloc().  Some
drivers which have the module reference mismatch problem described above
can pass their correct module reference by using __scsi_host_alloc()
which takes module reference argument.

Sub drivers of esp_scsi (mac_esp, am53c974, sun_esp, jazz_esp, sun3x_esp)
use a single scsi_host_template defined in esp_scsi module, so these
had module reference mismatch problem, but this change implicitly fixes
it.  Because sub drivers directly call scsi_host_alloc() and THIS_MODULE
is used for the module reference instead of scsi_host_template->module.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Dolev Raviv <draviv@codeaurora.org>
Cc: Sujit Reddy Thumma <sthumma@codeaurora.org>
Cc: Subhash Jadavani <subhashj@codeaurora.org>
Cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Karen Xie <kxie@chelsio.com>
Cc: Robert Love <robert.w.love@intel.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: open-iscsi@googlegroups.com
Cc: fcoe-devel@open-fcoe.org
Cc: linux-ide@vger.kernel.org
Cc: linux-usb@vger.kernel.org
Cc: usb-storage@lists.one-eyed-alien.net
Cc: linux-scsi@vger.kernel.org
---
 drivers/ata/libata-scsi.c     |  2 +-
 drivers/scsi/53c700.c         |  2 +-
 drivers/scsi/hosts.c          | 11 +++++++----
 drivers/scsi/libfc/fc_lport.c |  2 +-
 drivers/scsi/libfc/fc_npiv.c  |  3 +--
 drivers/scsi/libiscsi.c       |  2 +-
 drivers/scsi/scsi.c           |  4 ++--
 include/scsi/scsi_host.h      |  8 +++++++-
 8 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e364e86..20a963c 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3643,7 +3643,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
 		struct Scsi_Host *shost;
 
 		rc = -ENOMEM;
-		shost = scsi_host_alloc(sht, sizeof(struct ata_port *));
+		shost = __scsi_host_alloc(sht, sizeof(ap), host->module);
 		if (!shost)
 			goto err_alloc;
 
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index e70fd05..a5777f8 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -333,7 +333,7 @@ __NCR_700_detect(struct scsi_host_template *tpnt,
 	if(tpnt->proc_name == NULL)
 		tpnt->proc_name = "53c700";
 
-	host = scsi_host_alloc(tpnt, 4);
+	host = __scsi_host_alloc(tpnt, sizeof(hostdata), owner);
 	if (!host)
 		return NULL;
 	memset(hostdata->slots, 0, sizeof(struct NCR_700_command_slot)
diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index eb324f1..90c109e 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -354,9 +354,10 @@ static struct device_type scsi_host_type = {
 };
 
 /**
- * scsi_host_alloc - register a scsi host adapter instance.
+ * __scsi_host_alloc - register a scsi host adapter instance.
  * @sht:	pointer to scsi host template
  * @privsize:	extra bytes to allocate for driver
+ * @owner:	module which will be the owner of the scsi host
  *
  * Note:
  * 	Allocate a new Scsi_Host and perform basic initialization.
@@ -366,7 +367,8 @@ static struct device_type scsi_host_type = {
  * Return value:
  * 	Pointer to a new Scsi_Host
  **/
-struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
+struct Scsi_Host *__scsi_host_alloc(struct scsi_host_template *sht,
+				    int privsize, struct module *owner)
 {
 	struct Scsi_Host *shost;
 	gfp_t gfp_mask = GFP_KERNEL;
@@ -411,6 +413,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	 */
 	shost->max_cmd_len = 12;
 	shost->hostt = sht;
+	shost->module = owner;
 	shost->this_id = sht->this_id;
 	shost->can_queue = sht->can_queue;
 	shost->sg_tablesize = sht->sg_tablesize;
@@ -497,12 +500,12 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	kfree(shost);
 	return NULL;
 }
-EXPORT_SYMBOL(scsi_host_alloc);
+EXPORT_SYMBOL(__scsi_host_alloc);
 
 struct Scsi_Host *__scsi_register(struct scsi_host_template *sht, int privsize,
 				  struct module *owner)
 {
-	struct Scsi_Host *shost = scsi_host_alloc(sht, privsize);
+	struct Scsi_Host *shost = __scsi_host_alloc(sht, privsize, owner);
 
 	if (!sht->detect) {
 		printk(KERN_WARNING "scsi_register() called on new-style "
diff --git a/drivers/scsi/libfc/fc_lport.c b/drivers/scsi/libfc/fc_lport.c
index d931e69..54ef1c4 100644
--- a/drivers/scsi/libfc/fc_lport.c
+++ b/drivers/scsi/libfc/fc_lport.c
@@ -2158,7 +2158,7 @@ struct fc_lport *__libfc_host_alloc(struct scsi_host_template *sht,
 	struct fc_lport *lport;
 	struct Scsi_Host *shost;
 
-	shost = scsi_host_alloc(sht, sizeof(*lport) + priv_size);
+	shost = __scsi_host_alloc(sht, sizeof(*lport) + priv_size, owner);
 	if (!shost)
 		return NULL;
 	lport = shost_priv(shost);
diff --git a/drivers/scsi/libfc/fc_npiv.c b/drivers/scsi/libfc/fc_npiv.c
index 86133f9..1cf2abb 100644
--- a/drivers/scsi/libfc/fc_npiv.c
+++ b/drivers/scsi/libfc/fc_npiv.c
@@ -36,8 +36,7 @@ struct fc_lport *libfc_vport_create(struct fc_vport *vport, int privsize)
 	struct fc_lport *n_port = shost_priv(shost);
 	struct fc_lport *vn_port;
 
-	vn_port = __libfc_host_alloc(shost->hostt, privsize,
-				     shost->hostt->module);
+	vn_port = __libfc_host_alloc(shost->hostt, privsize, shost->module);
 	if (!vn_port)
 		return vn_port;
 
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 4c5be6b..6c2ebf3 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -2609,7 +2609,7 @@ struct Scsi_Host *__iscsi_host_alloc(struct scsi_host_template *sht,
 	struct Scsi_Host *shost;
 	struct iscsi_host *ihost;
 
-	shost = scsi_host_alloc(sht, sizeof(struct iscsi_host) + dd_data_size);
+	shost = __scsi_host_alloc(sht, sizeof(*ihost) + dd_data_size, owner);
 	if (!shost)
 		return NULL;
 	ihost = shost_priv(shost);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index e028854..5905b83 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -988,7 +988,7 @@ int scsi_device_get(struct scsi_device *sdev)
 		return -ENXIO;
 	/* We can fail this if we're doing SCSI operations
 	 * from module exit (like cache flush) */
-	try_module_get(sdev->host->hostt->module);
+	try_module_get(sdev->host->module);
 
 	return 0;
 }
@@ -1005,7 +1005,7 @@ EXPORT_SYMBOL(scsi_device_get);
 void scsi_device_put(struct scsi_device *sdev)
 {
 #ifdef CONFIG_MODULE_UNLOAD
-	struct module *module = sdev->host->hostt->module;
+	struct module *module = sdev->host->module;
 
 	/* The module refcount will be zero if scsi_device_get()
 	 * was called from a module removal routine */
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 0369b4e..acdf828 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -47,6 +47,7 @@ struct blk_queue_tags;
 #define ENABLE_CLUSTERING 1
 
 struct scsi_host_template {
+	/* This is unused and will be removed after mass conversion */
 	struct module *module;
 	const char *name;
 
@@ -617,6 +618,7 @@ struct Scsi_Host {
 	 */
 	unsigned short max_cmd_len;
 
+	struct module *module;
 	int this_id;
 	int can_queue;
 	short cmd_per_lun;
@@ -783,7 +785,11 @@ static inline bool shost_use_blk_mq(struct Scsi_Host *shost)
 extern int scsi_queue_work(struct Scsi_Host *, struct work_struct *);
 extern void scsi_flush_work(struct Scsi_Host *);
 
-extern struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *, int);
+extern struct Scsi_Host *__scsi_host_alloc(struct scsi_host_template *, int,
+					struct module *);
+#define scsi_host_alloc(sht, privsize) \
+	__scsi_host_alloc(sht, privsize, THIS_MODULE)
+
 extern int __must_check scsi_add_host_with_dma(struct Scsi_Host *,
 					       struct device *,
 					       struct device *);
-- 
1.9.1

