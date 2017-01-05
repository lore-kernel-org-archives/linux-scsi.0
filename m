From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 3/4] scsi: ufs: ufshcd_get_max_icc_level fix endianity handling
Date: Thu,  5 Jan 2017 10:45:11 +0200
Message-ID: <1483605912-15041-3-git-send-email-tomas.winkler@intel.com>
References: <1483605912-15041-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1483605912-15041-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>
List-Id: linux-scsi@vger.kernel.org

Reading big endian value from a buffer requires explicit cast.
Fix sparse warning:
drivers/scsi/ufs/ufshcd.c:4825:24: warning: cast to restricted __be16

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 63d7ae2c3be9..fdea08f79b7d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4822,7 +4822,7 @@ static u32 ufshcd_get_max_icc_level(int sup_curr_uA, u32 start_scan, char *buff)
 	u16 unit;
 
 	for (i = start_scan; i >= 0; i--) {
-		data = be16_to_cpu(*((u16 *)(buff + 2*i)));
+		data = be16_to_cpup((__be16 *)&buff[2 * i]);
 		unit = (data & ATTR_ICC_LVL_UNIT_MASK) >>
 						ATTR_ICC_LVL_UNIT_OFFSET;
 		curr_uA = data & ATTR_ICC_LVL_VALUE_MASK;
-- 
2.7.4
