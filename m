Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 574FDC33C8C
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:05:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 269C72089D
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573920312;
	bh=Y5oiB7530wepLPGyawlMUGIb28+HF8HLGv0HAT+h6v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Fv/8DMijcIdHyoa1af9h2UT1DUcgJTfGOPrTkT2xPrAgYxGhjt12G4vgtGwd31w3H
	 RzUGgu6KKN+b5oDxHmSkAJTQXHafmMi2Ac0I4RKh8miq/TajOfN+cZNdUJMYSd9v9v
	 ebLMlPhwlp8mV9PuBduFQZs3YUUWKQ/J1a2iAvu0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730748AbfKPPv0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Nov 2019 10:51:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:60042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729221AbfKPPvZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Nov 2019 10:51:25 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AB91214DE;
        Sat, 16 Nov 2019 15:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919485;
        bh=Y5oiB7530wepLPGyawlMUGIb28+HF8HLGv0HAT+h6v4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wHh3YxAuHxsYdkYvgJvyXfFT0eK+Y5GIdUpuVv8NT3Bj1eYKbEUbtlT9uKkXApS+f
         t1F9VKJy3/pBylgTA4/DJM+BcAt7kzmXu0x8zDCJ5UOxgLxj8PKLRBrunQ4AJkSOhj
         I67a2qUNERtNM5DZrX8Y07w6gcxZwkBZG3XbIL3Q=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 16/99] scsi: ips: fix missing break in switch
Date:   Sat, 16 Nov 2019 10:49:39 -0500
Message-Id: <20191116155103.10971-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116155103.10971-1-sashal@kernel.org>
References: <20191116155103.10971-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

[ Upstream commit 5d25ff7a544889bc4b749fda31778d6a18dddbcb ]

Add missing break statement in order to prevent the code from falling
through to case TEST_UNIT_READY.

Addresses-Coverity-ID: 1357338 ("Missing break in switch")
Suggested-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ips.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 02cb76fd44208..6bbf2945a3e00 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3500,6 +3500,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 
 		case START_STOP:
 			scb->scsi_cmd->result = DID_OK << 16;
+			break;
 
 		case TEST_UNIT_READY:
 		case INQUIRY:
-- 
2.20.1

