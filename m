Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C68C2C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:10:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF11261131
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 09:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237485AbhHSJLE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 05:11:04 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:60326 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237467AbhHSJLA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 05:11:00 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 7F0E9220BF;
        Thu, 19 Aug 2021 09:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629364223; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ax5NNOrXIESlaJee+dnuwn6R6DBBBILVRMqSXBfma5U=;
        b=MrevE7MHu4tGyIEqnQ7OiIoZtsNA9fHKY6+B6p7yVwbCXFSzL295cPe01yxOi/BIp61Yqg
        j4PmtK6tm3W8w35PEhpi/U5Mr3MUxWnq2vUAWDg7arQKN33TEeXn/7HYr3T4JascqFMiqp
        4Vckha31V6Sr4XBQsLM+3gCaRepxGOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629364223;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ax5NNOrXIESlaJee+dnuwn6R6DBBBILVRMqSXBfma5U=;
        b=Rw4CZprpeb8HjQ+NMyeSgUuMPunB+F2m6gajpuRtzGFDHmMmsX8hGowod4umLbJjgIL8sg
        i5VaWReqEhng2ADA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B84BDA3BA0;
        Thu, 19 Aug 2021 09:10:13 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 703EB518D282; Thu, 19 Aug 2021 11:10:23 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/3] mptfc: use fc_block_rport() instead of open-coding it
Date:   Thu, 19 Aug 2021 11:10:16 +0200
Message-Id: <20210819091017.94142-3-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210819091017.94142-1-hare@suse.de>
References: <20210819091017.94142-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

mptfc_block_error_handler() is just an open-coded version of
fc_block_rport().

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/message/fusion/mptfc.c | 92 +++++++++++++++-------------------
 1 file changed, 41 insertions(+), 51 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 572333fadd68..3962951c1e9a 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -183,73 +183,63 @@ static struct fc_function_template mptfc_transport_functions = {
 };
 
 static int
-mptfc_block_error_handler(struct scsi_cmnd *SCpnt,
-			  int (*func)(struct scsi_cmnd *SCpnt),
-			  const char *caller)
+mptfc_abort(struct scsi_cmnd *SCpnt)
 {
-	MPT_SCSI_HOST		*hd;
 	struct scsi_device	*sdev = SCpnt->device;
 	struct Scsi_Host	*shost = sdev->host;
 	struct fc_rport		*rport = starget_to_rport(scsi_target(sdev));
-	unsigned long		flags;
-	int			ready;
-	MPT_ADAPTER 		*ioc;
-	int			loops = 40;	/* seconds */
+	MPT_SCSI_HOST		*hd = shost_priv(shost);
+	MPT_ADAPTER 		*ioc = hd->ioc;
+	int rval;
 
-	hd = shost_priv(SCpnt->device->host);
-	ioc = hd->ioc;
-	spin_lock_irqsave(shost->host_lock, flags);
-	while ((ready = fc_remote_port_chkready(rport) >> 16) == DID_IMM_RETRY
-	 || (loops > 0 && ioc->active == 0)) {
-		spin_unlock_irqrestore(shost->host_lock, flags);
-		dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
-			"mptfc_block_error_handler.%d: %d:%llu, port status is "
-			"%x, active flag %d, deferring %s recovery.\n",
-			ioc->name, ioc->sh->host_no,
-			SCpnt->device->id, SCpnt->device->lun,
-			ready, ioc->active, caller));
-		msleep(1000);
-		spin_lock_irqsave(shost->host_lock, flags);
-		loops --;
-	}
-	spin_unlock_irqrestore(shost->host_lock, flags);
-
-	if (ready == DID_NO_CONNECT || !SCpnt->device->hostdata
-	 || ioc->active == 0) {
-		dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
-			"%s.%d: %d:%llu, failing recovery, "
-			"port state %x, active %d, vdevice %p.\n", caller,
-			ioc->name, ioc->sh->host_no,
-			SCpnt->device->id, SCpnt->device->lun, ready,
-			ioc->active, SCpnt->device->hostdata));
-		return FAILED;
-	}
+	rval = fc_block_rport(rport);
+	if (rval)
+		return rval;
 	dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
-		"%s.%d: %d:%llu, executing recovery.\n", caller,
-		ioc->name, ioc->sh->host_no,
-		SCpnt->device->id, SCpnt->device->lun));
-	return (*func)(SCpnt);
-}
-
-static int
-mptfc_abort(struct scsi_cmnd *SCpnt)
-{
-	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_abort, __func__);
+		"%s.%d: %d:%llu, executing recovery.\n",
+		ioc->name, __func__, ioc->sh->host_no,
+		sdev->id, sdev->lun));
+	return mptscsih_abort(SCpnt);
 }
 
 static int
 mptfc_dev_reset(struct scsi_cmnd *SCpnt)
 {
-	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_dev_reset, __func__);
+	struct scsi_device	*sdev = SCpnt->device;
+	struct Scsi_Host	*shost = sdev->host;
+	struct fc_rport		*rport = starget_to_rport(scsi_target(sdev));
+	MPT_SCSI_HOST		*hd = shost_priv(shost);
+	MPT_ADAPTER 		*ioc = hd->ioc;
+	int rval;
+
+	rval = fc_block_rport(rport);
+	if (rval)
+		return rval;
+	dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
+		"%s.%d: %d:%llu, executing recovery.\n",
+		ioc->name, __func__, ioc->sh->host_no,
+		sdev->id, sdev->lun));
+	return mptscsih_dev_reset(SCpnt);
 }
 
 static int
 mptfc_bus_reset(struct scsi_cmnd *SCpnt)
 {
-	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_bus_reset, __func__);
+	struct scsi_device	*sdev = SCpnt->device;
+	struct Scsi_Host	*shost = sdev->host;
+	struct fc_rport		*rport = starget_to_rport(scsi_target(sdev));
+	MPT_SCSI_HOST		*hd = shost_priv(shost);
+	MPT_ADAPTER 		*ioc = hd->ioc;
+	int rval;
+
+	rval = fc_block_rport(rport);
+	if (rval)
+		return rval;
+	dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
+		"%s.%d: %d:%llu, executing recovery.\n",
+		ioc->name, __func__, ioc->sh->host_no,
+		sdev->id, sdev->lun));
+	return mptscsih_bus_reset(SCpnt);
 }
 
 static void
-- 
2.29.2

