From: Tejun Heo <tj@kernel.org>
Subject: [PATCHSET] block: fix merge of requests with different failfast settings
Date: Fri,  3 Jul 2009 17:48:14 +0900
Message-ID: <1246610898-22350-1-git-send-email-tj@kernel.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:44646 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbZGCIs2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Jul 2009 04:48:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <jens.axboe@oracle.com>, Linux Kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Nie

Hello,

Block layer didn't consider failfast status while merging requests and
it led to premature failure of normal (non-failfast) IOs.  Niel
Lambrechts could trigger the problem semi-reliably on ext4 when
resuming from STR.  ext4 uses readahead when reading inodes and
combined with the deterministic extra SATA PHY exception cycle during
resume on the specific configuration, non-readahead inode read would
fail causing ext4 errors.  Please read the following thread for
details.

  http://lkml.org/lkml/2009/5/23/21

This patchset contains the following four patches to fix the problem.

 0001-block-don-t-merge-requests-of-different-failfast-se.patch
 0002-block-use-the-same-failfast-bits-for-bio-and-reques.patch
 0003-block-implement-mixed-merge-of-different-failfast-r.patch
 0004-scsi-block-update-SCSI-to-handle-mixed-merge-failur.patch

0001 disallows merge between requests with different failfast
settings.  This one is the quick fix and should go into 2.6.31 and
later to -stable as the bug is pretty serious and may lead to data
loss.

0002 preps for later changes.

0003-0004 implements and applies mixed merge.  Requests of different
failfast settings are merged as before but failure handling is updated
such that parts which shouldn't fail without retrial are properly
retried.

I spent quite some time thinking about and testing it but I'd really
like more pairs of eyes on this patchset as dangerous bugs can go
unnoticed for quite a while in this area (anyone knows when the
failfast bug was introduced?).

Jens, I think the best way to merge this is to first push 0001 to
Linus's tree and then pull it into for-next and then apply the rest on
top of them.

This patchset contains the following changes.

 block/blk-core.c        |  118 +++++++++++++++++++++++++++++++++++++++++++-----
 block/blk-merge.c       |   43 +++++++++++++++++
 block/blk.h             |    1 
 drivers/scsi/scsi_lib.c |    6 +-
 include/linux/bio.h     |   43 +++++++++--------
 include/linux/blkdev.h  |   27 ++++++++--
 6 files changed, 199 insertions(+), 39 deletions(-)

Thanks.

--
tejun
