From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 13/17] scsi: remove private implementation of
 get_unaligned_be32
Date: Wed, 29 Oct 2008 15:07:02 -0700
Message-ID: <20081029150702.1a20310a.akpm@linux-foundation.org>
References: <200810292124.m9TLOjl1021276@imap1.linux-foundation.org>
	<1225316894.3257.19.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752312AbYJ2WHh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 18:07:37 -0400
In-Reply-To: <1225316894.3257.19.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, harvey.harrison@gmail.com

On Wed, 29 Oct 2008 16:48:14 -0500
James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2008-10-29 at 14:24 -0700, akpm@linux-foundation.org wrote:
> > From: Harvey Harrison <harvey.harrison@gmail.com>
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > ---
> > 
> >  drivers/scsi/libsas/sas_expander.c |    9 +++++----
> >  include/scsi/scsi.h                |    6 ------
> >  2 files changed, 5 insertions(+), 10 deletions(-)
> > 
> > diff -puN drivers/scsi/libsas/sas_expander.c~scsi-remove-private-implementation-of-get_unaligned_be32 drivers/scsi/libsas/sas_expander.c
> > --- a/drivers/scsi/libsas/sas_expander.c~scsi-remove-private-implementation-of-get_unaligned_be32
> > +++ a/drivers/scsi/libsas/sas_expander.c
> > @@ -24,6 +24,7 @@
> >  
> >  #include <linux/scatterlist.h>
> >  #include <linux/blkdev.h>
> > +#include <asm/unaligned.h>
> >  
> >  #include "sas_internal.h"
> >  
> > @@ -541,10 +542,10 @@ int sas_smp_get_phy_events(struct sas_ph
> >  	if (!res)
> >  		goto out;
> >  
> > -	phy->invalid_dword_count = scsi_to_u32(&resp[12]);
> > -	phy->running_disparity_error_count = scsi_to_u32(&resp[16]);
> > -	phy->loss_of_dword_sync_count = scsi_to_u32(&resp[20]);
> > -	phy->phy_reset_problem_count = scsi_to_u32(&resp[24]);
> > +	phy->invalid_dword_count = get_unaligned_be32(&resp[12]);
> > +	phy->running_disparity_error_count = get_unaligned_be32(&resp[16]);
> > +	phy->loss_of_dword_sync_count = get_unaligned_be32(&resp[20]);
> > +	phy->phy_reset_problem_count = get_unaligned_be32(&resp[24]);
> >  
> >   out:
> >  	kfree(resp);
> > diff -puN include/scsi/scsi.h~scsi-remove-private-implementation-of-get_unaligned_be32 include/scsi/scsi.h
> > --- a/include/scsi/scsi.h~scsi-remove-private-implementation-of-get_unaligned_be32
> > +++ a/include/scsi/scsi.h
> > @@ -527,10 +527,4 @@ static inline void set_driver_byte(struc
> >  /* Used to obtain the PCI location of a device */
> >  #define SCSI_IOCTL_GET_PCI		0x5387
> >  
> > -/* Pull a u32 out of a SCSI message (using BE SCSI conventions) */
> > -static inline __u32 scsi_to_u32(__u8 *ptr)
> > -{
> > -	return (ptr[0]<<24) + (ptr[1]<<16) + (ptr[2]<<8) + ptr[3];
> > -}
> > -
> >  #endif /* _SCSI_SCSI_H */
> 
> No ... as I've said several times now, there's a debate going on about
> what we're supposed to be doing with all of this (either putting it in
> SCSI, pulling it out or just using the inline notation.

If I knew what the terrible word "it" is replacing, I'd know what the
above sentence means.

I'm kinda struggling to imagine why there's controversy, really.  scsi
has a private implementation of something which core kernel provides. 
Zap!

>  I'm not putting
> a patch like this in until we at least get some consensus.

I'll hang onto it, so there's nowhere to hide...
