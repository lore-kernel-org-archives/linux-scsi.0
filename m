From: "Jesper Juhl" <jesper.juhl@gmail.com>
Subject: Re: [PATCH][RESEND] Fix a potential NULL pointer deref in the aic7xxx, ahc_print_register() function
Date: Sun, 5 Aug 2007 17:36:35 +0200
Message-ID: <9a8748490708050836m20b5dd38gf6a8968cd4b106f9@mail.gmail.com>
References: <200708042030.52405.jesper.juhl@gmail.com>
	 <1186256627.3439.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ag-out-0708.google.com ([72.14.246.248]:18974 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbXHEPgg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Aug 2007 11:36:36 -0400
Received: by ag-out-0708.google.com with SMTP id 35so1335096aga
        for <linux-scsi@vger.kernel.org>; Sun, 05 Aug 2007 08:36:35 -0700 (PDT)
In-Reply-To: <1186256627.3439.22.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <jejb@kernel.org>, linux-scsi@vger.kernel.org, "Justin T. Gibbs" <gibbs@scsiguy.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On 04/08/07, James Bottomley <James.Bottomley@steeleye.com> wrote:
> On Sat, 2007-08-04 at 20:30 +0200, Jesper Juhl wrote:
> > (resend of patch previously submitted on 28-Jul-2007 23:06)
> >
> >
> > Ehlo,
> >
> > The Coverity checker noticed that we have a potential NULL pointer
> > deref in drivers/scsi/aic7xxx/aic7xxx_core.c::ahc_print_register().
> > This patch handles it by adding the same test against NULL that is
> > used elsewhere in the same function.
>
> It's on my list of things to look at ... but not very high.  I suspect
> it actually isn't triggerable, but if you can tell me how, it will save
> me from looking.
>

Here's what Coverity reported :
...
6525 	int
6526 	ahc_print_register(ahc_reg_parse_entry_t *table, u_int num_entries,
6527 			   const char *name, u_int address, u_int value,
6528 			   u_int *cur_column, u_int wrap_point)
6529 	{
6530 		int	printed;
6531 		u_int	printed_mask;
6532 	

Event var_compare_op: Added "cur_column" due to comparison "cur_column != 0"
Also see events: [var_deref_op]
At conditional (1): "cur_column != 0" taking false path

6533 		if (cur_column != NULL && *cur_column >= wrap_point) {
6534 			printf("\n");
6535 			*cur_column = 0;
6536 		}
6537 		printed = printf("%s[0x%x]", name, value);

At conditional (2): "table == 0" taking true path

6538 		if (table == NULL) {
6539 			printed += printf(" ");

Event var_deref_op: Variable "cur_column" tracked as NULL was dereferenced.
Also see events: [var_compare_op]

6540 			*cur_column += printed;
6541 			return (printed);
6542 		}
...

So it requires a NULL 'table' and a != NULL 'cur_column' to trigger.
Whether or not that's actually possible I'm not sure, but it seems
safer to guard against it :)


By the way; if this can actually be triggered, then
ahd_print_register() has the same problem.


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
