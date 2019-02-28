From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH v2] scsi: NCR5380: Mark expected switch fall-through
Date: Thu, 28 Feb 2019 14:27:59 -0600
Message-ID: <20190228202759.GA5883@embeddedor>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, Michael Schmitz <schmitzmic@gmail.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Kees Cook <keescook@chromium.org>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch
cases where we are expecting to fall through.

This patch fixes the following warning:

In file included from drivers/scsi/dmx3191d.c:48:
drivers/scsi/NCR5380.c: In function ‘NCR5380_information_transfer’:
drivers/scsi/NCR5380.c:1933:9: warning: this statement may fall through [-Wimplicit-fallthrough=]
      if (!hostdata->connected)
         ^
drivers/scsi/NCR5380.c:1937:5: note: here
     default:
     ^~~~~~~

Warning level 3 was used: -Wimplicit-fallthrough=3

Notice that, in this particular case, the code comment is modified
in accordance with what GCC is expecting to find.

This patch is part of the ongoing efforts to enable
-Wimplicit-fallthrough.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
Changes in v2:
 - Update commit log.
 - Move code comment after the default label and
   retain reason for fall-through in comment as
   requested by Michael Schmitz.

 drivers/scsi/NCR5380.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 01c23d27f290..985d1c053578 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -1933,13 +1933,12 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 					if (!hostdata->connected)
 						return;
 
-					/* Fall through to reject message */
-
+					/* Fall through - to reject message */
+				default:
 					/*
-					 * If we get something weird that we aren't expecting,
-					 * reject it.
+					 * If we get something weird that we
+					 * aren't expecting, reject it.
 					 */
-				default:
 					if (tmp == EXTENDED_MESSAGE)
 						scmd_printk(KERN_INFO, cmd,
 						            "rejecting unknown extended message code %02x, length %d\n",
-- 
2.21.0
