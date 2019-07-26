From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.3-rc1
Date: Fri, 26 Jul 2019 13:08:05 -0700
Message-ID: <1564171685.9950.14.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Nine fixes: The most important core one is the dma_max_mapping_size fix
that corrects the boot problem Gunter Roeck was having.  A couple of
other driver only fixes are significant, like the cxgbi selector
support addition, the alua 2 second delay and the fdomain build fix.

As you know I use expiring keys, so I've renewed and updated my current
keys on the keyservers, but if you're not using them, you can get it
from my DNSSEC using DANE with:

gpg --auto-key-locate dane --recv-keys D5606E73C8B46271BEAD9ADF814AE47C214854D6 

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Arnd Bergmann (1):
      scsi: fdomain: fix building pcmcia front-end

Christoph Hellwig (1):
      scsi: core: fix the dma_max_mapping_size call

Christophe JAILLET (1):
      scsi: fcoe: fix a typo

Colin Ian King (1):
      scsi: megaraid_sas: fix spelling mistake "megarid_sas" -> "megaraid_sas"

Hannes Reinecke (1):
      scsi: scsi_dh_alua: always use a 2 second delay before retrying RTPG

Junxiao Bi (1):
      scsi: megaraid_sas: fix panic on loading firmware crashdump

Tyrel Datwyler (1):
      scsi: ibmvfc: fix WARN_ON during event pool release

Varun Prakash (1):
      scsi: target: cxgbit: add support for IEEE_8021QAZ_APP_SEL_STREAM selector

YueHaibing (1):
      scsi: megaraid_sas: Make some functions static

And the diffstat:

 drivers/scsi/Kconfig                        |  4 ++--
 drivers/scsi/device_handler/scsi_dh_alua.c  |  7 ++++++-
 drivers/scsi/fcoe/fcoe_ctlr.c               |  2 +-
 drivers/scsi/ibmvscsi/ibmvfc.c              |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  5 ++++-
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 27 ++++++++++++++-------------
 drivers/scsi/scsi_lib.c                     |  6 ++++--
 drivers/target/iscsi/cxgbit/cxgbit_cm.c     |  8 +++++---
 drivers/target/iscsi/cxgbit/cxgbit_main.c   |  3 ++-
 include/scsi/libfcoe.h                      |  2 +-
 10 files changed, 40 insertions(+), 26 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 75f66f8ad3ea..1b92f3c19ff3 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -1523,10 +1523,10 @@ config SCSI_VIRTIO
 
 source "drivers/scsi/csiostor/Kconfig"
 
-endif # SCSI_LOWLEVEL
-
 source "drivers/scsi/pcmcia/Kconfig"
 
+endif # SCSI_LOWLEVEL
+
 source "drivers/scsi/device_handler/Kconfig"
 
 endmenu
diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index f0066f8a1786..4971104b1817 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -40,6 +40,7 @@
 #define ALUA_FAILOVER_TIMEOUT		60
 #define ALUA_FAILOVER_RETRIES		5
 #define ALUA_RTPG_DELAY_MSECS		5
+#define ALUA_RTPG_RETRY_DELAY		2
 
 /* device handler flags */
 #define ALUA_OPTIMIZE_STPG		0x01
