Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBBECC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 12:18:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB19520B80
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 12:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbgFPMSg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 08:18:36 -0400
Received: from mx2.suse.de ([195.135.220.15]:37468 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728483AbgFPMSa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 16 Jun 2020 08:18:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 37EF3ADB3;
        Tue, 16 Jun 2020 12:18:33 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/4] gdth: do not use struct scsi_cmnd as argument for bus reset
Date:   Tue, 16 Jun 2020 14:18:19 +0200
Message-Id: <20200616121821.99113-3-hare@suse.de>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20200616121821.99113-1-hare@suse.de>
References: <20200616121821.99113-1-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bus reset just needs the number of the bus to reset as argument,
so introduce a function gdth_bus_reset() and avoid allocating
a temporary scsi command when bus reset is triggered via ioctl.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/gdth.c | 21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index b65edccb3147..b62ecfc24bb6 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3323,18 +3323,14 @@ static enum blk_eh_timer_return gdth_timed_out(struct scsi_cmnd *scp)
 }
 
 
-static int gdth_eh_bus_reset(struct scsi_cmnd *scp)
+static int gdth_bus_reset(gdth_ha_str *ha, u8 b)
 {
-	gdth_ha_str *ha = shost_priv(scp->device->host);
 	int i;
 	unsigned long flags;
 	struct scsi_cmnd *cmnd;
-	u8 b;
 
 	TRACE2(("gdth_eh_bus_reset()\n"));
 
-	b = scp->device->channel;
-
 	/* clear command tab */
 	spin_lock_irqsave(&ha->smp_lock, flags);
 	for (i = 0; i < GDTH_MAXCMDS; ++i) {
@@ -3375,6 +3371,11 @@ static int gdth_eh_bus_reset(struct scsi_cmnd *scp)
 	return SUCCESS;
 }
 
+static int gdth_eh_bus_reset(struct scsi_cmnd *scp)
+{
+	return gdth_bus_reset(shost_priv(scp->device->host), scp->device->channel);
+}
+
 static int gdth_bios_param(struct scsi_device *sdev,struct block_device *bdev,
 			   sector_t cap,int *ip)
 {
@@ -3897,7 +3898,6 @@ static int ioc_rescan(void __user *arg, char *cmnd)
 static int gdth_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 {
 	gdth_ha_str *ha;
-	struct scsi_cmnd *scp;
 	unsigned long flags;
 	char cmnd[MAX_COMMAND_SIZE];
 	void __user *argp = (void __user *)arg;
@@ -4013,15 +4013,8 @@ static int gdth_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
 		    (NULL == (ha = gdth_find_ha(res.ionode))))
 			return -EFAULT;
 
-		scp  = kzalloc(sizeof(*scp), GFP_KERNEL);
-		if (!scp)
-			return -ENOMEM;
-		scp->device = ha->sdev;
-		scp->cmd_len = 12;
-		scp->device->channel = res.number;
-		rval = gdth_eh_bus_reset(scp);
+		rval = gdth_bus_reset(ha, res.number);
 		res.status = (rval == SUCCESS ? S_OK : S_GENERR);
-		kfree(scp);
 
 		if (copy_to_user(argp, &res, sizeof(gdth_ioctl_reset)))
 			return -EFAULT;
-- 
2.16.4

