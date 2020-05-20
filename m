Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F6FFC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 13:08:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 076BD20756
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 13:08:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgETNIW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 09:08:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:52430 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726435AbgETNIW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 May 2020 09:08:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 083A6AD11;
        Wed, 20 May 2020 13:08:24 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     Arun Easi <aeasi@marvell.com>, Nilesh Javali <njavali@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Hannes Reinecke <hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Daniel Wagner <dwagner@suse.de>
Subject: [PATCH] qla2xxx: Remove return value from qla_nvme_ls()
Date:   Wed, 20 May 2020 15:08:19 +0200
Message-Id: <20200520130819.90625-1-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function always returns QLA_SUCCESS and the caller
qla2x00_start_sp() doesn't even evalute the return value. So there is
no point in returning a status.

Signed-off-by: Daniel Wagner <dwagner@suse.de>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index b039bd83f947..8865c35d3421 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -3607,11 +3607,10 @@ static void qla2x00_send_notify_ack_iocb(srb_t *sp,
 /*
  * Build NVME LS request
  */
-static int
+static void
 qla_nvme_ls(srb_t *sp, struct pt_ls4_request *cmd_pkt)
 {
 	struct srb_iocb *nvme;
-	int     rval = QLA_SUCCESS;
 
 	nvme = &sp->u.iocb_cmd;
 	cmd_pkt->entry_type = PT_LS4_REQUEST;
@@ -3631,8 +3630,6 @@ qla_nvme_ls(srb_t *sp, struct pt_ls4_request *cmd_pkt)
 	cmd_pkt->rx_byte_count = cpu_to_le32(nvme->u.nvme.rsp_len);
 	cmd_pkt->dsd[1].length = cpu_to_le32(nvme->u.nvme.rsp_len);
 	put_unaligned_le64(nvme->u.nvme.rsp_dma, &cmd_pkt->dsd[1].address);
-
-	return rval;
 }
 
 static void
-- 
2.16.4

