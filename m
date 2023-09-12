Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB4FCA0ECF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 02:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236722AbjILCIC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 22:08:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237192AbjILCCB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 22:02:01 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5699A1A39B6;
        Mon, 11 Sep 2023 18:32:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647B8C32794;
        Tue, 12 Sep 2023 00:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694480228;
        bh=rdBLpZr0nte9cBd9BX1sL7lfQw3Y7w0fgD+Dbtdw+H0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWa8BEgsBswvonlZxZjVc/6V6Nwuz1bAvQGQy3r4sSKqUWSVoA2bIEX2aVO1yFw2K
         lA7h7eIoP2W8gWGh5xK5UI/l3onF/JKbmRcG1+M8g83zUDdNVPRw5SqmMUMHbsvwDp
         SOZqNss3BGOeB08bzpgrJ+cNYSc2UzJY+xlA2Rp6T87S8nKih1s7WUH6oaMIOHDZS6
         SofDU81SkKzvibuYw5m8r5sVwPhdZw8mnq3hMW9HzXN+zio1p3erYbUVB4XaVSkUlF
         p9YeZFZg5OXaNdSlK7ls5OwxkZjiTR6Ri9yLUGzNqeXutWIB5bDAzxJCQ3LkRA5c6T
         HVGnYB0qh83bQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH v2 07/21] scsi: sd: Do not issue commands to suspended disks on remove
Date:   Tue, 12 Sep 2023 09:56:41 +0900
Message-ID: <20230912005655.368075-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230912005655.368075-1-dlemoal@kernel.org>
References: <20230912005655.368075-1-dlemoal@kernel.org>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
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

