From: Mark Rustad <mrustad@gmail.com>
Subject: Re: AIC7xxx on 2.6.18
Date: Fri, 2 Feb 2007 23:12:19 -0600
Message-ID: <23196A89-6820-4441-B4AE-199E04B5CF96@gmail.com>
References: <20070128194620.GA6358@animx.eu.org> <20070128162408.9fffb6de.akpm@osdl.org> <20070203004201.GB25027@animx.eu.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.224]:8768 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946342AbXBCFM2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Feb 2007 00:12:28 -0500
Received: by nz-out-0506.google.com with SMTP id s1so1079021nze
        for <linux-scsi@vger.kernel.org>; Fri, 02 Feb 2007 21:12:27 -0800 (PST)
In-Reply-To: <20070203004201.GB25027@animx.eu.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Feb 2, 2007, at 6:42 PM, Wakko Warner wrote:

> Andrew Morton wrote:
>> Yes, getting the oops traces will help, thanks.  And confirmation  
>> on a more recent kernel would be good.
>
> Here's what I get.  I used netconsole so whatever was logged prior  
> to it
> starting was lost.
>
> The PC is a suprtmicro x5da8 with an onboard dual channel AHA-39320  
> u320
> controller.  I have a dual channel AHA-39160 u160 and a dual channel
> AHA-2940U/UW (ch0/internal is wide/narrow, ch1/externel is narrow).

I have used an x6-class Supermicro motherboard with the Adaptec u320  
controller and I had problems hot-swapping drives with 2.6.18. It  
seemed that the bus reset that the backplane processor generated  
caused trouble for the driver, killing the SCSI bus. 2.6.16 and  
2.6.17 locked up the kernel in the case of hot-swapping drives.

I switched to 2.6.19.2 and things are better. I did find that a card  
dump is produced when hot-inserting a drive, so it is way noisier  
than I think it should be, but it continues to operate and life goes  
on, which is much better behavior than 2.6.16, 2.6.17 or 2.6.18.

> I thought it was because I had option roms turned off, but when I  
> turned
> them on, it still has problems.  What's odd is the fact that if I  
> boot with init=/bin/sh, modprobe aic7xxx, it works fine and I can  
> exec init and it works fine.

I don't know what is up with that, but based on what I have seen I  
would recommend using 2.6.19.x instead of 2.6.18 for systems using  
the aic79xx driver.

-- 
Mark Rustad, MRustad@gmail.com


