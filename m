Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E617C43215
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:13:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1BCA21844
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573920820;
	bh=zwh5o7mR8BrVKGRz7UbRHu5ARyguS0ZtXWsha73MbrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=qcS7iwod0HNxvuxidBzgJXe62xPfypLiXwV3CcDG0oA8GgYLwxY1IdKP5b54efRs8
	 0CFxhmaBE4XRXk9F2WLW/Y30CwvzwJgT93VNn4XQqRWohNGw2GoTOwsQ+d4sK7WsNt
	 V2YYJt4yQmg4HUNJs9eFb3iUkohmmK2KCIbEippg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbfKPPr6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Nov 2019 10:47:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729873AbfKPPr5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Nov 2019 10:47:57 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 54706208D4;
        Sat, 16 Nov 2019 15:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919277;
        bh=zwh5o7mR8BrVKGRz7UbRHu5ARyguS0ZtXWsha73MbrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m4yp5zm85BdUB+V0cHy8jbv7sR3yuf6j7x4Z68xnni5nHcCdSQM/s6HJ4hhF2ykLt
         mfAKlQRITFESCpIfBYQPXdZQCc2J/Xn1Du4P+onA72IGsmX8+bSohCAptWaD+Lpz0k
         7MAzbXv5aGiK+O4nZYKTPAlg0wWONizSRb5no4Wc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 027/150] scsi: ips: fix missing break in switch
Date:   Sat, 16 Nov 2019 10:45:25 -0500
Message-Id: <20191116154729.9573-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154729.9573-1-sashal@kernel.org>
References: <20191116154729.9573-1-sashal@kernel.org>
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
index 67621308eb9ca..ea652f1e2071e 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -3497,6 +3497,7 @@ ips_send_cmd(ips_ha_t * ha, ips_scb_t * scb)
 
 		case START_STOP:
 			scb->scsi_cmd->result = DID_OK << 16;
+			break;
 
 		case TEST_UNIT_READY:
 		case INQUIRY:
-- 
2.20.1

