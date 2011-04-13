From: Jing Huang <huangj@brocade.com>
Subject: [PATCH 2/2] bfa: kdump fix
Date: Wed, 13 Apr 2011 11:45:53 -0700
Message-ID: <1302720353-27636-1-git-send-email-huangj@brocade.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-000f0801.pphosted.com ([67.231.144.122]:47700 "EHLO
	mx0a-000f0801.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756985Ab1DMS7K (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Apr 2011 14:59:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de, linux-scsi@vger.kernel.org
Cc: adapter_linux_open_src_team@brocade.com, Jing Huang <huangj@brocade.com>

Root cause: When kernel crashes, bfa IOC state machine and FW doesn't get
a notification and hence are not cleanly shutdown. So registers holding
driver/IOC state information are not reset back to valid disabled/parking
values. This causes subsequent driver initialization to hang during kdump
kernel boot.

Fix description: during the initialization of first PCI function, reset
corresponding register when unclean shutown is detect by reading chip
registers. This will make sure that ioc/fw gets clean re-initialization.
Signed-off-by: Jing Huang <huangj@brocade.com>
---
 drivers/scsi/bfa/bfa_ioc.c    |    4 +++-
 drivers/scsi/bfa/bfa_ioc.h    |    1 +
 drivers/scsi/bfa/bfa_ioc_cb.c |   11 +++++++++++
 drivers/scsi/bfa/bfa_ioc_ct.c |   26 ++++++++++++++++++++++++++
 4 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_ioc.c b/drivers/scsi/bfa/bfa_ioc.c
index c1f72c4..6c7e033 100644
--- a/drivers/scsi/bfa/bfa_ioc.c
+++ b/drivers/scsi/bfa/bfa_ioc.c
@@ -56,6 +56,8 @@ BFA_TRC_FILE(CNA, IOC);
 #define bfa_ioc_map_port(__ioc) ((__ioc)->ioc_hwif->ioc_map_port(__ioc))
 #define bfa_ioc_notify_fail(__ioc)              \
 			((__ioc)->ioc_hwif->ioc_notify_fail(__ioc))
+#define bfa_ioc_sync_start(__ioc)               \
+			((__ioc)->ioc_hwif->ioc_sync_start(__ioc))
 #define bfa_ioc_sync_join(__ioc)                \
 			((__ioc)->ioc_hwif->ioc_sync_join(__ioc))
 #define bfa_ioc_sync_leave(__ioc)               \
@@ -647,7 +649,7 @@ bfa_iocpf_sm_fwcheck(struct bfa_iocpf_s *iocpf, enum iocpf_event event)
 	switch (event) {
 	case IOCPF_E_SEMLOCKED:
 		if (bfa_ioc_firmware_lock(ioc)) {
-			if (bfa_ioc_sync_complete(ioc)) {
+			if (bfa_ioc_sync_start(ioc)) {
 				iocpf->retry_count = 0;
 				bfa_ioc_sync_join(ioc);
 				bfa_fsm_set_state(iocpf, bfa_iocpf_sm_hwinit);
diff --git a/drivers/scsi/bfa/bfa_ioc.h b/drivers/scsi/bfa/bfa_ioc.h
index ec9cf08..c85182a 100644
--- a/drivers/scsi/bfa/bfa_ioc.h
+++ b/drivers/scsi/bfa/bfa_ioc.h
@@ -263,6 +263,7 @@ struct bfa_ioc_hwif_s {
 					bfa_boolean_t msix);
 	void		(*ioc_notify_fail)	(struct bfa_ioc_s *ioc);
 	void		(*ioc_ownership_reset)	(struct bfa_ioc_s *ioc);
+	bfa_boolean_t   (*ioc_sync_start)       (struct bfa_ioc_s *ioc);
 	void		(*ioc_sync_join)	(struct bfa_ioc_s *ioc);
 	void		(*ioc_sync_leave)	(struct bfa_ioc_s *ioc);
 	void		(*ioc_sync_ack)		(struct bfa_ioc_s *ioc);
diff --git a/drivers/scsi/bfa/bfa_ioc_cb.c b/drivers/scsi/bfa/bfa_ioc_cb.c
index e4a0713..89ae4c8 100644
--- a/drivers/scsi/bfa/bfa_ioc_cb.c
+++ b/drivers/scsi/bfa/bfa_ioc_cb.c
@@ -32,6 +32,7 @@ static void bfa_ioc_cb_map_port(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix);
 static void bfa_ioc_cb_notify_fail(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_ownership_reset(struct bfa_ioc_s *ioc);
+static bfa_boolean_t bfa_ioc_cb_sync_start(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_sync_join(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_sync_leave(struct bfa_ioc_s *ioc);
 static void bfa_ioc_cb_sync_ack(struct bfa_ioc_s *ioc);
@@ -53,6 +54,7 @@ bfa_ioc_set_cb_hwif(struct bfa_ioc_s *ioc)
 	hwif_cb.ioc_isr_mode_set = bfa_ioc_cb_isr_mode_set;
 	hwif_cb.ioc_notify_fail = bfa_ioc_cb_notify_fail;
 	hwif_cb.ioc_ownership_reset = bfa_ioc_cb_ownership_reset;
+	hwif_cb.ioc_sync_start = bfa_ioc_cb_sync_start;
 	hwif_cb.ioc_sync_join = bfa_ioc_cb_sync_join;
 	hwif_cb.ioc_sync_leave = bfa_ioc_cb_sync_leave;
 	hwif_cb.ioc_sync_ack = bfa_ioc_cb_sync_ack;
@@ -195,6 +197,15 @@ bfa_ioc_cb_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix)
 }
 
 /*
+ * Synchronized IOC failure processing routines
+ */
+static bfa_boolean_t
+bfa_ioc_cb_sync_start(struct bfa_ioc_s *ioc)
+{
+	return bfa_ioc_cb_sync_complete(ioc);
+}
+
+/*
  * Cleanup hw semaphore and usecnt registers
  */
 static void
diff --git a/drivers/scsi/bfa/bfa_ioc_ct.c b/drivers/scsi/bfa/bfa_ioc_ct.c
index 008d129..9361252 100644
--- a/drivers/scsi/bfa/bfa_ioc_ct.c
+++ b/drivers/scsi/bfa/bfa_ioc_ct.c
@@ -41,6 +41,7 @@ static void bfa_ioc_ct_map_port(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_isr_mode_set(struct bfa_ioc_s *ioc, bfa_boolean_t msix);
 static void bfa_ioc_ct_notify_fail(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc);
+static bfa_boolean_t bfa_ioc_ct_sync_start(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_sync_join(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_sync_leave(struct bfa_ioc_s *ioc);
 static void bfa_ioc_ct_sync_ack(struct bfa_ioc_s *ioc);
@@ -62,6 +63,7 @@ bfa_ioc_set_ct_hwif(struct bfa_ioc_s *ioc)
 	hwif_ct.ioc_isr_mode_set = bfa_ioc_ct_isr_mode_set;
 	hwif_ct.ioc_notify_fail = bfa_ioc_ct_notify_fail;
 	hwif_ct.ioc_ownership_reset = bfa_ioc_ct_ownership_reset;
+	hwif_ct.ioc_sync_start = bfa_ioc_ct_sync_start;
 	hwif_ct.ioc_sync_join = bfa_ioc_ct_sync_join;
 	hwif_ct.ioc_sync_leave = bfa_ioc_ct_sync_leave;
 	hwif_ct.ioc_sync_ack = bfa_ioc_ct_sync_ack;
@@ -351,6 +353,30 @@ bfa_ioc_ct_ownership_reset(struct bfa_ioc_s *ioc)
 	writel(1, ioc->ioc_regs.ioc_sem_reg);
 }
 
+static bfa_boolean_t
+bfa_ioc_ct_sync_start(struct bfa_ioc_s *ioc)
+{
+	uint32_t r32 = readl(ioc->ioc_regs.ioc_fail_sync);
+	uint32_t sync_reqd = bfa_ioc_ct_get_sync_reqd(r32);
+
+	/*
+	 * Driver load time.  If the sync required bit for this PCI fn
+	 * is set, it is due to an unclean exit by the driver for this
+	 * PCI fn in the previous incarnation. Whoever comes here first
+	 * should clean it up, no matter which PCI fn.
+	 */
+
+	if (sync_reqd & bfa_ioc_ct_sync_pos(ioc)) {
+		writel(0, ioc->ioc_regs.ioc_fail_sync);
+		writel(1, ioc->ioc_regs.ioc_usage_reg);
+		writel(BFI_IOC_UNINIT, ioc->ioc_regs.ioc_fwstate);
+		writel(BFI_IOC_UNINIT, ioc->ioc_regs.alt_ioc_fwstate);
+		return BFA_TRUE;
+	}
+
+	return bfa_ioc_ct_sync_complete(ioc);
+}
+
 /*
  * Synchronized IOC failure processing routines
  */
-- 
1.6.5.2

