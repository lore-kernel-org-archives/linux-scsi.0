Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A41CDB482
	for <linux-scsi@archiver.kernel.org>; Sun, 15 Oct 2023 05:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233489AbjJOFPR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 15 Oct 2023 01:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjJOFPQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 15 Oct 2023 01:15:16 -0400
X-Greylist: delayed 493 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 14 Oct 2023 22:15:14 PDT
Received: from smtp.infotech.no (smtp.infotech.no [82.134.31.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 517F8B7
        for <linux-scsi@vger.kernel.org>; Sat, 14 Oct 2023 22:15:14 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 1AFED20418A;
        Sun, 15 Oct 2023 07:07:00 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id uYDknAcg0UVe; Sun, 15 Oct 2023 07:06:53 +0200 (CEST)
Received: from treten.bingwo.ca (host-104-157-209-188.dyn.295.ca [104.157.209.188])
        by smtp.infotech.no (Postfix) with ESMTPA id 45CE5204165;
        Sun, 15 Oct 2023 07:06:51 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH] scsi: depopulation and restoration in progress
Date:   Sun, 15 Oct 2023 01:06:50 -0400
Message-Id: <20231015050650.131145-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The default handling of the NOT READY sense key is to wait
for the device to become ready. The "wait" is assumed to
be relatively short. However there is a sub-class of NOT
READY that have the "... in progress" phrase in their
additional sense code and these can take much longer.
Following on from commit 505aa4b6a8834 we now have element
depopulation and restoration that can take a long time.
For example, over 24 hours for a 20 TB, 7200 rpm hard
disk to depopulate 1 of its 20 elements.

Add handling of asc/ascq: 0x4,0x24 (depopulation in progress)
and asc/ascq: 0x4,0x25 (depopulation restoration in progress)
to sd.c . The scsi_lib.c has incomplete handling of these
two messages, so complete it.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_lib.c | 1 +
 drivers/scsi/sd.c       | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c2f647a7c1b0..9adde7d9830a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -774,6 +774,7 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 				case 0x1b: /* sanitize in progress */
 				case 0x1d: /* configuration in progress */
 				case 0x24: /* depopulation in progress */
+				case 0x25: /* depopulation restore in progress */
 					action = ACTION_DELAYED_RETRY;
 					break;
 				case 0x0a: /* ALUA state transition */
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c92a317ba547..519baef237f3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2224,6 +2224,10 @@ sd_spinup_disk(struct scsi_disk *sdkp)
 				break;	/* unavailable */
 			if (sshdr.asc == 4 && sshdr.ascq == 0x1b)
 				break;	/* sanitize in progress */
+			if (sshdr.asc == 4 && sshdr.ascq == 0x24)
+				break;	/* depopulation in progress */
+			if (sshdr.asc == 4 && sshdr.ascq == 0x25)
+				break;	/* depopulation restoration in progress */
 			/*
 			 * Issue command to spin up drive when not ready
 			 */
-- 
2.40.1

