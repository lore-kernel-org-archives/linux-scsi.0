Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A19F0C433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:39:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387724AbiEBVmZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387725AbiEBVmH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:42:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 515A4E0A4
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:38:37 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id F26E01F74D;
        Mon,  2 May 2022 21:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651527512; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cEuTCsWgoRxM8nDi0W0Pe3ubFcm1Y8w3ShBgyeGIIJE=;
        b=YBh5PDntS+m0dmSm412tSmxBz2HrX7p3XQ7KojCsbH3ujB3tB1aU+RWiLLyp/Qz4HyY12M
        bdBsAtf5hFWAswQWq96SCi26d2/0k0X4alPGxGeU/e5ARlKvTB1LeVAY2/pUVqi9ZGL+Iz
        KLNIKrfMkmPI7OBu3jvb8UA0i3rwHg4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651527512;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cEuTCsWgoRxM8nDi0W0Pe3ubFcm1Y8w3ShBgyeGIIJE=;
        b=NDnR70wF3/wj5C1kUOh5+2t+uVO+PUhzy0v9yLxLisF67ic8WdpCUJ6A7gVanGsq/2dX/U
        AZGmYGlIN/qcd2Dg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id EB0672C153;
        Mon,  2 May 2022 21:38:32 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id E93235194108; Mon,  2 May 2022 23:38:32 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 10/24] ibmvfc: use fc_block_rport()
Date:   Mon,  2 May 2022 23:38:06 +0200
Message-Id: <20220502213820.3187-11-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502213820.3187-1-hare@suse.de>
References: <20220502213820.3187-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use fc_block_rport() instead of fc_block_scsi_eh() as the latter
will be deprecated.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/ibmvscsi/ibmvfc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
index 721d965f4b0e..2e7128f0d905 100644
--- a/drivers/scsi/ibmvscsi/ibmvfc.c
+++ b/drivers/scsi/ibmvscsi/ibmvfc.c
@@ -2857,12 +2857,13 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
 static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	int cancel_rc, block_rc;
 	int rc = FAILED;
 
 	ENTER;
-	block_rc = fc_block_scsi_eh(cmd);
+	block_rc = fc_block_rport(rport);
 	ibmvfc_wait_while_resetting(vhost);
 	if (block_rc != FAST_IO_FAIL) {
 		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
@@ -2890,12 +2891,13 @@ static int ibmvfc_eh_abort_handler(struct scsi_cmnd *cmd)
 static int ibmvfc_eh_device_reset_handler(struct scsi_cmnd *cmd)
 {
 	struct scsi_device *sdev = cmd->device;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
 	struct ibmvfc_host *vhost = shost_priv(sdev->host);
 	int cancel_rc, block_rc, reset_rc = 0;
 	int rc = FAILED;
 
 	ENTER;
-	block_rc = fc_block_scsi_eh(cmd);
+	block_rc = fc_block_rport(rport);
 	ibmvfc_wait_while_resetting(vhost);
 	if (block_rc != FAST_IO_FAIL) {
 		cancel_rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_LUN_RESET);
-- 
2.29.2

