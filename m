From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.13-rc6
Date: Wed, 23 Aug 2017 07:42:39 +0100
Message-ID: <1503470559.2729.4.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Six minor and error leg fixes, plus one major change: the reversion of
scsi-mq as the default.  We're doing the latter temporarily (with a
backport to stable) to give us time to fix all the issues that turned
up with this default before trying again.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Christoph Hellwig (1):
      Revert "scsi: default to scsi-mq"

Damien Le Moal (1):
      scsi: sd_zbc: Write unlock zone from sd_uninit_cmnd()

Raghava Aditya Renukunta (1):
      scsi: aacraid: Fix out of bounds in aac_get_name_resp

Varun Prakash (2):
      scsi: cxgb4i: call neigh_event_send() to update MAC address
      scsi: csiostor: fail probe if fw does not support FCoE

weiping zhang (1):
      scsi: megaraid_sas: fix error handle in megasas_probe_one

And the diffstat:

 drivers/scsi/Kconfig                      | 11 +++++++++++
 drivers/scsi/aacraid/aachba.c             |  9 +++++++--
 drivers/scsi/aacraid/aacraid.h            |  2 +-
 drivers/scsi/csiostor/csio_hw.c           |  4 +++-
 drivers/scsi/csiostor/csio_init.c         | 12 ++++++++----
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.c        |  3 +++
 drivers/scsi/megaraid/megaraid_sas_base.c |  2 +-
 drivers/scsi/scsi.c                       |  4 ++++
 drivers/scsi/sd.c                         |  3 +++
 drivers/scsi/sd_zbc.c                     |  9 +++++----
 include/scsi/scsi_cmnd.h                  |  1 +
 11 files changed, 47 insertions(+), 13 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index f4538d7a3016..d145e0d90227 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -47,6 +47,17 @@ config SCSI_NETLINK
 	default	n
 	depends on NET
 
