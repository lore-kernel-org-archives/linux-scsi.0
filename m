Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCC5C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Oct 2022 01:12:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbiJXBMB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 Oct 2022 21:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbiJXBMA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Oct 2022 21:12:00 -0400
X-Greylist: delayed 545 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 23 Oct 2022 18:11:57 PDT
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E7AE162A52
        for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2022 18:11:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 23A7E2041CF;
        Mon, 24 Oct 2022 03:02:53 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id D+Nj12dIbLLf; Mon, 24 Oct 2022 03:02:47 +0200 (CEST)
Received: from treten.bingwo.ca (host-45-78-203-98.dyn.295.ca [45.78.203.98])
        by smtp.infotech.no (Postfix) with ESMTPA id 4A88120413D;
        Mon, 24 Oct 2022 03:02:46 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH 0/5] scatterlist: add operations for scsi_debug
Date:   Sun, 23 Oct 2022 21:02:39 -0400
Message-Id: <20221024010244.9522-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi_debug driver is essentially a ramdisk dressed up as a SCSI host
with one or more SCSI devices attached. Like all low level SCSI drivers,
the scsi_debug driver receives and provides data to the SCSI mid-level
(and the block layer) using scatterlists whose interface is found in
include/linux/scatterlist.h .

After trying kmalloc() then vmalloc() based storage for the scsi_debug
driver, it was found that certain SCSI commands can be optimized if
instead one or more scatterlists is used as its backing store. The
specific SCSI command that benefits is VERIFY(BYTCHK=1) and the
equivalent NVMe command is COMPARE. These commands have data-out
buffers provided by an application that are compared by the storage
device with the LBA and count (of block) given in the command. In this
case the sgl_equal_sgl() function can be used instead of setting up
a temporary buffer.

The implementation of the more common SCSI READ and WRITE commands are
simplified by using the sgl_copy_sgl() function.

The first patch in this series removes an undocumented 4 GB limit in
the existing sgl_alloc_order() function.

In the final patch of this series, the scsi_debug driver uses the
new facilities in scatterlist to replace its vmalloc() backing store.

Douglas Gilbert (5):
  sgl_alloc_order: remove 4 GiB limit
  scatterlist: add sgl_copy_sgl() function
  scatterlist: add sgl_equal_sgl() function
  scatterlist: add sgl_memset()
  scsi_debug: change store from vmalloc to sgl

 drivers/scsi/Kconfig        |   3 +-
 drivers/scsi/scsi_debug.c   | 478 +++++++++++++++++++++++++-----------
 include/linux/scatterlist.h |  33 ++-
 lib/scatterlist.c           | 253 ++++++++++++++++---
 4 files changed, 596 insertions(+), 171 deletions(-)

-- 
2.37.3

