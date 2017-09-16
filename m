From: Colin King <colin.king@canonical.com>
Subject: [PATCH] ufs: make const array setup_attrs static to shink object code size
Date: Sat, 16 Sep 2017 17:14:11 +0100
Message-ID: <20170916161411.29464-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Joao Pinto <jpinto@synopsys.com>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate const array setup_attrs on the stack, instead make it
static.  Makes the object code smaller by over 120 bytes:

Before:
   text	   data	    bss	    dec	    hex	filename
   1588	    208	      0	   1796	    704	drivers/scsi/ufs/ufshcd-dwc.o

After:
   text	   data	    bss	    dec	    hex	filename
   1371	    304	      0	   1675	    68b	drivers/scsi/ufs/ufshcd-dwc.o

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/ufs/ufshcd-dwc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd-dwc.c b/drivers/scsi/ufs/ufshcd-dwc.c
index 5fd16c72207f..f061609c424d 100644
--- a/drivers/scsi/ufs/ufshcd-dwc.c
+++ b/drivers/scsi/ufs/ufshcd-dwc.c
@@ -83,7 +83,7 @@ static int ufshcd_dwc_link_is_up(struct ufs_hba *hba)
  */
 static int ufshcd_dwc_connection_setup(struct ufs_hba *hba)
 {
-	const struct ufshcd_dme_attr_val setup_attrs[] = {
+	static const struct ufshcd_dme_attr_val setup_attrs[] = {
 		{ UIC_ARG_MIB(T_CONNECTIONSTATE), 0, DME_LOCAL },
 		{ UIC_ARG_MIB(N_DEVICEID), 0, DME_LOCAL },
 		{ UIC_ARG_MIB(N_DEVICEID_VALID), 0, DME_LOCAL },
-- 
2.14.1
