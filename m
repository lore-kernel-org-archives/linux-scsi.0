From: John Garry <john.garry@huawei.com>
Subject: [PATCH 1/3] hisi_sas: fix v1 itct masks
Date: Mon, 21 Dec 2015 19:35:07 +0800
Message-ID: <1450697709-120516-2-git-send-email-john.garry@huawei.com>
References: <1450697709-120516-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:51422 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbbLULZL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Dec 2015 06:25:11 -0500
In-Reply-To: <1450697709-120516-1-git-send-email-john.garry@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, John Garry <john.garry@huawei.com>

The mask fields are for quad-words, so add ULL suffix.
Also unreferenced ITCT_HDR_BREAK_REPLY and
ITCT_HDR_MAX_BURST are removed.

Fixes: 50af155b6c ("hisi_sas: Add v1 hardware reg")

Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
index d543811..0af682c 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v1_hw.c
@@ -247,41 +247,36 @@
 /* ITCT header */
 /* qw0 */
 #define ITCT_HDR_DEV_TYPE_OFF		0
-#define ITCT_HDR_DEV_TYPE_MSK		(0x3 << ITCT_HDR_DEV_TYPE_OFF)
+#define ITCT_HDR_DEV_TYPE_MSK		(0x3ULL << ITCT_HDR_DEV_TYPE_OFF)
 #define ITCT_HDR_VALID_OFF		2
-#define ITCT_HDR_VALID_MSK		(0x1 << ITCT_HDR_VALID_OFF)
-#define ITCT_HDR_BREAK_REPLY_ENA_OFF	3
-#define ITCT_HDR_BREAK_REPLY_ENA_MSK	(0x1 << ITCT_HDR_BREAK_REPLY_ENA_OFF)
+#define ITCT_HDR_VALID_MSK		(0x1ULL << ITCT_HDR_VALID_OFF)
 #define ITCT_HDR_AWT_CONTROL_OFF	4
-#define ITCT_HDR_AWT_CONTROL_MSK	(0x1 << ITCT_HDR_AWT_CONTROL_OFF)
+#define ITCT_HDR_AWT_CONTROL_MSK	(0x1ULL << ITCT_HDR_AWT_CONTROL_OFF)
 #define ITCT_HDR_MAX_CONN_RATE_OFF	5
-#define ITCT_HDR_MAX_CONN_RATE_MSK	(0xf << ITCT_HDR_MAX_CONN_RATE_OFF)
+#define ITCT_HDR_MAX_CONN_RATE_MSK	(0xfULL << ITCT_HDR_MAX_CONN_RATE_OFF)
 #define ITCT_HDR_VALID_LINK_NUM_OFF	9
-#define ITCT_HDR_VALID_LINK_NUM_MSK	(0xf << ITCT_HDR_VALID_LINK_NUM_OFF)
+#define ITCT_HDR_VALID_LINK_NUM_MSK	(0xfULL << ITCT_HDR_VALID_LINK_NUM_OFF)
 #define ITCT_HDR_PORT_ID_OFF		13
-#define ITCT_HDR_PORT_ID_MSK		(0x7 << ITCT_HDR_PORT_ID_OFF)
+#define ITCT_HDR_PORT_ID_MSK		(0x7ULL << ITCT_HDR_PORT_ID_OFF)
 #define ITCT_HDR_SMP_TIMEOUT_OFF	16
-#define ITCT_HDR_SMP_TIMEOUT_MSK	(0xffff << ITCT_HDR_SMP_TIMEOUT_OFF)
-#define ITCT_HDR_MAX_BURST_BYTES_OFF	16
-#define ITCT_HDR_MAX_BURST_BYTES_MSK	(0xffffffff << \
-					ITCT_MAX_BURST_BYTES_OFF)
+#define ITCT_HDR_SMP_TIMEOUT_MSK	(0xffffULL << ITCT_HDR_SMP_TIMEOUT_OFF)
 /* qw1 */
 #define ITCT_HDR_MAX_SAS_ADDR_OFF	0
 #define ITCT_HDR_MAX_SAS_ADDR_MSK	(0xffffffffffffffff << \
 					ITCT_HDR_MAX_SAS_ADDR_OFF)
 /* qw2 */
 #define ITCT_HDR_IT_NEXUS_LOSS_TL_OFF	0
-#define ITCT_HDR_IT_NEXUS_LOSS_TL_MSK	(0xffff << \
+#define ITCT_HDR_IT_NEXUS_LOSS_TL_MSK	(0xffffULL << \
 					ITCT_HDR_IT_NEXUS_LOSS_TL_OFF)
 #define ITCT_HDR_BUS_INACTIVE_TL_OFF	16
-#define ITCT_HDR_BUS_INACTIVE_TL_MSK	(0xffff << \
+#define ITCT_HDR_BUS_INACTIVE_TL_MSK	(0xffffULL << \
 					ITCT_HDR_BUS_INACTIVE_TL_OFF)
 #define ITCT_HDR_MAX_CONN_TL_OFF	32
-#define ITCT_HDR_MAX_CONN_TL_MSK	(0xffff << \
+#define ITCT_HDR_MAX_CONN_TL_MSK	(0xffffULL << \
 					ITCT_HDR_MAX_CONN_TL_OFF)
 #define ITCT_HDR_REJ_OPEN_TL_OFF	48
-#define ITCT_HDR_REJ_OPEN_TL_MSK	(0xffff << \
-					ITCT_REJ_OPEN_TL_OFF)
+#define ITCT_HDR_REJ_OPEN_TL_MSK	(0xffffULL << \
+					ITCT_HDR_REJ_OPEN_TL_OFF)
 
 /* Err record header */
 #define ERR_HDR_DMA_TX_ERR_TYPE_OFF	0
-- 
1.9.1

