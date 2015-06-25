From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] ipr: Fix invalid array indexing for HRRQ
Date: Thu, 25 Jun 2015 08:44:34 -0500
Message-ID: <201506251344.t5PDiZLv025988@d03av03.boulder.ibm.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, wenxiong@linux.vnet.ibm.com, krisman@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org


James,

Here is one more fix for a rather nasty bug where the ipr driver can start
accessing memory it doesn't own. I'd like to add to the queue
of ipr patches. There are now two patches on top of the previously submitted
series of four. If you want me to resend everything as a complete
series, please let me know.

Thanks,

Brian

8<

Fixes another signed / unsigned array indexing bug in the ipr driver.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Tested-by: Wen Xiong <wenxiong@linux.vnet.ibm.com>
Cc: <stable@vger.kernel.org>
---

 drivers/scsi/ipr.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_hrrq_index_fix drivers/scsi/ipr.c
--- linux/drivers/scsi/ipr.c~ipr_hrrq_index_fix	2015-06-23 11:43:18.151741523 -0500
+++ linux-bjking1/drivers/scsi/ipr.c	2015-06-23 11:43:18.157741435 -0500
@@ -1052,10 +1052,15 @@ static void ipr_send_blocking_cmd(struct
 
 static int ipr_get_hrrq_index(struct ipr_ioa_cfg *ioa_cfg)
 {
+	unsigned int hrrq;
+
 	if (ioa_cfg->hrrq_num == 1)
-		return 0;
-	else
-		return (atomic_add_return(1, &ioa_cfg->hrrq_index) % (ioa_cfg->hrrq_num - 1)) + 1;
+		hrrq = 0;
+	else {
+		hrrq = atomic_add_return(1, &ioa_cfg->hrrq_index);
+		hrrq = ((hrrq + 1) % (ioa_cfg->hrrq_num - 1)) + 1;
+	}
+	return hrrq;
 }
 
 /**
_
