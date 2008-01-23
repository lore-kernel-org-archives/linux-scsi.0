From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Integration of SCST in the mainstream Linux kernel
Date: Wed, 23 Jan 2008 15:22:00 +0100
Message-ID: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.229]:48212 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbYAWOWD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2008 09:22:03 -0500
Received: by wr-out-0506.google.com with SMTP id c49so1133333wra.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2008 06:22:02 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Vladislav Bolkhovitin <vst@vlnb.net>, James.Bottomley@hansenpartnership.com, FUJITA
Cc: linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

As you probably know there is a trend in enterprise computing towards
networked storage. This is illustrated by the emergence during the
past few years of standards like SRP (SCSI RDMA Protocol), iSCSI
(Internet SCSI) and iSER (iSCSI Extensions for RDMA). Two different
pieces of software are necessary to make networked storage possible:
initiator software and target software. As far as I know there exist
three different SCSI target implementations for Linux:
- The iSCSI Enterprise Target Daemon (IETD,
http://iscsitarget.sourceforge.net/);
- The Linux SCSI Target Framework (STGT, http://stgt.berlios.de/);
- The Generic SCSI Target Middle Level for Linux project (SCST,
http://scst.sourceforge.net/).
Since I was wondering which SCSI target software would be best suited
for an InfiniBand network, I started evaluating the STGT and SCST SCSI
target implementations. Apparently the performance difference between
STGT and SCST is small on 100 Mbit/s and 1 Gbit/s Ethernet networks,
but the SCST target software outperforms the STGT software on an
InfiniBand network. See also the following thread for the details:
http://sourceforge.net/mailarchive/forum.php?thread_name=e2e108260801170127w2937b2afg9bef324efa945e43%40mail.gmail.com&forum_name=scst-devel.

About the design of the SCST software: while one of the goals of the
STGT project was to keep the in-kernel code minimal, the SCST project
implements the whole SCSI target in kernel space. SCST is implemented
as a set of new kernel modules, only minimal changes to the existing
kernel are necessary before the SCST kernel modules can be used. This
is the same approach that will be followed in the very near future in
the OpenSolaris kernel (see also
http://opensolaris.org/os/project/comstar/). More information about
the design of SCST can be found here:
http://scst.sourceforge.net/doc/scst_pg.html.

My impression is that both the STGT and SCST projects are well
designed, well maintained and have a considerable user base. According
to the SCST maintainer (Vladislav Bolkhovitin), SCST is superior to
STGT with respect to features, performance, maturity, stability, and
number of existing target drivers. Unfortunately the SCST kernel code
lives outside the kernel tree, which makes SCST harder to use than
STGT.

As an SCST user, I would like to see the SCST kernel code integrated
in the mainstream kernel because of its excellent performance on an
InfiniBand network. Since the SCST project comprises about 14 KLOC,
reviewing the SCST code will take considerable time. Who will do this
reviewing work ? And with regard to the comments made by the
reviewers: Vladislav, do you have the time to carry out the
modifications requested by the reviewers ? I expect a.o. that
reviewers will ask to move SCST's configuration pseudofiles from
procfs to sysfs.

Bart Van Assche.
