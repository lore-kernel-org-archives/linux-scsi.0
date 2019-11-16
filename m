Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22C6C43215
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:26:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFDF821479
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573921587;
	bh=6eykspN3cd2v1dC2FZs8AixH9I5Z7C5N1now7YBSKs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=GCnpnFR9XqZEMuf1M7Yf6HUhp63Ut6XGEdizpvgK6sPb17AWkDhRtVapmVms6gIse
	 5L4UasX7hU8Qz3NOqP8bfqE9a0HxgbdDDXiOkZ3ccTqfSNI5Oa3ffq8hhoArvOq9Ow
	 FDy1/1qUZJ2Ta4FMBw2ieBwKNQ1QcCCL2lMPhk2M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728039AbfKPPly (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Nov 2019 10:41:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728024AbfKPPlv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Nov 2019 10:41:51 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7BCB20833;
        Sat, 16 Nov 2019 15:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918911;
        bh=6eykspN3cd2v1dC2FZs8AixH9I5Z7C5N1now7YBSKs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KUeqWWM4PIyauU9lugAMBZBc8zKZUlUvpUEeZ2EaBuhZ9JVDEBEecmvxhsZOYj0Eh
         wWugueQxrCb67UMzCT0bLC4wENwx0olqdC53UevRAPBjEttpY0bV/3eGARe2FunanK
         iaV1FpCqkQGMnjPrEOPR8ny3yFNU8dgCZ5c8BaZI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luo Jiaxing <luojiaxing@huawei.com>,
        John Garry <john.garry@huawei.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 034/237] scsi: hisi_sas: Feed back linkrate(max/min) when re-attached
Date:   Sat, 16 Nov 2019 10:37:49 -0500
Message-Id: <20191116154113.7417-34-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Luo Jiaxing <luojiaxing@huawei.com>

[ Upstream commit 5a54691f874ab29ec82f08bc6936866a3ccdaa91 ]

At directly attached situation, if the user modifies the sysfs interface
of maximum_linkrate and minimum_linkrate to renegotiate the linkrate
between SAS controller and target, the value of both files mentioned
above should have change to user setting after renegotiate is over, but
it remains unchanged.

To fix this bug, maximum_linkrate and minimum_linkrate will be directly
fed back to relevant sas_phy structure.

Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
Signed-off-by: John Garry <john.garry@huawei.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hisi_sas/hisi_sas_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hisi_sas/hisi_sas_main.c b/drivers/scsi/hisi_sas/hisi_sas_main.c
index fd9d82c9033de..e9747379384b2 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_main.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_main.c
@@ -906,6 +906,9 @@ static void hisi_sas_phy_set_linkrate(struct hisi_hba *hisi_hba, int phy_no,
 	_r.maximum_linkrate = max;
 	_r.minimum_linkrate = min;
 
+	sas_phy->phy->maximum_linkrate = max;
+	sas_phy->phy->minimum_linkrate = min;
+
 	hisi_hba->hw->phy_disable(hisi_hba, phy_no);
 	msleep(100);
 	hisi_hba->hw->phy_set_linkrate(hisi_hba, phy_no, &_r);
-- 
2.20.1

