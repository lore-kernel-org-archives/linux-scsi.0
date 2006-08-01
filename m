From: Robert Annessi <robert@annessi.at>
Subject: dc395x: Report
Date: Tue, 01 Aug 2006 13:54:26 +0200
Message-ID: <44CF40F2.3080401@annessi.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx-03.sil.at ([86.59.12.202]:32229 "EHLO mx-03.sil.at")
	by vger.kernel.org with ESMTP id S1422784AbWHALyi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2006 07:54:38 -0400
Received: from home.annessi.at ([85.125.246.130] helo=[10.99.99.12])
	by mx-03.sil.at with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA:32)
	(Exim 4.60)
	(envelope-from <robert@annessi.at>)
	id 1G7spZ-0006Ys-7W
	for linux-scsi@vger.kernel.org; Tue, 01 Aug 2006 13:54:37 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi,

I got a Tekram 395UW SCSI controller with one hard disk attached to it. 
Since the kernel droped me the line "drivers/scsi/dc395x.c: Please, 
contact <linux-scsi@vger.kernel.org> to help improve support for your 
system.", I give you some feedback.

The default settings of the module were not applicable for me.
When loading the module (or the driver builtin within the kernel) 
without any additional arguments I got a bunch of these error messages:
"dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds"
(about 10 per second) and I was not able to access the disk.

Some log lines:
<snip>
dc395x: Target 00: Wide16 Sync: 48ns Offset 15 (41.7 MB/s)
   Vendor: SEAGATE   Model: ST3146807LC       Rev: 0007
   Type:   Direct-Access                      ANSI SCSI revision:
  03
sda : READ CAPACITY failed.
sda : status=12, message=00, host=7, driver=00
sda : sense not available.
sda: test WP failed, assume Write Enabled
sda: asking for cache data failed
sda: assuming drive cache: write through
sda : READ CAPACITY failed.
sda : status=12, message=00, host=7, driver=00
sda : sense not available.
sda: test WP failed, assume Write Enabled
sda: asking for cache data failed
sda: assuming drive cache: write through
sda:<6>dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds
dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds
dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds
dc395x: QUEUE_FULL for dev <00-0> with 1 cmnds
<snap>

When I turned the (hotswapable) disk off the machine freezed.

Loading the module with safe=1 (or dc395x.safe=1 when builtin) fixed the 
problem, but the speed of the disk was terrible slow (about 2mb/sec). So 
I did some try and error to find the arguments with the best performance 
  and of course no freeze:
dev_mode=0x0f : setting this to a higher value results in the error 
described above
adapter_mode=0x0f : setting this to a higher value results in the error 
described above
max_speed=0 : highest speed available - works for me
tags : I did not notice any difference in setting this, so I left the 
default value
reset_delay : I was not able to set any other value. The driver always 
uses 1 second (i do not mind - it works for me)

I noticed that there were some dc395 updates in 2.6.17 and 2.6.18-rc.
I currently use 2.6.16 with some patches. Some of them are currently not 
ported to 2.6.17|2.6.18-rc, so I am not able to upgrade yet. I gave 
2.6.17 a short try, but had the same "QUEUE_FULL"-error with the default 
values (but as I wrote: just a short try - I did not play around with it 
that much).

The firmware on the controller is the latest available from tekram.com 
(3.05).

lspci -vv:
<snip>
00:02.0 SCSI storage controller: Tekram Technology Co.,Ltd. TRM-S1040 
(rev 01)
         Subsystem: Tekram Technology Co.,Ltd. TRM-S1040
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64, Cache Line Size 04
         Interrupt: pin A routed to IRQ 11
         Region 0: I/O ports at d400 [size=256]
         Region 1: Memory at feaef000 (32-bit, non-prefetchable) [size=4K]
         Expansion ROM at feab0000 [disabled] [size=64K]
         Capabilities: [dc] Power Management version 1
                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-
<snap>

I am not subscribed to the list - please cc me in any replies.

Regards,
Robert
