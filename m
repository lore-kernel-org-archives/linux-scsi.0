Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72C70E784BE
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Oct 2023 15:49:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238249AbjJBPtp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Oct 2023 11:49:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238141AbjJBPtm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Oct 2023 11:49:42 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28D3DE0
        for <linux-scsi@vger.kernel.org>; Mon,  2 Oct 2023 08:49:36 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E347721875;
        Mon,  2 Oct 2023 15:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1696261770; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=18OFAjJY+wIEMlb/AfJ9DKKUZjFwO/lBfOgl6f1fojI=;
        b=T69Fu55zkkk1TtF7IiOoZV7sWW1NNxFjUnjC1cO++HhfGtJNzyztBz3+pYOizh+ZNRcDia
        QGVFdc5kQrWzOSdJ/O13EoGkPEcU1I/3aMuPjbRoIwLC5PC4lF99u/e3vmuGDz5U/nIRBD
        aiQK68G+/05WiOcz2O62oRweENKkt34=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1696261770;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=18OFAjJY+wIEMlb/AfJ9DKKUZjFwO/lBfOgl6f1fojI=;
        b=FcLR+EcpYBy9j8MXN8xSC1Oywv4+Mpb3yN/OsCzEGeDqkyVONaLLbOrWnIeEGiG7S8oNpU
        /gT6jGFJ6MaC45Cw==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id C58B82C15B;
        Mon,  2 Oct 2023 15:49:30 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id DBFCA51E7573; Mon,  2 Oct 2023 17:49:30 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/15] snic: allocate device reset command
Date:   Mon,  2 Oct 2023 17:49:23 +0200
Message-Id: <20231002154927.68643-12-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231002154927.68643-1-hare@suse.de>
References: <20231002154927.68643-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allocate a command to send a device reset instead of relying
on using the command which triggered the device failure.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/snic/snic_scsi.c | 63 +++++++++++++++++------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index f1ef781df837..06615619b84c 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -2091,70 +2091,69 @@ snic_unlink_and_release_req(struct snic *snic, struct scsi_cmnd *sc, int flag)
 int
 snic_device_reset(struct scsi_cmnd *sc)
 {
-	struct Scsi_Host *shost = sc->device->host;
+	struct scsi_device *sdev = sc->device;
+	struct Scsi_Host *shost = sdev->host;
 	struct snic *snic = shost_priv(shost);
+	struct request *req;
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
-		goto dev_rst_end;
+		return ret;
 	}
 
 	if (unlikely(snic_get_state(snic) != SNIC_ONLINE)) {
-		snic_unlink_and_release_req(snic, sc, 0);
 		SNIC_HOST_ERR(shost, "Devrst: Parent Devs are not online.\n");
 
-		goto dev_rst_end;
+		return ret;
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
+		return ret;
 
-		/* Add special tag for dr coming from user spc */
-		rqi->tm_tag = SNIC_TAG_IOCTL_DEV_RST;
-		rqi->sc = sc;
+	req = scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_IN,
+				 BLK_MQ_REQ_NOWAIT);
+	if (!req) {
+		SNIC_HOST_ERR(snic->shost,
+			      "Devrst: TMF busy\n");
+		goto dev_rst_end;
 	}
+	sc = blk_mq_rq_to_pdu(req);
+	memset(scsi_cmd_priv(sc), 0,
+	       sizeof(struct snic_internal_io_state));
+	CMD_SP(sc) = (char *)rqi;
+	CMD_FLAGS(sc) = SNIC_NO_FLAGS;
 
+	/* Add special tag for dr coming from user spc */
+	rqi->tm_tag = SNIC_TAG_IOCTL_DEV_RST;
+	rqi->sc = sc;
+	WRITE_ONCE(req->state, MQ_RQ_IN_FLIGHT);
 	ret = snic_send_dr_and_wait(snic, sc);
 	if (ret) {
 		SNIC_HOST_ERR(snic->shost,
 			      "Devrst: IO w/ Tag %x Failed w/ err = %d\n",
-			      tag, ret);
-
+			      snic_cmd_tag(sc), ret);
+		blk_mq_set_request_complete(req);
 		snic_unlink_and_release_req(snic, sc, 0);
 
 		goto dev_rst_end;
 	}
-
+	blk_mq_set_request_complete(req);
 	ret = snic_dr_finish(snic, sc);
 
 dev_rst_end:
-	SNIC_TRC(snic->shost->host_no, tag, (ulong) sc,
+	SNIC_TRC(snic->shost->host_no, snic_cmd_tag(sc), (ulong) sc,
 		 jiffies_to_msecs(jiffies - start_time),
 		 0, SNIC_TRC_CMD(sc), SNIC_TRC_CMD_STATE_FLAGS(sc));
-
+	if (req)
+		blk_mq_free_request(req);
 	SNIC_SCSI_DBG(snic->shost,
 		      "Devrst: Returning from Device Reset : %s\n",
 		      (ret == SUCCESS) ? "SUCCESS" : "FAILED");
-- 
2.35.3

