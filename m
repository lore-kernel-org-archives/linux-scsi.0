From: Ricard Wanderlof <ricard.wanderlof@axis.com>
Subject: Re: Race to power off harming SATA SSDs
Date: Mon, 8 May 2017 11:06:35 +0200
Message-ID: <alpine.DEB.2.11.1705081059580.6882@lnxricardw1>
References: <20170410232118.GA4816@khazad-dum.debian.net>  <20170410235206.GA28603@wtj.duckdns.org>  <20170507204007.GA25628@atrey.karlin.mff.cuni.cz>  <1494228094.6528.14.camel@infradead.org>  <alpine.DEB.2.11.1705080930150.6882@lnxricardw1>
 <1494231215.6528.22.camel@infradead.org>  <alpine.DEB.2.11.1705081034420.6882@lnxricardw1> <1494233673.6528.28.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1494233673.6528.28.camel@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, boris.brezillon@free-electrons.com, linux-scsi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>
List-Id: linux-scsi@vger.kernel.org


On Mon, 8 May 2017, David Woodhouse wrote:

> > On Mon, 8 May 2017, David Woodhouse wrote:
> > > Our empirical testing trumps your "can never happen" theory :)
> >
> > I'm sure it does. But what is the explanation then? Has anyone analyzed 
> > what is going on using an oscilloscope to verify relationship between 
> > erase command and supply voltage drop?
> 
> Not that I'm aware of. Once we have reached the "it does happen and we
> have to cope" there was not a lot of point in working out *why* it
> happened.
> 
> In fact, the only examples I *personally* remember were on NOR flash,
> which takes longer to erase. So it's vaguely possible that it doesn't
> happen on NAND. But really, it's not something we should be depending
> on and the software mechanisms have to remain in place.

My point is really that say that the problem is in fact not that the erase 
is cut short due to the power fail, but that the software issues a second 
command before the first erase command has completed, for instance, or 
some other situation. Then we'd have a concrete situation which we can 
resolve (i.e., fix the bug), rather than assuming that it's the hardware's 
fault and implement various software workarounds.

On the other hand, making the software resilient to erase problems 
essentially makes the system more robust in any case, so it's not a bad 
thing of course.

It's just that I've seen this "we're software guys, and it must be the 
hardware's fault" (and vice versa) enough times to cause a small warning 
bell to off here.

/Ricard
-- 
Ricard Wolf Wanderlöf                           ricardw(at)axis.com
Axis Communications AB, Lund, Sweden            www.axis.com
Phone +46 46 272 2016                           Fax +46 46 13 61 30
