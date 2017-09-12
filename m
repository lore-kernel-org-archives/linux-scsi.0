From: Colin King <colin.king@canonical.com>
Subject: [PATCH] scsi: ufs: tc-dwc-g210: make arrays static, reduces object code size
Date: Tue, 12 Sep 2017 12:32:28 +0100
Message-ID: <20170912113228.1389-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Joao Pinto <jpinto@synopsys.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate const arrays on the stack, instead make them
static.  Makes the object code smaller by over 740 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
   3840	    208	      0	   4048	    fd0	drivers/scsi/ufs/tc-dwc-g210.o

After:
   text	   data	    bss	    dec	    hex	filename
   2679	    624	      0	   3303	    ce7	drivers/scsi/ufs/tc-dwc-g210.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/ufs/tc-dwc-g210.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/tc-dwc-g210.c b/drivers/scsi/ufs/tc-dwc-g210.c
index dc03e47f7c58..3a8bc6d9cb5b 100644
--- a/drivers/scsi/ufs/tc-dwc-g210.c
+++ b/drivers/scsi/ufs/tc-dwc-g210.c
@@ -26,7 +26,7 @@
  */
 static int tc_dwc_g210_setup_40bit_rmmi(struct ufs_hba *hba)
 {
-	const struct ufshcd_dme_attr_val setup_attrs[] = {
+	static const struct ufshcd_dme_attr_val setup_attrs[] = {
 		{ UIC_ARG_MIB(TX_GLOBALHIBERNATE), 0x00, DME_LOCAL },
 		{ UIC_ARG_MIB(REFCLKMODE), 0x01, DME_LOCAL },
 		{ UIC_ARG_MIB(CDIRECTCTRL6), 0x80, DME_LOCAL },
@@ -90,7 +90,7 @@ static int tc_dwc_g210_setup_40bit_rmmi(struct ufs_hba *hba)
  */
 static int tc_dwc_g210_setup_20bit_rmmi_lane0(struct ufs_hba *hba)
 {
-	const struct ufshcd_dme_attr_val setup_attrs[] = {
+	static const struct ufshcd_dme_attr_val setup_attrs[] = {
 		{ UIC_ARG_MIB_SEL(TX_REFCLKFREQ, SELIND_LN0_TX), 0x01,
 								DME_LOCAL },
 		{ UIC_ARG_MIB_SEL(TX_CFGCLKFREQVAL, SELIND_LN0_TX), 0x19,
@@ -147,7 +147,7 @@ static int tc_dwc_g210_setup_20bit_rmmi_lane1(struct ufs_hba *hba)
 	int connected_tx_lanes = 0;
 	int ret = 0;
 
-	const struct ufshcd_dme_attr_val setup_tx_attrs[] = {
+	static const struct ufshcd_dme_attr_val setup_tx_attrs[] = {
 		{ UIC_ARG_MIB_SEL(TX_REFCLKFREQ, SELIND_LN1_TX), 0x0d,
 								DME_LOCAL },
 		{ UIC_ARG_MIB_SEL(TX_CFGCLKFREQVAL, SELIND_LN1_TX), 0x19,
@@ -158,7 +158,7 @@ static int tc_dwc_g210_setup_20bit_rmmi_lane1(struct ufs_hba *hba)
 								DME_LOCAL },
 	};
 
-	const struct ufshcd_dme_attr_val setup_rx_attrs[] = {
+	static const struct ufshcd_dme_attr_val setup_rx_attrs[] = {
 		{ UIC_ARG_MIB_SEL(RX_REFCLKFREQ, SELIND_LN1_RX), 0x01,
 								DME_LOCAL },
 		{ UIC_ARG_MIB_SEL(RX_CFGCLKFREQVAL, SELIND_LN1_RX), 0x19,
@@ -222,7 +222,7 @@ static int tc_dwc_g210_setup_20bit_rmmi(struct ufs_hba *hba)
 {
 	int ret = 0;
 
-	const struct ufshcd_dme_attr_val setup_attrs[] = {
+	static const struct ufshcd_dme_attr_val setup_attrs[] = {
 		{ UIC_ARG_MIB(TX_GLOBALHIBERNATE), 0x00, DME_LOCAL },
 		{ UIC_ARG_MIB(REFCLKMODE), 0x01, DME_LOCAL },
 		{ UIC_ARG_MIB(CDIRECTCTRL6), 0xc0, DME_LOCAL },
-- 
2.14.1

