Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2CD0C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 17:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F1F8246B9
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 17:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579194861;
	bh=/2xFaNxLa7K50Z785BV0wVYEyuwasJCRGTuj3dfdc2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=fYiip9vqzmajZKFJok2CismIv7ZWvzVc/4AE6IR0m7h+m08q9j7kr7qbwgFujKLvX
	 R6HyX81FdjF6l6DOWVRJi5cymAIOpqf8hQj5fiApR65RQeScfdt10BMfS+unzpjaRD
	 BTrroYbZSnn9b3Y8X6S65UYJMzUiYTV4nH1ruczE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390968AbgAPROU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:14:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:33138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390962AbgAPROU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jan 2020 12:14:20 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9D677246AF;
        Thu, 16 Jan 2020 17:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194859;
        bh=/2xFaNxLa7K50Z785BV0wVYEyuwasJCRGTuj3dfdc2s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7w8pQeJmlq+dr+hcya24HDCQoaa4itAaZ1885nbHGQXIniSmfPI9+3qp6RChugo9
         AsPIorMJA0H8734JpgmcfSkIEjz32Z7umDxNvwuiSNv2bgvFJ+fnXW0+attPC1+k3U
         wdUQ9b6Oi2JJyeiF/LyXc0wkWrqqFdRPE1EXJjLs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 654/671] scsi: target: core: Fix a pr_debug() argument
Date:   Thu, 16 Jan 2020 12:04:52 -0500
Message-Id: <20200116170509.12787-391-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit c941e0d172605731de9b4628bd4146d35cf2e7d6 ]

Print the string for which conversion failed instead of printing the
function name twice.

Fixes: 2650d71e244f ("target: move transport ID handling to the core")
Cc: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20191107215525.64415-1-bvanassche@acm.org
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_fabric_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 71a80257a052..10fae26b44ad 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -131,7 +131,7 @@ static int srp_get_pr_transport_id(
 	memset(buf + 8, 0, leading_zero_bytes);
 	rc = hex2bin(buf + 8 + leading_zero_bytes, p, count);
 	if (rc < 0) {
-		pr_debug("hex2bin failed for %s: %d\n", __func__, rc);
+		pr_debug("hex2bin failed for %s: %d\n", p, rc);
 		return rc;
 	}
 
-- 
2.20.1