@@ -682,7 +683,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 	case SCSI_ACCESS_STATE_TRANSITIONING:
 		if (time_before(jiffies, pg->expiry)) {
 			/* State transition, retry */
-			pg->interval = 2;
+			pg->interval = ALUA_RTPG_RETRY_DELAY;
 			err = SCSI_DH_RETRY;
 		} else {
 			struct alua_dh_data *h;
@@ -807,6 +808,8 @@ static void alua_rtpg_work(struct work_struct *work)
 				spin_lock_irqsave(&pg->lock, flags);
 				pg->flags &= ~ALUA_PG_RUNNING;
 				pg->flags |= ALUA_PG_RUN_RTPG;
+				if (!pg->interval)
+					pg->interval = ALUA_RTPG_RETRY_DELAY;
 				spin_unlock_irqrestore(&pg->lock, flags);
 				queue_delayed_work(kaluad_wq, &pg->rtpg_work,
 						   pg->interval * HZ);
@@ -818,6 +821,8 @@ static void alua_rtpg_work(struct work_struct *work)
 		spin_lock_irqsave(&pg->lock, flags);
 		if (err == SCSI_DH_RETRY || pg->flags & ALUA_PG_RUN_RTPG) {
 			pg->flags &= ~ALUA_PG_RUNNING;
+			if (!pg->interval && !(pg->flags & ALUA_PG_RUN_RTPG))
+				pg->interval = ALUA_RTPG_RETRY_DELAY;
 			pg->flags |= ALUA_PG_RUN_RTPG;
 			spin_unlock_irqrestore(&pg->lock, flags);
 			queue_delayed_work(kaluad_wq, &pg->rtpg_work,
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 590ec8009f52..1a85fe9e4b7b 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -1019,7 +1019,7 @@ static void fcoe_ctlr_recv_adv(struct fcoe_ctlr *fip, struct sk_buff *skb)
 {
 	struct fcoe_fcf *fcf;
 	struct fcoe_fcf new;
-	unsigned long sol_tov = msecs_to_jiffies(FCOE_CTRL_SOL_TOV);
+	unsigned long sol_tov = msecs_to_jiffies(FCOE_CTLR_SOL_TOV);
 	int first = 0;
 	int mtu_valid;
 	int found = 0;
diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index acd16e0d52cf..8cdbac076a1b 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -4864,8 +4864,8 @@ static int ibmvfc_remove(struct vio_dev *vdev)
 
 	spin_lock_irqsave(vhost->host->host_lock, flags);
 	ibmvfc_purge_requests(vhost, DID_ERROR);
-	ibmvfc_free_event_pool(vhost);
 	spin_unlock_irqrestore(vhost->host->host_lock, flags);
+	ibmvfc_free_event_pool(vhost);
 
 	ibmvfc_free_mem(vhost);
 	spin_lock(&ibmvfc_driver_lock);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index b2339d04a700..f9f07935556e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -3163,6 +3163,7 @@ fw_crash_buffer_show(struct device *cdev,
 		(struct megasas_instance *) shost->hostdata;
 	u32 size;
 	unsigned long dmachunk = CRASH_DMA_BUF_SIZE;
+	unsigned long chunk_left_bytes;
 	unsigned long src_addr;
 	unsigned long flags;
 	u32 buff_offset;
@@ -3186,6 +3187,8 @@ fw_crash_buffer_show(struct device *cdev,
 	}
 
 	size = (instance->fw_crash_buffer_size * dmachunk) - buff_offset;
+	chunk_left_bytes = dmachunk - (buff_offset % dmachunk);
+	size = (size > chunk_left_bytes) ? chunk_left_bytes : size;
 	size = (size >= PAGE_SIZE) ? (PAGE_SIZE - 1) : size;
 
 	src_addr = (unsigned long)instance->crash_buf[buff_offset / dmachunk] +
@@ -8763,7 +8766,7 @@ static int __init megasas_init(void)
 
 	if ((event_log_level < MFI_EVT_CLASS_DEBUG) ||
 	    (event_log_level > MFI_EVT_CLASS_DEAD)) {
-		printk(KERN_WARNING "megarid_sas: provided event log level is out of range, setting it to default 2(CLASS_CRITICAL), permissible range is: -2 to 4\n");
+		pr_warn("megaraid_sas: provided event log level is out of range, setting it to default 2(CLASS_CRITICAL), permissible range is: -2 to 4\n");
 		event_log_level = MFI_EVT_CLASS_CRITICAL;
 	}
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index a32b3f0fcd15..120e3c4de8c2 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -537,7 +537,7 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 	return 0;
 }
 
-int
+static int
 megasas_alloc_cmdlist_fusion(struct megasas_instance *instance)
 {
 	u32 max_mpt_cmd, i, j;
@@ -576,7 +576,8 @@ megasas_alloc_cmdlist_fusion(struct megasas_instance *instance)
 
 	return 0;
 }
-int
+
+static int
 megasas_alloc_request_fusion(struct megasas_instance *instance)
 {
 	struct fusion_context *fusion;
@@ -657,7 +658,7 @@ megasas_alloc_request_fusion(struct megasas_instance *instance)
 	return 0;
 }
 
-int
+static int
 megasas_alloc_reply_fusion(struct megasas_instance *instance)
 {
 	int i, count;
@@ -734,7 +735,7 @@ megasas_alloc_reply_fusion(struct megasas_instance *instance)
 	return 0;
 }
 
-int
+static int
 megasas_alloc_rdpq_fusion(struct megasas_instance *instance)
 {
 	int i, j, k, msix_count;
@@ -916,7 +917,7 @@ megasas_free_reply_fusion(struct megasas_instance *instance) {
  * and is used as SMID of the cmd.
  * SMID value range is from 1 to max_fw_cmds.
  */
-int
+static int
 megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 {
 	int i;
@@ -1736,7 +1737,7 @@ static inline void megasas_free_ioc_init_cmd(struct megasas_instance *instance)
  *
  * This is the main function for initializing firmware.
  */
-u32
+static u32
 megasas_init_adapter_fusion(struct megasas_instance *instance)
 {
 	struct fusion_context *fusion;
@@ -1962,7 +1963,7 @@ megasas_fusion_stop_watchdog(struct megasas_instance *instance)
  * @ext_status :	ext status of cmd returned by FW
  */
 
-void
+static void
 map_cmd_status(struct fusion_context *fusion,
 		struct scsi_cmnd *scmd, u8 status, u8 ext_status,
 		u32 data_length, u8 *sense)
@@ -2375,7 +2376,7 @@ int megasas_make_sgl(struct megasas_instance *instance, struct scsi_cmnd *scp,
  *
  * Used to set the PD LBA in CDB for FP IOs
  */
-void
+static void
 megasas_set_pd_lba(struct MPI2_RAID_SCSI_IO_REQUEST *io_request, u8 cdb_len,
 		   struct IO_REQUEST_INFO *io_info, struct scsi_cmnd *scp,
 		   struct MR_DRV_RAID_MAP_ALL *local_map_ptr, u32 ref_tag)
@@ -2714,7 +2715,7 @@ megasas_set_raidflag_cpu_affinity(struct fusion_context *fusion,
  * Prepares the io_request and chain elements (sg_frame) for IO
  * The IO can be for PD (Fast Path) or LD
  */
-void
+static void
 megasas_build_ldio_fusion(struct megasas_instance *instance,
 			  struct scsi_cmnd *scp,
 			  struct megasas_cmd_fusion *cmd)
@@ -3211,7 +3212,7 @@ megasas_build_syspd_fusion(struct megasas_instance *instance,
  * Invokes helper functions to prepare request frames
  * and sets flags appropriate for IO/Non-IO cmd
  */
-int
+static int
 megasas_build_io_fusion(struct megasas_instance *instance,
 			struct scsi_cmnd *scp,
 			struct megasas_cmd_fusion *cmd)
@@ -3325,9 +3326,9 @@ megasas_get_request_descriptor(struct megasas_instance *instance, u16 index)
 /* megasas_prepate_secondRaid1_IO
  *  It prepares the raid 1 second IO
  */
-void megasas_prepare_secondRaid1_IO(struct megasas_instance *instance,
-			    struct megasas_cmd_fusion *cmd,
-			    struct megasas_cmd_fusion *r1_cmd)
+static void megasas_prepare_secondRaid1_IO(struct megasas_instance *instance,
+					   struct megasas_cmd_fusion *cmd,
+					   struct megasas_cmd_fusion *r1_cmd)
 {
 	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc, *req_desc2 = NULL;
 	struct fusion_context *fusion;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9381171c2fc0..11e64b50497f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1784,8 +1784,10 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 		blk_queue_max_integrity_segments(q, shost->sg_prot_tablesize);
 	}
 
-	shost->max_sectors = min_t(unsigned int, shost->max_sectors,
-			dma_max_mapping_size(dev) << SECTOR_SHIFT);
+	if (dev->dma_mask) {
+		shost->max_sectors = min_t(unsigned int, shost->max_sectors,
+				dma_max_mapping_size(dev) >> SECTOR_SHIFT);
+	}
 	blk_queue_max_hw_sectors(q, shost->max_sectors);
 	if (shost->unchecked_isa_dma)
 		blk_queue_bounce_limit(q, BLK_BOUNCE_ISA);
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index 22dd4c457d6a..c70caf4ea490 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -875,10 +875,12 @@ static u8 cxgbit_get_iscsi_dcb_priority(struct net_device *ndev, u16 local_port)
 		return 0;
 
 	if (caps & DCB_CAP_DCBX_VER_IEEE) {
-		iscsi_dcb_app.selector = IEEE_8021QAZ_APP_SEL_ANY;
-
+		iscsi_dcb_app.selector = IEEE_8021QAZ_APP_SEL_STREAM;
 		ret = dcb_ieee_getapp_mask(ndev, &iscsi_dcb_app);
-
+		if (!ret) {
+			iscsi_dcb_app.selector = IEEE_8021QAZ_APP_SEL_ANY;
+			ret = dcb_ieee_getapp_mask(ndev, &iscsi_dcb_app);
+		}
 	} else if (caps & DCB_CAP_DCBX_VER_CEE) {
 		iscsi_dcb_app.selector = DCB_APP_IDTYPE_PORTNUM;
 
diff --git a/drivers/target/iscsi/cxgbit/cxgbit_main.c b/drivers/target/iscsi/cxgbit/cxgbit_main.c
index 343b129c2cfa..e877b917c15f 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_main.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_main.c
@@ -589,7 +589,8 @@ static void cxgbit_dcb_workfn(struct work_struct *work)
 	iscsi_app = &dcb_work->dcb_app;
 
 	if (iscsi_app->dcbx & DCB_CAP_DCBX_VER_IEEE) {
-		if (iscsi_app->app.selector != IEEE_8021QAZ_APP_SEL_ANY)
+		if ((iscsi_app->app.selector != IEEE_8021QAZ_APP_SEL_STREAM) &&
+		    (iscsi_app->app.selector != IEEE_8021QAZ_APP_SEL_ANY))
 			goto out;
 
 		priority = iscsi_app->app.priority;
diff --git a/include/scsi/libfcoe.h b/include/scsi/libfcoe.h
index c50fb297e265..dc14b52577f7 100644
--- a/include/scsi/libfcoe.h
+++ b/include/scsi/libfcoe.h
@@ -31,7 +31,7 @@
  * FIP tunable parameters.
  */
 #define FCOE_CTLR_START_DELAY	2000	/* mS after first adv. to choose FCF */
-#define FCOE_CTRL_SOL_TOV	2000	/* min. solicitation interval (mS) */
+#define FCOE_CTLR_SOL_TOV	2000	/* min. solicitation interval (mS) */
 #define FCOE_CTLR_FCF_LIMIT	20	/* max. number of FCF entries */
 #define FCOE_CTLR_VN2VN_LOGIN_LIMIT 3	/* max. VN2VN rport login retries */
 
