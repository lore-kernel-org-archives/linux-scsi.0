Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4DAFC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:38:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387738AbiEBVmN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387704AbiEBVmF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:42:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74EB6E0DA
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:38:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id E36E71F749;
        Mon,  2 May 2022 21:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651527512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQW+ld6DVkY26KGEBVDC2qH8YDm7D3hr+MPpV/gRzRE=;
        b=FCUjR0B2HN9wBNuRhg2WSxSASKkE3mCv2kR3hDCeWZZJ0ceGE0Fn36LWrykhpWAm8FtSD+
        fJ03wPdmQ7IwiuX78C2gig2QJr785ZIhLq4GBp5JJKBBodhDnRCubmkaSjgt/hGmtcs8zl
        9RHS26KRnQ4rT/iho5kcBjI8K2X/pdo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651527512;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fQW+ld6DVkY26KGEBVDC2qH8YDm7D3hr+MPpV/gRzRE=;
        b=oDJBs3ATgE31tdoY0dKQIa3k29YNGPtAxd49cWUR90SeZ6PP7Oo+mdunN7C0/BVncvReYy
        WQorOIELza0+GyAg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id D626B2C146;
        Mon,  2 May 2022 21:38:32 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id CCC3451940FC; Mon,  2 May 2022 23:38:32 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 04/24] mptfc: simplify mpt_fc_block_error_handler()
Date:   Mon,  2 May 2022 23:38:00 +0200
Message-Id: <20220502213820.3187-5-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502213820.3187-1-hare@suse.de>
References: <20220502213820.3187-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Instead of passing the a function we can as well return a status
and call the function directly afterwards.

Signed-off-by: Hannes Reinecke <hare@suse.com>
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

