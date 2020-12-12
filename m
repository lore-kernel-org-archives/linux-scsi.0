Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FF15C4361B
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Dec 2020 16:22:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70BA5230FA
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Dec 2020 16:22:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439474AbgLLQKl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 11:10:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:59454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439444AbgLLQKV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 12 Dec 2020 11:10:21 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Saruhan Karademir <skarade@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, devel@linuxdriverproject.org
Subject: [PATCH AUTOSEL 5.9 15/23] scsi: storvsc: Validate length of incoming packet in storvsc_on_channel_callback()
Date:   Sat, 12 Dec 2020 11:07:56 -0500
Message-Id: <20201212160804.2334982-15-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160804.2334982-1-sashal@kernel.org>
References: <20201212160804.2334982-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>

[ Upstream commit 3b8c72d076c42bf27284cda7b2b2b522810686f8 ]

Check that the packet is of the expected size at least, don't copy data
past the packet.

Link: https://lore.kernel.org/r/20201118145348.109879-1-parri.andrea@gmail.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Reported-by: Saruhan Karademir <skarade@microsoft.com>
Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/storvsc_drv.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8f5f5dc863a4a..6779ee4edfee3 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1246,6 +1246,11 @@ static void storvsc_on_channel_callback(void *context)
 		request = (struct storvsc_cmd_request *)
 			((unsigned long)desc->trans_id);
 
+		if (hv_pkt_datalen(desc) < sizeof(struct vstor_packet) - vmscsi_size_delta) {
+			dev_err(&device->device, "Invalid packet len\n");
+			continue;
+		}
+
 		if (request == &stor_device->init_request ||
 		    request == &stor_device->reset_request) {
 			memcpy(&request->vstor_packet, packet,
-- 
2.27.0

