From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [0/20] Remove isa_unchecked_dma and some more GFP_DMAs in the mid layer v3
Date: Wed, 12 Mar 2008 01:56:49 +0100
Message-ID: <20080312005649.GA2522@one.firstfloor.org>
References: <20080307653.720459648@firstfloor.org> <47D6C784.50408@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from one.firstfloor.org ([213.235.205.2]:39491 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbYCLAyx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Mar 2008 20:54:53 -0400
Content-Disposition: inline
In-Reply-To: <47D6C784.50408@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Andi Kleen <andi@firstfloor.org>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, axboe@kernel.dk, Jeff Garzik <jeff@garzik.org>

On Tue, Mar 11, 2008 at 07:55:16PM +0200, Boaz Harrosh wrote:
> It perfectly fits with two parallel efforts I'm perusing.
> 
> - First is with regard to scsi_cmnd->cmnd cleanup:
>   http://www.spinics.net/lists/linux-scsi/msg23676.html
> 
>   You have just done my job where I needed to audit all uses of 
>   scsi_cmnd->cmnd with regard to the isa_unchecked_dma.
>   (see: http://www.spinics.net/lists/linux-scsi/msg23747.html)

Some reauditing would be probably still a good idea, just to make
sure i didn't miss anything. Some of the code was rather unclean
and not always obvious too.

> The "scan-and-change of all scsi LLDS that..." is a very unrewarding and sure to 
> encounter-hidden-ghosts effort. As I should know freshly. Reviewing few of the
> drivers in this patchset I've spotted some minor problems. Mainly two things
> right now. For instance aha152x.c is a file used for both ISA and a PCMCIA
> devices, your change unnecessarily restricts the PCMCIA device. That driver, as 

But it was already restricted before wasn't it?

I'm definitely not trying to tune or improve these drivers in any way, 
just remove a crufty bit of infrastructure.

> well as other drivers in the patchset, are currently allocated low by the 
> isa_unchecked_dma, but from a closer inspection, none of the host_data is actually 
> used for DMA and the allocation can stay embedded. I think it is worth it to do

Hmm, I thought i had audited them for needing or not needing dma on
hostdata and only converted the ones who needed it, but I might have
err'ed on the side of caution in some cases I wasn't 100% sure.

Even if the hostdata is allocated unnecessarily as dma it is only
a quite small amount of memory so it shouldn't really hurt.

> that now in one go. One more thing is the EISA devices that are now pushed to
> behave like ISA because they do not have a device, like gdth, For that particular

Yes, but they already behaved before like that. No change. 
I was especially careful to not add unnecessary data bouncing for that 
case.

> driver Jeff Garzik has a patch in Q that might help. I will try to rebase your
> patch on top of his series.
> 
> I will put all your patches on a local git tree and try to stare at them deeper.
> Do you have these (And all the dma patches sent to lkml) on a public git tree
> somewhere? I would like to study and test them.

I have them in quilt on the ftp server. Actually
it contains some more, it is just the first part of larger work I'm doing to rework
DMA memory allocation.  The SCSI parts are up to "scsi-ch-dma" in the series.

I used to have a recipe to turn quilt into git, but it doesn't seem
to work anymore with latest git (or maybe I forgot it).

I can try to reconstruct that again later if you really need it.


> (The ftp url you specified in lkml returns an alphabetical order of patches and
> I'm not sure which subdirectory has the latest set)

It's a series of patches with the "series" file defining the 
order, aka quilt format.

The usual way for quilt is to get quilt get the patches dir
ln -s it into the source tree and then use quilt push -a to apply them
Or if you only want the SCSI stuff only go upto "scsi-ch-dma"

Or you could probably write some simple scripts to apply it based
on the series. It's essentially just

grep -v '#' patches/series | while read i ; do patch -p1 < patches/$i ; done

Thanks for your help.

-Andi
