From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: [PATCH v3 6/6] scsi: ufs: configure the attribute for power mode
Date: Mon, 26 Aug 2013 23:41:01 +0900
Message-ID: <003b01cea26a$48ffa670$dafef350$%jun@samsung.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
 <001d01ce8a06$76bb3420$64319c60$%jun@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:20239 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039Ab3HZOlC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 10:41:02 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout1.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MS5009NP7GBBQ10@mailout1.samsung.com> for
 linux-scsi@vger.kernel.org; Mon, 26 Aug 2013 23:41:01 +0900 (KST)
In-reply-to: 
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <James.Bottomley@HansenPartnership.com>

UIC attributes can be set with using DME_SET command for
power mode change. For configuration the link capability
attributes are used, which is updated after successful
link startup.

Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c |   66 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/unipro.h |   21 ++++++++++++++
 2 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c67118d..2ae845c 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1598,6 +1598,70 @@ out:
 }
 
 /**
+ * ufshcd_config_max_pwr_mode - Set & Change power mode with
+ *	maximum capability attribute information.
+ * @hba: per adapter instance
+ *
+ * Returns 0 on success, non-zero value on failure
+ */
+static int ufshcd_config_max_pwr_mode(struct ufs_hba *hba)
+{
+	enum {RX = 0, TX = 1};
+	u32 lanes[] = {1, 1};
+	u32 gear[] = {1, 1};
+	u8 pwr[] = {FASTAUTO_MODE, FASTAUTO_MODE};
+	int ret;
+
+	/* Get the connected lane count */
+	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES), &lanes[RX]);
+	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES), &lanes[TX]);
+
+	/*
+	 * First, get the maximum gears of HS speed.
+	 * If a zero value, it means there is no HSGEAR capability.
+	 * Then, get the maximum gears of PWM speed.
+	 */
+	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_MAXRXHSGEAR), &gear[RX]);
+	if (!gear[RX]) {
+		ufshcd_dme_get(hba, UIC_ARG_MIB(PA_MAXRXPWMGEAR), &gear[RX]);
+		pwr[RX] = SLOWAUTO_MODE;
+	}
+
+	ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_MAXRXHSGEAR), &gear[TX]);
+	if (!gear[TX]) {
+		ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_MAXRXPWMGEAR),
+				    &gear[TX]);
+		pwr[TX] = SLOWAUTO_MODE;
+	}
+
+	/*
+	 * Configure attributes for power mode change with below.
+	 * - PA_RXGEAR, PA_ACTIVERXDATALANES, PA_RXTERMINATION,
+	 * - PA_TXGEAR, PA_ACTIVETXDATALANES, PA_TXTERMINATION,
+	 * - PA_HSSERIES
+	 */
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXGEAR), gear[RX]);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVERXDATALANES), lanes[RX]);
+	if (pwr[RX] == FASTAUTO_MODE)
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_RXTERMINATION), TRUE);
+
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXGEAR), gear[TX]);
+	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_ACTIVETXDATALANES), lanes[TX]);
+	if (pwr[TX] == FASTAUTO_MODE)
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_TXTERMINATION), TRUE);
+
+	if (pwr[RX] == FASTAUTO_MODE || pwr[TX] == FASTAUTO_MODE)
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HSSERIES), PA_HS_MODE_B);
+
+	ret = ufshcd_uic_change_pwr_mode(hba, pwr[RX] << 4 | pwr[TX]);
+	if (ret)
+		dev_err(hba->dev,
+			"pwr_mode: power mode change failed %d\n", ret);
+
+	return ret;
+}
+
+/**
  * ufshcd_complete_dev_init() - checks device readiness
  * hba: per-adapter instance
  *
@@ -2942,6 +3006,8 @@ static void ufshcd_async_scan(void *data, async_cookie_t cookie)
 	if (ret)
 		goto out;
 
+	ufshcd_config_max_pwr_mode(hba);
+
 	ret = ufshcd_verify_dev_init(hba);
 	if (ret)
 		goto out;
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index 3a710eb..0bb8041 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -72,6 +72,21 @@
 #define PA_STALLNOCONFIGTIME	0x15A3
 #define PA_SAVECONFIGTIME	0x15A4
 
+/* PA power modes */
+enum {
+	FAST_MODE	= 1,
+	SLOW_MODE	= 2,
+	FASTAUTO_MODE	= 4,
+	SLOWAUTO_MODE	= 5,
+	UNCHANGED	= 7,
+};
+
+/* PA TX/RX Frequency Series */
+enum {
+	PA_HS_MODE_A	= 1,
+	PA_HS_MODE_B	= 2,
+};
+
 /*
  * Data Link Layer Attributes
  */
@@ -127,4 +142,10 @@
 #define T_TC0TXMAXSDUSIZE	0x4060
 #define T_TC1TXMAXSDUSIZE	0x4061
 
+/* Boolean attribute values */
+enum {
+	FALSE = 0,
+	TRUE,
+};
+
 #endif /* _UNIPRO_H_ */
-- 
1.7.0.4


