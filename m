Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A90D5C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Dec 2021 02:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242543AbhLaCQK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Dec 2021 21:16:10 -0500
Received: from smtp.infotech.no ([82.134.31.41]:46079 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242528AbhLaCQJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Dec 2021 21:16:09 -0500
X-Greylist: delayed 450 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Dec 2021 21:16:09 EST
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 61208204172;
        Fri, 31 Dec 2021 03:08:39 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id vtsk85F-47yG; Fri, 31 Dec 2021 03:08:32 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-58-208-241.dyn.295.ca [45.58.208.241])
        by smtp.infotech.no (Postfix) with ESMTPA id C080E20414C;
        Fri, 31 Dec 2021 03:08:31 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Subject: [PATCH 0/9] scsi_debug: collection of additions
Date:   Thu, 30 Dec 2021 21:08:20 -0500
Message-Id: <20211231020829.29147-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first patch is to address possible modprobe rmmod races.

The second patch adds READ_ONCE and WRITE_ONCE on several
high frequency variables.

See the headers of patches 3 and 4.

In patch 5 use different asc/ascq codes to distiguish between
and newly added LU and a reset on an existing LU.

In patch 6 add a no_rwlock module option to bypass the
read-write locks around user data reads and writes.

Patch 7 adds sdeb_sgl_copy_sgl, sdeb_sgl_compare_sgl_idx,
sdeb_sgl_compare_sgl and sdeb_sgl_memset functions for
performing sgl t0 sgl copy and compare operations currently
unsupported by scatterlist.h . This patch was originally
put forward as an enhancement of scatterlist.h but failed
to gain traction. So that patch is redirected to this driver
with the "sdeb_" added to each function. Compiling the
driver after this patch will result in warnings that those
newly introduced static functions are not used. Since LLDs
receive and send data "up" the stack via sgl_s, using
sgl_s as the storage medium for this driver bypasses one
level of conversions.

Patch 8 uses the new functions introduced in patch 7 to
change the internal store(s) used the this driver into
sgl_s rather than big vmalloc() allocations. The biggest
improvement is with the VERIFY(BYTCHK=1) performance
that went from about 20% slower than a copy operation
to 50% faster (up to 15 GB/s on my equipment). Before this
patch VERIFY(BYTCHK=1) needed a temporary, potentially
large, buffer for the incoming data-out transfer. The
COMPARE AND WRITE command also benefits from stores made
of sgl_s, and in addition it needs to know the index of
the first mismatched byte (if any).

Finally some issues have arisen in smartmontools with
SCSI log subpages. To aid is fixing this, the last patch
adds the driver's first log subpage (Environmental
reporting).

This patchset is based on lk 5.16.0-rc7 rather than MKP's
repository (based on rc1). Fixes have been added to this
driver between rc1 and rc7 that would break a single
patchset. So the most recent rc was chosen.


Douglas Gilbert (9):
  scsi_debug: address races following module load
  scsi_debug: strengthen defer_t accesses
  scsi_debug: use task set full more
  scsi_debug: refine sdebug_blk_mq_poll
  scsi_debug: divide power on reset unit attention
  scsi_debug: add no_rwlock parameter
  scsi_debug: add sdeb_sgl_copy_sgl and friends
  scsi_debug: change store from vmalloc to sgl
  scsi_debug: add environmental reporting log subpage

 drivers/scsi/Kconfig      |    3 +-
 drivers/scsi/scsi_debug.c | 1078 +++++++++++++++++++++++++++----------
 2 files changed, 800 insertions(+), 281 deletions(-)

-- 
2.25.1

