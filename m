From: Tejun Heo <htejun@gmail.com>
Subject: Re: linux-next: Tree for July 16 (crash on quad core AMD)
Date: Sat, 19 Jul 2008 09:59:11 +0900
Message-ID: <48813C5F.70007@gmail.com>
References: <20080716235011.ac9643aa.sfr@canb.auug.org.au>	<200807170053.36661.rjw@sisk.pl>	<1216249292.3358.66.camel@localhost.localdomain>	<200807170109.30655.rjw@sisk.pl>	<48808EE0.2060603@gmail.com> <20080719004736.626ef169@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20080719004736.626ef169@mjolnir.drzeus.cx>
Sender: linux-next-owner@vger.kernel.org
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kernel Testers List <kernel-testers@vger.kernel.org>, scsi <linux-scsi@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>, linux-ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, Takashi Iwai <tiwai@suse.de>, tino.keitel@gmx.de
List-Id: linux-scsi@vger.kernel.org

Pierre Ossman wrote:
> I just have one objection to your version, and that is that it cannot
> be used to nibble away at the sg list. The _next() call jumps an entire
> page, whereas you sometimes need to consume that page in two different
> sweeps. This could be handled by some external buffer that keeps the
> remainder of the page, but the point of these functions was to keep
> things simple for the callers.

Well, I don't know how often such usages would be necessary.  If it's a
very common ops, you can add a param to the next function but frankly I
think it's better to build a inside control structure for that.  There's
no need for external buffer, just an inner loop is sufficient.

-- 
tejun
