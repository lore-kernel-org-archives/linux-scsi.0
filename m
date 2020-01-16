Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73FDAC33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 18:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5088D206D9
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 18:26:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579199195;
	bh=CA0r0opEyIAcHEotkbR1xt2RU1tHCJWPsAFIyqh/TCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=vQ7YGrH1DaHfy1sjqO2lqvjQQyaOvz45fscWTnVqEd2kQbrSwDNP6DkrM8oR8EhWt
	 SWWMYi1IqwTutPCkz7Qjh3X593715ZyB/fPlLBVAfYnmJS7/bU+QEmEngrAPQJ4mqt
	 tJuVlAg16ykae9aSS8k4RzO+xhrlisR6zLMpWCfo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436616AbgAPS0e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 13:26:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:35640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404001AbgAPR0j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jan 2020 12:26:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D7A22468D;
        Thu, 16 Jan 2020 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579195599;
        bh=CA0r0opEyIAcHEotkbR1xt2RU1tHCJWPsAFIyqh/TCU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oopv+xbtA+V3skc4mfoakTZbx32COoI3WjhXaB/hM4K3ZzBvGe6JSRtvQk6V5UVlG
         FmBlVQ+Y62PnlzH7mJ+eWjXD4v8Hh/9f9VvDlqh1qxo01u93w+wGgi6PVk2kiVbRP8
         Izq3scjLVuV+YK6BHr//RaPBkSxjefuIEpb4zJOY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Himanshu Madhani <hmadhani@marvell.com>,
        Giridhar Malavali <gmalavali@marvell.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 175/371] scsi: qla2xxx: Avoid that qlt_send_resp_ctio() corrupts memory
Date:   Thu, 16 Jan 2020 12:20:47 -0500
Message-Id: <20200116172403.18149-118-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116172403.18149-1-sashal@kernel.org>
References: <20200116172403.18149-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit a861b49273578e255426a499842cf7f465456351 ]

The "(&ctio->u.status1.sense_data)[i]" where i >= 0 expressions in
qlt_send_resp_ctio() are probably typos and should have been
"(&ctio->u.status1.sense_data[4 * i])" instead. Instead of only fixing
these typos, modify the code for storing sense data such that it becomes
easy to read. This patch fixes a Coverity complaint about accessing an
array outside its bounds.

Cc: Himanshu Madhani <hmadhani@marvell.com>
Cc: Giridhar Malavali <gmalavali@marvell.com>
Fixes: be25152c0d9e ("qla2xxx: Improve T10-DIF/PI handling in driver.") # v4.11.
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Acked-by: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index 1000422ef4f8..21011c5fddeb 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -2122,14 +2122,14 @@ void qlt_send_resp_ctio(struct qla_qpair *qpair, struct qla_tgt_cmd *cmd,
 		ctio->u.status1.scsi_status |=
 		    cpu_to_le16(SS_RESIDUAL_UNDER);
 
-	/* Response code and sense key */
-	put_unaligned_le32(((0x70 << 24) | (sense_key << 8)),
-	    (&ctio->u.status1.sense_data)[0]);
+	/* Fixed format sense data. */
+	ctio->u.status1.sense_data[0] = 0x70;
+	ctio->u.status1.sense_data[2] = sense_key;
 	/* Additional sense length */
-	put_unaligned_le32(0x0a, (&ctio->u.status1.sense_data)[1]);
+	ctio->u.status1.sense_data[7] = 0xa;
 	/* ASC and ASCQ */
-	put_unaligned_le32(((asc << 24) | (ascq << 16)),
-	    (&ctio->u.status1.sense_data)[3]);
+	ctio->u.status1.sense_data[12] = asc;
+	ctio->u.status1.sense_data[13] = ascq;
 
 	/* Memory Barrier */
 	wmb();
-- 
2.20.1

