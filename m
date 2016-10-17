From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] lpfc: use %zd format string for size_t
Date: Mon, 17 Oct 2016 14:35:46 +0200
Message-ID: <20161017123605.2217411-1-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:59747 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934802AbcJQMhA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2016 08:37:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Hannes Reinecke <hare@suse.com>, James Bottomley <JBottomley@Odin.com>, Sebastian Herbszt <herbszt@gmx.de>, Johannes Thumshirn <jthumshirn@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

A recent bugfix introduced a harmless warning in the lpfc driver:

drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_write_firmware':
drivers/scsi/lpfc/lpfc_logmsg.h:56:45: error: format '%ld' expects argument of type 'long int', but argument 9 has type 'size_t {aka const unsigned int}' [-Werror=format=]

'size_t' is always the same width as 'long' in the kernel, but the compiler
doesn't know that. The %z modifier is what the standard expects to be
used here, and this shuts up the warning.

Fixes: 679053c651fb ("scsi: lpfc: Fix fw download on SLI-4 FC adapters")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 7be9b8a7bb19..4776fd85514f 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -10332,7 +10332,7 @@ lpfc_write_firmware(const struct firmware *fw, void *context)
 	    ftype != LPFC_FILE_TYPE_GROUP || fsize != fw->size) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
 				"3022 Invalid FW image found. "
-				"Magic:%x Type:%x ID:%x Size %d %ld\n",
+				"Magic:%x Type:%x ID:%x Size %d %zd\n",
 				magic_number, ftype, fid, fsize, fw->size);
 		rc = -EINVAL;
 		goto release_out;
-- 
2.9.0

