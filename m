Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10205C432C0
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 05:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CDE2120714
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 05:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574400488;
	bh=4UX+CxSvf6A7dtQ3cbPv4or4ULQtD3+cNrsIJxvQDp8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=K4n+2M5t23V2/jo8P9+/tBAFbDj+tknK118t4U2yEcMC6mISWfrCLAQStxxCMQcug
	 UEPkKT8rPSXL8hRTI39yIqI8qkKxOU/3cOu4De91+kwHKb11y6w7GK2MvyAwsqjsUL
	 1numhJU/JrDHPrJT3zb88hbM7aR5Wn7mXBwkEs98=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfKVF1o (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 00:27:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726018AbfKVF1o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 22 Nov 2019 00:27:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 739F120707;
        Fri, 22 Nov 2019 05:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574400463;
        bh=4UX+CxSvf6A7dtQ3cbPv4or4ULQtD3+cNrsIJxvQDp8=;
        h=From:To:Cc:Subject:Date:From;
        b=UBJX3dUm/OaLPvv9GWUAR/fJe4aqN0awv/iKhrHVlLTnNZafj7piw7DBm50ZKmVMb
         pSfo6I7XGyIWXLqBs4hynBOheZM1BykLRyX9clu7YiuwUxiMK69g1pnIWBzRCQOfme
         ivH0lFHpMQRUvGBqUCUOZxAZ4CvcafWgWYC47VBo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        David Disseldorp <ddiss@suse.de>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 001/219] scsi: target/tcmu: Fix queue_cmd_ring() declaration
Date:   Fri, 22 Nov 2019 00:24:03 -0500
Message-Id: <20191122052741.32499-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e7f411049f5164ee6db6c3434c07302846f09990 ]

This patch does not change any functionality but avoids that sparse
complains about the queue_cmd_ring() function and its callers.

Fixes: 6fd0ce79724d ("tcmu: prep queue_cmd_ring to be used by unmap wq")
Reviewed-by: David Disseldorp <ddiss@suse.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 7159e8363b83b..7ee0a75ce4526 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -962,7 +962,7 @@ static int add_to_qfull_queue(struct tcmu_cmd *tcmu_cmd)
  *  0 success
  *  1 internally queued to wait for ring memory to free.
  */
-static sense_reason_t queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, int *scsi_err)
+static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 {
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
 	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
-- 
2.20.1

