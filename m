Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9E23C43381
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 15:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C9D364F6C
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 15:51:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhCQPvc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 11:51:32 -0400
Received: from smtp.infotech.no ([82.134.31.41]:37232 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232809AbhCQPus (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Mar 2021 11:50:48 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 9758B204273;
        Wed, 17 Mar 2021 16:28:05 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6fubGvjMnL-P; Wed, 17 Mar 2021 16:28:02 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        by smtp.infotech.no (Postfix) with ESMTPA id A2CD220418C;
        Wed, 17 Mar 2021 16:28:01 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        dan.carpenter@oracle.com, colin.king@canonical.com
Subject: [PATCH v2 0/6] sg: fixes for 5.13/scsi-staging
Date:   Wed, 17 Mar 2021 11:27:52 -0400
Message-Id: <20210317152758.51689-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset addresses reports sent by Colin King to the linux-scsi
list in 20210311 based on coverity reports. There were also similar
reports from Dan Carpenter the following day. Plus syzbot (KASAN)
made a double free report. These were due to a 45 part patchset:
"sg: add v4 interface" applied to 5.13/scsi-staging recently.
Patches 1, 2 and 4 address those concerns.

Colin King sent a patch titled: "[PATCH][next] scsi: sg: Fix use of
pointer sfp after it has been kfree'd" [linux-scsi 20210311] which
should be applied.
Dan Carpenter sent a patch titled: "Re: [PATCH] scsi: sg: Fix a
warning message" [linux-scsi 20210312] regarding the use of
WARN_ONCE() which should be applied.

Patches 3, 5 and 6 are due to the author's ongoing testing.

This patchset is against MKP's repository, 5.13/scsi-staging
branch.

Douglas Gilbert (6):
  sg: sg_rq_map_kern: fix uninitialized
  sg: sg_remove_sfp_usercontext: remove NULL check
  sg: sg_rq_end_io: set SG_FRQ_ISSUED
  sg: fix double free of long scsi commands
  sg: tighten handling of struct request objects
  sg: remove debugging remnants

 drivers/scsi/sg.c | 87 +++++++++++++++++++----------------------------
 1 file changed, 35 insertions(+), 52 deletions(-)

-- 
2.25.1

