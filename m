From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: bytes/CDB of SCSI pass thru grossly limited maybe
Date: Mon, 30 Aug 2004 12:15:15 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <8AE29B65-FAB0-11D8-85F1-00039398BB5E@ieee.org>
References: <A8E06BE4-F7BA-11D8-AC6B-00039398BB5E@ieee.org> <Pine.LNX.4.44L0
	 .0408271100590.1238-100000@ida.rowland.org> <20040828143124.GB2518@suse.de
	> <1093715498.3682.4.camel@mulgrave> <20040828175547.GA8339@suse.de> <10937
	1 7255.3682.13.camel@mulgrave> <20040828184104.GA8460@suse.de> <1093742128.
	16 70.2.camel@mulgrave> <20040829134505.GB10384@suse.de>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:43712 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S268819AbUH3SPV
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 14:15:21 -0400
In-Reply-To: <20040829134505.GB10384@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>

Alan S:

>>> bio has 1, 4, 16, 64, 128, 256 pools. 32 might make more sense, I 
>>> seem
>>> to recall mpages using that. I'll see if I can sneak a BIO_MAX_PAGES
>>> reduction in, and spend that extra pool on 32 instead :)
>>
>> OK I'll follow whatever you do in SCSI.  I think at least aligning all
>> of our pool maximums is the correct thing to do.
>
> Definitely. I'll toss something out.

Delighted to see people volunteer work, of course ...

If we're next going to see smaller or larger limits on data bytes per 
CDB, I do not yet know, sorry.

> Actually I have no basis for saying there will be any significant 
> benefit
> from going higher than 1024.  Pat LaVarre is interested in trying 
> higher
> values, that's all.

I think, by changing the host, we'll discover devices that care: maybe 
especially in the mass market low end.

What I know is that in bus traces I see "streaming" fail: I see the 
host and device do Not always keep pace with each other, instead I see 
injected delays of a whole disc revolution.  For example, I see 
14.2857~ms/rev =  70 rev/s = 4200 RPM injected for a device that spins 
at 4200 RPM.

That's a concrete anecdote of pain.  My guess of an explanation is that 
we exceeded the margin in the system design.  The margin I mean is the 
time allowed for the overhead of getting from status in to the next 
command out.  Shattering a stream of gigabytes into microscopic 64 
kebibyte chunks multiplies the time overhead involved from status in to 
command out, by the number of chunks.

How do we predict when that large multiplier exceeds the margin 
available, except by trying?

I agree the device and the host both have to change to observe a 
difference.  Changing either alone gives the I-say-false impression of 
having achieved no effect.  For example, if we try an HDD with hardware 
that splices the chunks back together into a stream, so long as the 
system can burst data much more rapidly than the stream rate we're 
trying to sustain, our thruput survives the abuse of microscopic 
chunks.  But we're also all paying for hardware we don't actually need.

> interested in trying higher values, ...

I know SCSI over whatever, when coded entirely in software, as is 
common for USB/ FireWire/ PATAPI/ SATAPI/ etc., has no inherent limit 
on time or data per CDB.  Only the accelerator engine in a PCI adapter 
enforces irritating rules like pinning all data in memory before the 
command begins.  USB & FireWire do have summary descriptors for the 
command that limit data length, but not sharply, for example the USB 
limit is 31 or 32 bits i.e. 2 to 4 GiB - 1 B.  PATAPI & SATAPI have no 
limit whatsoever, though moving more data may for the first time test 
more than one UDMA CRC per CDB.

> interested in trying higher values, ...

I know I'll benefit if we get up to and beyond 1 MiB of data per CDB 
because,

I want to encourage ever more device developers to switch to Linux and 
free & open drivers from proprietary systems that can pass all of free 
memory per CDB.

SCSI-over-whatever device developers occasionally want as much as 128 
MiB per CDB, merely to exercise the standard test case of xFFFF LBA's 
in op x28 "READ (10") or op x2A "WRITE (10)", which at 2 KiB/LBA is 128 
MiB - 2 KiB.  Without such permission, they have to resort to arguing 
that testing less is the equal of testing more.

Pat LaVarre

