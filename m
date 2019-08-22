Return-Path: <SRS0=BT6k=WS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDC3FC3A5A1
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:58:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A053E23400
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Aug 2019 13:58:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731965AbfHVN6j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Aug 2019 09:58:39 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:33936 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731614AbfHVN6j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Aug 2019 09:58:39 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 138A121FB36AF0A6D579;
        Thu, 22 Aug 2019 21:58:24 +0800 (CST)
Received: from huawei.com (10.90.53.225) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.439.0; Thu, 22 Aug 2019
 21:58:14 +0800
From:   zhengbin <zhengbin13@huawei.com>
To:     <hare@suse.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
CC:     <yi.zhang@huawei.com>, <zhengbin13@huawei.com>
Subject: [PATCH 1/3] scsi: aic7xxx: remove set but not used variables 'ahd','paused','wait','saved_scsiid'
Date:   Thu, 22 Aug 2019 22:04:43 +0800
Message-ID: <1566482685-117305-2-git-send-email-zhengbin13@huawei.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566482685-117305-1-git-send-email-zhengbin13@huawei.com>
References: <1566482685-117305-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.90.53.225]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/scsi/aic7xxx/aic79xx_osm.c: In function ahd_linux_slave_configure:
drivers/scsi/aic7xxx/aic79xx_osm.c:703:20: warning: variable ahd set but not used [-Wunused-but-set-variable]
drivers/scsi/aic7xxx/aic79xx_osm.c: In function ahd_linux_dev_reset:
drivers/scsi/aic7xxx/aic79xx_osm.c:789:9: warning: variable wait set but not used [-Wunused-but-set-variable]
drivers/scsi/aic7xxx/aic79xx_osm.c: In function ahd_linux_dev_reset:
drivers/scsi/aic7xxx/aic79xx_osm.c:788:9: warning: variable paused set but not used [-Wunused-but-set-variable]
drivers/scsi/aic7xxx/aic79xx_osm.c: In function ahd_linux_queue_abort_cmd:
drivers/scsi/aic7xxx/aic79xx_osm.c:2155:9: warning: variable saved_scsiid set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/scsi/aic7xxx/aic79xx_osm.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c b/drivers/scsi/aic7xxx/aic79xx_osm.c
index 5799251..18ca82f 100644
--- a/drivers/scsi/aic7xxx/aic79xx_osm.c
+++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
@@ -700,9 +700,6 @@ ahd_linux_slave_alloc(struct scsi_device *sdev)
 static int
 ahd_linux_slave_configure(struct scsi_device *sdev)
 {
-	struct	ahd_softc *ahd;
-
-	ahd = *((struct ahd_softc **)sdev->host->hostdata);
 	if (bootverbose)
 		sdev_printk(KERN_INFO, sdev, "Slave Configure\n");

@@ -785,16 +782,12 @@ ahd_linux_dev_reset(struct scsi_cmnd *cmd)
 	struct scb *reset_scb;
 	u_int  cdb_byte;
 	int    retval = SUCCESS;
-	int    paused;
-	int    wait;
 	struct	ahd_initiator_tinfo *tinfo;
 	struct	ahd_tmode_tstate *tstate;
 	unsigned long flags;
 	DECLARE_COMPLETION_ONSTACK(done);

 	reset_scb = NULL;
-	paused = FALSE;
-	wait = FALSE;
 	ahd = *(struct ahd_softc **)cmd->device->host->hostdata;

 	scmd_printk(KERN_INFO, cmd,
@@ -2152,7 +2145,6 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
 	u_int  saved_scbptr;
 	u_int  active_scbptr;
 	u_int  last_phase;
-	u_int  saved_scsiid;
 	u_int  cdb_byte;
 	int    retval;
 	int    was_paused;
@@ -2268,7 +2260,6 @@ ahd_linux_queue_abort_cmd(struct scsi_cmnd *cmd)
 	 * passed in command.  That command is currently active on the
 	 * bus or is in the disconnected state.
 	 */
-	saved_scsiid = ahd_inb(ahd, SAVED_SCSIID);
 	if (last_phase != P_BUSFREE
 	    && SCB_GET_TAG(pending_scb) == active_scbptr) {

--
2.7.4

