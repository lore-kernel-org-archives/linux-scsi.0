Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB67C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 20:07:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238250AbiECULX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 16:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230466AbiECUKy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 16:10:54 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73F59403C9
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 13:07:20 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 5D2E62187D;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1651608435; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t9kqWrtR6rQYrTEOPBHuU+zmAD5YIiGUVdcENTriHBk=;
        b=0NEsyuxxQqCKW6aeZlo6anLPahExPYBSHKIgFNnkvBB1/XqCAY+fHebgS5gNMpl2QBNAPy
        AcCRTeEra6AOYVzvHZzNUUo9uNyv99d3bQhfVvnstvcziIu8Jq7AKtWXnCcXSO1aIc+XsS
        xz1F7LSQaecRRnH4+1qDq4Ziro17M9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1651608435;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t9kqWrtR6rQYrTEOPBHuU+zmAD5YIiGUVdcENTriHBk=;
        b=i6L8SmAVPcNaHSiyzxmQaujhMz5QcDzP2aFgTQkEzhzmd1EJ4zSDm7SQ2cD8EoRJA6x8ff
        uBh/1NkDokS1TgAA==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 38BDF2C16B;
        Tue,  3 May 2022 20:07:15 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 48CB151941E8; Tue,  3 May 2022 22:07:15 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/24] snic: reserve tag for TMF
Date:   Tue,  3 May 2022 22:06:57 +0200
Message-Id: <20220503200704.88003-18-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220503200704.88003-1-hare@suse.de>
References: <20220503200704.88003-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rather than re-using the failed command the snic driver should
reserve one command for TMFs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/snic/snic.h      |  3 ++-
 drivers/scsi/snic/snic_main.c |  3 +++
 drivers/scsi/snic/snic_scsi.c | 43 +++++++++++++++++------------------
 3 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index 4ec7e30678e1..e40492d36031 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -310,6 +310,7 @@ struct snic {
 	struct list_head spl_cmd_list;
 
 	unsigned int max_tag_id;
+	unsigned int tmf_tag_id;
 	atomic_t ios_inflight;		/* io in flight counter */
 
 	struct vnic_snic_config config;
@@ -380,7 +381,7 @@ int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int snic_abort_cmd(struct scsi_cmnd *);
 int snic_device_reset(struct scsi_cmnd *);
 int snic_host_reset(struct scsi_cmnd *);
-int snic_reset(struct Scsi_Host *, struct scsi_cmnd *);
+int snic_reset(struct Scsi_Host *);
 void snic_shutdown_scsi_cleanup(struct snic *);
 
 
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 29d56396058c..f344cbc27923 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -512,6 +512,9 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 					 max_t(u32, SNIC_MIN_IO_REQ, max_ios));
 
 	snic->max_tag_id = shost->can_queue;
+	/* Reserve one reset command */
+	shost->can_queue--;
+	snic->tmf_tag_id = shost->can_queue;
 
 	shost->max_lun = snic->config.luns_per_tgt;
 	shost->max_id = SNIC_MAX_TARGET;
diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 5f17666f3e1d..e18c8c5e4b46 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -1018,17 +1018,6 @@ snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 		      "reset_cmpl: type = %x, hdr_stat = %x, cmnd_id = %x, hid = %x, ctx = %lx\n",
 		      typ, hdr_stat, cmnd_id, hid, ctx);
 
