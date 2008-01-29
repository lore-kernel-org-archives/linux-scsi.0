From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Tue, 29 Jan 2008 15:42:11 -0500
Message-ID: <1201639331.3069.58.camel@localhost.localdomain>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53585 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758678AbYA2UyZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2008 15:54:25 -0500
In-Reply-To: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On Wed, 2008-01-23 at 15:22 +0100, Bart Van Assche wrote:
> As you probably know there is a trend in enterprise computing towards
> networked storage. This is illustrated by the emergence during the
> past few years of standards like SRP (SCSI RDMA Protocol), iSCSI
> (Internet SCSI) and iSER (iSCSI Extensions for RDMA). Two different
> pieces of software are necessary to make networked storage possible:
> initiator software and target software. As far as I know there exist
> three different SCSI target implementations for Linux:
> - The iSCSI Enterprise Target Daemon (IETD,
> http://iscsitarget.sourceforge.net/);
> - The Linux SCSI Target Framework (STGT, http://stgt.berlios.de/);
> - The Generic SCSI Target Middle Level for Linux project (SCST,
> http://scst.sourceforge.net/).
> Since I was wondering which SCSI target software would be best suited
> for an InfiniBand network, I started evaluating the STGT and SCST SCSI
> target implementations. Apparently the performance difference between
> STGT and SCST is small on 100 Mbit/s and 1 Gbit/s Ethernet networks,
> but the SCST target software outperforms the STGT software on an
> InfiniBand network. See also the following thread for the details:
> http://sourceforge.net/mailarchive/forum.php?thread_name=e2e108260801170127w2937b2afg9bef324efa945e43%40mail.gmail.com&forum_name=scst-devel.

That doesn't seem to pull up a thread.  However, I assume it's these
figures:

.............................................................................................
.                           .   STGT read     SCST read    .    STGT read      SCST read    .
.                           .  performance   performance   . performance    performance   .
.                           .  (0.5K, MB/s)  (0.5K, MB/s)  .   (1 MB, MB/s)   (1 MB, MB/s)  .
.............................................................................................
. Ethernet (1 Gb/s network) .      77             78       .        77            89       .
. IPoIB    (8 Gb/s network) .     163            185       .       201           239       .
. iSER     (8 Gb/s network) .     250            N/A       .       360           N/A       .
. SRP      (8 Gb/s network) .     N/A            421       .       N/A           683       .
.............................................................................................

On the comparable figures, which only seem to be IPoIB they're showing a
13-18% variance, aren't they?  Which isn't an incredible difference.

> About the design of the SCST software: while one of the goals of the
> STGT project was to keep the in-kernel code minimal, the SCST project
> implements the whole SCSI target in kernel space. SCST is implemented
> as a set of new kernel modules, only minimal changes to the existing
> kernel are necessary before the SCST kernel modules can be used. This
> is the same approach that will be followed in the very near future in
> the OpenSolaris kernel (see also
> http://opensolaris.org/os/project/comstar/). More information about
> the design of SCST can be found here:
> http://scst.sourceforge.net/doc/scst_pg.html.
> 
> My impression is that both the STGT and SCST projects are well
> designed, well maintained and have a considerable user base. According
> to the SCST maintainer (Vladislav Bolkhovitin), SCST is superior to
> STGT with respect to features, performance, maturity, stability, and
> number of existing target drivers. Unfortunately the SCST kernel code
> lives outside the kernel tree, which makes SCST harder to use than
> STGT.
> 
> As an SCST user, I would like to see the SCST kernel code integrated
> in the mainstream kernel because of its excellent performance on an
> InfiniBand network. Since the SCST project comprises about 14 KLOC,
> reviewing the SCST code will take considerable time. Who will do this
> reviewing work ? And with regard to the comments made by the
> reviewers: Vladislav, do you have the time to carry out the
> modifications requested by the reviewers ? I expect a.o. that
> reviewers will ask to move SCST's configuration pseudofiles from
> procfs to sysfs.

The two target architectures perform essentially identical functions, so
there's only really room for one in the kernel.  Right at the moment,
it's STGT.  Problems in STGT come from the user<->kernel boundary which
can be mitigated in a variety of ways.  The fact that the figures are
pretty much comparable on non IB networks shows this.

I really need a whole lot more evidence than at worst a 20% performance
difference on IB to pull one implementation out and replace it with
another.  Particularly as there's no real evidence that STGT can't be
tweaked to recover the 20% even on IB.

James


