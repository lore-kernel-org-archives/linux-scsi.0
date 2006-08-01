From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: dc395x: Report
Date: Wed, 2 Aug 2006 01:24:02 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0608020046510.8659@poirot.grange>
References: <44CF40F2.3080401@annessi.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.21]:33951 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1750740AbWHAXXo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2006 19:23:44 -0400
In-Reply-To: <44CF40F2.3080401@annessi.at>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Annessi <robert@annessi.at>
Cc: linux-scsi@vger.kernel.org

On Tue, 1 Aug 2006, Robert Annessi wrote:

> Hi,
> 
> I got a Tekram 395UW SCSI controller with one hard disk attached to it. Since
> the kernel droped me the line "drivers/scsi/dc395x.c: Please, contact
> <linux-scsi@vger.kernel.org> to help improve support for your system.", I give
> you some feedback.
> 
> The default settings of the module were not applicable for me.
> When loading the module (or the driver builtin within the kernel) without any
> additional arguments I got a bunch of these error messages:
> "dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds"
> (about 10 per second) and I was not able to access the disk.

Ok, I think:

1) your _device_ is buggy. If you look in drivers/scsi/scsi_devinfo.c in 
scsi_static_device_list[] blask list, you'll find 2 more SEAGATE drives 
with problems with tagged commands. Try adding your drive to the list also 
with BLIST_NOTQ like

{"SEAGATE", "ST3146807LC", "0007", BLIST_NOTQ}

or you can build dc395x as a module and before loading it add your device 
to /proc/scsi/device_info. Actually, you can even try it with your 2.6.16 
kernel, ...

!!! Oh, no... dc395x doesn't use the generic blacklist table... Anyone to 
fix it? Until it is fixed you should forget the above and could try 
disabling it in the driver by either

a) uncommenting the line

#define DC395x_NO_TAGQ

b) removing " | NTC_DO_TAG_QUEUEING" from dev mode from cfg_data

c) some other dirty trick...

2) dc395x was not patched for 2.6.17, only for 2.6.18-rc*, so, would be 
quite interesting if you could test with that. We haven't had any reports 
with wide devices with this "help improve support" problem yet.

3) if you do get round to testing your system under 2.6.18-rcX, please 
first test with vanilla kernel without parameters, then with safe=1, then 
with your disk added to the blacklist (hacked dc395x.c) without and (if 
still needed) with safe=1. Please, send all (distinct) negotiation 
protocols from these tests.

Thanks
Guennadi

> 
> Some log lines:
> <snip>
> dc395x: Target 00: Wide16 Sync: 48ns Offset 15 (41.7 MB/s)
>   Vendor: SEAGATE   Model: ST3146807LC       Rev: 0007
>   Type:   Direct-Access                      ANSI SCSI revision:
>  03
> sda : READ CAPACITY failed.
> sda : status=12, message=00, host=7, driver=00
> sda : sense not available.
> sda: test WP failed, assume Write Enabled
> sda: asking for cache data failed
> sda: assuming drive cache: write through
> sda : READ CAPACITY failed.
> sda : status=12, message=00, host=7, driver=00
> sda : sense not available.
> sda: test WP failed, assume Write Enabled
> sda: asking for cache data failed
> sda: assuming drive cache: write through
> sda:<6>dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds
> dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds
> dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds
> dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds
> <snap>
> 
> When I turned the (hotswapable) disk off the machine freezed.
> 
> Loading the module with safe=1 (or dc395x.safe=1 when builtin) fixed the
> problem, but the speed of the disk was terrible slow (about 2mb/sec). So I did
> some try and error to find the arguments with the best performance  and of
> course no freeze:
> dev_mode=0x0f : setting this to a higher value results in the error described
> above
> adapter_mode=0x0f : setting this to a higher value results in the error
> described above
> max_speed=0 : highest speed available - works for me
> tags : I did not notice any difference in setting this, so I left the default
> value
> reset_delay : I was not able to set any other value. The driver always uses 1
> second (i do not mind - it works for me)
> 
> I noticed that there were some dc395 updates in 2.6.17 and 2.6.18-rc.
> I currently use 2.6.16 with some patches. Some of them are currently not
> ported to 2.6.17|2.6.18-rc, so I am not able to upgrade yet. I gave 2.6.17 a
> short try, but had the same "QUEUE_FULL"-error with the default values (but as
> I wrote: just a short try - I did not play around with it that much).
> 
> The firmware on the controller is the latest available from tekram.com (3.05).
> 
> lspci -vv:
> <snip>
> 00:02.0 SCSI storage controller: Tekram Technology Co.,Ltd. TRM-S1040 (rev 01)
>         Subsystem: Tekram Technology Co.,Ltd. TRM-S1040
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 64, Cache Line Size 04
>         Interrupt: pin A routed to IRQ 11
>         Region 0: I/O ports at d400 [size=256]
>         Region 1: Memory at feaef000 (32-bit, non-prefetchable) [size=4K]
>         Expansion ROM at feab0000 [disabled] [size=64K]
>         Capabilities: [dc] Power Management version 1
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA
> PME(D0-,D1-,D2-,D3hot-,D3cold-)
>                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
> <snap>
> 
> I am not subscribed to the list - please cc me in any replies.
> 
> Regards,
> Robert
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

---
Guennadi Liakhovetski
