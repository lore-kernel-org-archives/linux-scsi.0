From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Using ncr53c8xx.c for a 53c770 chip (Was: State of NCR53c7xx
	based drivers)
Date: 13 Jan 2004 11:33:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074011584.2173.126.camel@mulgrave>
References: <20031122113834.GA8098@lst.de>
	<20031123175041.A1461@sygehus.dk> <1069606797.2066.2.camel@mulgrave>
	<20040113145553.A1738@sygehus.dk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:55984 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264382AbUAMQdI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jan 2004 11:33:08 -0500
In-Reply-To: <20040113145553.A1738@sygehus.dk>
List-Id: linux-scsi@vger.kernel.org
To: Rask Ingemann Lambertsen <rask@sygehus.dk>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-01-13 at 08:55, Rask Ingemann Lambertsen wrote:
> That's only for the 2.6.x kernels, isn't it?

it's only been cut apart to work nicely like this in 2.6 kernels, yes. 
There is a residue in 2.4 for driving the parisc zalon (53c720) card

> I need some help filling in the ncr_chip structure. Where do I find the
> device_id, revision_id, burst_max, nr_divisor and features settings? I can
> figure some of it out:
> .offset_max = 15 (the maximum allowed by the AmigaOS driver).
> .features = FE_ULTRA | FE_WIDE | FE_RAM (but maybe more flags are needed?)

I'd get it working in 53c720 mode first (i.e. drop the FE_ULTRA) and
then go back and add the ultra capability.

> I also need some help filling in the ncr_slot structure. The registers are
> memory mapped at bus address 0xf40000 and the script RAM is memory mapped at
> bus address 0xf41000. So I guess base is for the registers, base2 is for
> the script RAM and that *_v is for the virtual memory addresses of the above.
> That still leaves me with io_port, base_c, base2_c and base_io.

That should be correct...although I've not tested it, it might be wise
to begin without the FE_RAM as well.  I can check this with the
NCR_Q720, though if you get problems.  Although it doesn't have on-chip
ram for scripts, the board itself has 2Mb of ram behind the MCA window

> Where do I tell the driver about the SCSI clock (50 MHz)?

The driver will work it out...it has its own timing routine.

This is another reason for trying without FE_ULTRA.  Normally, a 770 in
Ultra mode requires an 80MHz clock.  For a 50MHz clock, you need to use
the 770s clock doubler mode, so when you're ready to try it, you'll need
FE_DBLR (and I don't think this has ever been tested on a 770 either...)

James


