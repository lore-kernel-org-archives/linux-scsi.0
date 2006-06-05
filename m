From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Mon, 5 Jun 2006 12:58:05 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0606051242150.4149@poirot.grange>
References: <Pine.LNX.4.64.0606042013200.14649@nev.ubzr>
 <Pine.LNX.4.60.0606041850090.13574@poirot.grange> <Pine.LNX.4.64.0606042201460.14649@nev.ubzr>
 <Pine.LNX.4.60.0606042022540.24306@poirot.grange> <Pine.LNX.4.64.0606051150440.4038@nev.ubzr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:28075 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S1750954AbWFEK6I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Jun 2006 06:58:08 -0400
In-Reply-To: <Pine.LNX.4.64.0606051150440.4038@nev.ubzr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Lev A. Melnikovsky" <leva@hotmail.com>
Cc: linux-scsi@vger.kernel.org, Jamie Lenehan <lenehan@twibble.org>

On Mon, 5 Jun 2006, Lev A. Melnikovsky wrote:

> I'm (also) having problems with my dc395x and HP C6270A scanner. The log
> contains multiple "Unexpected reselection" messages, so I assume this has
> something to do with the earlier report. Sorry, if my assumption is wrong.

I'm afraid your assumption is correct:-)

> I'm using [x]sane[d] (FC5 official rpm) to control the scanner. The problem is
> ~50% reproducible. Sometimes the scanning is successful, but sometimes it
> hangs for several minutes and reports and I/O Error (earlier sane versions
> segfaulted here, but the modern one does not).
> 
> I have tried the patch from
> http://marc.theaimsgroup.com/?l=linux-scsi&m=114400790021967&w=2
> but it did not really change anything observable.

Same as with other 2 (I think) reporters.

> The log (scsi_mod scsi_logging_level=15) follows:

Well, 15 is a little too small. As you've probably seen in 
drivers/scsi/scsi_logging.h logging is a bitfield with 3 bits allocated 
for every event-type (error, timer, etc.). Actually, if you have no other 
SCSI devices in the system (including USB storage), I would try raising it 
to the maximum ((1 << 30) - 1). The goal would be to try to see which 
command exactly leads to unexpected reselect. Apart from that I have 
little idea on how to debug it. If the log gets too big to be sent to the 
list, please upload it somewhere and provide a link.

> This scanner is the only device on the bus. My understanding is that I don't
> need to manually terminate anything, please correct me if I'm wrong. I can not

The bus has to be terminated on both ends. The HBA is, probably, 
terminating automatically, but the external end has to be terminated. 
Either with an external terminator or with a switch / jumper on your 
scanner.

> guarantee that this is not a hardware problem, but, as far as I remember, it
> did not show (this often) under 2.4 kernel (with the same hardware setup).

But it did show sometimes? On the same hardware?

> My configuration follows:
> 
> Linux 2.6.16.19 #9 Sun Jun 4 22:30:07 MSD 2006 i686 i686 i386 GNU/Linux
> 
> $ cat /proc/cpuinfo
> 
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 11
> model name      : Intel(R) Celeron(TM) CPU                1300MHz
> stepping        : 1
> cpu MHz         : 1303.107
> cache size      : 256 KB
> fdiv_bug        : no
> hlt_bug         : no
> f00f_bug        : no
> coma_bug        : no
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 2
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat
> pse36 mmx fxsr sse
> bogomips        : 2608.88
> 
> $ free
>              total       used       free     shared    buffers     cached
> Mem:        256164     242876      13288          0      13456     176828
> -/+ buffers/cache:      52592     203572
> Swap:       530136          0     530136

Which confirms that this problem is not 64 bit or highmem specific.

Thanks
Guennadi
---
Guennadi Liakhovetski
