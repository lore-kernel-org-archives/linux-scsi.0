From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] libata: implement minimal transport template for ->eh_timed_out
Date: Sat, 18 Mar 2006 18:40:14 +0900
Message-ID: <20060318094014.GE25706@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zproxy.gmail.com ([64.233.162.203]:50748 "EHLO zproxy.gmail.com")
	by vger.kernel.org with ESMTP id S932338AbWCRJkV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Mar 2006 04:40:21 -0500
Received: by zproxy.gmail.com with SMTP id o37so844996nzf
        for <linux-scsi@vger.kernel.org>; Sat, 18 Mar 2006 01:40:20 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>, Christoph Hellwig <hch@lst.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

SCSI midlayer has moved hostt->eh_timed_out to transport template.  As
libata doesn't need full-blown transport support yet, implement
minimal transport for libata.  No transport class or whatsoever, just
empty transport template with ->eh_timed_out hook.

Signed-off-by: Tejun Heo <htejun@gmail.com>

---

This patch is against the current libata #upstream[1] + scsi-misc
#master[2].  I simply pulled scsi-misc #master into libata #upstream
(no conflicts) and made on top of it.  Minimally tested on my machine
and seems to work fine.

[1] c39f5ebe0a542caab30c88e60623709c7bc6fe30
[2] a50a5e3792a6c65f95dab547dba45608bd193404

 drivers/scsi/ahci.c         |    1 -
 drivers/scsi/ata_piix.c     |    1 -
 drivers/scsi/libata-core.c  |    3 ++-
 drivers/scsi/libata-scsi.c  |   10 ++++++++++
 drivers/scsi/libata.h       |    2 ++
 drivers/scsi/pdc_adma.c     |    1 -
 drivers/scsi/sata_mv.c      |    1 -
 drivers/scsi/sata_nv.c      |    1 -
 drivers/scsi/sata_promise.c |    1 -
 drivers/scsi/sata_qstor.c   |    1 -
 drivers/scsi/sata_sil.c     |    1 -
 drivers/scsi/sata_sil24.c   |    1 -
 drivers/scsi/sata_sis.c     |    1 -
 drivers/scsi/sata_svw.c     |    1 -
 drivers/scsi/sata_sx4.c     |    1 -
 drivers/scsi/sata_uli.c     |    1 -
 drivers/scsi/sata_via.c     |    1 -
 drivers/scsi/sata_vsc.c     |    1 -
 include/linux/libata.h      |    1 -
 19 files changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/ahci.c b/drivers/scsi/ahci.c
index e97ab3e..a1ddbba 100644
--- a/drivers/scsi/ahci.c
+++ b/drivers/scsi/ahci.c
@@ -207,7 +207,6 @@ static struct scsi_host_template ahci_sh
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_timed_out		= ata_scsi_timed_out,
 	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/drivers/scsi/ata_piix.c b/drivers/scsi/ata_piix.c
index 9327b62..a74e23d 100644
--- a/drivers/scsi/ata_piix.c
+++ b/drivers/scsi/ata_piix.c
@@ -209,7 +209,6 @@ static struct scsi_host_template piix_sh
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_timed_out		= ata_scsi_timed_out,
 	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/drivers/scsi/libata-core.c b/drivers/scsi/libata-core.c
