From: akpm@linux-foundation.org
Subject: [patch 08/17] Fix a potential NULL pointer deref in the aic7xxx, ahc_print_register() function
Date: Tue, 02 Oct 2007 14:38:04 -0700
Message-ID: <200710022138.l92Lc4iM023579@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45259 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753331AbXJBViI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Oct 2007 17:38:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, jesper.juhl@gmail.com

From: Jesper Juhl <jesper.juhl@gmail.com>

The Coverity checker noticed that we have a potential NULL pointer
deref in drivers/scsi/aic7xxx/aic7xxx_core.c::ahc_print_register().
This patch handles it by adding the same test against NULL that is
used elsewhere in the same function.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic7xxx/aic7xxx_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/aic7xxx/aic7xxx_core.c~fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function drivers/scsi/aic7xxx/aic7xxx_core.c
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c~fix-a-potential-null-pointer-deref-in-the-aic7xxx-ahc_print_register-function
+++ a/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -6557,7 +6557,8 @@ ahc_print_register(ahc_reg_parse_entry_t
 	printed = printf("%s[0x%x]", name, value);
 	if (table == NULL) {
 		printed += printf(" ");
-		*cur_column += printed;
+		if (cur_column != NULL)
+			*cur_column += printed;
 		return (printed);
 	}
 	printed_mask = 0;
_
