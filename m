From: Wakko Warner <wakko@animx.eu.org>
Subject: Re: AIC94xx SAS question.
Date: Mon, 28 Apr 2008 21:53:23 -0400
Message-ID: <20080429015323.GB17521@animx.eu.org>
References: <20080421231940.GB5656@animx.eu.org> <4812B66A.5000105@hopnet.net> <20080426145649.GA8848@animx.eu.org> <48140F9F.1070109@hopnet.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from animx.eu.org ([216.98.75.249]:36998 "EHLO animx.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752604AbYD2Bx0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Apr 2008 21:53:26 -0400
Content-Disposition: inline
In-Reply-To: <48140F9F.1070109@hopnet.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Hopkins <lnxgnome@hopnet.net>
Cc: linux-scsi@vger.kernel.org

Keith Hopkins wrote:
> On 04/26/2008 10:56 PM, Wakko Warner wrote:
> >I can understand this from the point of the distrobution of the linux
> >kernel, but it still can be done.  If there were a patch or something that
> >would convert the file, that's all I care.  This for me would be preferred.
> 
> Sorry, no idea if it can actually be done.

I believe it can be.  I don't think the driver really cares if the firmware
came from firmware loader or a binary blob compiled into the kernel (so long
as the code is there to do this).

> >I'm not sure if you got the point of #2 or not.  I do *NOT* want the driver
> >as a module, I want it compiled into the kernel and then load the firmware
> >from an initramfs.
> 
> I think I got you all right.  My answers were just too short :)

I'd say so! =)

> SuSE loads the driver as a module and the firmware in initrd.  I haven't 
> tried initramfs, nor compiling it into the kernel.
> 
> I unpacked my current initrd, and in it I found:
> 
> lib/firmware/aic94xx-seq.fw
> + some ql firmware that I don't need.
> 
> I'm not sure if the driver compiled for SuSE "just knows" to look in 
> /lib/firmware, or how it finds the file.  It might have something to do 
> with the firmware_class module in SuSE.
> I do remember that I needed to load 'edd' before 94xx, or it would not init 
> the firmware.

[wakko@vegeta:/home/wakko] lsmod|egrep "edd|aic"
aic94xx                77436  6 
libsas                 46728  1 aic94xx
firmware_class         10880  1 aic94xx
scsi_transport_sas     35456  2 aic94xx,libsas
[wakko@vegeta:/home/wakko] 

Apparently, I didn't have to.  I still use the old hotplug scripts (I
personally hate udev)

> As for compiling the driver in the kernel, and putting the firmware in 
> initrd/initramfs, you would have to force the init of the 94xx module to be 
> after the initrd/initramfs was initialized, loaded and mounted.  I have not 
> checked to see if that is currently possible.

I'm not 100% sure how it would work, I know that if there's no firmware
available at module load time, it'll appear to hang for x number of seconds
waiting for the firmware.  I believe the same will happen if compiled in,
but I've not read the code nor would I understand if I did.  As I said in
another email, I "oopsed" (not a kernel oops!!) and loaded the module w/o
/sys mounted.  I later mounted /sys and told the driver to bind to the PCI
ID of the card.  It happily loaded the firmware that time.  I believe the
same would be true for compiled in.  In this case, a static initramfs
(static meaning no kernel modules and doesn't require updating every kernel
update) would work.  It would make firmware updates easier, but how often
would you update the firmware and not the kernel?

-- 
 Lab tests show that use of micro$oft causes cancer in lab animals
 Got Gas???
