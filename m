From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: hisi_sas: make several const arrays static
Date: Tue, 11 Jul 2017 13:11:44 +0100
Message-ID: <20170711121144.15840-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: John Garry <john.garry@huawei.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate various tables on the stack but make them static const.
Makes the object code smaller by over 280 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
  39887	   5080	     64	  45031	   afe7	hisi_sas_v2_hw.o

After:
   text	   data	    bss	    dec	    hex	filename
  39318	   5368	     64	  44750	   aece	hisi_sas_v2_hw.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
index 551d103c27f1..2bfea7082e3a 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v2_hw.c
@@ -1693,7 +1693,7 @@ static int prep_ssp_v2_hw(struct hisi_hba *hisi_hba,
 
 static int parse_trans_tx_err_code_v2_hw(u32 err_msk)
 {
-	const u8 trans_tx_err_code_prio[] = {
+	static const u8 trans_tx_err_code_prio[] = {
 		TRANS_TX_OPEN_FAIL_WITH_IT_NEXUS_LOSS,
 		TRANS_TX_ERR_PHY_NOT_ENABLE,
 		TRANS_TX_OPEN_CNX_ERR_WRONG_DESTINATION,
@@ -1738,7 +1738,7 @@ static int parse_trans_tx_err_code_v2_hw(u32 err_msk)
 
 static int parse_trans_rx_err_code_v2_hw(u32 err_msk)
 {
-	const u8 trans_rx_err_code_prio[] = {
+	static const u8 trans_rx_err_code_prio[] = {
 		TRANS_RX_ERR_WITH_RXFRAME_CRC_ERR,
 		TRANS_RX_ERR_WITH_RXFIS_8B10B_DISP_ERR,
 		TRANS_RX_ERR_WITH_RXFRAME_HAVE_ERRPRM,
@@ -1784,7 +1784,7 @@ static int parse_trans_rx_err_code_v2_hw(u32 err_msk)
 
 static int parse_dma_tx_err_code_v2_hw(u32 err_msk)
 {
-	const u8 dma_tx_err_code_prio[] = {
+	static const u8 dma_tx_err_code_prio[] = {
 		DMA_TX_UNEXP_XFER_ERR,
 		DMA_TX_UNEXP_RETRANS_ERR,
 		DMA_TX_XFER_LEN_OVERFLOW,
@@ -1810,7 +1810,7 @@ static int parse_dma_tx_err_code_v2_hw(u32 err_msk)
 
 static int parse_sipc_rx_err_code_v2_hw(u32 err_msk)
 {
-	const u8 sipc_rx_err_code_prio[] = {
+	static const u8 sipc_rx_err_code_prio[] = {
 		SIPC_RX_FIS_STATUS_ERR_BIT_VLD,
 		SIPC_RX_PIO_WRSETUP_STATUS_DRQ_ERR,
 		SIPC_RX_FIS_STATUS_BSY_BIT_ERR,
@@ -1836,7 +1836,7 @@ static int parse_sipc_rx_err_code_v2_hw(u32 err_msk)
 
 static int parse_dma_rx_err_code_v2_hw(u32 err_msk)
 {
-	const u8 dma_rx_err_code_prio[] = {
+	static const u8 dma_rx_err_code_prio[] = {
 		DMA_RX_UNKNOWN_FRM_ERR,
 		DMA_RX_DATA_LEN_OVERFLOW,
 		DMA_RX_DATA_LEN_UNDERFLOW,
-- 
2.11.0
