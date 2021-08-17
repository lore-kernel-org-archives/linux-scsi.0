Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05C57C4320A
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D72B460EE4
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 09:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbhHQJRT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Aug 2021 05:17:19 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:33176 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235849AbhHQJRP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Aug 2021 05:17:15 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id C445321D0B;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1629191801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lz2/ar2mBUsC6LhoKQvJV0v1jhYsZtGmKMpp6CS77Fo=;
        b=NEGmC1KNZOXNAe5d3vR/y3wjXXNFWZbPfvj8zayA62nirJJlSBdx/vrqLYv1gjXc8Mvc24
        Ib1X+mBmaVXXDg+fAK/nHnnm+FKzkVYoHLB3cVyVxdn2IF3A8fIOpqN+xuRGhCwbE32EEb
        E4/5z7PoZ0cAhnKyEg/NhULpvygKoBw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1629191801;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lz2/ar2mBUsC6LhoKQvJV0v1jhYsZtGmKMpp6CS77Fo=;
        b=nNq4/gXsqAWPdwrlWK7w0BqxwYAOr8KfsJOQmo7+4nIrQo0y3dyz5SGEiv0b4QdOTNwP7e
        e1Zl1SRX5YY+opDg==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id B8FA7A3B97;
        Tue, 17 Aug 2021 09:16:41 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id B3637518CE69; Tue, 17 Aug 2021 11:16:41 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 05/51] snic: reserve tag for TMF
Date:   Tue, 17 Aug 2021 11:14:10 +0200
Message-Id: <20210817091456.73342-6-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210817091456.73342-1-hare@suse.de>
References: <20210817091456.73342-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rather than re-using the failed command the snic driver should
reserve one command for TMFs.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/snic/snic.h      |  3 ++-
 drivers/scsi/snic/snic_main.c |  3 +++
 drivers/scsi/snic/snic_scsi.c | 51 +++++++++++++++--------------------
 3 files changed, 26 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index f4c666285bba..f88ecf73f708 100644
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
index 14f4ce665e58..65f50057c66e 100644
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
index 6dd0ff188bb4..1e59d59130d6 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -1021,17 +1021,6 @@ snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
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
@@ -1042,7 +1031,6 @@ snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 	}
 
 	sc = scsi_host_find_tag(snic->shost, cmnd_id);
-ioctl_hba_rst:
 	if (!sc) {
 		atomic64_inc(&snic->s_stats.io.sc_null);
 		SNIC_HOST_ERR(snic->shost,
@@ -1728,7 +1716,7 @@ snic_dr_clean_single_req(struct snic *snic,
 {
 	struct snic_req_info *rqi = NULL;
 	struct snic_tgt *tgt = NULL;
-	struct scsi_cmnd *sc = NULL;
+	struct scsi_cmnd *sc;
 	spinlock_t *io_lock = NULL;
 	u32 sv_state = 0, tmf = 0;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
@@ -2241,13 +2229,6 @@ snic_issue_hba_reset(struct snic *snic, struct scsi_cmnd *sc)
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
@@ -2322,11 +2303,13 @@ snic_issue_hba_reset(struct snic *snic, struct scsi_cmnd *sc)
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
@@ -2351,6 +2334,18 @@ snic_reset(struct Scsi_Host *shost, struct scsi_cmnd *sc)
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
@@ -2368,6 +2363,10 @@ snic_reset(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	ret = SUCCESS;
 
 reset_end:
+	SNIC_TRC(shost->host_no, sc ? snic_cmd_tag(sc) : SCSI_NO_TAG,
+		 (ulong) sc, jiffies_to_msecs(jiffies - start_time),
+		 0, 0, 0);
+
 	return ret;
 } /* end of snic_reset */
 
@@ -2382,21 +2381,13 @@ int
 snic_host_reset(struct scsi_cmnd *sc)
 {
 	struct Scsi_Host *shost = sc->device->host;
-	u32 start_time  = jiffies;
-	int ret = FAILED;
 
 	SNIC_SCSI_DBG(shost,
 		      "host reset:sc %p sc_cmd 0x%x req %p tag %d flags 0x%llx\n",
 		      sc, sc->cmnd[0], sc->request,
 		      snic_cmd_tag(sc), CMD_FLAGS(sc));
 
-	ret = snic_reset(shost, sc);
-
-	SNIC_TRC(shost->host_no, snic_cmd_tag(sc), (ulong) sc,
-		 jiffies_to_msecs(jiffies - start_time),
-		 0, SNIC_TRC_CMD(sc), SNIC_TRC_CMD_STATE_FLAGS(sc));
-
-	return ret;
+	return snic_reset(shost);
 } /* end of snic_host_reset */
 
 /*
-- 
2.29.2

