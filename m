Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B142C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241936AbiECULH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:11:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237460AbiECUKv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:51 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70A4926AE3
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:16 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 0D74D210E7;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r7HJkHr80WilWGLtgRALjqRPKQbUiMtulM1V6Eolt6I=;
        b=obdT/IDtxZ4xC8hmXEe4hTEaknR1qLFiapphUVqY/zhkvixOmxuMKuKA/M+8uaKBLlrxAR
        P6dw1X42mV2lKbmLDD4Ir+VxhTxQdUzyWoP8pwptxJqhHEZID2YGwG0TCyoUmyt4TjylPB
        Tc2VMEUdmhR4v5S5yXPlheWN1LUZDB4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=r7HJkHr80WilWGLtgRALjqRPKQbUiMtulM1V6Eolt6I=;
        b=8ZIX/saGMLfU4Sh8ypOGeNS+K+ZnrjIT3EcNxavchLB1rqmGAs3IMrpmOfVGFVvnF9Qit9
        Lj3qOEqWuea15NBw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id E56D72C14E;
        Tue,  3 May 2022 20:07:14 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id EF26351941CE; Tue,  3 May 2022 22:07:14 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 04/24] mptfc: simplify mpt_fc_block_error_handler()
Date:   Tue,  3 May 2022 22:06:44 +0200
Message-Id: <20220503200704.88003-5-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220503200704.88003-1-hare@suse.de>
References: <20220503200704.88003-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of passing the a function we can as well return a status
and call the function directly afterwards.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/message/fusion/mptfc.c | 83 ++++++++++++++++++++++------------
 1 file changed, 54 insertions(+), 29 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index fac747109209..ea8fc32dacfa 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -183,73 +183,98 @@ static struct fc_function_template mptfc_transport_functions = {
 };
 
 static int
-mptfc_block_error_handler(struct scsi_cmnd *SCpnt,
-			  int (*func)(struct scsi_cmnd *SCpnt),
-			  const char *caller)
+mptfc_block_error_handler(struct fc_rport *rport)
 {
 	MPT_SCSI_HOST		*hd;
-	struct scsi_device	*sdev = SCpnt->device;
-	struct Scsi_Host	*shost = sdev->host;
-	struct fc_rport		*rport = starget_to_rport(scsi_target(sdev));
+	struct Scsi_Host	*shost = rport_to_shost(rport);
 	unsigned long		flags;
 	int			ready;
-	MPT_ADAPTER 		*ioc;
+	MPT_ADAPTER		*ioc;
 	int			loops = 40;	/* seconds */
 
-	hd = shost_priv(SCpnt->device->host);
+	hd = shost_priv(shost);
 	ioc = hd->ioc;
 	spin_lock_irqsave(shost->host_lock, flags);
 	while ((ready = fc_remote_port_chkready(rport) >> 16) == DID_IMM_RETRY
 	 || (loops > 0 && ioc->active == 0)) {
 		spin_unlock_irqrestore(shost->host_lock, flags);
 		dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
-			"mptfc_block_error_handler.%d: %d:%llu, port status is "
-			"%x, active flag %d, deferring %s recovery.\n",
+			"mptfc_block_error_handler.%d: %s, port status is "
+			"%x, active flag %d, deferring recovery.\n",
 			ioc->name, ioc->sh->host_no,
-			SCpnt->device->id, SCpnt->device->lun,
-			ready, ioc->active, caller));
+			dev_name(&rport->dev), ready, ioc->active));
 		msleep(1000);
 		spin_lock_irqsave(shost->host_lock, flags);
 		loops --;
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	if (ready == DID_NO_CONNECT || !SCpnt->device->hostdata
-	 || ioc->active == 0) {
+	if (ready == DID_NO_CONNECT || ioc->active == 0) {
 		dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
-			"%s.%d: %d:%llu, failing recovery, "
-			"port state %x, active %d, vdevice %p.\n", caller,
+			"mpt_block_error_handler.%d: %s, failing recovery, "
+			"port state %x, active %d.\n",
 			ioc->name, ioc->sh->host_no,
-			SCpnt->device->id, SCpnt->device->lun, ready,
-			ioc->active, SCpnt->device->hostdata));
+			dev_name(&rport->dev), ready, ioc->active));
 		return FAILED;
 	}
-	dfcprintk (ioc, printk(MYIOC_s_DEBUG_FMT
-		"%s.%d: %d:%llu, executing recovery.\n", caller,
-		ioc->name, ioc->sh->host_no,
-		SCpnt->device->id, SCpnt->device->lun));
-	return (*func)(SCpnt);
+	return SUCCESS;
 }
 
 static int
 mptfc_abort(struct scsi_cmnd *SCpnt)
 {
-	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_abort, __func__);
+	struct Scsi_Host *shost = SCpnt->device->host;
+	struct fc_rport *rport = starget_to_rport(scsi_target(SCpnt->device));
+	MPT_SCSI_HOST __maybe_unused *hd = shost_priv(shost);
+	int rtn;
+
+	rtn = mptfc_block_error_handler(rport);
+	if (rtn == SUCCESS) {
+		dfcprintk (hd->ioc, printk(MYIOC_s_DEBUG_FMT
+			"%s.%d: %d:%llu, executing recovery.\n", __func__,
+			hd->ioc->name, shost->host_no,
+			SCpnt->device->id, SCpnt->device->lun));
+		rtn = mptscsih_abort(SCpnt);
+	}
+	return rtn;
 }
 
 static int
 mptfc_dev_reset(struct scsi_cmnd *SCpnt)
 {
-	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_dev_reset, __func__);
+	struct Scsi_Host *shost = SCpnt->device->host;
+	struct fc_rport *rport = starget_to_rport(scsi_target(SCpnt->device));
+	MPT_SCSI_HOST __maybe_unused *hd = shost_priv(shost);
+	int rtn;
+
+	rtn = mptfc_block_error_handler(rport);
+	if (rtn == SUCCESS) {
+		dfcprintk (hd->ioc, printk(MYIOC_s_DEBUG_FMT
+			"%s.%d: %d:%llu, executing recovery.\n", __func__,
+			hd->ioc->name, shost->host_no,
+			SCpnt->device->id, SCpnt->device->lun));
+		rtn = mptscsih_dev_reset(SCpnt);
+	}
+	return rtn;
 }
 
 static int
 mptfc_bus_reset(struct scsi_cmnd *SCpnt)
 {
-	return
-	    mptfc_block_error_handler(SCpnt, mptscsih_bus_reset, __func__);
+	struct Scsi_Host *shost = SCpnt->device->host;
+	struct fc_rport *rport = starget_to_rport(scsi_target(SCpnt->device));
+	MPT_SCSI_HOST __maybe_unused *hd = shost_priv(shost);
+	int rtn;
+
+	rtn = mptfc_block_error_handler(rport);
+	if (rtn == SUCCESS) {
+		dfcprintk (hd->ioc, printk(MYIOC_s_DEBUG_FMT
+			"%s.%d: %d:%llu, executing recovery.\n", __func__,
+			hd->ioc->name, shost->host_no,
+			SCpnt->device->id, SCpnt->device->lun));
+		rtn = mptscsih_bus_reset(SCpnt);
+	}
+	return rtn;
 }
 
 static void
-- 
2.29.2

