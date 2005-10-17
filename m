From: "F. Poncin" <cr27587@chello.be>
Subject: Re: Fw: slab error in cache_free_debugcheck(): cache `sgpool-8':
Date: Mon, 17 Oct 2005 21:38:21 +0200
Message-ID: <4353FDAD.1010204@chello.be>
References: <20051017002339.5156d7f4.akpm@osdl.org> <4353754B.1040500@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from amsfep12-int.chello.nl ([213.46.243.17]:4952 "EHLO
	amsfep12-int.chello.nl") by vger.kernel.org with ESMTP
	id S1751181AbVJQTi1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Oct 2005 15:38:27 -0400
In-Reply-To: <4353754B.1040500@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

Stefan Richter wrote:

> Andrew Morton wrote:
>
>> THis is rather deadly. Is it likely to be a 1394 bug, or scsi?
>
>
> I am not sure.

No impact on disk access.

>
>> Begin forwarded message:
>
> ...
>
>> Summary: slab error in cache_free_debugcheck(): cache `sgpool-8': 
>> double free, or memory outside object was overwritten
>> Kernel version: 2.6.14-rc4-g9149ccfa
>> Steps to reproduce: on boot
>> Hardware: Dell 8300 + External USB disk enclosures
>
>
> (FireWire enclosure, or FireWire attached combo enclosure)


Brand new Seagate USB/FireWire External Hard Drive - 
http://www.seagate.com/products/personal/external.html
Connected through FireWire to PCI card: FireWire (IEEE 1394): Agere 
Systems (former Lucent Microelectronics) FW323 (rev 61)

The older Seagate model (same size) is not affected.
Vendor: ST340083 Model: 2A Rev:
Type: Direct-Access-RBC ANSI SCSI revision: 04

>
>> I'm not subscribed to the list. Please Cc:
>> Additional info / test on request.
>>
>> extract from dmesg:
>>
>> scsi2 : SCSI emulation for IEEE-1394 SBP-2 Devices
>> ieee1394: sbp2: Logged into SBP-2 device
>> ieee1394: Node 0-00:1023: Max speed [S400] - Max payload [2048]
>> Vendor: Initio Model: ST3400832A Rev: 4.07
>> Type: Direct-Access ANSI SCSI revision: 00
>> SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
>> slab error in cache_free_debugcheck(): cache `sgpool-8': double free, 
>> or memory outside object was overwritten
>> [<c014a43b>] cache_free_debugcheck+0x15e/0x215
>> [<c0144c73>] mempool_free+0x6c/0x73
>> [<c014ae71>] kmem_cache_free+0x25/0x59
>> [<c0144c73>] mempool_free+0x6c/0x73
>> [<f8891d92>] scsi_io_completion+0x1fd/0x4ac [scsi_mod]
>> [<f8826d3f>] sd_rw_intr+0x155/0x30e [sd_mod]
>> [<c0148e2b>] poison_obj+0x1c/0x38
>> [<c032ca6e>] _spin_lock+0x1c/0x75
>> [<f888cc33>] scsi_finish_command+0x82/0xb5 [scsi_mod]
>
> ...
>
>> [<c03f088a>] start_kernel+0x18c/0x1cb
>> [<c03f030b>] unknown_bootoption+0x0/0x1b0
>> c233b7a8: redzone 1: 0x170fc2a5, redzone 2: 0xc0144b47.
>> sdc: asking for cache data failed
>> sdc: assuming drive cache: write through
>> SCSI device sdc: 781422768 512-byte hdwr sectors (400088 MB)
>> slab error in cache_free_debugcheck(): cache `sgpool-8': double free, 
>> or memory outside object was overwritten
>
>
> Note: RBC (reduced block command set) handling, which affects the 
> "asking for cache data" and is applicable to most FireWire harddisks, 
> was moved out of sbp2 into sd_mod (?) some time ago, then temporarily 
> back into sbp2 again due to bugs and incompatibilities of the new RBC 
> handling. We are about to free sbp2 of RBC handling again RSN. (We 
> need to test it more, plus to push the proper patches to -mm for more 
> exposure.)
>
> I have one Initio based 2.5" disk myself which reacted really nasty 
> when the RBC handling changes were introduced. The bridge's firmware 
> seems to be quite quirky. I think the RBC code in sd_mod (?) has 
> become a bit more robust since, but I did not touch that Initio based 
> disk recently. Will test RSN.