+config SCSI_MQ_DEFAULT
+	bool "SCSI: use blk-mq I/O path by default"
+	depends on SCSI
+	---help---
+	  This option enables the new blk-mq based I/O path for SCSI
+	  devices by default.  With the option the scsi_mod.use_blk_mq
+	  module/boot option defaults to Y, without it to N, but it can
+	  still be overridden either way.
+
+	  If unsure say N.
+
 config SCSI_PROC_FS
 	bool "legacy /proc/scsi/ support"
 	depends on SCSI && PROC_FS
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 4591113c49de..a1a2c71e1626 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -549,7 +549,9 @@ static void get_container_name_callback(void *context, struct fib * fibptr)
 	if ((le32_to_cpu(get_name_reply->status) == CT_OK)
 	 && (get_name_reply->data[0] != '\0')) {
 		char *sp = get_name_reply->data;
-		sp[sizeof(((struct aac_get_name_resp *)NULL)->data)] = '\0';
+		int data_size = FIELD_SIZEOF(struct aac_get_name_resp, data);
+
+		sp[data_size - 1] = '\0';
 		while (*sp == ' ')
 			++sp;
 		if (*sp) {
@@ -579,12 +581,15 @@ static void get_container_name_callback(void *context, struct fib * fibptr)
 static int aac_get_container_name(struct scsi_cmnd * scsicmd)
 {
 	int status;
+	int data_size;
 	struct aac_get_name *dinfo;
 	struct fib * cmd_fibcontext;
 	struct aac_dev * dev;
 
 	dev = (struct aac_dev *)scsicmd->device->host->hostdata;
 
+	data_size = FIELD_SIZEOF(struct aac_get_name_resp, data);
+
 	cmd_fibcontext = aac_fib_alloc_tag(dev, scsicmd);
 
 	aac_fib_init(cmd_fibcontext);
@@ -593,7 +598,7 @@ static int aac_get_container_name(struct scsi_cmnd * scsicmd)
 	dinfo->command = cpu_to_le32(VM_ContainerConfig);
 	dinfo->type = cpu_to_le32(CT_READ_NAME);
 	dinfo->cid = cpu_to_le32(scmd_id(scsicmd));
-	dinfo->count = cpu_to_le32(sizeof(((struct aac_get_name_resp *)NULL)->data));
+	dinfo->count = cpu_to_le32(data_size - 1);
 
 	status = aac_fib_send(ContainerCommand,
 		  cmd_fibcontext,
diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
index d31a9bc2ba69..ee2667e20e42 100644
--- a/drivers/scsi/aacraid/aacraid.h
+++ b/drivers/scsi/aacraid/aacraid.h
@@ -2274,7 +2274,7 @@ struct aac_get_name_resp {
 	__le32		parm3;
 	__le32		parm4;
 	__le32		parm5;
-	u8		data[16];
+	u8		data[17];
 };
 
 #define CT_CID_TO_32BITS_UID 165
diff --git a/drivers/scsi/csiostor/csio_hw.c b/drivers/scsi/csiostor/csio_hw.c
index 2029ad225121..5be0086142ca 100644
--- a/drivers/scsi/csiostor/csio_hw.c
+++ b/drivers/scsi/csiostor/csio_hw.c
@@ -3845,8 +3845,10 @@ csio_hw_start(struct csio_hw *hw)
 
 	if (csio_is_hw_ready(hw))
 		return 0;
-	else
+	else if (csio_match_state(hw, csio_hws_uninit))
 		return -EINVAL;
+	else
+		return -ENODEV;
 }
 
 int
diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index ea0c31086cc6..dcd074169aa9 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -969,10 +969,14 @@ static int csio_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	pci_set_drvdata(pdev, hw);
 
-	if (csio_hw_start(hw) != 0) {
-		dev_err(&pdev->dev,
-			"Failed to start FW, continuing in debug mode.\n");
-		return 0;
+	rv = csio_hw_start(hw);
+	if (rv) {
+		if (rv == -EINVAL) {
+			dev_err(&pdev->dev,
+				"Failed to start FW, continuing in debug mode.\n");
+			return 0;
+		}
+		goto err_lnode_exit;
 	}
 
 	sprintf(hw->fwrev_str, "%u.%u.%u.%u\n",
diff --git a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
index a69a9ac836f5..1d02cf9fe06c 100644
--- a/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
+++ b/drivers/scsi/cxgbi/cxgb4i/cxgb4i.c
@@ -1635,6 +1635,9 @@ static int init_act_open(struct cxgbi_sock *csk)
 		goto rel_resource;
 	}
 
+	if (!(n->nud_state & NUD_VALID))
+		neigh_event_send(n, NULL);
+
 	csk->atid = cxgb4_alloc_atid(lldi->tids, csk);
 	if (csk->atid < 0) {
 		pr_err("%s, NO atid available.\n", ndev->name);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 316c3df0c3fd..71c4746341ea 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -6228,8 +6228,8 @@ static int megasas_probe_one(struct pci_dev *pdev,
 fail_start_aen:
 fail_io_attach:
 	megasas_mgmt_info.count--;
-	megasas_mgmt_info.instance[megasas_mgmt_info.max_index] = NULL;
 	megasas_mgmt_info.max_index--;
+	megasas_mgmt_info.instance[megasas_mgmt_info.max_index] = NULL;
 
 	instance->instancet->disable_intr(instance);
 	megasas_destroy_irqs(instance);
diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 3d38c6d463b8..1bf274e3b2b6 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -800,7 +800,11 @@ MODULE_LICENSE("GPL");
 module_param(scsi_logging_level, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(scsi_logging_level, "a bit mask of logging levels");
 
+#ifdef CONFIG_SCSI_MQ_DEFAULT
 bool scsi_use_blk_mq = true;
+#else
+bool scsi_use_blk_mq = false;
+#endif
 module_param_named(use_blk_mq, scsi_use_blk_mq, bool, S_IWUSR | S_IRUGO);
 
 static int __init init_scsi(void)
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bea36adeee17..e2647f2d4430 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1277,6 +1277,9 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = SCpnt->request;
 
+	if (SCpnt->flags & SCMD_ZONE_WRITE_LOCK)
+		sd_zbc_write_unlock_zone(SCpnt);
+
 	if (rq->rq_flags & RQF_SPECIAL_PAYLOAD)
 		__free_page(rq->special_vec.bv_page);
 
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 96855df9f49d..8aa54779aac1 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -294,6 +294,9 @@ int sd_zbc_write_lock_zone(struct scsi_cmnd *cmd)
 	    test_and_set_bit(zno, sdkp->zones_wlock))
 		return BLKPREP_DEFER;
 
+	WARN_ON_ONCE(cmd->flags & SCMD_ZONE_WRITE_LOCK);
+	cmd->flags |= SCMD_ZONE_WRITE_LOCK;
+
 	return BLKPREP_OK;
 }
 
@@ -302,9 +305,10 @@ void sd_zbc_write_unlock_zone(struct scsi_cmnd *cmd)
 	struct request *rq = cmd->request;
 	struct scsi_disk *sdkp = scsi_disk(rq->rq_disk);
 
-	if (sdkp->zones_wlock) {
+	if (sdkp->zones_wlock && cmd->flags & SCMD_ZONE_WRITE_LOCK) {
 		unsigned int zno = sd_zbc_zone_no(sdkp, blk_rq_pos(rq));
 		WARN_ON_ONCE(!test_bit(zno, sdkp->zones_wlock));
+		cmd->flags &= ~SCMD_ZONE_WRITE_LOCK;
 		clear_bit_unlock(zno, sdkp->zones_wlock);
 		smp_mb__after_atomic();
 	}
@@ -335,9 +339,6 @@ void sd_zbc_complete(struct scsi_cmnd *cmd,
 	case REQ_OP_WRITE_ZEROES:
 	case REQ_OP_WRITE_SAME:
 
-		/* Unlock the zone */
-		sd_zbc_write_unlock_zone(cmd);
-
 		if (result &&
 		    sshdr->sense_key == ILLEGAL_REQUEST &&
 		    sshdr->asc == 0x21)
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index a1266d318c85..6af198d8120b 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -57,6 +57,7 @@ struct scsi_pointer {
 /* for scmd->flags */
 #define SCMD_TAGGED		(1 << 0)
 #define SCMD_UNCHECKED_ISA_DMA	(1 << 1)
+#define SCMD_ZONE_WRITE_LOCK	(1 << 2)
 
 struct scsi_cmnd {
 	struct scsi_request req;
