Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABB7CC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 12:47:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85E38619C4
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 12:47:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232040AbhC3Mq3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 08:46:29 -0400
Received: from mail-m17635.qiye.163.com ([59.111.176.35]:35856 "EHLO
        mail-m17635.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbhC3MqL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 08:46:11 -0400
Received: from ubuntu.localdomain (unknown [36.152.145.182])
        by mail-m17635.qiye.163.com (Hmail) with ESMTPA id 3B904400486;
        Tue, 30 Mar 2021 20:46:08 +0800 (CST)
From:   zhouchuangao <zhouchuangao@vivo.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     zhouchuangao <zhouchuangao@vivo.com>
Subject: [PATCH] message/fusion: Use BUG_ON instead of if condition followed by BUG.
Date:   Tue, 30 Mar 2021 05:46:01 -0700
Message-Id: <1617108361-6870-1-git-send-email-zhouchuangao@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZTRoaH0NNS0pNGUIaVkpNSkxKS0NITUNPQ0tVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NiI6GRw6Tj8UAjcNQyw5KSsV
        Kx8wCQJVSlVKTUpMSktDSE1DTEhOVTMWGhIXVQETFA4YEw4aFRwaFDsNEg0UVRgUFkVZV1kSC1lB
        WUhNVUpOSVVKT05VSkNJWVdZCAFZQUlKTU83Bg++
X-HM-Tid: 0a78832b7c1bd991kuws3b904400486
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

BUG_ON() uses unlikely in if(), which can be optimized at compile time.

Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
---
 drivers/message/fusion/mptsas.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 5eb0b33..5e425fd 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3442,14 +3442,12 @@ mptsas_expander_event_add(MPT_ADAPTER *ioc,
 	__le64 sas_address;
 
 	port_info = kzalloc(sizeof(struct mptsas_portinfo), GFP_KERNEL);
-	if (!port_info)
-		BUG();
+	BUG_ON(!port_info);
 	port_info->num_phys = (expander_data->NumPhys) ?
 	    expander_data->NumPhys : 1;
 	port_info->phy_info = kcalloc(port_info->num_phys,
 	    sizeof(struct mptsas_phyinfo), GFP_KERNEL);
-	if (!port_info->phy_info)
-		BUG();
+	BUG_ON(!port_info->phy_info);
 	memcpy(&sas_address, &expander_data->SASAddress, sizeof(__le64));
 	for (i = 0; i < port_info->num_phys; i++) {
 		port_info->phy_info[i].portinfo = port_info;
-- 
2.7.4

