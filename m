Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3629AE8FDDE
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 08:58:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241855AbjJDI6I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 04:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbjJDI6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 04:58:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 682F7A6;
        Wed,  4 Oct 2023 01:58:05 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640A4C433C7;
        Wed,  4 Oct 2023 08:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696409885;
        bh=kaUcGXGYsxr4dX4XEVnR9qTr7F181aGeqx7apSckpUk=;
        h=From:To:Cc:Subject:Date:From;
        b=rFSLAVyu5Ug8LIABDlehtbtllCyvihcLuDYMyYhF6viv+XG2VCZu3wOJtch/1otsp
         KO/Dck3sxvUM4NtvaP7/uKclqkhbe259jZ3wQjwalWSq2sPrMe6ZXsg8xvWIrcCgoJ
         PrCyO5OiWfVcJ8oiqZkdQ8EBJWKlAyjEvgTRLC+RO608KwDJB9vkW1z1ZO2N9Vs+ox
         JBl7yqflDHWNCLIvh0AW2G57Vos/uNu44MCUh1iS3ZENkzwRNkOYjr0bdxpHbqtKGX
         7DHbbuOHQV7MDxN+k8RtyDHVHV3rxdx/zX4X0IFZH743UbBk1AKdtQdD5W+va6QBEv
         mmJ5iN63W2a0w==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Cc:     Petr Tesarik <petr@tesarici.cz>
Subject: [PATCH] scsi: Do not rescan devices with a suspended queue
Date:   Wed,  4 Oct 2023 17:58:03 +0900
Message-ID: <20231004085803.130722-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit ff48b37802e5 ("scsi: Do not attempt to rescan suspended devices")
modified scsi_rescan_device() to avoid attempting rescanning a suspended
device. However, the modification added a check to verify that a SCSI
device is in the running state without checking if the device request
queue (in the case of block device) is also running, thus allowing the
exectuion of internal requests. Without checking the device request
queue, commit ff48b37802e5 fix is incomplete and deadlocks on resume can
still happen. Use blk_queue_pm_only() to check if the device request
queue allows executing commands in addition to checking the SCSI device
state.

Reported-by: Petr Tesarik <petr@tesarici.cz>
Fixes: ff48b37802e5 ("scsi: Do not attempt to rescan suspended devices")
Cc: stable@vger.kernel.org
Tested-by: Petr Tesarik <petr@tesarici.cz>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/scsi_scan.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 3db4d31a03a1..b05a55f498a2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1627,12 +1627,13 @@ int scsi_rescan_device(struct scsi_device *sdev)
 	device_lock(dev);
 
 	/*
-	 * Bail out if the device is not running. Otherwise, the rescan may
-	 * block waiting for commands to be executed, with us holding the
-	 * device lock. This can result in a potential deadlock in the power
-	 * management core code when system resume is on-going.
+	 * Bail out if the device or its queue are not running. Otherwise,
+	 * the rescan may block waiting for commands to be executed, with us
+	 * holding the device lock. This can result in a potential deadlock
+	 * in the power management core code when system resume is on-going.
 	 */
-	if (sdev->sdev_state != SDEV_RUNNING) {
+	if (sdev->sdev_state != SDEV_RUNNING ||
+	    blk_queue_pm_only(sdev->request_queue)) {
 		ret = -EWOULDBLOCK;
 		goto unlock;
 	}
-- 
2.41.0

