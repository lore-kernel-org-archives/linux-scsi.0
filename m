Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4282EFA372C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 11:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0464A215EA
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 11:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573214289;
	bh=j0vVPIXMypYqTEMvMdKlvJ6+YOCotT63Oz/wwCbmGG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=rGfEW361J8d22BvaEH2eK1mkX3s4yiKSJMSSC4DO3EVT9p8H6GysNLx7L3CEmeoDP
	 IVKkX3M4RQik20Vf3G4ol2OzXANuv+aTnqiASWAty4DZoiHjDMO7jVC2GS2mApPlim
	 mmZmzuS+5muxyVQQApGR7y/uWSUtM7svSWJcyOpo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390041AbfKHL6C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 06:58:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:59894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390915AbfKHLov (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Nov 2019 06:44:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BB5721D7B;
        Fri,  8 Nov 2019 11:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213490;
        bh=j0vVPIXMypYqTEMvMdKlvJ6+YOCotT63Oz/wwCbmGG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D1b0ht+Mj4t5TCBTOgrHXB3DhnZwrGnHLR0UuSpVrJyF+ssI1bYNTi/niLnHfs/78
         Y1iNpqQIHZAluZ6Mn3AuIsycsFSSg0e3iqTPuN8ovnCxRaps6rA1TXvwurmatYJs8x
         R3iak3f/zWKLdnnxuRxtYpKN/y2frcn6nEPPbeQI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 070/103] scsi: qla2xxx: Fix dropped srb resource.
Date:   Fri,  8 Nov 2019 06:42:35 -0500
Message-Id: <20191108114310.14363-70-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108114310.14363-1-sashal@kernel.org>
References: <20191108114310.14363-1-sashal@kernel.org>
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
index df94ef816826b..6a76d72175154 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -2792,6 +2792,7 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	case ELS_IOCB_TYPE:
 	case ABORT_IOCB_TYPE:
 	case MBX_IOCB_TYPE:
+	default:
 		sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 		if (sp) {
 			sp->done(sp, res);
@@ -2802,7 +2803,6 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	case ABTS_RESP_24XX:
 	case CTIO_TYPE7:
 	case CTIO_CRC2:
-	default:
 		return 1;
 	}
 fatal:
-- 
2.20.1

