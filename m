Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C5DC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  2 May 2022 21:39:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387775AbiEBVmx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 May 2022 17:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387734AbiEBVmI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 May 2022 17:42:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD0664D6
        for <linux-scsi@vger.kernel.org>; Mon,  2 May 2022 14:38:38 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 1B34F1F8AB;
        Mon,  2 May 2022 21:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651527513; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lL4br4q93TiGjeVzhe1cZF3dpMgVYwS+haJ2nPRPLLc=;
        b=H6MxAfS1u3stHTEgf1GSnFmDyIZgsXfERegWR1Qwag1QXHe7PBxaW3fZm6zaz5XeFJD/Pk
        Hcsg6zXEClh87sQKOZZMsjW1/llXes6h5KpY6OAiCgKMQV/mPMHySLSsQnKJOq3onjpwD4
        hZan+gSGycDOcezkNIgmlkMVg6Pk58U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651527513;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lL4br4q93TiGjeVzhe1cZF3dpMgVYwS+haJ2nPRPLLc=;
        b=jWf4KAEe9s7SA45ZpY7gU04dTxt+sK8qTxEHoakbZ+eHkeaw/jEd4W/5xLT+dmvEFREFr6
        ezuL2Pg+7luVblCQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 164E92C162;
        Mon,  2 May 2022 21:38:33 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 136345194118; Mon,  2 May 2022 23:38:33 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 18/24] snic: use dedicated device reset command
Date:   Mon,  2 May 2022 23:38:14 +0200
Message-Id: <20220502213820.3187-19-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220502213820.3187-1-hare@suse.de>
References: <20220502213820.3187-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use a dedicated command to send a device reset instead of relying
on using the command which triggered the device failure.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/snic/snic_scsi.c | 52 ++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index e18c8c5e4b46..0d6156085616 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -2128,57 +2128,53 @@ snic_unlink_and_release_req(struct snic *snic, struct scsi_cmnd *sc, int flag)
 int
 snic_device_reset(struct scsi_cmnd *sc)
 {
-	struct Scsi_Host *shost = sc->device->host;
+	struct scsi_device *sdev = sc->device;
+	struct Scsi_Host *shost = sdev->host;
 	struct snic *snic = shost_priv(shost);
 	struct snic_req_info *rqi = NULL;
-	int tag = snic_cmd_tag(sc);
 	int start_time = jiffies;
 	int ret = FAILED;
 	int dr_supp = 0;
 
-	SNIC_SCSI_DBG(shost, "dev_reset:sc %p :0x%x :req = %p :tag = %d\n",
-		      sc, sc->cmnd[0], scsi_cmd_to_rq(sc),
-		      snic_cmd_tag(sc));
-	dr_supp = snic_dev_reset_supported(sc->device);
+	SNIC_SCSI_DBG(shost, "dev_reset\n");
+	dr_supp = snic_dev_reset_supported(sdev);
 	if (!dr_supp) {
 		/* device reset op is not supported */
 		SNIC_HOST_INFO(shost, "LUN Reset Op not supported.\n");
-		snic_unlink_and_release_req(snic, sc, SNIC_DEV_RST_NOTSUP);
-
 		goto dev_rst_end;
 	}
 
 	if (unlikely(snic_get_state(snic) != SNIC_ONLINE)) {
-		snic_unlink_and_release_req(snic, sc, 0);
 		SNIC_HOST_ERR(shost, "Devrst: Parent Devs are not online.\n");
 
 		goto dev_rst_end;
 	}
 
-	/* There is no tag when lun reset is issue through ioctl. */
-	if (unlikely(tag <= SNIC_NO_TAG)) {
-		SNIC_HOST_INFO(snic->shost,
-			       "Devrst: LUN Reset Recvd thru IOCTL.\n");
-
-		rqi = snic_req_init(snic, 0);
-		if (!rqi)
-			goto dev_rst_end;
-
-		memset(scsi_cmd_priv(sc), 0,
-			sizeof(struct snic_internal_io_state));
-		CMD_SP(sc) = (char *)rqi;
-		CMD_FLAGS(sc) = SNIC_NO_FLAGS;
+	rqi = snic_req_init(snic, 0);
+	if (!rqi)
+		goto dev_rst_end;
 
-		/* Add special tag for dr coming from user spc */
-		rqi->tm_tag = SNIC_TAG_IOCTL_DEV_RST;
-		rqi->sc = sc;
+	/* The last tag is reserved for device reset */
+	sc = scsi_host_find_tag(snic->shost, snic->tmf_tag_id);
+	if (!sc || CMD_SP(sc)) {
+		SNIC_HOST_ERR(snic->shost,
+			      "Devrst: TMF busy\n");
+		goto dev_rst_end;
 	}
+	memset(scsi_cmd_priv(sc), 0,
+	       sizeof(struct snic_internal_io_state));
+	CMD_SP(sc) = (char *)rqi;
+	CMD_FLAGS(sc) = SNIC_NO_FLAGS;
+
+	/* Add special tag for dr coming from user spc */
+	rqi->tm_tag = SNIC_TAG_IOCTL_DEV_RST;
+	rqi->sc = sc;
 
 	ret = snic_send_dr_and_wait(snic, sc);
 	if (ret) {
 		SNIC_HOST_ERR(snic->shost,
 			      "Devrst: IO w/ Tag %x Failed w/ err = %d\n",
-			      tag, ret);
+			      snic_cmd_tag(sc), ret);
 
 		snic_unlink_and_release_req(snic, sc, 0);
 
@@ -2188,7 +2184,7 @@ snic_device_reset(struct scsi_cmnd *sc)
 	ret = snic_dr_finish(snic, sc);
 
 dev_rst_end:
-	SNIC_TRC(snic->shost->host_no, tag, (ulong) sc,
+	SNIC_TRC(snic->shost->host_no, snic_cmd_tag(sc), (ulong) sc,
 		 jiffies_to_msecs(jiffies - start_time),
 		 0, SNIC_TRC_CMD(sc), SNIC_TRC_CMD_STATE_FLAGS(sc));
 
@@ -2332,7 +2328,7 @@ snic_reset(struct Scsi_Host *shost)
 		schedule_timeout(msecs_to_jiffies(1));
 
 	sc = scsi_host_find_tag(shost, snic->tmf_tag_id);
-	if (!sc) {
+	if (!sc || CMD_SP(sc)) {
 		SNIC_HOST_ERR(shost,
 			      "reset:Host Reset Failed to allocate sc.\n");
 		spin_lock_irqsave(&snic->snic_lock, flags);
-- 
2.29.2

