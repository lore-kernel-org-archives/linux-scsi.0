Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4EECC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 03:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232792AbiBADt1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 22:49:27 -0500
Received: from smtp.infotech.no ([82.134.31.41]:32834 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231993AbiBADt1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Jan 2022 22:49:27 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 1107D2041C0;
        Tue,  1 Feb 2022 04:49:25 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uVyeaFfQRPf0; Tue,  1 Feb 2022 04:49:18 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id 35560204169;
        Tue,  1 Feb 2022 04:49:16 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v7 0/4] scatterlist: add new capabilities
Date:   Mon, 31 Jan 2022 22:49:11 -0500
Message-Id: <20220201034915.183117-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Scatter-gather lists (sgl_s) are frequently used as data carriers in
the block layer. For example the SCSI and NVMe subsystems interchange
data with the block layer using sgl_s. The sgl API is declared in
<linux/scatterlist.h>

This patchset extends the scatterlist API by adding functions to:
  - copy a sgl to another sgl, stop after copying n_bytes or
    when either sgl is exhausted [2/4]
  - compare one sgl against another sgl for equality. Stop when
    either sgl is exhausted, or a miscompare is detected or when
    n_bytes are compared. Supply a variant function that gives the
    position of the miscompare [3/4]
  - generalize the existing sg_zero_buffer() function with a
    new sgl_memset function [4/4]

The first patch [1/4] removes a 4 GiB size limitation from the
sgl_alloc_order() function.

The author changed the backing store (i.e. ramdisks) behind the
scsi_debug driver from using vmalloc() to using the scatterlist
API with the above additions. The removal of the 4 GiB size limit
allows scsi_debug to mimic a disk of larger size. Being able to
copy one sgl to another simplifies implementing SCSI READ and WRITE
commands. The sgl_equal_sgl() function both simplifies the SCSI
VERIFY(BytChk=1) and COMPARE AND WRITE commands and is a performance
win as there is no need for a temporary buffer to hold the data-out
transfer associated with these comparison commands.

The target subsystem and NVMe may find these additions to the
scatterlist API useful.

Changes since v6 [posted 20210118]:
  - re-add sgl_alloc_order() fix to remove its (undocumented) 4 GiB
    limit
  - rebase on lk 5.17.0-rc1

Changes since v5 [posted 20201228]:
  - incorporate review requests from Jason Gunthorpe
  - replace integer overflow detection code in sgl_alloc_order()
    with a pre-condition statement
  - rebase on lk 5.11.0-rc4

Changes since v4 [posted 20201105]:
  - rebase on lk 5.10.0-rc2

Changes since v3 [posted 20201019]:
  - re-instate check on integer overflow of nent calculation in
    sgl_alloc_order(). Do it in such a way as to not limit the
    overall sgl size to 4  GiB
  - introduce sgl_compare_sgl_idx() helper function that, if
    requested and if a miscompare is detected, will yield the byte
    index of the first miscompare.
  - add Reviewed-by tags from Bodo Stroesser
  - rebase on lk 5.10.0-rc2 [was on lk 5.9.0]

Changes since v2 [posted 20201018]:
  - remove unneeded lines from sgl_memset() definition.
  - change sg_zero_buffer() to call sgl_memset() as the former
    is a subset.

Changes since v1 [posted 20201016]:
  - Bodo Stroesser pointed out a problem with the nesting of
    kmap_atomic() [called via sg_miter_next()] and kunmap_atomic()
    calls [called via sg_miter_stop()] and proposed a solution that
    simplifies the previous code.

  - the new implementation of the three functions has shorter periods
    when pre-emption is disabled (but has more them). This should
    make operations on large sgl_s more pre-emption "friendly" with
    a relatively small performance hit.

  - sgl_memset return type changed from void to size_t and is the
    number of bytes actually (over)written. That number is needed
    anyway internally so may as well return it as it may be useful to
    the caller.

This patchset is against lk 5.17.0-rc1


*** BLURB HERE ***

Douglas Gilbert (4):
  sgl_alloc_order: remove 4 GiB limit
  scatterlist: add sgl_copy_sgl() function
  scatterlist: add sgl_equal_sgl() function
  scatterlist: add sgl_memset()

 include/linux/scatterlist.h |  33 ++++-
 lib/scatterlist.c           | 256 +++++++++++++++++++++++++++++++-----
 2 files changed, 256 insertions(+), 33 deletions(-)

-- 
2.25.1

