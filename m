From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 22/26] esas2r: constify local structures
Date: Sun, 11 Sep 2016 15:06:04 +0200
Message-ID: <1473599168-30561-23-git-send-email-Julia.Lawall@lip6.fr>
References: <1473599168-30561-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
In-Reply-To: <1473599168-30561-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: kernel-janitors-owner@vger.kernel.org
To: Bradley Grove <linuxdrivers@attotech.com>
Cc: joe@perches.com, kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

For structure types defined in the same file or local header files, find
top-level static structure declarations that have the following
properties:
1. Never reassigned.
2. Address never taken
3. Not passed to a top-level macro call
4. No pointer or array-typed field passed to a function or stored in a
variable.
Declare structures having all of these properties as const.

Done using Coccinelle.
Based on a suggestion by Joe Perches <joe@perches.com>.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The semantic patch seems too long for a commit log, but is in the cover
letter.

 drivers/scsi/esas2r/esas2r_flash.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_flash.c b/drivers/scsi/esas2r/esas2r_flash.c
index 7bd376d..f8414b5 100644
--- a/drivers/scsi/esas2r/esas2r_flash.c
+++ b/drivers/scsi/esas2r/esas2r_flash.c
@@ -54,7 +54,7 @@
 
 #define ESAS2R_FS_DRVR_VER 2
 
-static struct esas2r_sas_nvram default_sas_nvram = {
+static const struct esas2r_sas_nvram default_sas_nvram = {
 	{ 'E',	'S',  'A',  'S'			     }, /* signature          */
 	SASNVR_VERSION,                                 /* version            */
 	0,                                              /* checksum           */

