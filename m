From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 0/8] dm: request-based dm-multipath
Date: Fri, 03 Oct 2008 11:08:25 -0400 (EDT)
Message-ID: <20081003.110825.74754936.k-ueda@ct.jp.nec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:34691 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752400AbYJCPKn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 3 Oct 2008 11:10:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: agk@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com, mbroz@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com

Hi Alasdair,

This patch-set is the updated version of request-based dm-multipath.
The changes from the previous version (*) are to follow up the change
of the interface to export lld's busy state (PATCH 5).

(*) http://lkml.org/lkml/2008/9/12/100

All necessary interfaces to support request stacking drivers are now
in the for-2.6.28 branch of the Jens' linux-2.6-block git repository.
This patch-set depends on those interfaces.

This patch-set is created on top of 2.6.27-rc8 + your patches shown
between "NEXT_PATCHES_START" and "NEXT_PATCHES_END" of the series file:
  ftp://sources.redhat.com/pub/dm/patches/2.6-unstable/editing-quilt/patches/series.html

Please review and apply.


Summary of the patches:
  1/8: dm core: remove unused DM_WQ_FLUSH_ALL
  2/8: dm core: tidy local_init
  3/8: dm core: add kmem_cache for request-based dm
  4/8: dm core: add target interfaces for request-based dm
  5/8: dm core: add core functions for request-based dm
  6/8: dm core: enable request-based dm
  7/8: dm core: reject I/O violating new queue limits
  8/8: dm-mpath: convert to request-based
  (PATCH 1 is also included in the Milan's barrier support patch-set)

 drivers/md/dm-ioctl.c         |   13
 drivers/md/dm-mpath.c         |  192 +++++---
 drivers/md/dm-table.c         |   82 +++
 drivers/md/dm.c               |  956 +++++++++++++++++++++++++++++++++++++++--- drivers/md/dm.h               |   17
 include/linux/device-mapper.h |   24 +
 6 files changed, 1161 insertions(+), 123 deletions(-)

Thanks,
Kiyoshi Ueda
