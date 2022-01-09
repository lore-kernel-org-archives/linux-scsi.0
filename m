Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFC74C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Jan 2022 01:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234975AbiAIB27 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Jan 2022 20:28:59 -0500
Received: from smtp.infotech.no ([82.134.31.41]:37797 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229775AbiAIB27 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 8 Jan 2022 20:28:59 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id E465F2041AC;
        Sun,  9 Jan 2022 02:28:56 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wqhVfVrHiLE2; Sun,  9 Jan 2022 02:28:56 +0100 (CET)
Received: from xtwo70.bingwo.ca (unknown [10.16.20.11])
        by smtp.infotech.no (Postfix) with ESMTPA id 9AB0720413E;
        Sun,  9 Jan 2022 02:28:55 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v2 0/9] scsi_debug: collection of additions
Date:   Sat,  8 Jan 2022 20:28:44 -0500
Message-Id: <20220109012853.301953-1-dgilbert@interlog.com>
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
a newly added LU and a reset of an existing LU.

In patch 6 add a no_rwlock module option to bypass the
read-write locks around user data reads and writes.

Patch 7 adds sdeb_sgl_copy_sgl, sdeb_sgl_compare_sgl_idx,
sdeb_sgl_compare_sgl and sdeb_sgl_memset functions for
performing sgl to sgl copy and compare operations currently
unsupported by scatterlist.h . This patch was originally
put forward as an enhancement of scatterlist.h but failed
to gain traction. So that patch is redirected to this driver
with the "sdeb_" prefix on each function. Compiling the
driver after this patch will result in warnings that those
newly introduced static functions are not used. Since LLDs
receive and send data "up" the stack via sgl_s, using
sgl_s as the storage medium for this driver bypasses one
level of conversions (i.e. bypasses using a 'flat' array).

Patch 8 uses the new functions introduced in patch 7 to
change the internal store(s) used by this driver from big
vmalloc() allocations to sgl_s. The biggest improvement
is with the VERIFY(BYTCHK=1) performance that went from
about 20% slower than a copy operation to 50% faster (up
to a compare rate of 15 GB/s on my equipment). Before
this patch VERIFY(BYTCHK=1) needed a temporary,
potentially large, buffer for the incoming data-out
transfer. The COMPARE AND WRITE (CAW) command also benefits
from stores made of sgl_s. In addition CAW needs to know
the index of the first mismatched byte (if any).

Finally some issues have arisen in smartmontools with
SCSI log subpages. To aid in fixing this, the last patch
adds this driver's first log subpage (Environmental
Reporting).

This patchset is based on lk 5.16.0-rc8 rather than MKP's
repository (based on rc1). Fixes have been added to this
driver between rc1 and rc8 that would break a patchset
trying to target both. So the most recent rc was chosen.

Changes since v1 [sent to linux-scsi list on 20211230]
  - in the first patch replace READ_ONCE() and WRITE_ONCE()
    with smp_load_acquire() and smp_store_release() as
    suggested by Bart
  - add Tested-by: Shin'ichiro Kawasaki on patch 8
  - rework prot_verify_read() to remove heap allocation;
    if it failed previously the code return '-1' which
    Dan Carpenter termed as "sloppy"
  - rebase on rc8 (was rc7)


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
 drivers/scsi/scsi_debug.c | 1104 +++++++++++++++++++++++++++----------
 2 files changed, 823 insertions(+), 284 deletions(-)

-- 
2.25.1

