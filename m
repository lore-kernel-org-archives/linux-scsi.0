From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: esp_scsi incorrect unsigned test
Date: Sat, 19 Apr 2008 09:16:38 -0500
Message-ID: <1208614598.3280.11.camel@localhost.localdomain>
References: <4808C90A.5040600@tiscali.nl>
	 <Pine.LNX.4.64.0804182101200.14832@ask.diku.dk>
	 <20080419140555.GJ20637@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36601 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755941AbYDSOQm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Apr 2008 10:16:42 -0400
In-Reply-To: <20080419140555.GJ20637@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Julia Lawall <julia@diku.dk>, David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, Roel Kluin <12o3l@tiscali.nl>, kernel-janitors@vger.kernel.org, kernelnewbies-bounce@nl.linux.org

On Sat, 2008-04-19 at 08:05 -0600, Matthew Wilcox wrote:
> On Fri, Apr 18, 2008 at 09:08:55PM +0200, Julia Lawall wrote:
> > I found 63 occurrences of this problem with the following semantic match
> > (http://www.emn.fr/x-info/coccinelle/):
> > 
> > @@ unsigned int i; @@
> > 
> > * i < 0
> > 
> > I looked through all of the results by hand, and they all seem to be 
> > problems.  In many cases, it seems like the variable should not be 
> > unsigned as it is used to hold the return value of a function that might 
> > return a negative error code, but I haven't looked into this in detail.
> > 
> > In the output below, the lines that begin with a single start contain a 
> > test of whether an unsigned variable or structure field is less than 0.
> > The output is actually generated with diff, but I converted the -s to *s 
> > to avoid confusion.
> 
> > diff -u -p a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> > *** a/drivers/scsi/esp_scsi.c 2008-03-12 14:13:14.000000000 +0100
> > @@ -380,7 +380,7 @@ static void esp_advance_dma(struct esp *
> >  
> >  	p->cur_residue -= len;
> >  	p->tot_residue -= len;
> > *	if (p->cur_residue < 0 || p->tot_residue < 0) {
> >  		printk(KERN_ERR PFX "esp%d: Data transfer overflow.\n",
> >  		       esp->host->unique_id);
> >  		printk(KERN_ERR PFX "esp%d: cur_residue[%d] tot_residue[%d] "
> 
> This is clearly buggy.  A residue is, though, inherently unsigned, so I
> don't think we should change the type of the variable.  Rather, we
> should test it before subtraction.  Dave, what do you think?
> 
> ----
> 
> Fix ESP data transfer overflow checks
> 
> The current code attempts to detect data transfer overflow by checking
> whether an unsigned variable is negative.  Instead, we should
> compare the two variables before subtracting them.
> 
> Reported-by: Julia Lawall <julia@diku.dk>
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index bfdee59..b5e8a94 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -378,9 +378,7 @@ static void esp_advance_dma(struct esp *esp, struct esp_cmd_entry *ent,
>  		return;
>  	}
>  
> -	p->cur_residue -= len;
> -	p->tot_residue -= len;
> -	if (p->cur_residue < 0 || p->tot_residue < 0) {
> +	if (unlikely(p->cur_residue < len || p->tot_residue < len)) {
>  		printk(KERN_ERR PFX "esp%d: Data transfer overflow.\n",
>  		       esp->host->unique_id);
>  		printk(KERN_ERR PFX "esp%d: cur_residue[%d] tot_residue[%d] "

To be pedantic, this should be %u not %d for unsigned.

> @@ -389,7 +387,11 @@ static void esp_advance_dma(struct esp *esp, struct esp_cmd_entry *ent,
>  		       p->cur_residue, p->tot_residue, len);
>  		p->cur_residue = 0;
>  		p->tot_residue = 0;
> +	} else {
> +		p->cur_residue -= len;
> +		p->tot_residue -= len;
>  	}
> +
>  	if (!p->cur_residue && p->tot_residue) {
>  		p->cur_sg++;
>  		p->cur_residue = sg_dma_len(p->cur_sg);

It look fine to me ... although an alternative (and possibly simpler)
fix would just be to remove the unsigned from the two residue
definitions in the struct.

James


