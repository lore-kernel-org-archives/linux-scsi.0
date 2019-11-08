Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 933C8C5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 12:06:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A4BF21924
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 12:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573214779;
	bh=/NQtkOkpEuUWMY3f+/lnoDmUzsLbRI5O/I0APk7Ai9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wP+ReyEqk/+5oTR/vr6pzKkEkzhonzIvyIGkx+hIVLQADtBw186JgZkbDo9DUAKiN
	 qsstSA7Xnm4qQOUvdNG9e9PJMa21TVJpBZ0lgQFCrtZwW+WjG47TUBy+fXze4G75pT
	 2Xhp3Je3AKdA1s0cSOyfTpjdtiNmUgv5n6QpcbZo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390449AbfKHMGP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 07:06:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:54584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389331AbfKHLlT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 8 Nov 2019 06:41:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 89AF02245A;
        Fri,  8 Nov 2019 11:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213279;
        bh=/NQtkOkpEuUWMY3f+/lnoDmUzsLbRI5O/I0APk7Ai9Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l2zF4KkC1Y45HJKMBm7grLGzbXHyjb0+4gxMABeNZRrzZnmajHJykYfVBmzPiPeQp
         tpEEjx+nmYb6PG34NVCN5axiI45pu/HDttj92Ll13MwIGM6na+1ofHpe+3TnZZW5r4
         IsYhV8OW2uPDFotWeAh21BR+oNc5YFaSA/cy/2Po=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Quinn Tran <quinn.tran@cavium.com>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 140/205] scsi: qla2xxx: Terminate Plogi/PRLI if WWN is 0
Date:   Fri,  8 Nov 2019 06:36:47 -0500
Message-Id: <20191108113752.12502-140-sashal@kernel.org>
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

[ Upstream commit aa9e6d7b9643fc50a88c7b7aa1e34be8dc032749 ]

When driver receive PLOGI/PRLI from FW, the WWPN value will be provided.  If
it is not, then driver will terminate it.  The WWPN allows driver to locate
the session or create a new session.

Signed-off-by: Quinn Tran <quinn.tran@cavium.com>
Signed-off-by: Himanshu Madhani <himanshu.madhani@cavium.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index d6dc320f81a7a..078d124533247 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -4703,6 +4703,12 @@ static int qlt_handle_login(struct scsi_qla_host *vha,
 		sess = qlt_find_sess_invalidate_other(vha, wwn,
 		    port_id, loop_id, &conflict_sess);
 		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
+	} else {
+		ql_dbg(ql_dbg_disc, vha, 0xffff,
+		    "%s %d Term INOT due to WWN=0 lid=%d, NportID %06X ",
+		    __func__, __LINE__, loop_id, port_id.b24);
+		qlt_send_term_imm_notif(vha, iocb, 1);
+		goto out;
 	}
 
 	if (IS_SW_RESV_ADDR(port_id)) {
-- 
2.20.1

