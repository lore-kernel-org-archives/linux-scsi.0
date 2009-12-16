From: Yong Zhang <yong.zhang0@gmail.com>
Subject: [PATCH 5/5] aha152x: use DECLARE_COMPLETION_ONSTACK for non-constant completion
Date: Wed, 16 Dec 2009 22:36:01 +0800
Message-ID: <1260974161-6934-6-git-send-email-yong.zhang0@gmail.com>
References: <1260974161-6934-1-git-send-email-yong.zhang0@gmail.com>
 <1260974161-6934-2-git-send-email-yong.zhang0@gmail.com>
 <1260974161-6934-3-git-send-email-yong.zhang0@gmail.com>
 <1260974161-6934-4-git-send-email-yong.zhang0@gmail.com>
 <1260974161-6934-5-git-send-email-yong.zhang0@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:59843 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762170AbZLPOgu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2009 09:36:50 -0500
In-Reply-To: <1260974161-6934-5-git-send-email-yong.zhang0@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "Juergen E. Fischer" <fischer@norbit.de>, "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

The _ONSTACK variant should be used for on-stack completion,
otherwise it will break lockdep.

Signed-off-by: Yong Zhang <yong.zhang0@gmail.com>
Cc: Juergen E. Fischer <fischer@norbit.de>
Cc: James E.J. Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/aha152x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 1e5478a..44e43b5 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -1143,7 +1143,7 @@ static int aha152x_abort(Scsi_Cmnd *SCpnt)
 static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
 {
 	struct Scsi_Host *shpnt = SCpnt->device->host;
-	DECLARE_COMPLETION(done);
+	DECLARE_COMPLETION_ONSTACK(done);
 	int ret, issued, disconnected;
 	unsigned char old_cmd_len = SCpnt->cmd_len;
 	unsigned long flags;
-- 
1.6.3.3

