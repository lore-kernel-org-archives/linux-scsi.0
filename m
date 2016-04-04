From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH fix for v4.6] scsi: ufs: make ufshcd_query_descriptor_retry static
Date: Tue,  5 Apr 2016 00:16:31 +0300
Message-ID: <1459804591-27495-1-git-send-email-tomas.winkler@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3836 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbcDDVS2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 17:18:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Vinayak Holikatti <vinholikatti@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Yaniv Gardi <ygardi@codeaurora.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>

This function was intended to be exported into the ufshcd
API but after all it is not used outside ufshcd.c
Make it static and drop EXPORT_SYMBOL; this can be restored
when needed.

=46ixes
warning: no previous prototype for =E2=80=98ufshcd_query_descriptor_ret=
ry=E2=80=99
Introduced by
commit a70e91b8bbaa ("scsi: ufs: add retry for query descriptors")'

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f8fa72c31a9d..629140c11be6 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1982,7 +1982,7 @@ out:
  * The buf_len parameter will contain, on return, the length parameter
  * received on the response.
  */
-int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
+static int ufshcd_query_descriptor_retry(struct ufs_hba *hba,
 			enum query_opcode opcode, enum desc_idn idn, u8 index,
 			u8 selector, u8 *desc_buf, int *buf_len)
 {
@@ -1998,7 +1998,6 @@ int ufshcd_query_descriptor_retry(struct ufs_hba =
*hba,
=20
 	return err;
 }
-EXPORT_SYMBOL(ufshcd_query_descriptor_retry);
=20
 /**
  * ufshcd_read_desc_param - read the specified descriptor parameter
--=20
2.4.11

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
