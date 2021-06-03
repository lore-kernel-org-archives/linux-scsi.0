Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1353C47098
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 17:08:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DE16613F8
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 17:08:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbhFCRJy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 13:09:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231393AbhFCRJx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Jun 2021 13:09:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7519E613FF;
        Thu,  3 Jun 2021 17:08:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622740088;
        bh=d/WeDXI2SiQXWsZKkAp0Kn29WO4HKxpw5LZgqRdHHTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VheBeLsJ6NClcinpcT4AV9BBo0Sxff2bNQej7bL9h2gPzZHtBAqMgKnwDUQeJK9jV
         NbK3WiMjlVCWgiuBUQlCkuRb9lBmbKBPe5ykz5zzAHYYFVzER9SfP2mCNKouotTACn
         dP9aHDJFu7n0DOJ8F0ibmFQObHKbS/iphOV2kWZuoJHuj8pC8qkHfpWvM1J1RWhQ1q
         gXqrVcYB2GEuP2RJp6pCWUzN1723EKjtJF6xDMLJZIc84QIb4MsvuWQvTy8QPjKoF+
         wStQbjKxiwfvEhnuRZAfPSN54CMvuT+gzS9bovQdf84DLWGD20EOZS5jnqG5SpyAr3
         hOEqs4yPz/P6A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Javed Hasan <jhasan@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 27/43] scsi: bnx2fc: Return failure if io_req is already in ABTS processing
Date:   Thu,  3 Jun 2021 13:07:17 -0400
Message-Id: <20210603170734.3168284-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210603170734.3168284-1-sashal@kernel.org>
References: <20210603170734.3168284-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Javed Hasan <jhasan@marvell.com>

[ Upstream commit 122c81c563b0c1c6b15ff76a9159af5ee1f21563 ]

Return failure from bnx2fc_eh_abort() if io_req is already in ABTS
processing.

Link: https://lore.kernel.org/r/20210519061416.19321-1-jhasan@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Javed Hasan <jhasan@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 1a0dc18d6915..ed300a279a38 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -1220,6 +1220,7 @@ int bnx2fc_eh_abort(struct scsi_cmnd *sc_cmd)
 		   was a result from the ABTS request rather than the CLEANUP
 		   request */
 		set_bit(BNX2FC_FLAG_IO_CLEANUP,	&io_req->req_flags);
+		rc = FAILED;
 		goto done;
 	}
 
-- 
2.30.2

