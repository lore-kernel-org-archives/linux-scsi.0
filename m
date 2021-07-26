Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42597C4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 11:49:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2029D60F37
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Jul 2021 11:49:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbhGZLJC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 07:09:02 -0400
Received: from smtpbg702.qq.com ([203.205.195.102]:55711 "EHLO
        smtpproxy21.qq.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S233570AbhGZLJC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jul 2021 07:09:02 -0400
X-Greylist: delayed 166106 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jul 2021 07:09:01 EDT
X-QQ-mid: bizesmtp45t1627300161t2s8pii1
Received: from localhost.localdomain (unknown [58.240.82.166])
        by esmtp6.qq.com (ESMTP) with 
        id ; Mon, 26 Jul 2021 19:49:14 +0800 (CST)
X-QQ-SSF: 01400000008000103000B00B0000000
X-QQ-FEAT: jIuKqQTmtbxgJRL5evlLzzhIfzh9cGgegIfQuWljjhTp3gZaLojByFuQkd8/r
        QoEnU2NESUFgX5AEhatsPcpPQbE7/4tg/ODcTKZ2+vTA24kf2ksX0Lvh5XQwFGKEhM6bfdd
        WlfiYDrUrV2GYNO0DMMOIBG7ksfcGd/MoGqcpwKxyWoOowlwW30K4Um078CZQZphfYCFzfZ
        Rt0VIdhcj/uDCCWw/u5GYEtvk7/EZudMw/ts9fnnK2cbQck3l5A0aCao/sqLwXBsdEVpmg/
        S6T7VPUaLZdrJb2GAcXWig63ma0S1KpxlKtOyoCbpzFizVsZscTo/2bTKkMMv7YL3ihkUKj
        WmqdRVHg2LutzPIzoKRxCAfQf+oPw==
X-QQ-GoodBg: 2
From:   Li Manyi <limanyi@uniontech.com>
To:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Li Manyi <limanyi@uniontech.com>
Subject: [PATCH] scsi: sr: Return correct event when media event code is 3
Date:   Mon, 26 Jul 2021 19:49:13 +0800
Message-Id: <20210726114913.6760-1-limanyi@uniontech.com>
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



