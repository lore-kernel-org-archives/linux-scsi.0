From: Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch 13/30] nsp32_restart_autoscsi(): remove error check
Date: Sat, 11 Aug 2007 04:25:39 +0200
Message-ID: <20070811022539.GD22213@stusta.de>
References: <200708102150.l7ALoeZw011354@imap1.linux-foundation.org> <1186794232.6334.21.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57625 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757296AbXHKCZw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2007 22:25:52 -0400
Content-Disposition: inline
In-Reply-To: <1186794232.6334.21.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: akpm@linux-foundation.org, linux-scsi@vger.kernel.org, yokota@netlab.is.tsukuba.ac.jp

On Fri, Aug 10, 2007 at 09:03:52PM -0400, James Bottomley wrote:
> On Fri, 2007-08-10 at 14:50 -0700, akpm@linux-foundation.org wrote:
> > From: Adrian Bunk <bunk@stusta.de>
> > 
> > The Coverity checker noted that we'll anyway Oops later when we ran into
> > this condition - and the error check didn't prevent that.
> > 
> > Considering that the error condition shouldn't be possible, and we are
> > not able to handle it easily, this patch simply removes the pointless
> > error check.
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> > Cc: <yokota@netlab.is.tsukuba.ac.jp>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/scsi/nsp32.c |    4 ----
> >  1 files changed, 4 deletions(-)
> > 
> > diff -puN drivers/scsi/nsp32.c~nsp32_restart_autoscsi-remove-error-check drivers/scsi/nsp32.c
> > --- a/drivers/scsi/nsp32.c~nsp32_restart_autoscsi-remove-error-check
> > +++ a/drivers/scsi/nsp32.c
> > @@ -1905,10 +1905,6 @@ static void nsp32_restart_autoscsi(struc
> >  
> >  	nsp32_dbg(NSP32_DEBUG_RESTART, "enter");
> >  
> > -	if (data->cur_target == NULL || data->cur_lunt == NULL) {
> > -		nsp32_msg(KERN_ERR, "Target or Lun is invalid");
> > -	}
> > -
> 
> I disagree pretty strongly with this ... you're not removing an error
> check, you're removing a warning printk.  Before the driver would say
> what the problem is and oops.  After, it will oops and you won't
> necessarily know why.  I think that's a retrograde step.

"Target or Lun is invalid" isn't a precise problem description either.

But the main point is:

An Oops indicates a programming error in the kernel (or kernel 
corruption), and for this purpose an Oops is a good error message.

We can't put printk()'s in front of all pointer dereferences in the 
kernel.

Is there any legal way how any of these could be NULL at this point?
My impression was there isn't.
But if there is we don't need only a printk(), we'd need an error 
handling that returns from the function without Oops'ing plus an error 
handling in the caller.

> James

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

