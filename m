Return-Path: <SRS0=XP5+=5I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97483C54EEB
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:54:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 75B8D20714
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Mar 2020 16:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbgCWQyZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Mar 2020 12:54:25 -0400
Received: from mx2.suse.de ([195.135.220.15]:50422 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgCWQyY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Mar 2020 12:54:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 3A426AB8F;
        Mon, 23 Mar 2020 16:54:23 +0000 (UTC)
From:   David Disseldorp <ddiss@suse.de>
To:     target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        bvanassche@acm.org
Subject: [RFC PATCH 0/5] scsi: target: XCOPY performance
Date:   Mon, 23 Mar 2020 17:54:05 +0100
Message-Id: <20200323165410.24423-1-ddiss@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These changes remove unnecessary heap allocations in the XCOPY
READ/WRITE dispatch loop.

Synthetic benchmarks on my laptop using the libiscsi iscsi-dd utility
(--xcopy --max 1 --blocks 65535 src=dst) against a target backed by an 8G
zram (DEBUG_KMEMLEAK=y) iblock backstore (avg across four runs) show:
before: 5.35776G/s
after:  6.12636G/s (approx. +14%)

Feedback appreciated.

Cheers, David

----------------------------------------------------------------
David Disseldorp (5):
      scsi: target: use #def for xcopy descriptor len
      scsi: target: drop xcopy DISK BLOCK LENGTH debug
      scsi: target: avoid per-loop XCOPY buffer allocations
      scsi: target: increase XCOPY I/O size
      scsi: target: avoid XCOPY per-loop read/write cmd allocations

 drivers/target/target_core_xcopy.c | 135 ++++++++++-------------------
 drivers/target/target_core_xcopy.h |  14 +--
 2 files changed, 57 insertions(+), 92 deletions(-)
