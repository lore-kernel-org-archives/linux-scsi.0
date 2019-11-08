Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FF4FC6197
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 12:05:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24A9721D7B
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 12:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573214750;
	bh=Pinh2lC8WS7vzQoxxDgtlVIhQsObFr0h8M7YlCl6gbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=MXWY2PScvnwAD7BARHoYNvrU8mul4U54VWlLBQ6jm2QJfwVabExIpAIp9zpKfFSQ6
	 C6MgbvpndAEJu5dkQx0pBaxyNCctVs8YyuUdA1AI8YTgl5pRcNGaOpAoUf+1mn1cVU
	 4+Oi1SYOKE48PFkqtaAJ2BVS1DVqvMV/BZxwMaf4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390934AbfKHMFt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:05:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389436AbfKHLlZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AE31222CE;
        Fri,  8 Nov 2019 11:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213284;
        bh=Pinh2lC8WS7vzQoxxDgtlVIhQsObFr0h8M7YlCl6gbw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fyir4GRVh2PtQy6cWiqycjOAbNdefRr0pkBStaqAvHPBwfpn4R4jD90K0Z8hb9OqQ
         lY0kRZeFkMHmFniANZHVY40cc57EG5cUPhHdubR8Qq14dxwvQeRqXq/RJP2KhFSYTQ
         +xvyViVYNaGUNelFYu5iHNr9a9HMQCK1+nTKf3FM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 145/205] scsi: qla2xxx: Fix dropped srb resource.
Date:   Fri,  8 Nov 2019 06:36:52 -0500
Message-Id: <20191108113752.12502-145-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Quinn Tran <quinn.tran@cavium.com>

[ Upstream commit 527b8ae3948bb59c13ebaa7d657ced56ea25ab05 ]

When FW rejects a command due to "entry_status" error (malform IOCB), the srb
resource needs to be returned back for cleanup.  The filter to catch this is
in the wrong location.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index f559beda8d5ad..8fa7242dbb437 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2837,6 +2837,7 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	case ELS_IOCB_TYPE:
 	case ABORT_IOCB_TYPE:
 	case MBX_IOCB_TYPE:
+	default:
 		sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 		if (sp) {
 			sp->done(sp, res);
@@ -2847,7 +2848,6 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	case ABTS_RESP_24XX:
 	case CTIO_TYPE7:
 	case CTIO_CRC2:
-	default:
 		return 1;
 	}
 fatal:
-- 
2.20.1

