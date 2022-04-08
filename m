Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2D6C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 04:06:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234269AbiDHEI6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 00:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbiDHEIk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 00:08:40 -0400
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0964812FF90
        for <linux-scsi@vger.kernel.org>; Thu,  7 Apr 2022 21:06:30 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 7025920418D;
        Fri,  8 Apr 2022 05:57:01 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8k1LYWa9NdVU; Fri,  8 Apr 2022 05:56:54 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-195-155.dyn.295.ca [45.78.195.155])
        by smtp.infotech.no (Postfix) with ESMTPA id B21D9204171;
        Fri,  8 Apr 2022 05:56:53 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, hch@lst.de
Subject: [PATCH 0/6] scsi: fix scsi_cmd::cmd_len
Date:   Thu,  7 Apr 2022 23:56:45 -0400
Message-Id: <20220408035651.6472-1-dgilbert@interlog.com>
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
greater than 32 bytes. Two access function are added, one for read
access, the other for create/write access to the CDB held inside
a scsi_cmnd object.

A scsi_cmnd object is always paired with a struct request object
that immediately precedes it. To note this pairing the new comments
refer to a scsi_cmnd "sub-object". Prior to this patch the
constructor/destructor naming was obscure:
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
CDB lengths > 32 bytes; in that case they should use
scsi_cmnd_get_cdb().

This patchset is against lk 5.18.0-rc1 and also applies cleanly
to MKP's 5.19/scsi-queue branch.

Douglas Gilbert (6):
  scsi_cmnd: reinstate support for cmd_len > 32
  sd, sd_zbc: use scsi_cmnd cdb access functions
  sg: reinstate cmd_len > 32
  bsg: allow cmd_len > 32
  scsi_debug: reinstate cmd_len > 32
  st,sr: use scsi_cmnd cdb access functions and dtor

 drivers/scsi/scsi_bsg.c     |  22 +-
 drivers/scsi/scsi_debug.c   | 410 +++++++++++++++++++-----------------
 drivers/scsi/scsi_debugfs.c |   2 +-
 drivers/scsi/scsi_error.c   |  76 ++++---
 drivers/scsi/scsi_ioctl.c   |  21 +-
 drivers/scsi/scsi_lib.c     |  75 ++++++-
 drivers/scsi/scsi_logging.c |  11 +-
 drivers/scsi/sd.c           | 176 +++++++++-------
 drivers/scsi/sd_zbc.c       |  12 +-
 drivers/scsi/sg.c           |  21 +-
 drivers/scsi/sr.c           |  24 ++-
 drivers/scsi/st.c           |  12 +-
 include/scsi/scsi_cmnd.h    |  71 ++++++-
 include/scsi/scsi_eh.h      |   6 +-
 14 files changed, 565 insertions(+), 374 deletions(-)

-- 
2.25.1

