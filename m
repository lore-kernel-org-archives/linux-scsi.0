From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v1 09/10] scsi: ufs: add quirk to handle broken UFS HCI version
Date: Sun, 17 May 2015 18:55:05 +0300
Message-ID: <1431878106-30579-10-git-send-email-ygardi@codeaurora.org>
References: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431878106-30579-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, dovl@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Some host controller hardware controllers may not advertise correct
version in UFS HCI VER register. To workaround this, add new quirk
and call the host controller hardware vendor specific callback to
get the correct UFS HCI version register value.

Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c |  5 +++++
 drivers/scsi/ufs/ufshcd.h | 10 ++++++++++
 drivers/scsi/ufs/ufshci.h |  5 +++--
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 014f1c0..b0ade73 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -271,6 +271,11 @@ static inline u32 ufshcd_get_intr_mask(struct ufs_hba *hba)
  */
 static inline u32 ufshcd_get_ufs_version(struct ufs_hba *hba)
 {
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION) {
+		if (hba->vops && hba->vops->get_ufs_hci_version)
+			return hba->vops->get_ufs_hci_version(hba);
+	}
+
 	return ufshcd_readl(hba, REG_UFS_VERSION);
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index eb6831d..c40a0e7 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -246,6 +246,7 @@ struct ufs_pwr_mode_info {
  * @name: variant name
  * @init: called when the driver is initialized
  * @exit: called to cleanup everything done in init
+ * @get_ufs_hci_version: called to get UFS HCI version
  * @clk_scale_notify: notifies that clks are scaled up/down
  * @setup_clocks: called before touching any of the controller registers
  * @setup_regulators: called before accessing the host controller
@@ -263,6 +264,7 @@ struct ufs_hba_variant_ops {
 	const char *name;
 	int	(*init)(struct ufs_hba *);
 	void    (*exit)(struct ufs_hba *);
+	u32	(*get_ufs_hci_version)(struct ufs_hba *);
 	void    (*clk_scale_notify)(struct ufs_hba *);
 	int     (*setup_clocks)(struct ufs_hba *, bool);
 	int     (*setup_regulators)(struct ufs_hba *, bool);
@@ -449,6 +451,14 @@ struct ufs_hba {
 	 */
 	#define UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE		UFS_BIT(4)
 
+	/*
+	 * This quirk needs to be enabled if the host contoller doesn't
+	 * advertise the correct version in UFS_VER register. If this quirk
+	 * is enabled, standard UFS host driver will call the vendor specific
+	 * ops (get_ufs_hci_version) to get the correct version.
+	 */
+	#define UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		UFS_BIT(5)
+
 	unsigned int quirks;	/* Deviations from standard UFSHCI spec. */
 
 	wait_queue_head_t tm_wq;
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index f8909ec..0ae0967 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -89,8 +89,9 @@ enum {
 
 /* Controller UFSHCI version */
 enum {
-	UFSHCI_VERSION_10 = 0x00010000,
-	UFSHCI_VERSION_11 = 0x00010100,
+	UFSHCI_VERSION_10 = 0x00010000, /* 1.0 */
+	UFSHCI_VERSION_11 = 0x00010100, /* 1.1 */
+	UFSHCI_VERSION_20 = 0x00000200, /* 2.0 */
 };
 
 /*
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
