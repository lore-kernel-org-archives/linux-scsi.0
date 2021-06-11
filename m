Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45E50C48BD1
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 09:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 328AE613DD
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Jun 2021 09:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbhFKJqy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Jun 2021 05:46:54 -0400
Received: from lucky1.263xmail.com ([211.157.147.131]:47410 "EHLO
        lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhFKJqx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Jun 2021 05:46:53 -0400
Received: from localhost (unknown [192.168.167.235])
        by lucky1.263xmail.com (Postfix) with ESMTP id 90DDDBAA71;
        Fri, 11 Jun 2021 17:44:51 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-SKE-CHECKED: 1
X-ANTISPAM-LEVEL: 2
Received: from localhost.localdomain (unknown [58.240.82.166])
        by smtp.263.net (postfix) whith ESMTP id P15326T140654319490816S1623404677729545_;
        Fri, 11 Jun 2021 17:44:51 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <7cb6ee5a5d2345daf20d82e5eb4eab98>
X-RL-SENDER: limanyi@uniontech.com
X-SENDER: limanyi@uniontech.com
X-LOGIN-NAME: limanyi@uniontech.com
X-FST-TO: axboe@kernel.dk
X-RCPT-COUNT: 6
X-SENDER-IP: 58.240.82.166
X-ATTACHMENT-NUM: 0
X-System-Flag: 0
From:   ManYi Li <limanyi@uniontech.com>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        ManYi Li <limanyi@uniontech.com>
Subject: [PATCH] sr: Fix get the error media event code
Date:   Fri, 11 Jun 2021 17:44:02 +0800
Message-Id: <20210611094402.23884-1-limanyi@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Eject the specified slot or media through a mechanical switch on the Drive,
med->media_event_code is 3 not 1 in the sr_get_events().

If disk_flush_events() and sr_block_open() are called,
clearing is 1 or 3 in the sr_check_events(),then it report
DISK_EVENT_MEDIA_CHANGE not DISK_EVENT_EJECT_REQUEST.

If disk_flush_events() and sr_block_open() aren't called,
clearing is 0 in the sr_check_events(),then it doesn't
report any event.

Signed-off-by: ManYi Li <limanyi@uniontech.com>
---
 drivers/scsi/sr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 482a07b662a9..94c254e9012e 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -220,6 +220,8 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 		return DISK_EVENT_EJECT_REQUEST;
 	else if (med->media_event_code == 2)
 		return DISK_EVENT_MEDIA_CHANGE;
+	else if (med->media_event_code == 3)
+		return DISK_EVENT_EJECT_REQUEST;
 	return 0;
 }
 
-- 
2.20.1



