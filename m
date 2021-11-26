Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA19C43217
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Nov 2021 02:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358524AbhKZCoR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 25 Nov 2021 21:44:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:49262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358107AbhKZCmL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 25 Nov 2021 21:42:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E3B961260;
        Fri, 26 Nov 2021 02:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894110;
        bh=WA0RYjt9t3R3xqN95MQc1/7KLR5qSNYVtHNyVr2+xRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtL4H5vv38srvb0nD6QGPJirkveIyS7yiHEV9RUFM1r0u1y/468Cqj5x/vjkuYjcr
         /poxEhMQtmXR0irGsptISZL5dRvy+2+rqJzO3MQZhQ7aQBHDc9ii8kEy7txlaCsutm
         qBzCs79ItIRQ6kLuDwo3IDbluYoO1vGBLHLQevya4+5jZbK3CAqugF5H72HF0QBfkM
         bWobK6pLDKPA6XW1Et/aZgsU0dSDczQ04v+e1g5U5c6V0U/rMrE2fmpoEHV3/aMJaR
         duR2flNPuOSGKS1uJGen0VjuI69tl7uE4WukxyseA+urRmDNmRKuTq6YM26KU8J3cz
         fFb2wZ8CpXGvg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, cleech@redhat.com,
        jejb@linux.ibm.com, open-iscsi@googlegroups.com,
        linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/19] scsi: iscsi: Unblock session then wake up error handler
Date:   Thu, 25 Nov 2021 21:34:42 -0500
Message-Id: <20211126023448.442529-13-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023448.442529-1-sashal@kernel.org>
References: <20211126023448.442529-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit a0c2f8b6709a9a4af175497ca65f93804f57b248 ]

We can race where iscsi_session_recovery_timedout() has woken up the error
handler thread and it's now setting the devices to offline, and
session_recovery_timedout()'s call to scsi_target_unblock() is also trying
to set the device's state to transport-offline. We can then get a mix of
states.

For the case where we can't relogin we want the devices to be in
transport-offline so when we have repaired the connection
__iscsi_unblock_session() can set the state back to running.

Set the device state then call into libiscsi to wake up the error handler.

Link: https://lore.kernel.org/r/20211105221048.6541-2-michael.christie@oracle.com
Reviewed-by: Lee Duncan <lduncan@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_iscsi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 6f21cb75d95fd..f6cce0befa7de 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1894,12 +1894,12 @@ static void session_recovery_timedout(struct work_struct *work)
 	}
 	spin_unlock_irqrestore(&session->lock, flags);
 
-	if (session->transport->session_recovery_timedout)
-		session->transport->session_recovery_timedout(session);
-
 	ISCSI_DBG_TRANS_SESSION(session, "Unblocking SCSI target\n");
 	scsi_target_unblock(&session->dev, SDEV_TRANSPORT_OFFLINE);
 	ISCSI_DBG_TRANS_SESSION(session, "Completed unblocking SCSI target\n");
+
+	if (session->transport->session_recovery_timedout)
+		session->transport->session_recovery_timedout(session);
 }
 
 static void __iscsi_unblock_session(struct work_struct *work)
-- 
2.33.0

