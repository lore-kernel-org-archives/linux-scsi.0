Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9004C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 19:01:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8156B206E6
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 19:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579201308;
	bh=sDHeSNFZTFf/Qdc7mGgk87AI8Jz5FOfYbi9yfRQ7+BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=Ua5fx6rFS4Y+V35VtBZa1gDVBpzyZjGwTHVlji/OMzID1ybvUCIsoVUAvxXTJZG+K
	 T+EdJ89jYScyP0Cwy/0UWFsrTLvmFZEqEJs4LDWHCf0JPan273uqYRTqyh1/nyclQ4
	 XYnectNpSJg4nYoSeknWjrnjhJ/SY0NDig+cc6Ok=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388807AbgAPTBm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 14:01:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:35190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388740AbgAPRFt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Jan 2020 12:05:49 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CAEA2077B;
        Thu, 16 Jan 2020 17:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194348;
        bh=sDHeSNFZTFf/Qdc7mGgk87AI8Jz5FOfYbi9yfRQ7+BY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZMRRmtPIFv3FVd3yDU6e+moqLMh2HfJp/4wPkENpj5O0zV8RHBzSxXZjahVIPqDza
         gXbYi1n7DvqsAj5AlNIYca+x6FJhBhDYmCzH00iO1rMZxOGMnKa1nyi/BUarJ9WvKA
         Kurc9zcEQyJ4pYyJys/ElZuD13X/6MgvX5Wtptt4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Mike Christie <mchristi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 289/671] scsi: target/core: Fix a race condition in the LUN lookup code
Date:   Thu, 16 Jan 2020 11:58:47 -0500
Message-Id: <20200116170509.12787-26-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 63f7479439c95bcd49b7dd4af809862c316c71a3 ]

The rcu_dereference(deve->se_lun) expression occurs twice in the LUN lookup
functions. Since these expressions are not serialized against deve->se_lun
assignments each of these expressions may yield a different result. Avoid
that the wrong LUN pointer is stored in se_cmd by reading deve->se_lun only
once.

Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Fixes: 29a05deebf6c ("target: Convert se_node_acl->device_list[] to RCU hlist") # v4.10
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index e9ff2a7c0c0e..22e97a93728d 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -85,7 +85,7 @@ transport_lookup_cmd_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 			goto out_unlock;
 		}
 
-		se_cmd->se_lun = rcu_dereference(deve->se_lun);
+		se_cmd->se_lun = se_lun;
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
@@ -176,7 +176,7 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 			goto out_unlock;
 		}
 
-		se_cmd->se_lun = rcu_dereference(deve->se_lun);
+		se_cmd->se_lun = se_lun;
 		se_cmd->pr_res_key = deve->pr_res_key;
 		se_cmd->orig_fe_lun = unpacked_lun;
 		se_cmd->se_cmd_flags |= SCF_SE_LUN_CMD;
-- 
2.20.1

