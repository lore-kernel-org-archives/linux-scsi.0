From: Gene Heskett <gene.heskett@verizon.net>
Subject: Re: advansys driver vs 2.6 breakage
Date: Fri, 15 Aug 2003 06:33:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200308150633.00715.gene.heskett@verizon.net>
References: <20030810224402.5c7fa063.rddunlap@osdl.org> <200308131922.20098.gene.heskett@verizon.net> <20030813163001.5c56451e.rddunlap@osdl.org>
Reply-To: gene.heskett@verizon.net
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out001pub.verizon.net ([206.46.170.140]:13756 "EHLO
	out001.verizon.net") by vger.kernel.org with ESMTP id S275896AbTHOKdD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Aug 2003 06:33:03 -0400
In-Reply-To: <20030813163001.5c56451e.rddunlap@osdl.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: linux-scsi@vger.kernel.org, willy@debian.org

On Wednesday 13 August 2003 19:30, Randy.Dunlap wrote:
>On Wed, 13 Aug 2003 19:22:19 -0400 Gene Heskett <gene.heskett@verizon.net> wrote:
>| On Wednesday 13 August 2003 16:25, Randy.Dunlap wrote:
>| >Gene,
>| >
>| >Both the 2.4 and 2.6 logs show lots of successful IOs and a few
>| >IO errors.  The IO errors look like this in both of them:
>| >
>| >Aug 11 13:48:28 coyote kernel: asc_isr_callback: QD_WITH_ERROR
>| >Aug 11 13:48:28 coyote kernel: asc_isr_callback: host_stat 0x11
>| >
>| >This is a timeout as I read the source file.
>| >Maybe I'm misreading the logs, but I don't see any other errors
>| >being reported.  What are the symptoms of the errors that you are
>| >seeing on 2.6.0-test?
>|
>| The last boot I just did is to 2.6.0-test3-mm2, with the bogug bug
>| patch, advansys builtin with debugging off. Using anticipatory
>| scheduler just yet, and kmail just did a mail fetch which tore the
>| machines responsiveness a new one.
>|
>| The original problem was that it wouldn't even boot with test2,
>| and I hadn't tried test1.  That was without the debugging and
>| builtin like it is now, but before the patch that made the
>| debugging stuff build.
>|
>| I'd test it but I need to do 2 things, 1, take the missus out for
>| dinner, and 2, swap all the tapes in the magazine, so it will be a
>| couple of hours before thats all done.  I'll post again with the
>| results.

Ok, after a few nites running, I think its safe to say 
that this new scheduler is stepping on amanda a wee bit.  
Generally speaking, it was better this morning, finishing 
at 4:03, the earliest so far for a 2.6.0 boot, in this case 
to test3-mm2.  For comparison, 2 weeks ago running 2.4.22-rc2 
(IIRC), the finish times were universally in hour 3:xx 
someplace, usually fairly early in it.

However, test3-mm2 does seem to make the machine more 
responsive from the keyboard, with faster screen updates.  
So we win one, and lose a little.

Now if we could just get rid of the short delay to key 
repeat, these ancient fingers aren't as fast as they used 
to be and I'm spending too much time editing the repeats 
out of what I type.  This shows both in the console and 
in x.  But I can probably get used to it.

I've got /sys mounted now, but I still don't see any info 
in there that would tell me what my 2.6-ified devices are, 
xawtv won't run, nor will gnomeradio, and I'm getting the 
impression its because the devices have been re-arranged.

I'm seeing some timeouts in the logs, as follows:

Aug 15 05:09:59 coyote kernel: via82cxxx: timeout while reading AC97 codec (0x9A0000)
Aug 15 05:20:11 coyote kernel: via82cxxx: timeout while reading AC97 codec (0x9A0000)
Aug 15 05:27:04 coyote kernel: via82cxxx: timeout while reading AC97 codec (0x9A0000)
Aug 15 05:31:32 coyote kernel: via82cxxx: timeout while reading AC97 codec (0x9A0000)

But thats not associated with an attempt to run xawtv.
Trying to run gnomeradio logs this:

Aug 15 06:19:01 coyote gconfd (root-16961): starting (version 1.2.1), pid 16961 user 'root'
Aug 15 06:19:01 coyote gconfd (root-16961): Resolved address "xml:readonly:/etc/gconf/gconf.xml.mandatory" to a read-only config source at position 0
Aug 15 06:19:01 coyote gconfd (root-16961): Resolved address "xml:readwrite:/root/.gconf" to a writable config source at position 1
Aug 15 06:19:01 coyote gconfd (root-16961): Resolved address "xml:readonly:/etc/gconf/gconf.xml.defaults" to a read-only config source at position 2
Aug 15 06:20:45 coyote kernel: via82cxxx: timeout while reading AC97 codec (0x9A0000)
Aug 15 06:21:01 coyote gconfd (root-16961): GConf server is not in use, shutting down.
Aug 15 06:21:01 coyote gconfd (root-16961): Exiting

This mobo has a VIA8233.  From lspci -vv:
[...]
00:09.0 Multimedia video controller: Brooktree Corporation Bt878 Video Capture (rev 11)
        Subsystem: Hauppauge computer works Inc. WinTV/GO
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (4000ns min, 10000ns max)
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at ef004000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-

00:09.1 Multimedia controller: Brooktree Corporation Bt878 Audio Capture (rev 11)
        Subsystem: Hauppauge computer works Inc. WinTV/GO
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Latency: 32 (1000ns min, 63750ns max)
        Interrupt: pin A routed to IRQ 5
        Region 0: Memory at ef005000 (32-bit, prefetchable) [size=4K]
        Capabilities: [44] Vital Product Data
        Capabilities: [4c] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
[...]
00:11.5 Multimedia audio controller: VIA Technologies, Inc. VT8233 AC97 Audio Controller (rev 10)
        Subsystem: Realtek Semiconductor Co., Ltd.: Unknown device 4710
        Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66Mhz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
        Interrupt: pin C routed to IRQ 12
        Region 0: I/O ports at e800 [size=256]
        Capabilities: [c0] Power Management version 2
                Flags: PMEClk- DSI- D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot-,D3cold-)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
[...]

FWIW, kde-3.1.1a can make audio, and xmms works too!

-- 
Cheers, Gene
AMD K6-III@500mhz 320M
Athlon1600XP@1400mhz  512M
99.27% setiathome rank, not too shabby for a WV hillbilly
Yahoo.com attornies please note, additions to this message
by Gene Heskett are:
Copyright 2003 by Maurice Eugene Heskett, all rights reserved.

