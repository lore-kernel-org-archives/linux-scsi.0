From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Some NCQ numbers...
Date: Wed, 04 Jul 2007 09:40:34 -0500
Message-ID: <1183560034.3418.15.camel@localhost.localdomain>
References: <468392CE.6010206@msgid.tls.msk.ru> <468A06A0.1020802@gmail.com>
	 <468AB1A7.9010201@msgid.tls.msk.ru>  <468AF5BB.10005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:40267 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758850AbXGDOkg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Jul 2007 10:40:36 -0400
In-Reply-To: <468AF5BB.10005@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2007-07-04 at 10:19 +0900, Tejun Heo wrote:
> Michael Tokarev wrote:
> > Well.  It looks like the results does not depend on the
> > elevator.  Originally I tried with deadline, and just
> > re-ran the test with noop (hence the long delay with
> > the answer) - changing linux elevator changes almost
> > nothing in the results - modulo some random "fluctuations".
> 
> I see.  Thanks for testing.
> 
> > In any case, NCQ - at least in this drive - just does
> > not work.  Linux with its I/O elevator may help to
> > speed things up a bit, but the disk does nothing in
> > this area.  NCQ doesn't slow things down either - it
> > just does not work.
> > 
> > The same's for ST3250620NS "enterprise" drives.
> > 
> > By the way, Seagate announced Barracuda ES 2 series
> > (in range 500..1200Gb if memory serves) - maybe with
> > those, NCQ will work better?
> 
> No one would know without testing.
> 
> > Or maybe it's libata which does not implement NCQ
> > "properly"?  (As I shown before, with almost all
> > ol'good SCSI drives TCQ helps alot - up to 2x the
> > difference and more - with multiple I/O threads)
> 
> Well, what the driver does is minimal.  It just passes through all the
> commands to the harddrive.  After all, NCQ/TCQ gives the harddrive more
> responsibility regarding request scheduling.

Actually, in many ways the result support a theory of SCSI TCQ Jens used
when designing the block layer.  The original TCQ theory held that the
drive could make much better head scheduling decisions than the
Operating System, so you just used TCQ to pass all the outstanding I/O
unfiltered down to the drive to let it schedule.  However, the I/O
results always seemed to indicate that the effect of TCQ was negligible
at around 4 outstanding commands, leading to the second theory that all
TCQ was good for was saturating the transport, and making scheduling
decisions was, indeed, better left to the OS (hence all our I/O
schedulers).

The key difference between NCQ and TCQ is that NCQ allows a non
interlock setup and completion, but there can't be overlapping (or
interrupted) data transfers.  TCQ and Disconnect (for SPI although there
are equivalents for most other transports) allow any style of overlap
you can construct, so NCQ was really designed more to allow the drive to
make the head scheduling decisions.

Where SCSI TCQ seems to win is that most devices pull the incoming TCQ
commands into a (usually quite large) pre-execute cache, which gives
them streaming command execution (usually they're executing command n-2
or 3 while accepting the data for command n), so they're using the cache
actually to smooth out internal latencies.

One final question: have you tried SAS devices for comparison?  The
figures that give TCQ a 2x performance boost were with SPI and FC ...
I'm not aware that anyone has actually done a SAS test.

James


