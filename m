From: Santosh Y <santoshsy@gmail.com>
Subject: [PATCH 1/2] [SCSI] ufs: update Response UPIU length in dword
Date: Fri,  6 Apr 2012 17:57:20 +0530
Message-ID: <1333715241-32346-1-git-send-email-santoshsy@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:60614 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab2DFM1g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Apr 2012 08:27:36 -0400
Received: by dake40 with SMTP id e40so2733037dak.11
        for <linux-scsi@vger.kernel.org>; Fri, 06 Apr 2012 05:27:36 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, yoshitake.kobayashi@toshiba.co.jp, vinholikatti@gmail.com, Santosh Y <santoshsy@gmail.com>

UFSHCI spec mentions that Response UPIU Length(RUL)
field in Transfer Request Descriptor should be in dword.

Query Response UPIU size is variable depending on the data
to be read/written and the size of a SCSI command Response
UPIU is fixed.

Currently response_upiu_length is being updated in bytes.
If a UFS host controller prepares a Query Response UPIU
with response_upiu_length, it will result in wrong Query
Response UPIU size corrupting the command descriptor list.

This issue will not affect the current UFSHCD Ver 0.1,
since Query function support is not yet implemented.
But this patch also ensures against command descriptor list
corruption if a UFS controller prepares SCSI Response UPIU
with response_upiu_length.

Reported-by: KOBAYASHI Yoshitake <yoshitake.kobayashi@toshiba.co.jp>
Reviewed-by: Vinayak Holikatti <vinholikatti@gmail.com>
Signed-off-by: Santosh Y <santoshsy@gmail.com>
---
 drivers/scsi/ufs/ufshcd.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 52b96e8..1878cd8 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -830,13 +830,16 @@ static void ufshcd_host_memory_configure(struct ufs_hba *hba)
 		utrdlp[i].command_desc_base_addr_hi =
 				cpu_to_le32(upper_32_bits(cmd_desc_element_addr));
 
-		/* Response upiu and prdt offset should be in double words */
+		/*
+		 * Response upiu offset, prdt offset and response upiu length
+		 * should be in double words
+		 */
 		utrdlp[i].response_upiu_offset =
 				cpu_to_le16((response_offset >> 2));
 		utrdlp[i].prd_table_offset =
 				cpu_to_le16((prdt_offset >> 2));
 		utrdlp[i].response_upiu_length =
-				cpu_to_le16(ALIGNED_UPIU_SIZE);
+				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
 
 		hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
 		hba->lrb[i].ucd_cmd_ptr =
-- 
1.7.5.4

