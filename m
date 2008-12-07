From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] remove ide-scsi
Date: Sun, 07 Dec 2008 09:04:58 -0600
Message-ID: <1228662298.3501.19.camel@localhost.localdomain>
References: <20081203103856S.fujita.tomonori@lab.ntt.co.jp>
	 <200812061551.08525.bzolnier@gmail.com>	<20081206120001.3580b9e3@tuna>
	 <200812062241.35601.bzolnier@gmail.com>
	 <20081206222423.04aada70@lxorguk.ukuu.org.uk>
	 <493B022B.3050406@ru.mvista.com>
	 <20081206230227.07b00e2f@lxorguk.ukuu.org.uk>
	 <493B0867.5020700@ru.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37665 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753706AbYLGPE5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Dec 2008 10:04:57 -0500
In-Reply-To: <493B0867.5020700@ru.mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Dan =?ISO-8859-1?Q?No=E9?= <dpn@isomerica.net>, Christoph Hellwig <hch@infradead.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, osst@riede.org

On Sun, 2008-12-07 at 02:19 +0300, Sergei Shtylyov wrote:
> Hello.
> 
> Alan Cox wrote:
> 
> >>    Oh, yes. SCSI emulation is just what Linux embedded world is asking 
> >> for...
> >>     
> >
> > Well ATAPI is SCSI emulation (its a sort of pidgin SCSI admittedly).
> >   
> 
>    ATAPI is SCSI transport (with maybe some quirks at SCSI command level 
> tho, IIRC). ATA is neither thansport nor does it map to SCSI 1:1.


Well, to be wholly accurate, since SCSI-3, SCSI has been separated into
an architecture, primary command, device specific command and transport
model (called the SCSI architecture model).  Starting with ATA-8, ATA
will go this way again.  What ATAPI actually is is a SCSI (really MMC
for CD and SSC for tape) command transported over ATA using the ATA
PACKET command.  With ATA-8 it will be much more analogous to SCSI
command over ATA transport.

>  The 
> code for emulating SCSI on ATA only burdens the kernel (and causes user 
> complaints about changing disk names from /dev/hdx to /dev/sda :-).

The code for sorting this out is already upstream in the block tree for
2.6.29.

> > I'm actually seeing two strands of requests (including from embedded)
> >
> > - CF only small "dumb as president" type driver that is written to be as
> > compact as possible and preferably considers IRQs as optional
> >   
> 
>    Yes, support for IRQ-less CF is what IDE core lacks. I must note 
> however that IRQ-less mode looks inherently risky to me because of the 
> raciness of tbothe the ATA spec and its implimentatin WRT the "interrupt 
> pending" state. I may be mistaking but someone of T13 experts (Hale 
> Landis I guess) told me that the devices require that state to be 
> cleared to proceed with the command, and that's what the fast polling 
> host is likely to fail at because it doesn't know if rthe device has 
> actually entered this state when BSY is cleared... Oh well, that's an 
> old story...
> 
> > - Full SATA and NCQ aware platform support.
> >   
> 
>    I don't see how SATA/NCQ support is connected to SCSI.

They require features that SCSI has had for a long time for TCQ but
which weren't present in block.

Originally I'd been promised that libata would be out of SCSI within a
year (that was when it went in).  The slight problem is that having all
the features it needed, SCSI became a very comfortable host. Getting
libata out of SCSI was also made difficult by the fact that few people
cared enough to help.  The only significant external problem is the size
of the stack and the slight performance penalty for SATA disks going
over SAT.  Unfortunately for the latter, slight turns out to be pretty
unmeasurable, so the only hope became people who cared about
footprint ... and there don't seem to be any of those.

The other problem is that it isn't just moving libata out of SCSI.  To
do this correctly, SCSI itself needs to be sliced up because lots of
devices running over ATA transports are genuinely governed by SCSI
protocols (CD with MMC and tape with SSC), so we have to be able to run
sr and st over an ATA transport, thus it needs the minimal pieces of
SCSI to function.  This in turn necessitates splitting the whole of the
SCSI mid layer into a stand alone upper layer support library and a
lower layer platform, which is a significant piece of work.

The way it's happening is that people keep thinking of incremental steps
towards this (ULD separated from SCSI, block timers, sd device
allocation separation, block error handling) and doing them, but lacking
a major spur, it's going slowly.

James


