Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87227C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 06:19:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6189460F11
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 06:19:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231759AbhGZFjV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 01:39:21 -0400
Received: from smtpbguseast3.qq.com ([54.243.244.52]:60710 "EHLO
        smtpbguseast3.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbhGZFjU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 01:39:20 -0400
X-Greylist: delayed 146352 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jul 2021 01:39:20 EDT
X-QQ-mid: bizesmtp54t1627280378t44aezga
Received: from localhost.localdomain (unknown [58.240.82.166])
        by esmtp6.qq.com (ESMTP) with 
        id ; Mon, 26 Jul 2021 14:19:32 +0800 (CST)
X-QQ-SSF: 01400000008000103000B00B0000000
X-QQ-FEAT: N3Byn/eJX/ur+pNJ/zWCyIt//RhJo5srcG4KsMNSoXTlXmblUY2grIKPz/mLi
        a6KBa4cpgt8JAJ6VxH6ntrL6nBOrcNJk3jQcJgmBFHy/+QWUt3RKbgOLGEyxeT+gYm5veuW
        pNaXRD5T0kYhIQ3FhMSc1t8SZuoCKvlu/FQlU1MGjMngYjARxY2rSlwdp3NWSeQ41dhFTcv
        NVUhfy/Fy4RGaEp3EOIKXgqVz9el3SjZ2xymavQzHKjwJvjfWLaCciBQUKnFmRGFBF784rc
        V/ZhVFO/RBEXJBXNjWbj+dzuOHCzAfRoQHOe4FZX4nJ4P9e2gAC3/T0E05N0yrtkZlUlCPs
        lw4tzoN
X-QQ-GoodBg: 2
From:   Li Manyi <limanyi@uniontech.com>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Manyi <limanyi@uniontech.com>
Subject: [PATCH] scsi: sr: Return correct event when media event code is 3
Date:   Mon, 26 Jul 2021 14:19:22 +0800
Message-Id: <20210726061922.19516-1-limanyi@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign6
X-QQ-Bgrelay: 1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

the description for media event code 0: NoChg
Media status is unchanged.

the description for media event code 1: EjectRequest
The Drive has received a request from the user (usually through a
mechanical switch on the Drive) to eject the specified slot or media.

the description for media event code 2: NewMedia
The specified slot (or the Drive) has received new media, and is
ready to access it.

the description for media event code 3: MediaRemoval
The media has been removed from the specified slot, and the
Drive is unable to access the media without user intervention.
This applies to media changers only.

fix bug: https://bugzilla.kernel.org/show_bug.cgi?id=213759

Signed-off-by: Li Manyi <limanyi@uniontech.com>
---
 drivers/scsi/sr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 94c254e9012e..a6d3ac0a6cbc 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -221,7 +221,7 @@ static unsigned int sr_get_events(struct scsi_device *sdev)
 	else if (med->media_event_code == 2)
 		return DISK_EVENT_MEDIA_CHANGE;
 	else if (med->media_event_code == 3)
-		return DISK_EVENT_EJECT_REQUEST;
+		return DISK_EVENT_MEDIA_CHANGE;
 	return 0;
 }
 
-- 
2.20.1



