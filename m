Return-Path: <SRS0=XSNP=53=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE20EC2BA19
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 23:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E77F20787
	for <linux-scsi@archiver.kernel.org>; Sat, 11 Apr 2020 23:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586648092;
	bh=GoiEiaxMkSmC3deUYvrLpIzfI0ZOZrg8e1NxkKqlHEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=mYFfIj7Llgi/UNmLKpKU0jydiIISvalv/P7/2twz1BPAuXFf/aPMDgHDE+PJfDz+i
	 YkCMmkshzg9ddMuFIfN4NTPV/p0nvIaRenuvBLEsrzKKpPJqQzmjHfGcsLZPI6OeAi
	 udKCHGZO0Xa57m8Su6B0azTOHOAGW9+4+YO3N954=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727664AbgDKXev (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 11 Apr 2020 19:34:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:46798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729146AbgDKXJN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 11 Apr 2020 19:09:13 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 987C520787;
        Sat, 11 Apr 2020 23:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586646553;
        bh=GoiEiaxMkSmC3deUYvrLpIzfI0ZOZrg8e1NxkKqlHEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5EJwZPf0t4bDPt6ANKQRrTP6M//gkj0Rv0GfqFcE/xjKyh3wDOz7mDO6/OJifpPK
         MgUvWJmobwukLr2bfpUYwgvlsbT//QbTqTahO6omhpFBNDRlATSV8PSt/YxpntLDBY
         l97L1RbZeGDB9DqtVOD0BjhH1b5ZQ2BoHjJlJ43I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Himanshu Madhani <hmadhani@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 103/121] scsi: qla2xxx: Add fixes for mailbox command
Date:   Sat, 11 Apr 2020 19:06:48 -0400
Message-Id: <20200411230706.23855-103-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200411230706.23855-1-sashal@kernel.org>
References: <20200411230706.23855-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Himanshu Madhani <hmadhani@marvell.com>

[ Upstream commit 345f574dac85276d1471492c6e90c57e3f90a4f3 ]

This patch fixes:

- qla2x00_issue_iocb_timeout will now return if chip is down

- only check for sp->qpair in abort handling

Link: https://lore.kernel.org/r/20200212214436.25532-24-hmadhani@marvell.com
Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_mbx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
index 9e09964f5c0e4..f0846ce0c4da4 100644
--- a/drivers/scsi/qla2xxx/qla_mbx.c
+++ b/drivers/scsi/qla2xxx/qla_mbx.c
@@ -1405,6 +1405,9 @@ qla2x00_issue_iocb_timeout(scsi_qla_host_t *vha, void *buffer,
 	mbx_cmd_t	mc;
 	mbx_cmd_t	*mcp = &mc;
 
+	if (qla2x00_chip_is_down(vha))
+		return QLA_INVALID_COMMAND;
+
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x1038,
 	    "Entered %s.\n", __func__);
 
@@ -1475,7 +1478,7 @@ qla2x00_abort_command(srb_t *sp)
 	ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x103b,
 	    "Entered %s.\n", __func__);
 
-	if (vha->flags.qpairs_available && sp->qpair)
+	if (sp->qpair)
 		req = sp->qpair->req;
 	else
 		req = vha->req;
-- 
2.20.1

