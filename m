From: Keith Hopkins <lnxgnome@hopnet.net>
Subject: Re: AIC94xx SAS question.
Date: Sun, 27 Apr 2008 13:31:11 +0800
Message-ID: <48140F9F.1070109@hopnet.net>
References: <20080421231940.GB5656@animx.eu.org>	<4812B66A.5000105@hopnet.net> <20080426145649.GA8848@animx.eu.org>
Reply-To: lnxgnome@hopnet.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:26915 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980AbYD0FbS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 27 Apr 2008 01:31:18 -0400
Received: by wa-out-1112.google.com with SMTP id m16so7053861waf.23
        for <linux-scsi@vger.kernel.org>; Sat, 26 Apr 2008 22:31:17 -0700 (PDT)
In-Reply-To: <20080426145649.GA8848@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-scsi@vger.kernel.org

On 04/26/2008 10:56 PM, Wakko Warner wrote:
> Keith Hopkins wrote:
>> On 04/22/2008 07:19 AM, Wakko Warner wrote:
>>> Can either of these be done:
>>> 1) Embed the firmware into the driver so that it can be used before the
>>> rootfs id mounted.
>> I think this is generally not done because firmware tends to be 
>> closed-source.
> 
> I can understand this from the point of the distrobution of the linux
> kernel, but it still can be done.  If there were a patch or something that
> would convert the file, that's all I care.  This for me would be preferred.

Sorry, no idea if it can actually be done.

> 
>>> 2) Can the firmware be loaded in an initr{d,amfs}?
>> Sure.  openSuSE does it in their mkinitrd.
> 
> I'm not sure if you got the point of #2 or not.  I do *NOT* want the driver
> as a module, I want it compiled into the kernel and then load the firmware
> from an initramfs.

I think I got you all right.  My answers were just too short :)

SuSE loads the driver as a module and the firmware in initrd.  I haven't tried initramfs, nor compiling it into the kernel.

I unpacked my current initrd, and in it I found:

lib/firmware/aic94xx-seq.fw
+ some ql firmware that I don't need.

I'm not sure if the driver compiled for SuSE "just knows" to look in /lib/firmware, or how it finds the file.  It might have something to do with the firmware_class module in SuSE.
I do remember that I needed to load 'edd' before 94xx, or it would not init the firmware.

As for compiling the driver in the kernel, and putting the firmware in initrd/initramfs, you would have to force the init of the 94xx module to be after the initrd/initramfs was initialized, loaded and mounted.  I have not checked to see if that is currently possible.

--Keith
