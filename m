From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: LSF Papers online?
Date: Thu, 16 Apr 2009 11:37:02 -0500
Message-ID: <1239899823.3762.37.camel@mulgrave.int.hansenpartnership.com>
References: <49E335BA.3020103@panasas.com>
	 <200904141654.24067.bzolnier@gmail.com>
	 <20090414175441.5ce1f59d@lxorguk.ukuu.org.uk>
	 <200904150009.06539.bzolnier@gmail.com> <1239749357.3638.3.camel@mulgrave>
	 <49E53AE6.4010803@gmail.com>
	 <da824cf30904152331r82594e5i1968471af1dbb1fa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <da824cf30904152331r82594e5i1968471af1dbb1fa@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Grant Grundler <grundler@google.com>
Cc: Robert Hancock <hancockrwd@gmail.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-04-15 at 23:31 -0700, Grant Grundler wrote:
> On Tue, Apr 14, 2009 at 6:39 PM, Robert Hancock <hancockrwd@gmail.com> wrote:
> > James Bottomley wrote:

[...]
> > Compared to
> > any kind of hardware/controller interactions I wouldn't say it's likely to
> > be a significant bottleneck at all. In oprofile runs I've done with heavy
> > ATA activity, the top time consumers are the interrupt handlers,
> 
> interrupts just introduce completion reporting latency. Interrupt mitigation
> techinques/smarter controller can reduce this.

For sure smarter controllers; I'm less convinced on interrupt mitigation
techniques, primarily because smart controllers tend to do batch
completion anyway.

The reason storage shouldn't really need interrupt mitigation (like NAPI
for networks) is that we shouldn't ever really be surprised by an
interrupt, unlike networks.  We should always know what payloads will be
coming at us from the device (and have buffers ready and waiting).  Most
SCSI controllers (including the SAS ones) do all of this today: You can
send out I/O and on some of them get under two interrupts per gigabyte
of data.   I fully agree that some of the less smart SATA controllers
have a lot of catching up to do in this space, but that isn't
necessarily a driver issue; you can't polish a turd as the saying
goes ...

> > command issue paths,
> 
> Hrm? Is this in the device driver?
> 
> > code that actually is poking IO registers.
> 
> Stupid controller design. NICs have been able to run without
> MMIO *Reads* in the performance for more than 5 years now.
> New "Enterprise" SAS/SATA controllers are better but I'm not
> at liberty to discuss those. (sorry)

That's both a protocol and a controller issue for SATA: some of the ATA
transfer modes (like pio) have a lot higher overhead (and,
unfortunately, less offload in the controller) in the protocol stack and
can be unavoidable on certain transactions.

> > The libata-scsi code
> > hasn't even shown up on the radar in my experience.
> 
> It won't for normal disk IOPS rates (<1000 IOPS per disk).
> Run it at 20K or 50K IOPS and see again.
> NICs are pushing alot more than that.

So again, we get to this terminology problem:  NICs tend to have a fixed
packet size (the network MTU) so IOPS/s makes a lot of sense for them.
In most storage transactions we don't really have MTU limitations, so we
try to right size the outgoing transactions to maximize for bandwidth,
so IOPS don't tell the full story.  (after all, if I see all my packets
are 128k, I can artificially reduce the merge limit to 64k and double my
IOPS).

IOPS are starting to come up because SSDs are saying they prefer many
smaller transactions to an accumulated larger one.  I'm still not
entirely convinced that trying to rightsize is wrong here:  most of the
FS data is getting more contiguous, so even for SSDs we can merge
without a lot of work.  A simple back of the envelope calculation can
give the rightizing:  If you want a SSD to max out at its 31 allowed
tags saturating a 3G sata link, then you're talking 10M per tag per
second.  If we assume a 4k sector size, that's 2500 IOPS per tag
(there's no real point doing less than 4k, because that has us splitting
the page cache). Or, to put it another way, over 75k IOPS for a single
SSD doesn't make sense ... the interesting question is whether it would
make more sense to align on, say 16k io and so expect to max out at 20k
IOPS.

James


