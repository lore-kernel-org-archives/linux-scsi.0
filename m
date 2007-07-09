From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Some NCQ numbers...
Date: Mon, 9 Jul 2007 14:26:28 +0200
Message-ID: <20070709122627.GQ5267@kernel.dk>
References: <468392CE.6010206@msgid.tls.msk.ru> <468A06A0.1020802@gmail.com> <468AB1A7.9010201@msgid.tls.msk.ru> <468AF5BB.10005@gmail.com> <1183560034.3418.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:18697 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbXGIM0U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 9 Jul 2007 08:26:20 -0400
Content-Disposition: inline
In-Reply-To: <1183560034.3418.15.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Tejun Heo <htejun@gmail.com>, Michael Tokarev <mjt@tls.msk.ru>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jul 04 2007, James Bottomley wrote:
> On Wed, 2007-07-04 at 10:19 +0900, Tejun Heo wrote:
> > Michael Tokarev wrote:
> > > Well.  It looks like the results does not depend on the
> > > elevator.  Originally I tried with deadline, and just
> > > re-ran the test with noop (hence the long delay with
> > > the answer) - changing linux elevator changes almost
> > > nothing in the results - modulo some random "fluctuations".
> > 
> > I see.  Thanks for testing.
> > 
> > > In any case, NCQ - at least in this drive - just does
> > > not work.  Linux with its I/O elevator may help to
> > > speed things up a bit, but the disk does nothing in
> > > this area.  NCQ doesn't slow things down either - it
> > > just does not work.
> > > 
> > > The same's for ST3250620NS "enterprise" drives.
> > > 
> > > By the way, Seagate announced Barracuda ES 2 series
> > > (in range 500..1200Gb if memory serves) - maybe with
> > > those, NCQ will work better?
> > 
> > No one would know without testing.
> > 
> > > Or maybe it's libata which does not implement NCQ
> > > "properly"?  (As I shown before, with almost all
> > > ol'good SCSI drives TCQ helps alot - up to 2x the
> > > difference and more - with multiple I/O threads)
> > 
> > Well, what the driver does is minimal.  It just passes through all the
> > commands to the harddrive.  After all, NCQ/TCQ gives the harddrive more
> > responsibility regarding request scheduling.
> 
> Actually, in many ways the result support a theory of SCSI TCQ Jens used
> when designing the block layer.  The original TCQ theory held that the
> drive could make much better head scheduling decisions than the
> Operating System, so you just used TCQ to pass all the outstanding I/O
> unfiltered down to the drive to let it schedule.  However, the I/O
> results always seemed to indicate that the effect of TCQ was negligible
> at around 4 outstanding commands, leading to the second theory that all
> TCQ was good for was saturating the transport, and making scheduling
> decisions was, indeed, better left to the OS (hence all our I/O
> schedulers).

Indeed, the above I still find to be true. The only real case where
larger depths make a real difference, is a pure random reads (or writes,
with write caching off) workload. And those situations are largely
synthetic, hence benchmarks tend to show NCQ being a lot more beneficial
since they construct workloads that consist 100% of random IO. Real life
is rarely so black and white.

Additionally, there are cases where drive queue depths hurt a lot. The
drive has no knowledge of fairness, or process-to-io mappings. So AS/CFQ
has to artificially limit queue depths competing IO processes doing
semi (or fully) sequential workloads, or throughput plummets.

So while NCQ has some benefits, I typically tend to prefer managing the
IO queue largely in software instead of punting to (often) buggy
firmware.

-- 
Jens Axboe

