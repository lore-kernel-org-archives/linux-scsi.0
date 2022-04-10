Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D58C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 10 Apr 2022 17:37:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239997AbiDJRjQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 Apr 2022 13:39:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237246AbiDJRjP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2022 13:39:15 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16EC628E13
        for <linux-scsi@vger.kernel.org>; Sun, 10 Apr 2022 10:37:01 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 933BC2041CB;
        Sun, 10 Apr 2022 19:36:58 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 12FZvKJlLKcM; Sun, 10 Apr 2022 19:36:56 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id A1081204179;
        Sun, 10 Apr 2022 19:36:55 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@lst.de
Subject: [PATCH v2 0/6] scsi: fix scsi_cmd::cmd_len
Date:   Sun, 10 Apr 2022 13:36:46 -0400
Message-Id: <20220410173652.313016-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

As described in the first patch of this set, commit ce70fd9a551af
reduced the maximum size of any SCSI commands (CDB length) to
32 bytes. It was previously larger in struct scsi_request which
has now (lk 5.18.0-rc1) been removed.

Use a slightly different scheme than before to support CDB lengths
greater than 16 bytes. Three access function are added, one for read
access, one for writable access that doesn't increase the cdb length,
and the third for create/write access to the CDB held inside a
scsi_cmnd object. This reduces the size of struct scsi_cmnd by 16
bytes.

A scsi_cmnd object is always paired with a struct request object
that immediately precedes it. To note this pairing the new comments
refer to a scsi_cmnd "sub-object". Prior to this patch the
constructor/destructor naming was confusing:
   - scsi_alloc_request() to create a pair
   - blk_mq_free_request() to destruct a pair

Add a new destructor function:
   scsi_free_cmnd(struct scsi_cmnd *scmd)

to make this a bit clearer. Also scsi_free_cmnd() will free up a
pointer to a long cdb buffer on the heap, if one is present.

These changes have been applied to SCSI mid-level and the upper
level drivers (ULDs, e.g. sd). Only one low level driver (LLD)
has been updated: scsi_debug. The rest of the LLDs can continue
to use scsi_cmnd::cmnd directly _unless_ they wish to support
CDB lengths > 16 bytes; in that case they should use
scsi_cmnd_get_cdb().

This patchset is against lk 5.18.0-rc1 and also applies cleanly
to MKP's 5.19/scsi-queue branch.

Changes since the first revision:
  - introduce a new SCSI_MAX_RUN_TIME_8BIT_CDB_LEN define for the
    case where hp->cmd_len is an 8 bit quantity. This addresses a
    kernel test robot report on patch 1 sent 20220408
  - take up Bart's suggestion to reduce
    SCSI_MAX_COMPILE_TIME_CDB_LEN to 16, hence shaving 16 bytes
    off the size of struct scsi_cmnd
  - introduce scsi_cmnd_get_changeable_cdb() access function for
    the case when the code wants to change some bytes in an
    existing cdb but not increase its size
  - add a broad description of how struct scsi_cmnd fits into
    overall architecture, tweak some other comments
  - further work on the sr and stex ULDs
 

Douglas Gilbert (6):
  scsi_cmnd: reinstate support for cmd_len > 32
  sd, sd_zbc: use scsi_cmnd cdb access functions
  sg: reinstate cmd_len > 32
  bsg: allow cmd_len > 32
  scsi_debug: reinstate cmd_len > 32
  st,sr,stex: use scsi_cmnd cdb access functions

 drivers/scsi/scsi_bsg.c     |  22 +-
 drivers/scsi/scsi_debug.c   | 410 +++++++++++++++++++-----------------
 drivers/scsi/scsi_debugfs.c |   3 +-
 drivers/scsi/scsi_error.c   |  76 ++++---
 drivers/scsi/scsi_ioctl.c   |  21 +-
 drivers/scsi/scsi_lib.c     |  75 ++++++-
 drivers/scsi/scsi_logging.c |  11 +-
 drivers/scsi/sd.c           | 176 +++++++++-------
 drivers/scsi/sd_zbc.c       |  12 +-
 drivers/scsi/sg.c           |  23 +-
 drivers/scsi/sr.c           |  40 ++--
 drivers/scsi/st.c           |  12 +-
 drivers/scsi/stex.c         |  22 +-
 include/scsi/scsi_cmnd.h    | 116 ++++++++--
 include/scsi/scsi_eh.h      |   6 +-
 15 files changed, 623 insertions(+), 402 deletions(-)

-- 
2.25.1

