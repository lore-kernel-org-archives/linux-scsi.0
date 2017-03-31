From: David Buckley <dbuckley@oreilly.com>
Subject: problem with discard granularity in sd
Date: Fri, 31 Mar 2017 09:52:38 -0700
Message-ID: <CA+Xd3XHp381w87Fr5_HGU5gBpWMSRSwD+pRacGkHu7Rp7CYUfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f180.google.com ([209.85.216.180]:34264 "EHLO
        mail-qt0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933302AbdCaQxU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2017 12:53:20 -0400
Received: by mail-qt0-f180.google.com with SMTP id n21so70464761qta.1
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2017 09:53:19 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,

Hopefully this is the right place for this, and apologies for the
lengthy mail.  I'm struggling with an issue with SCSI UNMAP/discard in
newer kernels, and I'm hoping to find a resolution or at least to
better understand why this has changed.

Some background info:
Our Linux boxes are primarily VMs running on VMware backed by NetApp
storage.  We have a fair number of systems that directly mount LUNs
(due to i/o requirements, snapshot scheduling, dedupe issues, etc.).
On newer LUNs, the 'space_alloc' option is enabled, which causes the
LUN to report unmap support and free unused blocks on the underlying
storage.

The problem:
I noticed multiple LUNs with space_alloc enabled reported 100%
utilization on the netapp but much less from the Linux. I verified
they were mounted with discard option and also ran fstrim, which
reported success but did not change the utilization reported by the
netapp.  I eventually was able to isolate kernel version as the only
factor in whether discard worked.  Further testing showed 3.10.x
handled discard correctly, but 4.4.x would never free blocks.  This
was verified on a single machine with the only change being the
kernel.

The only notable difference I could find was in
/sys/block/sdX/discard* values - on 3.10.x the discard granularity was
reported as 4096, while on 4.4.x it was 512 (logical block size is
512, physical is 4096 on the LUNs).  Eventually that led me to these
patches for sd.c:
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/drivers/scsi/sd.c?id=397737223c59e89dca7305feb6528caef8fbef84
and https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git/commit/drivers/scsi/sd.c?id=f4327a95dd080ed6aecb185478a88ce1ee4fa3c4.
They result in discard granularity being forced to logical block size
if the disk reports LBPRZ is enabled (which the netapp luns do).  It
seems that this change is responsible for the difference in discard
granularity, and my assumption is that because wafl is actually a 4k
block filesystem the netapp requires 4k granularity and ignores the
512b discard requests.

It's not clear to me whether this is a bug in sd or an issue in the
way the LUNs are presented from the netapp side (I've opened a case
with them as well and am waiting to hear back).  However,
minimum_io_size is 4096, so it seems a bit odd that
discard_granularity would be smaller.  And earlier kernel versions
work as expected, which seems to indicate the problem is in sd.

As far as fixes or workarounds, it seems that there are three potential options:

1) The netapp could change the reported logical block size to match
the physical block size
2) The netapp could report LBPRZ=0
3) The sd code could be updated to use max(logical_block_size,
physical_block_size) or  max(logical_block_size, minimum_io_size) or
otherwise changed to ensure discard_granularity is set to a supported
value

I'm not sure of the implications of either the netapp changes, though
reporting 4k logical blocks seems potential as this is supported in
newer OS at least.  The sd change potentially would at least partially
undo the patches referenced above.  But it would seem that (assuming
an aligned filesystem with 4k blocks and minimum_io_size=4096) there
is no possibility of a partial block discard or advantage to sending
the discard requests in 512 blocks?

Any help is greatly appreciated.

Thanks,
-David
