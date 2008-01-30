From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Wed, 30 Jan 2008 09:29:27 +0100
Message-ID: <e2e108260801300029r1a949353k73b30f1f28db0bc9@mail.gmail.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:12953 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567AbYA3I3b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Jan 2008 03:29:31 -0500
Received: by py-out-1112.google.com with SMTP id u52so245959pyb.10
        for <linux-scsi@vger.kernel.org>; Wed, 30 Jan 2008 00:29:27 -0800 (PST)
In-Reply-To: <1201639331.3069.58.camel@localhost.localdomain>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Jan 29, 2008 9:42 PM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> > As an SCST user, I would like to see the SCST kernel code integrated
> > in the mainstream kernel because of its excellent performance on an
> > InfiniBand network. Since the SCST project comprises about 14 KLOC,
> > reviewing the SCST code will take considerable time. Who will do this
> > reviewing work ? And with regard to the comments made by the
> > reviewers: Vladislav, do you have the time to carry out the
> > modifications requested by the reviewers ? I expect a.o. that
> > reviewers will ask to move SCST's configuration pseudofiles from
> > procfs to sysfs.
>
> The two target architectures perform essentially identical functions, so
> there's only really room for one in the kernel.  Right at the moment,
> it's STGT.  Problems in STGT come from the user<->kernel boundary which
> can be mitigated in a variety of ways.  The fact that the figures are
> pretty much comparable on non IB networks shows this.

Are you saying that users who need an efficient iSCSI implementation
should switch to OpenSolaris ? The OpenSolaris COMSTAR project involves
the migration of the existing OpenSolaris iSCSI target daemon from
userspace to their kernel. The OpenSolaris developers are
spending time on this because they expect a significant performance
improvement.

> I really need a whole lot more evidence than at worst a 20% performance
> difference on IB to pull one implementation out and replace it with
> another.  Particularly as there's no real evidence that STGT can't be
> tweaked to recover the 20% even on IB.

My measurements on a 1 GB/s InfiniBand network have shown that the current
SCST implementation is able to read data via direct I/O at a rate of 811 GB/s
(via SRP) and that the current STGT implementation is able to transfer data at a
rate of 589 MB/s (via iSER). That's a performance difference of 38%.

And even more important, the I/O latency of SCST is significantly
lower than that
of STGT. This is very important for database workloads -- the I/O pattern caused
by database software is close to random I/O, and database software needs low
latency I/O in order to run efficiently.

In the thread with the title "Performance of SCST versus STGT" on the
SCST-devel /
STGT-devel mailing lists not only the raw performance numbers were discussed but
also which further performance improvements are possible. It became clear that
the SCST performance can be improved further by implementing a well known
optimization (zero-copy I/O). Fujita Tomonori explained in the same
thread that it is
possible to improve the performance of STGT further, but that this would require
a lot of effort (implementing asynchronous I/O in the kernel and also
implementing
a new caching mechanism using pre-registered buffers).

See also:
http://sourceforge.net/mailarchive/forum.php?forum_name=scst-devel&viewmonth=200801&viewday=17

Bart Van Assche.
