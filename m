Return-Path: <SRS0=8X05=DC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47F5FC4741F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 18:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08D92221E5
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Sep 2020 18:42:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="dkHgCknQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729732AbgIYSma (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Sep 2020 14:42:30 -0400
Received: from mx2.suse.de ([195.135.220.15]:59724 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727151AbgIYSm3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 25 Sep 2020 14:42:29 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1601059348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2Kq1FxqxZLYWoE4X3kI+VDC0KjL+XQlYmdMO7aSdeHQ=;
        b=dkHgCknQrtNzIYbkAY8Us9mQ2+Tq1RzmidcCoO1f3HYCZt1i4S6y1N0EJ70GLPz5IMBIY6
        4cdsdmYXSZeICVm7DV3EKThU9lnjCV+jmB72s6SeDQKJq2DgdwYFvejEOjDv7Vk26Jo17T
        s4PAgBX4TjKRKJk6pcKTZMB6JUN0Z00=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2F349AC68;
        Fri, 25 Sep 2020 18:42:28 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 8D666514D99; Fri, 25 Sep 2020 11:42:26 -0700 (PDT)
From:   <lduncan@suse.com>
To:     linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com,
        martin.petersen@oracle.com, mchristi@redhat.com, hare@suse.com,
        Lee Duncan <lduncan@suse.com>
Subject: [PATCH v2 0/1] scsi: libiscsi: fix NOP race condition
Date:   Fri, 25 Sep 2020 11:41:47 -0700
Message-Id: <cover.1601058301.git.lduncan@suse.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Lee Duncan <lduncan@suse.com>

A customer that uses iSCSI NOPs extensively found a race
condition caused in part by the two-lock system used in
iscsi (a forward and a back lock), since sending an iSCSI
NOP uses the forward lock, and receiving one uses the
back lock. Because of this, processing of the "send"
can still be in progress when the "receive" occurs, on
a sufficiently fast multicore system.

To handle this case, we add a new state to the "ping_task"
pointer besides unassigned and assigned, called "invalid",
which means the "not yet completed sending". Tests show
this closes this race condition hole.

Changes since V1:
- Removed two redundant lines in iscsi_send_nopout()
- Updated commit text to be more clear
- Added this cover letter with even more info

Lee Duncan (1):
  scsi: libiscsi: fix NOP race condition

 drivers/scsi/libiscsi.c | 13 ++++++++++---
 include/scsi/libiscsi.h |  3 +++
 2 files changed, 13 insertions(+), 3 deletions(-)

-- 
2.26.2

