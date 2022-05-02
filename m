Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5012C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387737AbiEBVmJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384965AbiEBVmF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:42:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451B8E0C4
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:38:34 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id DF9141F38D;
        Mon,  2 May 2022 21:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651527512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dtN2+oOCnne1foghEl3P+vOCI8JISeEHhxWGm//7S18=;
        b=B7sf2LDQpbPtS1GKOXEc/CD+r8mOXjkcC7Qn+QY2vVqVvMHBkm61b2GKPq6lH0qS9BZ6iR
        3VbCuyW/XjnLIpIpYG0xlBl99cSiiuPRtO6Plz4q8/XgkPCGoUeuxLdhn17q8v8UFKRnyt
        wgvPqG3r/i7Wn67bwzNEbslcuTXkWnU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651527512;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dtN2+oOCnne1foghEl3P+vOCI8JISeEHhxWGm//7S18=;
        b=OAtLpL5fqgGF/3TDBCRkt/CawsTSOmOuNLDSSC5s3I2nCZFnnsSb70+rGUluJyLbcM7C4A
        LdLeVByVI3uIKDCw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id D32F82C145;
        Mon,  2 May 2022 21:38:32 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id C75CD51940FA; Mon,  2 May 2022 23:38:32 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: [PATCH 03/24] zfcp: open-code fc_block_scsi_eh() for host reset
Date:   Mon,  2 May 2022 23:37:59 +0200
Message-Id: <20220502213820.3187-4-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502213820.3187-1-hare@suse.de>
References: <20220502213820.3187-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When issuing a host reset we should be waiting for all
ports to become unblocked; just waiting for one might
be resulting in host reset to return too early.

Signed-off-by: Hannes Reinecke <hare@suse.com>
Cc: Steffen Maier <maier@linux.ibm.com>
Cc: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_scsi.c | 29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 526ac240d9fe..fb2b73fca381 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -373,9 +373,11 @@ static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
 
 static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 {
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
-	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
-	int ret = SUCCESS, fc_ret;
+	struct Scsi_Host *host = scpnt->device->host;
+	struct zfcp_adapter *adapter = (struct zfcp_adapter *)host->hostdata[0];
+	int ret = SUCCESS;
+	unsigned long flags;
+	struct zfcp_port *port;
 
 	if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE)) {
 		zfcp_erp_port_forced_reopen_all(adapter, 0, "schrh_p");
@@ -383,9 +385,24 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 	}
 	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
 	zfcp_erp_wait(adapter);
-	fc_ret = fc_block_scsi_eh(scpnt);
-	if (fc_ret)
-		ret = fc_ret;
+retry_rport_blocked:
+	spin_lock_irqsave(host->host_lock, flags);
+	list_for_each_entry(port, &adapter->port_list, list) {
+		struct fc_rport *rport = port->rport;
+
+		if (rport->port_state == FC_PORTSTATE_BLOCKED) {
+			if (rport->flags & FC_RPORT_FAST_FAIL_TIMEDOUT)
+				ret = FAST_IO_FAIL;
+			else
+				ret = NEEDS_RETRY;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(host->host_lock, flags);
+	if (ret == NEEDS_RETRY) {
+		msleep(1000);
+		goto retry_rport_blocked;
+	}
 
 	zfcp_dbf_scsi_eh("schrh_r", adapter, ~0, ret);
 	return ret;
-- 
2.29.2

