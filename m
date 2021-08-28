Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A7CC432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 18:09:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E795F60E9B
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 18:09:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbhH1SKs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Aug 2021 14:10:48 -0400
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:51654 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229479AbhH1SKs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 28 Aug 2021 14:10:48 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 8C4DC12802DB;
        Sat, 28 Aug 2021 11:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1630174197;
        bh=Jri9M2z+L6BNmQfbdTcw8CwtirXkoSroHqBCKW2QoKg=;
        h=Message-ID:Subject:From:To:Date:From;
        b=VE0Pw2XySNP/vbDkD8F/k4zuQTiJmro3a5Lr24d4Vt1ElhqFD1RZKupP0loobS+oZ
         /72Q2DdyA5vwCpf3GTYGHeP5JpYSJ9qTyS5IRPkRU/BGQqNs9Z7a96fgtbsG/KwLex
         ocqzfhVfRWa4DnATzLneJpDW0urqguylsNHyrD98=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0xF9_Z2rMan6; Sat, 28 Aug 2021 11:09:57 -0700 (PDT)
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:600:8280:66d1::527])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 2BD7A12802CC;
        Sat, 28 Aug 2021 11:09:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1630174197;
        bh=Jri9M2z+L6BNmQfbdTcw8CwtirXkoSroHqBCKW2QoKg=;
        h=Message-ID:Subject:From:To:Date:From;
        b=VE0Pw2XySNP/vbDkD8F/k4zuQTiJmro3a5Lr24d4Vt1ElhqFD1RZKupP0loobS+oZ
         /72Q2DdyA5vwCpf3GTYGHeP5JpYSJ9qTyS5IRPkRU/BGQqNs9Z7a96fgtbsG/KwLex
         ocqzfhVfRWa4DnATzLneJpDW0urqguylsNHyrD98=
Message-ID: <4313aa33c50578e6b3c52437d27704f24e27ae8f.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 5.14-rc7
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 28 Aug 2021 11:09:55 -0700
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A single fix for a race introduced by a fix that went up in 5.14-rc5.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Li Jinlin (1):
      scsi: core: Fix hang of freezing queue between blocking and running device

And the diffstat:

 drivers/scsi/scsi_sysfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

With full diff below.

James

---

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ae9bfc658203..c0d31119d6d7 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -808,12 +808,15 @@ store_state_field(struct device *dev, struct device_attribute *attr,
 	ret = scsi_device_set_state(sdev, state);
 	/*
 	 * If the device state changes to SDEV_RUNNING, we need to
-	 * rescan the device to revalidate it, and run the queue to
-	 * avoid I/O hang.
+	 * run the queue to avoid I/O hang, and rescan the device
+	 * to revalidate it. Running the queue first is necessary
+	 * because another thread may be waiting inside
+	 * blk_mq_freeze_queue_wait() and because that call may be
+	 * waiting for pending I/O to finish.
 	 */
 	if (ret == 0 && state == SDEV_RUNNING) {
-		scsi_rescan_device(dev);
 		blk_mq_run_hw_queues(sdev->request_queue, true);
+		scsi_rescan_device(dev);
 	}
 	mutex_unlock(&sdev->state_mutex);
 

