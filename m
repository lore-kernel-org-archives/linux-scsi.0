Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FD03C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 11:13:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353096AbiELLNn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 07:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353041AbiELLM6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 07:12:58 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A33E565D0D
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 04:12:53 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 634E71F935;
        Thu, 12 May 2022 11:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652353966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=afNDgdCMsbxlbqYImqGCF65kYSrnWmCqxVEFBqiN78g=;
        b=jPj8759LniirFdHje4MFsojOlwW7NHFhm4E0L/Nbzi5qdtQ7AN5UJVZwQWpLwzcTC2SDA1
        862V4yMoUW4bvwNrfJncBFuv0+7h74sKZcBxOOAaDr94pgG7MKSnQdKUGf0DwjJQ3Esd7U
        BB9vY1PU6up6s7YyJbH4RGaUr9vD7xA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652353966;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=afNDgdCMsbxlbqYImqGCF65kYSrnWmCqxVEFBqiN78g=;
        b=80HJoqQ4aTt5OmzADuedmo9qDt1P2s7TGiNCDQ0PUnIqzkCM6D/1Vh0u038RkALiQYz8qd
        izQ2lHtawqgF+5BQ==
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 545972C15F;
        Thu, 12 May 2022 11:12:46 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id 2F91F51943F8; Thu, 12 May 2022 13:12:46 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 16/20] snic: reserve tag for TMF
Date:   Thu, 12 May 2022 13:12:32 +0200
Message-Id: <20220512111236.109851-17-hare@suse.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20220512111236.109851-1-hare@suse.de>
References: <20220512111236.109851-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rather than re-using the failed command the snic driver should
reserve one command for TMFs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/scsi/snic/snic.h      |  2 +-
 drivers/scsi/snic/snic_main.c |  8 +++++++
 drivers/scsi/snic/snic_scsi.c | 44 +++++++++++++++++------------------
 3 files changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index 4ec7e30678e1..28059b66f191 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -380,7 +380,7 @@ int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int snic_abort_cmd(struct scsi_cmnd *);
 int snic_device_reset(struct scsi_cmnd *);
 int snic_host_reset(struct scsi_cmnd *);
-int snic_reset(struct Scsi_Host *, struct scsi_cmnd *);
+int snic_reset(struct Scsi_Host *);
 void snic_shutdown_scsi_cleanup(struct snic *);
 
 
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 29d56396058c..3375153dd636 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -663,6 +663,14 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_get_conf;
 	}
 
+	/*
+	 * Hack alert: reduce can_queue by one after scsi_add_host()
+	 * had been called.
+	 * This essentially reserves the topmost request for TMF.
+	 * Should be replaced by reserved command
+	 * once support is being added.
+	 */
+	shost->can_queue--;
 	snic_set_state(snic, SNIC_ONLINE);
 
 	ret = snic_disc_start(snic);
diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 5f17666f3e1d..e69bed855a39 100644
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
@@ -2348,6 +2331,19 @@ snic_reset(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	while (atomic_read(&snic->ios_inflight))
 		schedule_timeout(msecs_to_jiffies(1));
 
+	/* The topmost command is reserved for TMF */
+	sc = scsi_host_find_tag(shost, snic->max_tag_id - 1);
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
@@ -2365,6 +2361,10 @@ snic_reset(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	ret = SUCCESS;
 
 reset_end:
+	SNIC_TRC(shost->host_no, sc ? snic_cmd_tag(sc) : SCSI_NO_TAG,
+		 (ulong) sc, jiffies_to_msecs(jiffies - start_time),
+		 0, 0, 0);
+
 	return ret;
 } /* end of snic_reset */
 
@@ -2387,7 +2387,7 @@ snic_host_reset(struct scsi_cmnd *sc)
 		      sc, sc->cmnd[0], scsi_cmd_to_rq(sc),
 		      snic_cmd_tag(sc), CMD_FLAGS(sc));
 
-	ret = snic_reset(shost, sc);
+	ret = snic_reset(shost);
 
 	SNIC_TRC(shost->host_no, snic_cmd_tag(sc), (ulong) sc,
 		 jiffies_to_msecs(jiffies - start_time),
-- 
2.29.2

