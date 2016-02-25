From: Colin King <colin.king@canonical.com>
Subject: [PATCH] snic: correctly check for array overrun on overly long version number
Date: Thu, 25 Feb 2016 22:58:25 +0000
Message-ID: <1456441105-19042-1-git-send-email-colin.king@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Narsimhulu Musini <nmusini@cisco.com>, Sesidhar Baddela <sebaddel@cisco.com>, "James E . J . Bottomley" <JBottomley@odin.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The snic version number is expected to be 4 decimals in the form like
a netmask string with each number stored in an element in array v.
However, there is an off-by-one check on the number of elements in v
allowing one to pass a 5 decimal version number causing v[4] to be
referenced, causing a buffer overrun.  Fix the off-by-one error by
comparing to i > 3 rather than 4.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/scsi/snic/snic_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/snic/snic_ctl.c b/drivers/scsi/snic/snic_ctl.c
index aebe753..ab0e06b 100644
--- a/drivers/scsi/snic/snic_ctl.c
+++ b/drivers/scsi/snic/snic_ctl.c
@@ -75,7 +75,7 @@ snic_ver_enc(const char *s)
 			continue;
 		}
 
-		if (i > 4 || !isdigit(c))
+		if (i > 3 || !isdigit(c))
 			goto end;
 
 		v[i] = v[i] * 10 + (c - '0');
-- 
2.7.0
