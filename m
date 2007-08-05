From: Jesper Juhl <jesper.juhl@gmail.com>
Subject: Re: [PATCH][RESEND] Fix a potential NULL pointer deref in the aic7xxx, ahc_print_register() function
Date: Sun, 5 Aug 2007 17:52:05 +0200
Message-ID: <200708051752.06003.jesper.juhl@gmail.com>
References: <200708042030.52405.jesper.juhl@gmail.com> <9a8748490708050836m20b5dd38gf6a8968cd4b106f9@mail.gmail.com> <46B5EFE7.6090008@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hu-out-0506.google.com ([72.14.214.227]:30938 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134AbXHEPyK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Aug 2007 11:54:10 -0400
Received: by hu-out-0506.google.com with SMTP id 19so817129hue
        for <linux-scsi@vger.kernel.org>; Sun, 05 Aug 2007 08:54:09 -0700 (PDT)
In-Reply-To: <46B5EFE7.6090008@scsiguy.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@linux-foundation.org>, James Bottomley <jejb@kernel.org>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jesper Juhl <jesper.juhl@gmail.com>

On Sunday 05 August 2007 17:42:31 Justin T. Gibbs wrote:
> All of this logic was simplified back in '05 in the BSD drivers by adding
> this to the top of the function:
> 
>         u_int   dummy_column;
>   
>         if (cur_column == NULL) {
>                 dummy_column = 0;
>                 cur_column = &dummy_column;
>         }
> 
> and then stripping out the cur_column == NULL checks in the routine.
> 

Thank you for that info.

James, if that sounds like a better way to deal with it to you, then 
here's a patch to implement it.



Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 drivers/scsi/aic7xxx/aic7xxx_core.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index 75733b0..d1f3f25 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -6529,8 +6529,14 @@ ahc_print_register(ahc_reg_parse_entry_t *table, u_int num_entries,
 {
 	int	printed;
 	u_int	printed_mask;
+	u_int	dummy_column;
 
-	if (cur_column != NULL && *cur_column >= wrap_point) {
+	if (!cur_column) {
+		dummy_column = 0;
+		cur_column = &dummy_column;
+	}
+
+	if (*cur_column >= wrap_point) {
 		printf("\n");
 		*cur_column = 0;
 	}
@@ -6565,8 +6571,7 @@ ahc_print_register(ahc_reg_parse_entry_t *table, u_int num_entries,
 		printed += printf(") ");
 	else
 		printed += printf(" ");
-	if (cur_column != NULL)
-		*cur_column += printed;
+	*cur_column += printed;
 	return (printed);
 }
 


