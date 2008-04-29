From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: AIC94xx SAS question.
Date: Mon, 28 Apr 2008 22:04:17 -0400
Message-ID: <20080429020417.GC17521@animx.eu.org>
References: <20080421231940.GB5656@animx.eu.org> <4812B66A.5000105@hopnet.net> <20080426145649.GA8848@animx.eu.org> <48140F9F.1070109@hopnet.net> <48159A75.6020400@ipax.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:34112 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbYD2CEU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Apr 2008 22:04:20 -0400
Content-Disposition: inline
In-Reply-To: <48159A75.6020400@ipax.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Raoul Bhatia [IPAX]" <r.bhatia@ipax.at>
Cc: linux-scsi@vger.kernel.org, lnxgnome@hopnet.net

Raoul Bhatia [IPAX] wrote:
> Keith Hopkins wrote:
> > SuSE loads the driver as a module and the firmware in initrd.  I haven't
> > tried initramfs, nor compiling it into the kernel.
> > 
> > I unpacked my current initrd, and in it I found:
> > 
> > lib/firmware/aic94xx-seq.fw
> > + some ql firmware that I don't need.
> > 
> > I'm not sure if the driver compiled for SuSE "just knows" to look in
> > /lib/firmware, or how it finds the file.  It might have something to do
> > with the firmware_class module in SuSE.
> > I do remember that I needed to load 'edd' before 94xx, or it would not
> > init the firmware.
> 
> this is a default behaviour of this and many other drivers.

Which part are you refering to as being default?  Requiring edd or something
else?

> > As for compiling the driver in the kernel, and putting the firmware in
> > initrd/initramfs, you would have to force the init of the 94xx module to
> > be after the initrd/initramfs was initialized, loaded and mounted.  I
> > have not checked to see if that is currently possible.
> 
> in the end, there is no big deal in putting the firmware into the
> initramfs. some distributions may work out of the box, some might
> require a little tuning of an initramfs hook.

I compile kernels specifically for each machine that I have (which is not
that often and not that many).  Some mount NFS root, others have different
drivers required to mount / and other CPU options as well.  Thus I do not
need the extra overhead and complexity of an initramfs.

> which leads me to my question: why are you absolutly against an
> initramfs image? properly configured - and that is not a big deal
> in current versions of mkinitramfs and current distributions - there
> are few possibilities to break the setup.

I've always hated the idea that one would require this just to get their /
mounted.  Granted there are some setups out there that absolutely require
it.  I have one such setup at work, but that system was designed to run out
of ram anyway.

See comment about initramfs above.  Now if I were attempting to mount
NFSroot over wireless, I would have to use an initramfs.  I see no point in
using initramfs for something that can simply be compiled into the kernel. 
I am aware of possible hardware changes (IE going from ata, scsi, etc to
sata or sas) that would require a recompile and I prefer this again over
initramfs.

As for the reason for this thread, the AIC94xx chip requires non-free
firmware.  Right now, my / is on SCSI and is compiled in.  I had considered
re-doing my system and doing away with the SCSI hard drives.  That'd mean
that I'd need the driver in the kernel (Key word is "I").  So how do I go
about getting the firmware to the driver.  My 2 options, if doable, is to
somehow build the firmware into the kernel myself or build an initramfs with
just enough tools to load the firmware into the driver and mount my /.

I still like the "There's more than 1 way to do it" and I'll probably do a
different way for anything =)

> if you require assistance, i can help.

I appreciate the offer.  I think I know what needs to be done if/when I
decide to redesign my system.

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
