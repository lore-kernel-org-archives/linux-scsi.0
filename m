Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E760C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 18:00:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 68F34214AF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 18:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579197644;
	bh=EAbDPNX6swMYVTN9IdARfGMkDFGM3kWg6yADy5rDtcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=cADTTNMTySOvpq0GC79c4yF8E3b+uRuL/uXoQQS42ax4qYyb0dFW7CwptKxfRZfNH
	 gyhT++MuZ7liK3FW9H2h3TfZ3NnAaDVktJiWw1j7jfPFU9Griz74zonXEa6si0Lr/2
	 aAY2Z33MituIUqHjhnDwVeCuz+ir5BiM/b4Lm6W4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394913AbgAPSAj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 13:00:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:59506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405777AbgAPRlo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jan 2020 12:41:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D09824695;
        Thu, 16 Jan 2020 17:41:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196504;
        bh=EAbDPNX6swMYVTN9IdARfGMkDFGM3kWg6yADy5rDtcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bEfyMsTRSNIVpDQqdns1C2XODiBThxADHWgBMmSciDlhR4blHZrivDjSEzW48C9sn
         Z59QSD7E2gKuhh8hVWx62EsJKCCgelyErBDMYd5RLereN1ng5aFB0J6qXiZYeVWD/Q
         GffkX1/bADRASWScj03937pzJ/mFw/7EgQ2vXe4A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 245/251] scsi: target: core: Fix a pr_debug() argument
Date:   Thu, 16 Jan 2020 12:36:34 -0500
Message-Id: <20200116173641.22137-205-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
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
index cb6497ce4b61..6e75095af681 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -130,7 +130,7 @@ static int srp_get_pr_transport_id(
 	memset(buf + 8, 0, leading_zero_bytes);
 	rc = hex2bin(buf + 8 + leading_zero_bytes, p, count);
 	if (rc < 0) {
-		pr_debug("hex2bin failed for %s: %d\n", __func__, rc);
+		pr_debug("hex2bin failed for %s: %d\n", p, rc);
 		return rc;
 	}
 
-- 
2.20.1

