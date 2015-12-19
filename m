From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH] SCSI-lpfc: Use a signed return type for two functions
Date: Sat, 19 Dec 2015 19:44:06 +0100
Message-ID: <5675A576.8020008@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:49614 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932750AbbLSSoZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Dec 2015 13:44:25 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Dick Kennedy <dick.kennedy@avagotech.com>, "James E. J. Bottomley" <JBottomley@odin.com>, James Smart <james.smart@avagotech.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sat, 19 Dec 2015 19:32:27 +0100

The return type "size_t" was used by the functions "lpfc_wwn_set"
and "lpfc_oas_lun_state_set" despite of the aspect that they will
eventually return a negative error code.
Improve this implementation detail by using the type "ssize_t" instead.

This issue was detected by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/scsi/lpfc/lpfc_attr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index f6446d7..777960e 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -2089,7 +2089,7 @@ static char *lpfc_soft_wwn_key = "C99G71SL8032A";
  * -EINVAL if the buffer does not contain a valid wwn
  * 0 success
  **/
-static size_t
+static ssize_t
 lpfc_wwn_set(const char *buf, size_t cnt, char wwn[])
 {
 	unsigned int i, j;
@@ -2570,7 +2570,7 @@ static DEVICE_ATTR(lpfc_xlane_lun_status, S_IRUGO,
  * -EPERM OAS is not enabled or not supported by this port.
  *
  */
-static size_t
+static ssize_t
 lpfc_oas_lun_state_set(struct lpfc_hba *phba, uint8_t vpt_wwpn[],
 		       uint8_t tgt_wwpn[], uint64_t lun, uint32_t oas_state)
 {
-- 
2.6.3

