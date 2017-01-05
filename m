From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 1/4] scsi: ufs: ufshcd_query_descriptor_retry should be static
Date: Thu,  5 Jan 2017 10:45:09 +0200
Message-ID: <1483605912-15041-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga05.intel.com ([192.55.52.43]:60831 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031094AbdAEHtx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 5 Jan 2017 02:49:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>

Fix the following compilation warning:

drivers/scsi/ufs/ufshcd.c:2076:5: warning: no previous prototype for
‘ufshcd_query_descriptor_retry’ [-Wmissing-prototypes]

Also do not export the function, it should not be used out of ufs
context.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 20e5e5fb048c..be3c2900b6bb 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2073,9 +2073,11 @@ static int __ufshcd_query_descriptor(struct ufs_hba *hba,
  * The buf_len parameter will contain, on return, the length parameter
  * received on the response.
  */
-int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
-			enum query_opcode opcode, enum desc_idn idn, u8 index,
-			u8 selector, u8 *desc_buf, int *buf_len)
+static int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
+					 enum query_opcode opcode,
+					 enum desc_idn idn, u8 index,
+					 u8 selector,
+					 u8 *desc_buf, int *buf_len)
 {
 	int err;
 	int retries;
@@ -2089,7 +2091,6 @@ int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 
 	return err;
 }
-EXPORT_SYMBOL(ufshcd_query_descriptor_retry);
 
 /**
  * ufshcd_read_desc_param - read the specified descriptor parameter
-- 
2.7.4

