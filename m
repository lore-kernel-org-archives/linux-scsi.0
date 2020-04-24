Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7464C55191
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:28:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78EF920767
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 12:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587731280;
	bh=5qRrk/qk1QSXAwev/EVg/ssIKECEKJ1TPHFWCiMyJVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=k88pwROAvff7OwXh6bjROcvq3POAY8CZV3u8F214s9cmKyIXvHY/HRay771zmDOMm
	 7rrZ6d2F+8hiUHCwPaydwOwZKuIEseUuMe1rjzlKAXgIIEHtIJ5kg+TdQUzH9zgBRS
	 fJ0JS7gc84udCdKFDmX1RuhPBNxaHq9SX44PzmwY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgDXM16 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 08:27:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:55064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728414AbgDXMY1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 08:24:27 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BBA821744;
        Fri, 24 Apr 2020 12:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731067;
        bh=5qRrk/qk1QSXAwev/EVg/ssIKECEKJ1TPHFWCiMyJVM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZc9OE9pLP93VqYKwlvX7qHLkTrRCbCxaxynxHVE90+p1wMcxf//dZi/qHad97h+I
         BvwJ4/iZA6WrfPTGmLDpf0GjVXUFJZriJCQGrKlRgZ68MXWH/AalABHTnP3vlapQ1X
         MyFEnr95UcuWwqfr8x2jVyiLK7aAQt0EIJD73Cq0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Li Bin <huawei.libin@huawei.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/21] scsi: sg: add sg_remove_request in sg_common_write
Date:   Fri, 24 Apr 2020 08:24:04 -0400
Message-Id: <20200424122419.10648-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122419.10648-1-sashal@kernel.org>
References: <20200424122419.10648-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Li Bin <huawei.libin@huawei.com>

[ Upstream commit 849f8583e955dbe3a1806e03ecacd5e71cce0a08 ]

If the dxfer_len is greater than 256M then the request is invalid and we
need to call sg_remove_request in sg_common_write.

Link: https://lore.kernel.org/r/1586777361-17339-1-git-send-email-huawei.libin@huawei.com
Fixes: f930c7043663 ("scsi: sg: only check for dxfer_len greater than 256M")
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Li Bin <huawei.libin@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3a406b40f1505..b5f589b7b43dc 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -809,8 +809,10 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 			"sg_common_write:  scsi opcode=0x%02x, cmd_size=%d\n",
 			(int) cmnd[0], (int) hp->cmd_len));
 
-	if (hp->dxfer_len >= SZ_256M)
+	if (hp->dxfer_len >= SZ_256M) {
+		sg_remove_request(sfp, srp);
 		return -EINVAL;
+	}
 
 	k = sg_start_req(srp, cmnd);
 	if (k) {
-- 
2.20.1

