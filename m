From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Fw: slab error in cache_free_debugcheck(): cache `sgpool-8':
Date: Mon, 20 Feb 2006 00:39:08 +0100
Message-ID: <43F9019C.3010505@s5r6.in-berlin.de>
References: <20051017002339.5156d7f4.akpm@osdl.org> <4353754B.1040500@s5r6.in-berlin.de> <4353FDAD.1010204@chello.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:20668 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932424AbWBSXjk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Feb 2006 18:39:40 -0500
In-Reply-To: <4353FDAD.1010204@chello.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "F. Poncin" <cr27587@chello.be>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

F. Poncin wrote on 2005-10-17:
> Stefan Richter wrote:
>> Andrew Morton wrote:
>>> THis is rather deadly. Is it likely to be a 1394 bug, or scsi?
>>
>> I am not sure.
> 
> No impact on disk access.
> 
>>> Begin forwarded message:
>> ...
>>> Summary: slab error in cache_free_debugcheck(): cache `sgpool-8': 
>>> double free, or memory outside object was overwritten
>>> Kernel version: 2.6.14-rc4-g9149ccfa
>>> Steps to reproduce: on boot
>>> Hardware: Dell 8300 + External USB disk enclosures
...
> Brand new Seagate USB/FireWire External Hard Drive - 
> http://www.seagate.com/products/personal/external.html
> Connected through FireWire to PCI card: FireWire (IEEE 1394): Agere 
> Systems (former Lucent Microelectronics) FW323 (rev 61)
> 
> The older Seagate model (same size) is not affected.
> Vendor: ST340083 Model: 2A Rev:
> Type: Direct-Access-RBC ANSI SCSI revision: 04
...
>>> scsi2 : SCSI emulation for IEEE-1394 SBP-2 Devices
>>> ieee1394: sbp2: Logged into SBP-2 device
>>> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
>>> Vendor: Initio Model: ST3400832A Rev: 4.07
>>> Type: Direct-Access ANSI SCSI revision: 00
>>> SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
>>> slab error in cache_free_debugcheck(): cache `sgpool-8': double free, 
>>> or memory outside object was overwritten
...
>>> c233b7a8: redzone 1: 0x170fc2a5, redzone 2: 0xc0144b47.
>>> sdc: asking for cache data failed
>>> sdc: assuming drive cache: write through
>>> SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
>>> slab error in cache_free_debugcheck(): cache `sgpool-8': double free, 
>>> or memory outside object was overwritten
...

Finally there is news for Initio SBP-2 bridges.
http://marc.theaimsgroup.com/?l=linux-scsi&m=114038995826749

Could you try the scsi_mod parameters mentioned there?

Alternatively, update to the latest 1394 drivers (soon to be in -mm, 
curently only at 
http://www.kernel.org/git/?p=linux/kernel/git/scjody/ieee1394.git or 
http://me.in-berlin.de/~s5r6/linux1394/updates/ ) and load sbp2 with 
"modprobe sbp2 force_inquiry_hack=1" before connecting the disk.

If either one of these workarounds helps I would be interested in the 
firmware revision which is logged by sbp2 with force_inquiry_hack=1. You 
can get this value with unpatched drivers too.
-- 
Stefan Richter
-=====-=-==- --=- =-=--
http://arcgraph.de/sr/
