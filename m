Return-Path: <SRS0=a792=EB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3651AC4363A
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 19:13:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0196E20878
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Oct 2020 19:13:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1792631AbgJZTNn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 15:13:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:44142 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392749AbgJZTH0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Oct 2020 15:07:26 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8E796AE2C;
        Mon, 26 Oct 2020 19:07:25 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org
Subject: [PATCH v2 0/5] scsi: target: COMPARE AND WRITE miscompare sense
Date:   Mon, 26 Oct 2020 20:06:41 +0100
Message-Id: <20201026190646.8727-1-ddiss@suse.de>
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

Changes since v1:
- drop unnecessary WARN_ON()
- fix two checkpatch warnings
- drop single-use nlbas variable
- avoid compare_len recalculation

Cheers, David

 drivers/target/target_core_sbc.c       | 137 +++++++++++++++----------
 drivers/target/target_core_transport.c |  33 +++---
 include/target/target_core_base.h      |   2 +-
 lib/scatterlist.c                      |   2 +-
 4 files changed, 102 insertions(+), 72 deletions(-)

