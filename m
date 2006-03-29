From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Maxtor drive doesn't wake from sleep
Date: Wed, 29 Mar 2006 19:31:48 +0200
Message-ID: <442AC484.2070107@s5r6.in-berlin.de>
References: <442AB4A8.8070307@alma.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:9118 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S1750894AbWC2Rc5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 12:32:57 -0500
In-Reply-To: <442AB4A8.8070307@alma.ch>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mi <mi.lists@alma.ch>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

Mi wrote at linux1394-devel:
> Hello,
> 
> I have 3 external firewire Maxtor One Touch III drives, which appear to 
> go into a "sleep" state after between one and two hours, and cannot be 
> accessed after that.
> 
> After a lot of searches and tests, I have found a few clues, but still 
> wonder why they don't wake up automatically as needed. Is there anything 
> I can do to my system so that it "Just Works"? Is this a known problem?

There are very few vendors which implement auto-spin-down in FireWire 
disk enclosures. And of these few, only few get it right.

> To have the drive re-appear, I found I can
> 
>   rmmod sbp2
>   modprobe sbp2
> 
> and I later found scsi-spin which is also able to wake up the drive:
> 
>   scsi-spin -u /dev/sdd
> 
> But since these drives are on a server and suposed to be mounted with 
> automount, these manual steps to wake them are nt much help.
> 
> Note that there is absolutely nothing in the logs when the drive goes to 
> sleep. Only errors when I try to access them:
> 
>    kernel: Device sdd not ready.
>    kernel: end_request: I/O error, dev sdd, sector 0

I don't think this could be solved in the FireWire drivers. It seems 
sd_mod is the place to look for a solution. The sbp2 driver is not aware 
that there is something wrong with the disk, else there would be error 
messages.

That's why I added linux-scsi to the recipients. I'd be glad if somebody 
of the SCSI folk could comment.

> My system is Debian stable (Sarge / 3.1) with kernel 2.6:
> 
> # uname -a
> Linux gc 2.6.8-2-686 #1 Tue Aug 16 13:22:48 UTC 2005 i686 GNU/Linux

This is quite an old kernel. I don't know though if newer kernels 
contain changes to sd_mod which are relevant to the problem.

> In case it's relevant, the Firewire card is
> 
>  0000:02:02.0 FireWire (IEEE 1394): Texas Instruments TSB82AA2 
> IEEE-1394b Link Layer Controller (rev 01) (prog-if 10 [OHCI])
>        Subsystem: Timedia Technology Co Ltd: Unknown device 3110
>        Flags: bus master, medium devsel, latency 32, IRQ 209
>        Memory at fe9ff800 (32-bit, non-prefetchable) [size=2K]
>        Memory at fe9f8000 (32-bit, non-prefetchable) [size=16K]
>        Capabilities: [44] Power Management version 2
> 
> and an excerpt from lsmod (I kept the loaded modules which looked 
> relevant + the ones I didn't know):
> 
> sbp2                   24392  0
> ohci1394               35492  0
> ieee1394              111512  2 sbp2,ohci1394
> shpchp                101900  0
> pciehp                 99020  0
> pci_hotplug            34640  2 shpchp,pciehp
> ide_scsi               17412  0
> capability              4520  0
> commoncap               7232  1 capability
> mbcache                 9348  2 ext2,ext3
> sd_mod                 21728  11
> scsi_mod              125228  5 sbp2,aic79xx,ide_scsi,sd_mod,aic7xxx
> 
> 
> I don't know how to find out the module versions, but they are the 
> modules which come with that stock Debian kernel.
> 
> 
> Thanks for any help
> 
> M

-- 
Stefan Richter
-=====-=-==- --== ===-=
http://arcgraph.de/sr/
