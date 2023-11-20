Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D33C54FB9
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Nov 2023 07:35:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjKTHfc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Nov 2023 02:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjKTHfb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Nov 2023 02:35:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6736BD5E
        for <linux-scsi@vger.kernel.org>; Sun, 19 Nov 2023 23:35:27 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FDBC433C9;
        Mon, 20 Nov 2023 07:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700465727;
        bh=EQX3/86Vv7wsbEi0uJlh+x4Ip/sHKdTdinG04g68vnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMDPwLaqWx+43lBopoaZYnAPyOtD8iVJl7aguzFefR1s233vbnfOv209F2dpdp5E4
         hLZp+GOidk6b/0DSWYLbfla/UsxK+9TDQPCKSB4WRbqZyLLCaPDfdduv50H6gKYv7Z
         O9WtsMeDNlFqcJq0TRnusoWY9NDeFSiDTnxSl8jVChyRLorevmoJGBwy8rwhcguurB
         fSnZG35OHECZjyL1O88h+ZOG9M4dbx3hmWuqR/glpaicgcUhkxRO1ggaiZ0ZDVYASR
         1j4wCQHGKgKkDTEnycSM7+KqL+TBF3ZNzYly1yBM3H3b2CF9tvNqCiQ2R6TFmQ2vfL
         IpOAT5mwgq1Qw==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Phillip Susi <phill@thesusis.net>
Subject: [PATCH 1/2] scsi: Change scsi device boolean fields to single bit flags
Date:   Mon, 20 Nov 2023 16:35:21 +0900
Message-ID: <20231120073522.34180-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231120073522.34180-1-dlemoal@kernel.org>
References: <20231120073522.34180-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 3cc2ffe5c16d ("scsi: sd: Differentiate system and runtime
start/stop management") changed the single bit manage_start_stop flag
into 2 boolean fields of the SCSI device structure. Commit 24eca2dce0f8
("scsi: sd: Introduce manage_shutdown device flag") introduced the
manage_shutdown boolean field for the same structure. Together, these 2
commits increase the size of struct scsi_device by 8 bytes by using
booleans instead of defining the manage_xxx fields as single bit flags,
similarly to other flags of this structure.

Avoid this unnecessary structure size increase and be consistent with
the definition of other flags by reverting the definitions of the
manage_xxx fields as single bit flags.

Fixes: 3cc2ffe5c16d ("scsi: sd: Differentiate system and runtime start/stop management")
Fixes: 24eca2dce0f8 ("scsi: sd: Introduce manage_shutdown device flag")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/libata-scsi.c  | 4 ++--
 drivers/firewire/sbp2.c    | 6 +++---
 include/scsi/scsi_device.h | 6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index c10ff8985203..63317449f6ea 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1056,8 +1056,8 @@ int ata_scsi_dev_config(struct scsi_device *sdev, struct ata_device *dev)
 		 * and resume and shutdown only. For system level suspend/resume,
 		 * devices power state is handled directly by libata EH.
 		 */
-		sdev->manage_runtime_start_stop = true;
-		sdev->manage_shutdown = true;
+		sdev->manage_runtime_start_stop = 1;
+		sdev->manage_shutdown = 1;
 	}
 
 	/*
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 7edf2c95282f..e779d866022b 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1519,9 +1519,9 @@ static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
 	sdev->use_10_for_rw = 1;
 
 	if (sbp2_param_exclusive_login) {
-		sdev->manage_system_start_stop = true;
-		sdev->manage_runtime_start_stop = true;
-		sdev->manage_shutdown = true;
+		sdev->manage_system_start_stop = 1;
+		sdev->manage_runtime_start_stop = 1;
+		sdev->manage_shutdown = 1;
 	}
 
 	if (sdev->type == TYPE_ROM)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 10480eb582b2..1fb460dfca0c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -167,19 +167,19 @@ struct scsi_device {
 	 * power state for system suspend/resume (suspend to RAM and
 	 * hibernation) operations.
 	 */
-	bool manage_system_start_stop;
+	unsigned manage_system_start_stop:1;
 
 	/*
 	 * If true, let the high-level device driver (sd) manage the device
 	 * power state for runtime device suspand and resume operations.
 	 */
-	bool manage_runtime_start_stop;
+	unsigned manage_runtime_start_stop:1;
 
 	/*
 	 * If true, let the high-level device driver (sd) manage the device
 	 * power state for system shutdown (power off) operations.
 	 */
-	bool manage_shutdown;
+	unsigned manage_shutdown:1;
 
 	unsigned removable:1;
 	unsigned changed:1;	/* Data invalid due to media change */
-- 
2.42.0

