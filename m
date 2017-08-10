From: John Garry <john.garry@huawei.com>
Subject: [PATCH 03/19] scsi: hisi_sas: fix v2 hw underflow residual value
Date: Fri, 11 Aug 2017 00:09:28 +0800
Message-ID: <1502381384-219889-4-git-send-email-john.garry@huawei.com>
References: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1502381384-219889-1-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linuxarm@huawei.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, bianpan2016@163.com, Xiang Chen <chenxiang66@hisilicon.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiang Chen <chenxiang66@hisilicon.com>

The value dw0 is the residual bytes when UNDERFLOW error
happens, but we filled the residual with the value of dw3
before. So change the residual from dw3 to dw0.

Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
Signed-off-by: John Garry <john.garry@huawei.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 8c504b4..a762b25 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1972,7 +1972,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 		}
 		case DMA_RX_DATA_LEN_UNDERFLOW:
 		{
-			ts->residual = dma_rx_err_type;
+			ts->residual = trans_tx_fail_type;
 			ts->stat = SAS_DATA_UNDERRUN;
 			break;
 		}
@@ -2098,7 +2098,7 @@ static void slot_err_v2_hw(struct hisi_hba *hisi_hba,
 		}
 		case DMA_RX_DATA_LEN_UNDERFLOW:
 		{
-			ts->residual = dma_rx_err_type;
+			ts->residual = trans_tx_fail_type;
 			ts->stat = SAS_DATA_UNDERRUN;
 			break;
 		}
-- 
1.9.1
