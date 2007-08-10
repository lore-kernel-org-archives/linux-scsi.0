From: akpm@linux-foundation.org
Subject: [patch 28/30] Fix a potential NULL pointer deref in the aic7xxx, ahc_print_register() function
Date: Fri, 10 Aug 2007 14:50:51 -0700
Message-ID: <200708102150.l7ALoqcC011404@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36529 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752313AbXHJV7S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Aug 2007 17:59:18 -0400
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
 1 files changed, 2 insertions(+), 1 deletion(-)

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