-	/* spl case, host reset issued through ioctl */
-	if (cmnd_id == SCSI_NO_TAG) {
-		rqi = (struct snic_req_info *) ctx;
-		SNIC_HOST_INFO(snic->shost,
-			       "reset_cmpl:Tag %d ctx %lx cmpl stat %s\n",
-			       cmnd_id, ctx, snic_io_status_to_str(hdr_stat));
-		sc = rqi->sc;
-
-		goto ioctl_hba_rst;
-	}
-
 	if (cmnd_id >= snic->max_tag_id) {
 		SNIC_HOST_ERR(snic->shost,
 			      "reset_cmpl: Tag 0x%x out of Range,HdrStat %s\n",
@@ -1039,7 +1028,6 @@ snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 	}
 
 	sc = scsi_host_find_tag(snic->shost, cmnd_id);
-ioctl_hba_rst:
 	if (!sc) {
 		atomic64_inc(&snic->s_stats.io.sc_null);
 		SNIC_HOST_ERR(snic->shost,
@@ -1725,7 +1713,7 @@ snic_dr_clean_single_req(struct snic *snic,
 {
 	struct snic_req_info *rqi = NULL;
 	struct snic_tgt *tgt = NULL;
-	struct scsi_cmnd *sc = NULL;
+	struct scsi_cmnd *sc;
 	spinlock_t *io_lock = NULL;
 	u32 sv_state = 0, tmf = 0;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
@@ -2238,13 +2226,6 @@ snic_issue_hba_reset(struct snic *snic, struct scsi_cmnd *sc)
 		goto hba_rst_end;
 	}
 
-	if (snic_cmd_tag(sc) == SCSI_NO_TAG) {
-		memset(scsi_cmd_priv(sc), 0,
-			sizeof(struct snic_internal_io_state));
-		SNIC_HOST_INFO(snic->shost, "issu_hr:Host reset thru ioctl.\n");
-		rqi->sc = sc;
-	}
-
 	req = rqi_to_req(rqi);
 
 	io_lock = snic_io_lock_hash(snic, sc);
@@ -2319,11 +2300,13 @@ snic_issue_hba_reset(struct snic *snic, struct scsi_cmnd *sc)
 } /* end of snic_issue_hba_reset */
 
 int
-snic_reset(struct Scsi_Host *shost, struct scsi_cmnd *sc)
+snic_reset(struct Scsi_Host *shost)
 {
 	struct snic *snic = shost_priv(shost);
+	struct scsi_cmnd *sc = NULL;
 	enum snic_state sv_state;
 	unsigned long flags;
+	u32 start_time  = jiffies;
 	int ret = FAILED;
 
 	/* Set snic state as SNIC_FWRESET*/
@@ -2348,6 +2331,18 @@ snic_reset(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	while (atomic_read(&snic->ios_inflight))
 		schedule_timeout(msecs_to_jiffies(1));
 
+	sc = scsi_host_find_tag(shost, snic->tmf_tag_id);
+	if (!sc) {
+		SNIC_HOST_ERR(shost,
+			      "reset:Host Reset Failed to allocate sc.\n");
+		spin_lock_irqsave(&snic->snic_lock, flags);
+		snic_set_state(snic, sv_state);
+		spin_unlock_irqrestore(&snic->snic_lock, flags);
+		atomic64_inc(&snic->s_stats.reset.hba_reset_fail);
+		ret = FAILED;
+
+		goto reset_end;
+	}
 	ret = snic_issue_hba_reset(snic, sc);
 	if (ret) {
 		SNIC_HOST_ERR(shost,
@@ -2365,6 +2360,10 @@ snic_reset(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	ret = SUCCESS;
 
 reset_end:
+	SNIC_TRC(shost->host_no, sc ? snic_cmd_tag(sc) : SCSI_NO_TAG,
+		 (ulong) sc, jiffies_to_msecs(jiffies - start_time),
+		 0, 0, 0);
+
 	return ret;
 } /* end of snic_reset */
 
@@ -2387,7 +2386,7 @@ snic_host_reset(struct scsi_cmnd *sc)
 		      sc, sc->cmnd[0], scsi_cmd_to_rq(sc),
 		      snic_cmd_tag(sc), CMD_FLAGS(sc));
 
-	ret = snic_reset(shost, sc);
+	ret = snic_reset(shost);
 
 	SNIC_TRC(shost->host_no, snic_cmd_tag(sc), (ulong) sc,
 		 jiffies_to_msecs(jiffies - start_time),
-- 
2.29.2

