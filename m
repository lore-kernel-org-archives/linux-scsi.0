Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1F14C433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 16:25:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 944B261399
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Apr 2021 16:25:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244525AbhDLQ0P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Apr 2021 12:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:57688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243966AbhDLQYs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Apr 2021 12:24:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C5216137E;
        Mon, 12 Apr 2021 16:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618244669;
        bh=66NdWp2CtQXh24sKJMkxOfxG01+moLWkPVs3IXI9yzM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AqY00+Veinz79JLmtR4CbAjLuGcTyxDH2Jg8NmFJ0/7q5eocgPwJcig/sYjlDhOXP
         95xyqjlf8/VjehTAAI0eb946XpuIN9wAwGtXg9kDgPT9xnxQIAmPxbWHXpZUSLiGed
         /LDTbTE/JPWYY9LpOXUx19bNrSxqhQy3LlgipJXTFhHeWUJfhYARgZbGsdqFCOvUO+
         /8Ln4rEFx/DLox2KRj2ZI5qTfxq8dfWhsyhCFdmiT57MGClHkqbYHnkJSwlrkKBtvG
         gaf2m0pyHEt9FbrbHxEZ5UYdN8jxg9MWhAfdVO74PVa47/e7zsnwXuM10hrNlnOl5A
         KKjPamNfcNfww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Martin Wilck <mwilck@suse.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 22/46] scsi: scsi_transport_srp: Don't block target in SRP_PORT_LOST state
Date:   Mon, 12 Apr 2021 12:23:37 -0400
Message-Id: <20210412162401.314035-22-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210412162401.314035-1-sashal@kernel.org>
References: <20210412162401.314035-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Martin Wilck <mwilck@suse.com>

[ Upstream commit 5cd0f6f57639c5afbb36100c69281fee82c95ee7 ]

rport_dev_loss_timedout() sets the rport state to SRP_PORT_LOST and the
SCSI target state to SDEV_TRANSPORT_OFFLINE. If this races with
srp_reconnect_work(), a warning is printed:

Mar 27 18:48:07 ictm1604s01h4 kernel: dev_loss_tmo expired for SRP port-18:1 / host18.
Mar 27 18:48:07 ictm1604s01h4 kernel: ------------[ cut here ]------------
Mar 27 18:48:07 ictm1604s01h4 kernel: scsi_internal_device_block(18:0:0:100) failed: ret = -22
Mar 27 18:48:07 ictm1604s01h4 kernel: Call Trace:
Mar 27 18:48:07 ictm1604s01h4 kernel:  ? scsi_target_unblock+0x50/0x50 [scsi_mod]
Mar 27 18:48:07 ictm1604s01h4 kernel:  starget_for_each_device+0x80/0xb0 [scsi_mod]
Mar 27 18:48:07 ictm1604s01h4 kernel:  target_block+0x24/0x30 [scsi_mod]
Mar 27 18:48:07 ictm1604s01h4 kernel:  device_for_each_child+0x57/0x90
Mar 27 18:48:07 ictm1604s01h4 kernel:  srp_reconnect_rport+0xe4/0x230 [scsi_transport_srp]
Mar 27 18:48:07 ictm1604s01h4 kernel:  srp_reconnect_work+0x40/0xc0 [scsi_transport_srp]

Avoid this by not trying to block targets for rports in SRP_PORT_LOST
state.

Link: https://lore.kernel.org/r/20210401091105.8046-1-mwilck@suse.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_srp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 1e939a2a387f..98a34ed10f1a 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -541,7 +541,7 @@ int srp_reconnect_rport(struct srp_rport *rport)
 	res = mutex_lock_interruptible(&rport->mutex);
 	if (res)
 		goto out;
-	if (rport->state != SRP_RPORT_FAIL_FAST)
+	if (rport->state != SRP_RPORT_FAIL_FAST && rport->state != SRP_RPORT_LOST)
 		/*
 		 * sdev state must be SDEV_TRANSPORT_OFFLINE, transition
 		 * to SDEV_BLOCK is illegal. Calling scsi_target_unblock()
-- 
2.30.2

