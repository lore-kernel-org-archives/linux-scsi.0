From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH][RESEND] Fix a potential NULL pointer deref in the
	aic7xxx, ahc_print_register() function
Date: Sun, 05 Aug 2007 10:53:03 -0500
Message-ID: <1186329183.3455.13.camel@localhost.localdomain>
References: <200708042030.52405.jesper.juhl@gmail.com>
	 <1186256627.3439.22.camel@localhost.localdomain>
	 <9a8748490708050836m20b5dd38gf6a8968cd4b106f9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55147 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753924AbXHEPxG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Aug 2007 11:53:06 -0400
In-Reply-To: <9a8748490708050836m20b5dd38gf6a8968cd4b106f9@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, "Justin T. Gibbs" <gibbs@scsiguy.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>

On Sun, 2007-08-05 at 17:36 +0200, Jesper Juhl wrote:
> On 04/08/07, James Bottomley <James.Bottomley@steeleye.com> wrote:
> > On Sat, 2007-08-04 at 20:30 +0200, Jesper Juhl wrote:
> > > (resend of patch previously submitted on 28-Jul-2007 23:06)
> > >
> > >
> > > Ehlo,
> > >
> > > The Coverity checker noticed that we have a potential NULL pointer
> > > deref in drivers/scsi/aic7xxx/aic7xxx_core.c::ahc_print_register().
> > > This patch handles it by adding the same test against NULL that is
> > > used elsewhere in the same function.
> >
> > It's on my list of things to look at ... but not very high.  I suspect
> > it actually isn't triggerable, but if you can tell me how, it will save
> > me from looking.
> >
> 
> Here's what Coverity reported :
> ...
> 6525 	int
> 6526 	ahc_print_register(ahc_reg_parse_entry_t *table, u_int num_entries,
> 6527 			   const char *name, u_int address, u_int value,
> 6528 			   u_int *cur_column, u_int wrap_point)
> 6529 	{
> 6530 		int	printed;
> 6531 		u_int	printed_mask;
> 6532 	
> 
> Event var_compare_op: Added "cur_column" due to comparison "cur_column != 0"
> Also see events: [var_deref_op]
> At conditional (1): "cur_column != 0" taking false path
> 
> 6533 		if (cur_column != NULL && *cur_column >= wrap_point) {
> 6534 			printf("\n");
> 6535 			*cur_column = 0;
> 6536 		}
> 6537 		printed = printf("%s[0x%x]", name, value);
> 
> At conditional (2): "table == 0" taking true path
> 
> 6538 		if (table == NULL) {
> 6539 			printed += printf(" ");
> 
> Event var_deref_op: Variable "cur_column" tracked as NULL was dereferenced.
> Also see events: [var_compare_op]
> 
> 6540 			*cur_column += printed;
> 6541 			return (printed);
> 6542 		}
> ...
> 
> So it requires a NULL 'table' and a != NULL 'cur_column' to trigger.
> Whether or not that's actually possible I'm not sure, but it seems
> safer to guard against it :)
> 
> 
> By the way; if this can actually be triggered, then
> ahd_print_register() has the same problem.

But this is precisely the point.  A large number of drivers have purely
internal functions, which this is.  Most often, because the API is
purely internal to the driver, misuse is reported via BUG_ON (supposed
to be picked up by the driver writer in their testing).  The problem
with this is that we never do:

BUG_ON(ptr==NULL);

Because a simple use of the null pointer will also trigger the bug, so
we don't need the check.

I suspect table == NULL requires cur_column != NULL as part of the
internal API and there's no BUG_ON checking for it because the use of
the pointer would be the BUG.

If you blindly go checking for NULL and coping with it, you've actually
weakened our internal API checking, which definitely isn't the object of
the exercise.  Worse, becase we have no maintainer for this driver
someone touching it could easily get this wrong and a subtle and much
harder to find bug will be introduced.

So, as I said, if you can prove

table == NULL && cur_column == NULL

should be a genuine use case of the API then by all means, this can go
in.

James