index 714b42b..64dce00 100644
--- a/drivers/scsi/libata-core.c
+++ b/drivers/scsi/libata-core.c
@@ -4653,6 +4653,8 @@ static struct ata_port * ata_host_add(co
 	if (!host)
 		return NULL;
 
+	host->transportt = &ata_scsi_transport_template;
+
 	ap = (struct ata_port *) &host->hostdata[0];
 
 	ata_host_init(ap, host, host_set, ent, port_no);
@@ -5084,7 +5086,6 @@ EXPORT_SYMBOL_GPL(ata_busy_sleep);
 EXPORT_SYMBOL_GPL(ata_port_queue_task);
 EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
 EXPORT_SYMBOL_GPL(ata_scsi_queuecmd);
-EXPORT_SYMBOL_GPL(ata_scsi_timed_out);
 EXPORT_SYMBOL_GPL(ata_scsi_error);
 EXPORT_SYMBOL_GPL(ata_scsi_slave_config);
 EXPORT_SYMBOL_GPL(ata_scsi_release);
diff --git a/drivers/scsi/libata-scsi.c b/drivers/scsi/libata-scsi.c
index ccedb45..bd9f217 100644
--- a/drivers/scsi/libata-scsi.c
+++ b/drivers/scsi/libata-scsi.c
@@ -41,6 +41,7 @@
 #include <scsi/scsi_eh.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_request.h>
+#include <scsi/scsi_transport.h>
 #include <linux/libata.h>
 #include <linux/hdreg.h>
 #include <asm/uaccess.h>
@@ -52,6 +53,7 @@
 typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *qc, const u8 *scsicmd);
 static struct ata_device *
 ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev);
+enum scsi_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
 
 #define RW_RECOVERY_MPAGE 0x1
 #define RW_RECOVERY_MPAGE_LEN 12
@@ -92,6 +94,14 @@ static const u8 def_control_mpage[CONTRO
 	0, 30	/* extended self test time, see 05-359r1 */
 };
 
+/*
+ * libata transport template.  libata doesn't do real transport stuff.
+ * It just needs the eh_timed_out hook.
+ */
+struct scsi_transport_template ata_scsi_transport_template = {
+	.eh_timed_out		= ata_scsi_timed_out,
+};
+
 
 static void ata_scsi_invalid_field(struct scsi_cmnd *cmd,
 				   void (*done)(struct scsi_cmnd *))
