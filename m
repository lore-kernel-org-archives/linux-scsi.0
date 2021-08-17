Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F32C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41E4D60720
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbhHQJRW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:22 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:47450 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235981AbhHQJRP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id D6A5620014;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QM8+N+Fjtm2c/LTrtQP2sO2xn/YHy1e/vJXLx+ti6dY=;
        b=qIQN5a6Wh/6GU14vlgdsOTO73syHpo220zwQSUrAM+MX2MdeKYtbUCZyzFGSAzhjcE7W9w
        IiYJGGFvnhf36hosmVMkkeoVNtU2mUJ/YkXF6D1ABTTf5KUjE4exOk+Mbr5QUho7dTgYCc
        /ZRlyE7E7yiTKuc4Cy8KF4rkv7u7iWs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191801;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QM8+N+Fjtm2c/LTrtQP2sO2xn/YHy1e/vJXLx+ti6dY=;
        b=VpNbocFnXNj0u1VgNcXi9UJZfZsklCW01+f6knUojr+Rruwgh/Zo+UiD+hz4Gv4ipjuaQo
        7KMZRwgEocxp9zBQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id C7F61A3B9A;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id C5B54518CE6F; Tue, 17 Aug 2021 11:16:41 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: [PATCH 08/51] zfcp: open-code fc_block_scsi_eh() for host reset
Date:   Tue, 17 Aug 2021 11:14:13 +0200
Message-Id: <20210817091456.73342-9-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
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
index 9da9b2b2a580..9393f1587e8a 100644
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

