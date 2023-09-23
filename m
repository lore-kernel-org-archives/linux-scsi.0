Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E0BCCE7A89
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Sep 2023 00:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjIWAaM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Sep 2023 20:30:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjIWA37 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2023 20:29:59 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A6E1A8;
        Fri, 22 Sep 2023 17:29:53 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB526C433C9;
        Sat, 23 Sep 2023 00:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695428993;
        bh=DsNALLFTsA/yo3xIe7lsle6aQCXo9hgI82ahTtxIcZA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jzKmfiazF1Oeb6sC2oHb9eg0zo3s6O8OB36hB54woWDYT2qpUEufknMDsQ023cUZ0
         MA2p8mOzwiBUIbPG7i8L+Mu8iPW2XPXOZKXh58t1ikS4FH73skJtVOlZ+aSa+cqo8C
         avSI7iCd1Wlal3cz8pqfYO+cUvONOXB6dR0tfpycjFXSEsUSPilv1P03lx3tdcdkfO
         8GqsDENI6RRfWGLJTUbX76y7M45zwSuWBcjPh9PjASSN220pVZI7tRDLpY0dZ2OOf4
         UFdTolumbykuFAXLwLnhRmddnKsRNjKd5W9kX42fYMKYjP22Mzii61b5gxdkkivxKh
         yHzkr0hX552OA==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: [PATCH v6 12/23] scsi: Remove scsi device no_start_on_resume flag
Date:   Sat, 23 Sep 2023 09:29:21 +0900
Message-ID: <20230923002932.1082348-13-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230923002932.1082348-1-dlemoal@kernel.org>
References: <20230923002932.1082348-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The scsi device flag no_start_on_resume is not set by any scsi low
level driver. Remove it. This reverts the changes introduced by commit
0a8589055936 ("ata,scsi: do not issue START STOP UNIT on resume").

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c          | 13 ++++---------
 include/scsi/scsi_device.h |  1 -
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index bff8663be7e0..e372834bf56f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3900,20 +3900,15 @@ static int sd_resume(struct device *dev, bool runtime)
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
 
-	if (!sd_do_start_stop(sdkp->device, runtime)) {
-		sdkp->suspended = 0;
-		return 0;
-	}
-
-	if (!sdkp->device->no_start_on_resume) {
+	if (sd_do_start_stop(sdkp->device, runtime)) {
 		sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 		ret = sd_start_stop_device(sdkp, 1);
+		if (!ret)
+			opal_unlock_from_suspend(sdkp->opal_dev);
 	}
 
-	if (!ret) {
-		opal_unlock_from_suspend(sdkp->opal_dev);
+	if (!ret)
 		sdkp->suspended = 0;
-	}
 
 	return ret;
 }
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index b7df1e6da969..8db0c88cf48e 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -195,7 +195,6 @@ struct scsi_device {
 	unsigned allow_restart:1; /* issue START_UNIT in error handler */
 	unsigned manage_system_start_stop:1; /* Let HLD (sd) manage system start/stop */
 	unsigned manage_runtime_start_stop:1; /* Let HLD (sd) manage runtime start/stop */
-	unsigned no_start_on_resume:1; /* Do not issue START_STOP_UNIT on resume */
 	unsigned start_stop_pwr_cond:1;	/* Set power cond. in START_STOP_UNIT */
 	unsigned no_uld_attach:1; /* disable connecting to upper level drivers */
 	unsigned select_no_atn:1;
-- 
2.41.0

