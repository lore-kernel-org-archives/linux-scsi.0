Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34078E784BF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbjJBPn4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:43:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238171AbjJBPnu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:43:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D3FDA
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:43:46 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 822561F74D;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261423; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A4q7E1/BXL2CF0ZlGv6XBmSRPCh23hXsLAL3al04zak=;
        b=ojgXDdX1shxp9ps2RfoYPE0O/XWms+EmrAma/YxKchepzas3MHepqW1N5LpqSfFCVAd6zv
        gCUCnNb4I/p4Q+bB0gJ5cwN2loILA+uW4QMMJmkzj7pM6GON2RTMZfobXH9IVxaiE66p3B
        WZ1QhH8prW++9hL8DkIr21F9MFIUVGo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261423;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A4q7E1/BXL2CF0ZlGv6XBmSRPCh23hXsLAL3al04zak=;
        b=NM9NX/GKQsXkQ/sqnIRda6m6/IUKYkwEyV8n8ZQTAxDsfihUWT6gDLoTXCzQYCucx6Dzag
        uLdHcm2XhZJep4CA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 59A3E2C146;
        Mon,  2 Oct 2023 15:43:43 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 4566B51E7539; Mon,  2 Oct 2023 17:43:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 01/18] mptfc: simplify mptfc_block_error_handler()
Date:   Mon,  2 Oct 2023 17:43:11 +0200
Message-Id: <20231002154328.43718-2-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154328.43718-1-hare@suse.de>
References: <20231002154328.43718-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of passing in a function to mptfc_block_error_handler()
we can as well return a status and call the function afterwards.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/message/fusion/mptfc.c | 83 ++++++++++++++++++++++------------
 1 file changed, 54 insertions(+), 29 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index 22e7779a332b..5d5563ea90c2 100644
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
2.35.3

