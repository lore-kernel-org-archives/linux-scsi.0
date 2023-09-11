Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7378C71153
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 04:02:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbjIKECq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 00:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjIKECi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 00:02:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76F9AD2;
        Sun, 10 Sep 2023 21:02:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1A87C433C9;
        Mon, 11 Sep 2023 04:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694404954;
        bh=pk3mewJpWExrKyWLQE9wo66o0OVhniKxzuiOqrDYPbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vGeVIB4nlnifw7z3bAFKu5M4i8j1C8+19FuCZBKY1ETajPoxMBZT5vzIFnnsxpV2f
         0DJTvrbmaa1WXZeg0kn6gZat9P173uPpLdv+K/tEvOw8qe62Os/FK4RhrCFgLnapKq
         OizECdbF+F65a6a8JgaDNWSu6surOCha9gfAtk5DZALFvsi/XHazUQF1HdGiK1ndS3
         stpz+9XblyeG87yKM2bMZNZALyR04lYfyvivndDz9u/psQHcQovkqrWj8R5RSkYk3v
         up9isQKP9hjPeYxzBmTsf8VV8ZChoBDlL8sWOFfJkgia22bxCfS10get941OrWOInU
         +Iy43s/8qNeEQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH 07/19] scsi: sd: Do not issue commands to suspended disks on remove
Date:   Mon, 11 Sep 2023 13:02:05 +0900
Message-ID: <20230911040217.253905-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230911040217.253905-1-dlemoal@kernel.org>
References: <20230911040217.253905-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If an error occurs when resuming a host adapter before the devices
attached to the adapter are resumed, the adapter low level driver may
remove the scsi host, resulting in a call to sd_remove() for the
disks of the host. However, since this function calls sd_shutdown(),
a synchronize cache command and a start stop unit may be issued with the
drive still sleeping and the HBA non-functional. This causes PM resume
to hang, forcing a reset of the machine to recover.

Fix this by checking a device host state in sd_shutdown() and by
returning early doing nothing if the host state is not SHOST_RUNNING.

Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c92a317ba547..a415abb721d3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3763,7 +3763,8 @@ static void sd_shutdown(struct device *dev)
 	if (!sdkp)
 		return;         /* this can happen */
 
-	if (pm_runtime_suspended(dev))
+	if (pm_runtime_suspended(dev) ||
+	    sdkp->device->host->shost_state != SHOST_RUNNING)
 		return;
 
 	if (sdkp->WCE && sdkp->media_present) {
-- 
2.41.0

