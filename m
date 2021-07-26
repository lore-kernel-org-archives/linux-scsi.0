Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26049C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 11:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F31D860EB2
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 11:42:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233504AbhGZLCT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:02:19 -0400
Received: from smtpbguseast3.qq.com ([54.243.244.52]:42703 "EHLO
        smtpbguseast3.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233464AbhGZLCS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 07:02:18 -0400
X-QQ-mid: bizesmtp51t1627299758t4xbo5eq
Received: from localhost.localdomain (unknown [58.240.82.166])
        by esmtp6.qq.com (ESMTP) with 
        id ; Mon, 26 Jul 2021 19:42:31 +0800 (CST)
X-QQ-SSF: 01400000008000103000B00B0000000
X-QQ-FEAT: 5eVkbtW6/SC+6wAnJpFwnj0MoKG1KKSm/+cM6LG7wFKt+5jJNatP/18/vO/9U
        ZHwWzrwJi35bXTDxgDar70uShKHnIKKNueZMfK9tIm4ixZUwVwLhtw5QmKkuikNfCdef6eW
        EeSyiFlRdInbCUu3cxQzfEyOa8LaucqdN/zMWTtNralfalMgVMxok7zNSR8RdlzMHc7Wkj5
        88Rew/+8AXRVjQPep+iwDGBd8ihASqw72dQlgK5DE65dMickncuR9SpAQ02Mlzo1/cEymr6
        p357Oh2DnhJnsSLBk/rvwFVj8cyNNJdqpkhS4EWpMTs7gLoQe2aW1qps15eGf4xBPvo6TUR
        ZJkGQt9AcufwqIeJs4=
X-QQ-GoodBg: 2
From:   Li Manyi <limanyi@uniontech.com>
To:     limanyi@uniontech.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: sr: Return correct event when media event code is 3
Date:   Mon, 26 Jul 2021 19:42:27 +0800
Message-Id: <20210726114227.3661-1-limanyi@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:uniontech.com:qybgforeign:qybgforeign2
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



