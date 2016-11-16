From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3] ufs: add a variety of definitions decribed in UFS spec
Date: Wed, 16 Nov 2016 14:14:14 +0900
Message-ID: <000801d23fc8$45b14420$d113cc60$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:47682 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750701AbcKPFOQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2016 00:14:16 -0500
Received: from epcpsbgm1new.samsung.com (epcpsbgm1 [203.254.230.26])
 by mailout2.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May  5 2014))
 with ESMTP id <0OGP00RTXYJQ9550@mailout2.samsung.com> for
 linux-scsi@vger.kernel.org; Wed, 16 Nov 2016 14:14:14 +0900 (KST)
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: cpgs@samsung.com, HeonGwang Chu <hg.chu@samsung.com>

These things are defined to be used by some UFS Host controllers.
And a new file for some declarations of mphy standard is added

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
V3: add new macros of all bits of UECDL
--- 
 drivers/scsi/ufs/mphy.h   | 38 ++++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshci.h | 28 +++++++++++++++++++++++++---
 drivers/scsi/ufs/unipro.h | 26 ++++++++++++++++++++++++++
 3 files changed, 89 insertions(+), 3 deletions(-)
 create mode 100644 drivers/scsi/ufs/mphy.h

diff --git a/drivers/scsi/ufs/mphy.h b/drivers/scsi/ufs/mphy.h
new file mode 100644
index 0000000..c431f49
--- /dev/null
+++ b/drivers/scsi/ufs/mphy.h
@@ -0,0 +1,38 @@
+/*
+ * drivers/scsi/ufs/mphy.h
+ *
+ * Copyright (C) 2014 Samsung Electronics Co., Ltd.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+#ifndef _MPHY_H_
+#define _MPHY_H_
+
+#define TX_HIBERN8TIME_CAP		0x0f
+#define TX_MIN_ACTIVATE_TIME		0x33
+
+#define RX_HS_G1_SYNC_LEN_CAP	0x8b
+#define RX_HS_G1_PREP_LEN_CAP	0x8c
+#define RX_HS_G2_SYNC_LEN_CAP	0x94
+#define RX_HS_G3_SYNC_LEN_CAP	0x95
+#define RX_HS_G2_PREP_LEN_CAP	0x96
+#define RX_HS_G3_PREP_LEN_CAP	0x97
+ #define SYNC_RANGE_FINE	(0 << 6)
+ #define SYNC_RANGE_COARSE	(1 << 6)
+ #define SYNC_LEN(x)		((x) & 0x3f)
+ #define PREP_LEN(x)		((x) & 0xf)
+#define RX_ADV_GRANULARITY_CAP		0x98
+ #define RX_ADV_GRAN_STEP(x)	((((x) & 0x3) << 1) | 0x1)
+#define TX_ADV_GRANULARITY_CAP		0x10
+ #define TX_ADV_GRAN_STEP(x)	((((x) & 0x3) << 1) | 0x1)
+#define RX_MIN_ACTIVATETIME_CAP		0x8f
+#define RX_HIBERN8TIME_CAP		0x92
+#define RX_ADV_HIBERN8TIME_CAP		0x99
+#define RX_ADV_MIN_ACTIVATETIME_CAP	0x9a
+
+#endif /* _MPHY_H_ */
+ 
diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
index 9599741..799cb26 100644
--- a/drivers/scsi/ufs/ufshci.h
+++ b/drivers/scsi/ufs/ufshci.h
@@ -170,17 +170,39 @@ enum {
 /* UECDL - Host UIC Error Code Data Link Layer 3Ch */
 #define UIC_DATA_LINK_LAYER_ERROR		UFS_BIT(31)
 #define UIC_DATA_LINK_LAYER_ERROR_CODE_MASK	0x7FFF
-#define UIC_DATA_LINK_LAYER_ERROR_PA_INIT	0x2000
-#define UIC_DATA_LINK_LAYER_ERROR_NAC_RECEIVED	0x0001
-#define UIC_DATA_LINK_LAYER_ERROR_TCx_REPLAY_TIMEOUT 0x0002
+#define UIC_DATA_LINK_LAYER_ERROR_NAC_RECEIVED			UFS_BIT(0)
+#define UIC_DATA_LINK_LAYER_ERROR_TCx_REPLAY_TIMEOUT		UFS_BIT(1)
+#define UIC_DATA_LINK_LAYER_ERROR_AFCx_REQUEST_TIMEOUT		UFS_BIT(2)
+#define UIC_DATA_LINK_LAYER_ERROR_FCx_PROTECTION_TIMEOUT	UFS_BIT(3)
+#define UIC_DATA_LINK_LAYER_ERROR_CRC_ERROR			UFS_BIT(4)
+#define UIC_DATA_LINK_LAYER_ERROR_RX_BUF_OF			UFS_BIT(5)
+#define UIC_DATA_LINK_LAYER_ERROR_MAX_FRAME_LENGTH_EXCEEDED	UFS_BIT(6)
+#define UIC_DATA_LINK_LAYER_ERROR_WRONG_SEQUENCE_NUMBER		UFS_BIT(7)
+#define UIC_DATA_LINK_LAYER_ERROR_AFC_FRAME_SYNTAX_ERROR	UFS_BIT(8)
+#define UIC_DATA_LINK_LAYER_ERROR_NAC_FRAME_SYNTAX_ERROR	UFS_BIT(9)
+#define UIC_DATA_LINK_LAYER_ERROR_EOF_SYNTAX_ERROR		UFS_BIT(10)
+#define UIC_DATA_LINK_LAYER_ERROR_FRAME_SYNTAX_ERROR		UFS_BIT(11)
+#define UIC_DATA_LINK_LAYER_ERROR_BAD_CTRL_SYMBOL_TYPE		UFS_BIT(12)
+#define UIC_DATA_LINK_LAYER_ERROR_PA_INIT			UFS_BIT(13)
+#define UIC_DATA_LINK_LAYER_ERROR_PA_ERROR_IND_RECEIVED		UFS_BIT(14)
+
 
 /* UECN - Host UIC Error Code Network Layer 40h */
 #define UIC_NETWORK_LAYER_ERROR			UFS_BIT(31)
 #define UIC_NETWORK_LAYER_ERROR_CODE_MASK	0x7
+#define UIC_NETWORK_UNSUPPORTED_HEADER_TYPE	BIT(0)
+#define UIC_NETWORK_BAD_DEVICEID_ENC		BIT(1)
+#define UIC_NETWORK_LHDR_TRAP_PACKET_DROPPING	BIT(2)
 
 /* UECT - Host UIC Error Code Transport Layer 44h */
 #define UIC_TRANSPORT_LAYER_ERROR		UFS_BIT(31)
 #define UIC_TRANSPORT_LAYER_ERROR_CODE_MASK	0x7F
+#define UIC_TRANSPORT_UNSUPPORTED_HEADER_TYPE	BIT(0)
+#define UIC_TRANSPORT_UNKNOWN_CPORTID		BIT(1)
+#define UIC_TRANSPORT_NO_CONNECTION_RX		BIT(2)
+#define UIC_TRANSPORT_BAD_TC			BIT(4)
+#define UIC_TRANSPORT_E2E_CREDIT_OVERFLOW	BIT(5)
+#define UIC_TRANSPORT_SAFETY_VALVE_DROPPING	BIT(6)
 
 /* UECDME - Host UIC Error Code DME 48h */
 #define UIC_DME_ERROR			UFS_BIT(31) 
diff --git a/drivers/scsi/ufs/unipro.h b/drivers/scsi/ufs/unipro.h
index eff8b56..490d867 100644
--- a/drivers/scsi/ufs/unipro.h
+++ b/drivers/scsi/ufs/unipro.h
@@ -127,6 +127,7 @@
 #define PA_PACPREQEOBTIMEOUT	0x1591
 #define PA_HIBERN8TIME		0x15A7
 #define PA_LOCALVERINFO		0x15A9
+#define PA_GRANULARITY		0x15AA
 #define PA_TACTIVATE		0x15A8
 #define PA_PACPFRAMECOUNT	0x15C0
 #define PA_PACPERRORCOUNT	0x15C1
@@ -170,6 +171,9 @@ enum {
 	UNCHANGED	= 7,
 };
 
+#define IS_HS_PWR_MODE(m)        (((m) == FAST_MODE) || ((m) == FASTAUTO_MODE))
+#define IS_PWM_PWR_MODE(m)       (((m) == SLOW_MODE) || ((m) == SLOWAUTO_MODE))
+
 /* PA TX/RX Frequency Series */
 enum {
 	PA_HS_MODE_A	= 1,
@@ -231,6 +235,11 @@ enum ufs_unipro_ver {
 #define DL_PEERTC1PRESENT	0x2066
 #define DL_PEERTC1RXINITCREVAL	0x2067
 
+/* Default value of L2 Timer */
+#define FC0PROTTIMEOUTVAL	8191
+#define TC0REPLAYTIMEOUTVAL	65535
+#define AFC0REQTIMEOUTVAL	32767
+
 /*
  * Network Layer Attributes
  */ 
@@ -259,6 +268,23 @@ enum ufs_unipro_ver {
 #define T_TC0TXMAXSDUSIZE	0x4060
 #define T_TC1TXMAXSDUSIZE	0x4061
 
+/* CPort setting */
+#define T_CPORTFLAGS_E2EFC_ON	(1 << 0)
+#define T_CPORTFLAGS_E2EFC_OFF	(0 << 0)
+#define T_CPORTFLAGS_CSD_N_ON	(0 << 1)
+#define T_CPORTFLAGS_CSD_N_OFF	(1 << 1)
+#define T_CPORTFLAGS_CSV_N_ON	(0 << 2)
+#define T_CPORTFLAGS_CSV_N_OFF	(1 << 2)
+#define T_CPORTFLAGS_DEF	(T_CPORTFLAGS_CSV_N_OFF | \
+				T_CPORTFLAGS_CSD_N_OFF | \
+				T_CPORTFLAGS_E2EFC_OFF)
+
+/* CPort connection state */
+enum {
+	CPORT_IDLE = 0,
+	CPORT_CONNECTED,
+};
+
 #ifdef FALSE
 #undef FALSE
 #endif
-- 
2.1.4


