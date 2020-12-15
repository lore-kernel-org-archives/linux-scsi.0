Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8075BC4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 03:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50FD720731
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 03:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgLOD3k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 22:29:40 -0500
Received: from smtp.infotech.no ([82.134.31.41]:36606 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgLOD3a (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 14 Dec 2020 22:29:30 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id AE72020426C;
        Tue, 15 Dec 2020 04:28:41 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LpVR8JhqnvDj; Tue, 15 Dec 2020 04:28:40 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        by smtp.infotech.no (Postfix) with ESMTPA id 5405820418E;
        Tue, 15 Dec 2020 04:28:39 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bostroesser@gmail.com, ddiss@suse.de
Subject: [PATCH v2 0/2] scsi_debug: change store from vmalloc to sgl
Date:   Mon, 14 Dec 2020 22:28:34 -0500
Message-Id: <20201215032836.437175-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset is a reworking of a single patch titled:
"[PATCH] scsi_debug: change store from vmalloc to sgl"
sent to the linux-scsi list on 20201105.  That patch depended on
"[PATCH v4 0/4] scatterlist: add new capabilities" which is still
to be accepted through the linux-block tree. The kernel build robot
failed to compile the 20201105 patch due to that missing dependency.

In order to move forward, the first patch in this series adds the
sgl to sgl handling functions into the scsi_debug driver with a
"sdeb_" prefix. The second patch in this set is almost the same
as the original patch from 20201105.

This patchset is based on ithe 5.11/scsi-queue branch in MKP's
repository and builds clean on lk 5.10.0 .

Douglas Gilbert (2):
  scsi_debug: add sdeb_sgl_copy_sgl and friends
  scsi_debug: change store from vmalloc to sgl

 drivers/scsi/Kconfig      |   3 +-
 drivers/scsi/scsi_debug.c | 567 ++++++++++++++++++++++++++++----------
 2 files changed, 427 insertions(+), 143 deletions(-)

-- 
2.25.1

