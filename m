From: Colin King <colin.king@canonical.com>
Subject: [PATCH][scsi-next] scsi: aacraid: remove redundant setting of variable c
Date: Fri,  5 Jan 2018 15:31:06 +0000
Message-ID: <20180105153106.17605-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:46054 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751633AbeAEPbL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jan 2018 10:31:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adaptec OEM Raid Solutions <aacraid@microsemi.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

A previous commit no longer stores the contents of c, so we now have
a situation where c is being updated but the value is never read. Clean
up the code by removing the now redundant setting of variable c.

Cleans up clang warning:
drivers/scsi/aacraid/aachba.c:943:3: warning: Value stored to 'c' is
never read

Fixes: f4e8708d3104 ("scsi: aacraid: Fix udev inquiry race condition")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/aacraid/aachba.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index a2bdd7931cf1..525d72fcbf3e 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -940,11 +940,8 @@ static void setinqstr(struct aac_dev *dev, void *data, int tindex)
 		while (*cp == ' ')
 			++cp;
 		/* last six chars reserved for vol type */
-		c = 0;
-		if (strlen(cp) > sizeof(str->pid)) {
-			c = cp[sizeof(str->pid)];
+		if (strlen(cp) > sizeof(str->pid))
 			cp[sizeof(str->pid)] = '\0';
-		}
 		inqstrcpy (cp, str->pid);
 
 		kfree(cname);
-- 
2.15.1
