From: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH] SCSI, pmcraid: Fix kmalloc() argument order in
 pmcraid_chr_ioctl()
Date: Tue, 25 Oct 2011 00:51:38 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1110250047430.19795@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1110250036370.19795@swampdragon.chaosbits.net> <1319496149.2094.3.camel@Joe-Laptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13282 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab1JXWrG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2011 18:47:06 -0400
In-Reply-To: <1319496149.2094.3.camel@Joe-Laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Perches <joe@perches.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, Anil Ravindranath <anil_ravindranath@pmc-sierra.com>

On Mon, 24 Oct 2011, Joe Perches wrote:

> On Tue, 2011-10-25 at 00:38 +0200, Jesper Juhl wrote:
> > The first argument to kmalloc() is the size, the second is
> > flags. pmcraid_chr_ioctl() gets this wrong and swaps the
> > arguments. This patch corrects the mistake.
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> >  drivers/scsi/pmcraid.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> >  compile tested only.
> > 
> > diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> > index d079f9a..da19bdf 100644
> > --- a/drivers/scsi/pmcraid.c
> > +++ b/drivers/scsi/pmcraid.c
> > @@ -4103,7 +4103,7 @@ static long pmcraid_chr_ioctl(
> >  	struct pmcraid_ioctl_header *hdr = NULL;
> >  	int retval = -ENOTTY;
> >  
> > -	hdr = kmalloc(GFP_KERNEL, sizeof(struct pmcraid_ioctl_header));
> > +	hdr = kmalloc(sizeof(struct pmcraid_ioctl_header), GFP_KERNEL);
> >  
> >  	if (!hdr) {
> >  		pmcraid_err("faile to allocate memory for ioctl header\n");
> > -- 
> > 1.7.7
> > 
> > 
> 
> James seems to be uninterested in picking up
> obvious and trivially correct patches.
> 
I've been getting that impression as well..
For example: 
http://git.kernel.org/?p=linux/kernel/git/next/linux-next-history.git;a=commitdiff;h=2abe1b25e56b7c8e65f101fb22282dafeb5ec4ef 
which I've been sumbitting numerous times over a long period of time 
(these days akpm has picked it up and sends it on repeatedly, so I don't 
really bother myself any more)... 

> >From a year ago...
> 
> https://lkml.org/lkml/2010/10/31/123
> 
Ok, so you obviously got there first and your patch should be merged 
rather than mine. I was not aware of that.

> James?
> 
?

-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

