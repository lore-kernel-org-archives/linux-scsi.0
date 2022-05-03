Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A2EC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238804AbiECUK5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbiECUKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:50 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 709AE26AC3
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:16 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 0E6241F74B;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DXJNnr1bZ70hxjEgcWXEr+BncqNw0ZT0D911iJNukZs=;
        b=cc7BXBSVTzexujoHkItDrKLQKE9mrt+mJ1raX9cayeXU1vl+tMmn1Kmpu+paRgZSa/75bs
        6ioFGIh4tfLWQfFE6CwybmUKBf0pho9cknQvYfOek6DrUcZlYBUdMMJeATufWQLi0hVb/U
        QGZj7tIXtnXgG7u4p1D7C/H9qgkGhzY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DXJNnr1bZ70hxjEgcWXEr+BncqNw0ZT0D911iJNukZs=;
        b=/cmO7a1eT/AYPpxneXtmXho5PG/pK27FQMHjZwFqI98q8KZntyAnPQw7qY2538QLypHnnD
        CzH28g9CJFIAuYCg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id E30322C14B;
        Tue,  3 May 2022 20:07:14 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id E7F6B51941CC; Tue,  3 May 2022 22:07:14 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Steffen Maier <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>
Subject: [PATCH 03/24] zfcp: open-code fc_block_scsi_eh() for host reset
Date:   Tue,  3 May 2022 22:06:43 +0200
Message-Id: <20220503200704.88003-4-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220503200704.88003-1-hare@suse.de>
References: <20220503200704.88003-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When issuing a host reset we should be waiting for all
ports to become unblocked; just waiting for one might
be resulting in host reset to return too early.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Steffen Maier <maier@linux.ibm.com>
Cc: Benjamin Block <bblock@linux.ibm.com>
---
 drivers/s390/scsi/zfcp_scsi.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 526ac240d9fe..2e615e1dcde6 100644
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
@@ -383,9 +385,16 @@ static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 	}
 	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
 	zfcp_erp_wait(adapter);
-	fc_ret = fc_block_scsi_eh(scpnt);
-	if (fc_ret)
-		ret = fc_ret;
+
+	spin_lock_irqsave(&adapter->port_list_lock, flags);
+	list_for_each_entry(port, &adapter->port_list, list) {
+		struct fc_rport *rport = port->rport;
+
+		ret = fc_block_rport(rport);
+		if (ret)
+			break;
+	}
+	spin_unlock_irqrestore(&adapter->port_list_lock, flags);
 
 	zfcp_dbf_scsi_eh("schrh_r", adapter, ~0, ret);
 	return ret;
-- 
2.29.2

