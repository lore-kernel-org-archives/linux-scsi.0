From: post@pfrst.de
Subject: Re: [PATCH][SCSI] sgiwd93.c: interfacing to wd33c93
Date: Fri, 16 Feb 2007 23:39:42 +0100 (MET)
Message-ID: <Pine.LNX.4.21.0702162316240.676-100000@SNaIlmail.Peter>
References: <1171640162.3443.19.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail1.pearl-online.net ([62.159.194.147]:20476 "EHLO
	mail1.pearl-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbXBPW40 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Feb 2007 17:56:26 -0500
In-Reply-To: <1171640162.3443.19.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>, Kumba <kumba@gentoo.org>, Thiemo Seufer <ths@networkno.de>, Tim Yamin <plasmaroo@gentoo.org>



Sorry for the annoyance, i split it, since these patches address different
issues: the nosync patch just (re)allows an appropriate commandline
setting (with or without the wd33c93 patches applied) to cope with some
uncooperative devices, while the other one depends on the 2nd wd33c93 patch
being applied already/simultaneously.

kind regards

peter 


On Fri, 16 Feb 2007, James Bottomley wrote:

> Date: Fri, 16 Feb 2007 09:36:02 -0600
> From: James Bottomley <James.Bottomley@HansenPartnership.com>
> To: post@pfrst.de
> Cc: linux-scsi@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>,
>      Kumba <kumba@gentoo.org>, Thiemo Seufer <ths@networkno.de>,
>      Tim Yamin <plasmaroo@gentoo.org>
> Subject: Re: [PATCH][SCSI] sgiwd93.c: interfacing to wd33c93
> 
> On Mon, 2007-02-12 at 15:27 +0100, peter fuerst wrote:
> > ========================================================================
> > --- dc7bdc97927ea1c519f0d8bd3133739600c841d4/drivers/scsi/sgiwd93.c	Sat Oct  7 00:00:00 2006
> > +++ new/drivers/scsi/sgiwd93.c	Sun Feb 11 22:10:06 2007
> > @@ -250,3 +250,3 @@
> > 
> > -	hdata->wh.no_sync = 0;
> > +	if (0xff == hdata->wh.no_sync) hdata->wh.no_sync = 0;
> > 
> > ========================================================================
> > 
> > 
> > ========================================================================
> > --- dc7bdc97927ea1c519f0d8bd3133739600c841d4/drivers/scsi/sgiwd93.c	Sat Oct  7 00:00:00 2006
> > +++ stage2/drivers/scsi/sgiwd93.c	Sun Feb 11 22:10:06 2007
> > @@ -248,3 +248,3 @@
> > 
> > -	wd33c93_init(host, regs, dma_setup, dma_stop, WD33C93_FS_16_20);
> > +	wd33c93_init(host, regs, dma_setup, dma_stop, WD33C93_FS_MHZ(20));
> > 
> > ========================================================================
> 
> You don't make it easy, do you ... these are two separate patches for
> overlapping regions of the file ... neither quilt nor git likes this way
> of doing things.  Plus the if should be
> 
> if (hdata->wh.no_sync == 0xff)
> 	hdata->wh.no_sync = 0;
> 
> to match the style of the sgiwd93.c.
> 
> Since this is pretty simple, I fixed it up.
> 
> James
> 
> 
> 
> 