diff --git a/drivers/scsi/libata.h b/drivers/scsi/libata.h
index f4c48c9..65f52be 100644
--- a/drivers/scsi/libata.h
+++ b/drivers/scsi/libata.h
@@ -57,6 +57,8 @@ extern int ata_cmd_ioctl(struct scsi_dev
 
 
 /* libata-scsi.c */
+extern struct scsi_transport_template ata_scsi_transport_template;
+
 extern void ata_scsi_scan_host(struct ata_port *ap);
 extern int ata_scsi_error(struct Scsi_Host *host);
 extern unsigned int ata_scsiop_inq_std(struct ata_scsi_args *args, u8 *rbuf,
diff --git a/drivers/scsi/pdc_adma.c b/drivers/scsi/pdc_adma.c
index 5f33cc9..b3dc5f8 100644
--- a/drivers/scsi/pdc_adma.c
+++ b/drivers/scsi/pdc_adma.c
@@ -143,7 +143,6 @@ static struct scsi_host_template adma_at
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_timed_out		= ata_scsi_timed_out,
 	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/drivers/scsi/sata_mv.c b/drivers/scsi/sata_mv.c
index aceaf56..4df5f86 100644
--- a/drivers/scsi/sata_mv.c
+++ b/drivers/scsi/sata_mv.c
@@ -378,7 +378,6 @@ static struct scsi_host_template mv_sht 
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_timed_out		= ata_scsi_timed_out,
 	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= MV_USE_Q_DEPTH,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/drivers/scsi/sata_nv.c b/drivers/scsi/sata_nv.c
index caffadc..e5b20c6 100644
--- a/drivers/scsi/sata_nv.c
+++ b/drivers/scsi/sata_nv.c
@@ -229,7 +229,6 @@ static struct scsi_host_template nv_sht 
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_timed_out		= ata_scsi_timed_out,
 	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/drivers/scsi/sata_promise.c b/drivers/scsi/sata_promise.c
index 84cb394..cc928c6 100644
--- a/drivers/scsi/sata_promise.c
+++ b/drivers/scsi/sata_promise.c
@@ -111,7 +111,6 @@ static struct scsi_host_template pdc_ata
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_timed_out		= ata_scsi_timed_out,
 	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/drivers/scsi/sata_qstor.c b/drivers/scsi/sata_qstor.c
index 9602f43..9ffe1ef 100644
--- a/drivers/scsi/sata_qstor.c
+++ b/drivers/scsi/sata_qstor.c
@@ -132,7 +132,6 @@ static struct scsi_host_template qs_ata_
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_timed_out		= ata_scsi_timed_out,
 	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/drivers/scsi/sata_sil.c b/drivers/scsi/sata_sil.c
index 4f2a67e..3e75d67 100644
--- a/drivers/scsi/sata_sil.c
+++ b/drivers/scsi/sata_sil.c
@@ -146,7 +146,6 @@ static struct scsi_host_template sil_sht
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_timed_out		= ata_scsi_timed_out,
 	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/drivers/scsi/sata_sil24.c b/drivers/scsi/sata_sil24.c
index 9a53a5e..5d01e5c 100644
--- a/drivers/scsi/sata_sil24.c
+++ b/drivers/scsi/sata_sil24.c
@@ -281,7 +281,6 @@ static struct scsi_host_template sil24_s
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_timed_out		= ata_scsi_timed_out,
 	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/drivers/scsi/sata_sis.c b/drivers/scsi/sata_sis.c
index 7fd45f8..acc8439 100644
--- a/drivers/scsi/sata_sis.c
+++ b/drivers/scsi/sata_sis.c
@@ -87,7 +87,6 @@ static struct scsi_host_template sis_sht
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_timed_out		= ata_scsi_timed_out,
 	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/drivers/scsi/sata_svw.c b/drivers/scsi/sata_svw.c
index 4aaccd5..051e47d 100644
--- a/drivers/scsi/sata_svw.c
+++ b/drivers/scsi/sata_svw.c
@@ -288,7 +288,6 @@ static struct scsi_host_template k2_sata
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_timed_out		= ata_scsi_timed_out,
 	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/drivers/scsi/sata_sx4.c b/drivers/scsi/sata_sx4.c
index 9f8a768..ae70f60 100644
--- a/drivers/scsi/sata_sx4.c
+++ b/drivers/scsi/sata_sx4.c
@@ -182,7 +182,6 @@ static struct scsi_host_template pdc_sat
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_timed_out		= ata_scsi_timed_out,
 	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/drivers/scsi/sata_uli.c b/drivers/scsi/sata_uli.c
index 37a487b..8f50257 100644
--- a/drivers/scsi/sata_uli.c
+++ b/drivers/scsi/sata_uli.c
@@ -75,7 +75,6 @@ static struct scsi_host_template uli_sht
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_timed_out		= ata_scsi_timed_out,
 	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/drivers/scsi/sata_via.c b/drivers/scsi/sata_via.c
index ff65a0b..791bf65 100644
--- a/drivers/scsi/sata_via.c
+++ b/drivers/scsi/sata_via.c
@@ -94,7 +94,6 @@ static struct scsi_host_template svia_sh
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_timed_out		= ata_scsi_timed_out,
 	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/drivers/scsi/sata_vsc.c b/drivers/scsi/sata_vsc.c
index b574379..ee75b9b 100644
--- a/drivers/scsi/sata_vsc.c
+++ b/drivers/scsi/sata_vsc.c
@@ -251,7 +251,6 @@ static struct scsi_host_template vsc_sat
 	.name			= DRV_NAME,
 	.ioctl			= ata_scsi_ioctl,
 	.queuecommand		= ata_scsi_queuecmd,
-	.eh_timed_out		= ata_scsi_timed_out,
 	.eh_strategy_handler	= ata_scsi_error,
 	.can_queue		= ATA_DEF_QUEUE,
 	.this_id		= ATA_SHT_THIS_ID,
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 239408e..204c37a 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -508,7 +508,6 @@ extern void ata_host_set_remove(struct a
 extern int ata_scsi_detect(struct scsi_host_template *sht);
 extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
 extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
-extern enum scsi_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd);
 extern int ata_scsi_error(struct Scsi_Host *host);
 extern void ata_eh_qc_complete(struct ata_queued_cmd *qc);
 extern void ata_eh_qc_retry(struct ata_queued_cmd *qc);
