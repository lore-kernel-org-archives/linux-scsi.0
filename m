Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CB0DC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Nov 2022 19:49:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbiKLTty (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Nov 2022 14:49:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231919AbiKLTtw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Nov 2022 14:49:52 -0500
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C2ACCDFCA
        for <linux-scsi@vger.kernel.org>; Sat, 12 Nov 2022 11:49:50 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id F127820417C;
        Sat, 12 Nov 2022 20:49:49 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id iIL9zcF5bU6F; Sat, 12 Nov 2022 20:49:43 +0100 (CET)
Received: from treten.bingwo.ca (host-45-78-203-98.dyn.295.ca [45.78.203.98])
        by smtp.infotech.no (Postfix) with ESMTPA id 1A9D420414C;
        Sat, 12 Nov 2022 20:49:41 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org, bostroesser@gmail.com, jgg@ziepe.ca
Subject: [PATCH v2 0/5] scatterlist: add operations for scsi_debug
Date:   Sat, 12 Nov 2022 14:49:34 -0500
Message-Id: <20221112194939.4823-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.37.2
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
specific SCSI command that benefits the most is VERIFY(BYTCHK=1) whose
NVMe equivalent is COMPARE. These commands have data-out buffers
provided by an application that are compared by the storage device
with the LBA and count (of blocks) given in the command. In this
case the sgl_equal_sgl() function can be used instead of setting up
a temporary buffer.

The implementation of the more common SCSI READ and WRITE commands are
simplified by using the sgl_copy_sgl() function.

The first patch in this series removes an undocumented 4 GB limit in
the existing sgl_alloc_order() function.

In the final patch of this series, the scsi_debug driver uses the
new facilities in scatterlist to replace its vmalloc() backing store
with a sgl_alloc_order() based store. Also several loops based on
memcpy() and memcmp() are replaced by the new scatterlist copy
and 'equal' functions.

Changes since v1 (sent to linux-scsi list on 20221023)
  - in sgl_alloc_order() add check that order argument is less
    then MAX_ORDER; protects following call to round_up()
  - in sdeb_sgl_cmp_buf() within scsi_debug.c remove call to
    sg_miter_stop() as suggested by reviewer


Douglas Gilbert (5):
  sgl_alloc_order: remove 4 GiB limit
  scatterlist: add sgl_copy_sgl() function
  scatterlist: add sgl_equal_sgl() function
  scatterlist: add sgl_memset()
  scsi_debug: change store from vmalloc to sgl

 drivers/scsi/Kconfig        |   3 +-
 drivers/scsi/scsi_debug.c   | 442 ++++++++++++++++++++++++------------
 include/linux/scatterlist.h |  33 ++-
 lib/scatterlist.c           | 255 ++++++++++++++++++---
 4 files changed, 562 insertions(+), 171 deletions(-)

-- 
2.37.2

