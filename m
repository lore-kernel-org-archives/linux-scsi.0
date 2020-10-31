Return-Path: <SRS0=Icgp=EG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C598C388F7
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 23:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39D8F208B6
	for <linux-scsi@archiver.kernel.org>; Sat, 31 Oct 2020 23:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbgJaXcZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 31 Oct 2020 19:32:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:57498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725809AbgJaXcZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 31 Oct 2020 19:32:25 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 514D9ABD1;
        Sat, 31 Oct 2020 23:32:23 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH v4 0/4] scsi: target: COMPARE AND WRITE miscompare sense
Date:   Sun,  1 Nov 2020 00:32:07 +0100
Message-Id: <20201031233211.5207-1-ddiss@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset adds missing functionality to return the offset of
non-matching read/compare data in the sense INFORMATION field on
COMPARE AND WRITE miscompare.

The functionality can be tested using the libiscsi
CompareAndWrite.MiscompareSense test proposed via:
  https://github.com/sahlberg/libiscsi/pull/344

Changes since v3:
- (4/4) optimize for equality, as suggested by Doug
  + perform byte-by-byte offset check only after memcmp() failure
  + drop Mike's RB tag due to this rework

Changes since v2:
- perform bad_sector->sense_info rename in overlooked ib_isert
- drop scatterlist change queued via Jens' tree
- add Mike's reviewed-by tag
- rebase against Martin's 5.11/scsi-queue branch

Changes since v1:
- drop unnecessary WARN_ON()
- fix two checkpatch warnings
- drop single-use nlbas variable
- avoid compare_len recalculation

Cheers, David

 drivers/infiniband/ulp/isert/ib_isert.c |   4 +-
 drivers/target/target_core_sbc.c        | 138 ++++++++++++++----------
 drivers/target/target_core_transport.c  |  33 +++---
 include/target/target_core_base.h       |   2 +-
 4 files changed, 104 insertions(+), 73 deletions(-)

