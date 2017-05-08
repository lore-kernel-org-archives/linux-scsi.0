From: Ricard Wanderlof <ricard.wanderlof@axis.com>
Subject: Re: Race to power off harming SATA SSDs
Date: Mon, 8 May 2017 09:38:24 +0200
Message-ID: <alpine.DEB.2.11.1705080930150.6882@lnxricardw1>
References: <20170410232118.GA4816@khazad-dum.debian.net> <20170410235206.GA28603@wtj.duckdns.org> <20170507204007.GA25628@atrey.karlin.mff.cuni.cz> <1494228094.6528.14.camel@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1494228094.6528.14.camel@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: David Woodhouse <dwmw2@infradead.org>
Cc: Pavel Machek <pavel@ucw.cz>, Tejun Heo <tj@kernel.org>, boris.brezillon@free-electrons.com, linux-scsi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org, Henrique de Moraes Holschuh <hmh@hmh.eng.br>
List-Id: linux-scsi@vger.kernel.org


On Mon, 8 May 2017, David Woodhouse wrote:

> > [Issue is, if you powerdown during erase, you get "weakly erased"
> > page, which will contain expected 0xff's, but you'll get bitflips
> > there quickly. Similar issue exists for writes. It is solveable in
> > software, just hard and slow... and we don't do it.]
> 
> It's not that hard. We certainly do it in JFFS2. I was fairly sure that
> it was also part of the design considerations for UBI ? it really ought
> to be right there too. I'm less sure about UBIFS but I would have
> expected it to be OK.

I've got a problem with the underlying mechanism. How long does it take to 
erase a NAND block? A couple of milliseconds. That means that for an erase 
to be "weak" du to a power fail, the host CPU must issue an erase command, 
and then the power to the NAND must drop within those milliseconds. 
However, in most systems there will be a power monitor which will 
essentially reset the CPU as soon as the power starts dropping. So in 
practice, by the time the voltage is too low to successfully supply the 
NAND chip, the CPU has already been reset, hence, no reset command will 
have been given by the time NAND runs out of steam.

Sure, with switchmode power supplies, we don't have those large capacitors 
in the power supply which can keep the power going for a second or more, 
but still, I would think that the power wouldn't die fast enough for this 
to be an issue.

But I could very well be wrong and I haven't had experience with that many 
NAND flash systems. But then please tell me where the above reasoning is 
flawed.

/Ricard
-- 
Ricard Wolf Wanderlöf                           ricardw(at)axis.com
Axis Communications AB, Lund, Sweden            www.axis.com
Phone +46 46 272 2016                           Fax +46 46 13 61 30
