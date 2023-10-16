Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A97EACDB474
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 09:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233043AbjJPJZC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 05:25:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232661AbjJPJYt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 05:24:49 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6F5B4
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 02:24:46 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id AFC951FEB7;
        Mon, 16 Oct 2023 09:24:44 +0000 (UTC)
Received: from adalid.arch.suse.de (adalid.arch.suse.de [10.161.8.13])
        by relay2.suse.de (Postfix) with ESMTP id 2590E2CB4A;
        Mon, 16 Oct 2023 09:24:44 +0000 (UTC)
Received: by adalid.arch.suse.de (Postfix, from userid 16045)
        id E68F651EBDD3; Mon, 16 Oct 2023 11:24:43 +0200 (CEST)
From:   Hannes Reinecke <hare@suse.de>
To:     Christoph Hellwig <hch@lst.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/17] snic: reserve tag for TMF
Date:   Mon, 16 Oct 2023 11:24:24 +0200
Message-Id: <20231016092430.55557-12-hare@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20231016092430.55557-1-hare@suse.de>
References: <20231016092430.55557-1-hare@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++++++
Authentication-Results: smtp-out2.suse.de;
        dkim=none;
        dmarc=none;
        spf=softfail (smtp-out2.suse.de: 149.44.160.134 is neither permitted nor denied by domain of hare@suse.de) smtp.mailfrom=hare@suse.de
X-Rspamd-Server: rspamd2
X-Spamd-Result: default: False [8.49 / 50.00];
         ARC_NA(0.00)[];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.20)[suse.de];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.60)[~all:c];
         RCPT_COUNT_FIVE(0.00)[5];
         TO_MATCH_ENVRCPT_SOME(0.00)[];
         VIOLATED_DIRECT_SPF(3.50)[];
         MX_GOOD(-0.01)[];
         NEURAL_SPAM_LONG(3.00)[1.000];
         MID_CONTAINS_FROM(1.00)[];
         RWL_MAILSPIKE_GOOD(0.00)[149.44.160.134:from];
         NEURAL_HAM_SHORT(-1.00)[-1.000];
         RCVD_NO_TLS_LAST(0.10)[];
         FROM_EQ_ENVFROM(0.00)[];
         R_DKIM_NA(0.20)[];
         MIME_TRACE(0.00)[0:+];
         RCVD_COUNT_TWO(0.00)[2];
         BAYES_HAM(-3.00)[100.00%]
X-Rspamd-Queue-Id: AFC951FEB7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Rework the hba reset function to not rely on scsi commands and
reserve one command for HBA reset.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/snic/snic.h      |  2 +-
 drivers/scsi/snic/snic_main.c |  5 ++-
 drivers/scsi/snic/snic_scsi.c | 82 ++++++++---------------------------
 3 files changed, 21 insertions(+), 68 deletions(-)

diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index 32f5a34b6987..0b7411624bcf 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -366,7 +366,7 @@ int snic_queuecommand(struct Scsi_Host *, struct scsi_cmnd *);
 int snic_abort_cmd(struct scsi_cmnd *);
 int snic_device_reset(struct scsi_cmnd *);
 int snic_host_reset(struct scsi_cmnd *);
-int snic_reset(struct Scsi_Host *, struct scsi_cmnd *);
+int snic_reset(struct Scsi_Host *);
 void snic_shutdown_scsi_cleanup(struct snic *);
 
 
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index cc824dcfe7da..9bee91eedc10 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -494,9 +494,10 @@ snic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	/* Configure Maximum Outstanding IO reqs */
 	max_ios = snic->config.io_throttle_count;
 	if (max_ios != SNIC_UCSM_DFLT_THROTTLE_CNT_BLD)
-		shost->can_queue = min_t(u32, SNIC_MAX_IO_REQ,
+		max_ios = min_t(u32, SNIC_MAX_IO_REQ,
 					 max_t(u32, SNIC_MIN_IO_REQ, max_ios));
-
+	/* Reserve one tag for HBA reset */
+	shost->can_queue = max_ios - 1;
 	snic->max_tag_id = shost->can_queue;
 
 	shost->max_lun = snic->config.luns_per_tgt;
diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index c50ede326cc4..f1ef781df837 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -952,13 +952,13 @@ snic_itmf_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 
 
 static void
-snic_hba_reset_scsi_cleanup(struct snic *snic, struct scsi_cmnd *sc)
+snic_hba_reset_scsi_cleanup(struct snic *snic)
 {
 	struct snic_stats *st = &snic->s_stats;
 	long act_ios = 0, act_fwreqs = 0;
 
 	SNIC_SCSI_DBG(snic->shost, "HBA Reset scsi cleanup.\n");
-	snic_scsi_cleanup(snic, snic_cmd_tag(sc));
+	snic_scsi_cleanup(snic, snic->max_tag_id);
 
 	/* Update stats on pending IOs */
 	act_ios = atomic64_read(&st->io.active);
@@ -984,7 +984,6 @@ snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 	u32 hid;
 	u8 typ;
 	u8 hdr_stat;
-	struct scsi_cmnd *sc = NULL;
 	struct snic_req_info *rqi = NULL;
 	spinlock_t *io_lock = NULL;
 	unsigned long flags, gflags;
@@ -999,18 +998,9 @@ snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
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
+	rqi = (struct snic_req_info *) ctx;
 
-	if (cmnd_id >= snic->max_tag_id) {
+	if (cmnd_id != snic->max_tag_id) {
 		SNIC_HOST_ERR(snic->shost,
 			      "reset_cmpl: Tag 0x%x out of Range,HdrStat %s\n",
 			      cmnd_id, snic_io_status_to_str(hdr_stat));
@@ -1019,55 +1009,35 @@ snic_hba_reset_cmpl_handler(struct snic *snic, struct snic_fw_req *fwreq)
 		return 1;
 	}
 
-	sc = scsi_host_find_tag(snic->shost, cmnd_id);
-ioctl_hba_rst:
-	if (!sc) {
-		atomic64_inc(&snic->s_stats.io.sc_null);
-		SNIC_HOST_ERR(snic->shost,
-			      "reset_cmpl: sc is NULL - Hdr Stat %s Tag 0x%x\n",
-			      snic_io_status_to_str(hdr_stat), cmnd_id);
-		ret = 1;
-
-		return ret;
-	}
-
 	SNIC_HOST_INFO(snic->shost,
-		       "reset_cmpl: sc %p rqi %p Tag %d flags 0x%llx\n",
-		       sc, rqi, cmnd_id, CMD_FLAGS(sc));
+		       "reset_cmpl: rqi %p Tag %d\n", rqi, cmnd_id);
 
-	io_lock = snic_io_lock_hash(snic, sc);
+	io_lock = snic_io_lock_tag(snic, cmnd_id);
 	spin_lock_irqsave(io_lock, flags);
 
 	if (!snic->remove_wait) {
 		spin_unlock_irqrestore(io_lock, flags);
 		SNIC_HOST_ERR(snic->shost,
 			      "reset_cmpl:host reset completed after timeout\n");
-		ret = 1;
-
-		return ret;
+		return 1;
 	}
 
-	rqi = (struct snic_req_info *) CMD_SP(sc);
 	WARN_ON_ONCE(!rqi);
 
 	if (!rqi) {
 		atomic64_inc(&snic->s_stats.io.req_null);
 		spin_unlock_irqrestore(io_lock, flags);
-		CMD_FLAGS(sc) |= SNIC_IO_ABTS_TERM_REQ_NULL;
 		SNIC_HOST_ERR(snic->shost,
-			      "reset_cmpl: rqi is null,Hdr stat %s Tag 0x%x sc 0x%p flags 0x%llx\n",
-			      snic_io_status_to_str(hdr_stat), cmnd_id, sc,
-			      CMD_FLAGS(sc));
-
-		ret = 1;
+			      "reset_cmpl: rqi is null,Hdr stat %s Tag 0x%x\n",
+			      snic_io_status_to_str(hdr_stat), cmnd_id);
 
-		return ret;
+		return 1;
 	}
 	/* stats */
 	spin_unlock_irqrestore(io_lock, flags);
 
 	/* scsi cleanup */
-	snic_hba_reset_scsi_cleanup(snic, sc);
+	snic_hba_reset_scsi_cleanup(snic);
 
 	SNIC_BUG_ON(snic_get_state(snic) != SNIC_OFFLINE &&
 		    snic_get_state(snic) != SNIC_FWRESET);
@@ -2203,7 +2173,7 @@ snic_device_reset(struct scsi_cmnd *sc)
  * snic_issue_hba_reset : Queues FW Reset Request.
  */
 static int
-snic_issue_hba_reset(struct snic *snic, struct scsi_cmnd *sc)
+snic_issue_hba_reset(struct snic *snic)
 {
 	struct snic_req_info *rqi = NULL;
 	struct snic_host_req *req = NULL;
@@ -2219,26 +2189,15 @@ snic_issue_hba_reset(struct snic *snic, struct scsi_cmnd *sc)
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
 
-	io_lock = snic_io_lock_hash(snic, sc);
+	io_lock = snic_io_lock_tag(snic, snic->max_tag_id);
 	spin_lock_irqsave(io_lock, flags);
-	SNIC_BUG_ON(CMD_SP(sc) != NULL);
-	CMD_STATE(sc) = SNIC_IOREQ_PENDING;
-	CMD_SP(sc) = (char *) rqi;
-	CMD_FLAGS(sc) |= SNIC_IO_INITIALIZED;
 	snic->remove_wait = &wait;
 	spin_unlock_irqrestore(io_lock, flags);
 
 	/* Initialize Request */
-	snic_io_hdr_enc(&req->hdr, SNIC_REQ_HBA_RESET, 0, snic_cmd_tag(sc),
+	snic_io_hdr_enc(&req->hdr, SNIC_REQ_HBA_RESET, 0, snic->max_tag_id,
 			snic->config.hid, 0, (ulong) rqi);
 
 	req->u.reset.flags = 0;
@@ -2252,9 +2211,6 @@ snic_issue_hba_reset(struct snic *snic, struct scsi_cmnd *sc)
 		goto hba_rst_err;
 	}
 
-	spin_lock_irqsave(io_lock, flags);
-	CMD_FLAGS(sc) |= SNIC_HOST_RESET_ISSUED;
-	spin_unlock_irqrestore(io_lock, flags);
 	atomic64_inc(&snic->s_stats.reset.hba_resets);
 	SNIC_HOST_INFO(snic->shost, "Queued HBA Reset Successfully.\n");
 
@@ -2270,8 +2226,6 @@ snic_issue_hba_reset(struct snic *snic, struct scsi_cmnd *sc)
 
 	spin_lock_irqsave(io_lock, flags);
 	snic->remove_wait = NULL;
-	rqi = (struct snic_req_info *) CMD_SP(sc);
-	CMD_SP(sc) = NULL;
 	spin_unlock_irqrestore(io_lock, flags);
 
 	if (rqi)
@@ -2284,8 +2238,6 @@ snic_issue_hba_reset(struct snic *snic, struct scsi_cmnd *sc)
 hba_rst_err:
 	spin_lock_irqsave(io_lock, flags);
 	snic->remove_wait = NULL;
-	rqi = (struct snic_req_info *) CMD_SP(sc);
-	CMD_SP(sc) = NULL;
 	spin_unlock_irqrestore(io_lock, flags);
 
 	if (rqi)
@@ -2300,7 +2252,7 @@ snic_issue_hba_reset(struct snic *snic, struct scsi_cmnd *sc)
 } /* end of snic_issue_hba_reset */
 
 int
-snic_reset(struct Scsi_Host *shost, struct scsi_cmnd *sc)
+snic_reset(struct Scsi_Host *shost)
 {
 	struct snic *snic = shost_priv(shost);
 	enum snic_state sv_state;
@@ -2329,7 +2281,7 @@ snic_reset(struct Scsi_Host *shost, struct scsi_cmnd *sc)
 	while (atomic_read(&snic->ios_inflight))
 		schedule_timeout(msecs_to_jiffies(1));
 
-	ret = snic_issue_hba_reset(snic, sc);
+	ret = snic_issue_hba_reset(snic);
 	if (ret) {
 		SNIC_HOST_ERR(shost,
 			      "reset:Host Reset Failed w/ err %d.\n",
@@ -2368,7 +2320,7 @@ snic_host_reset(struct scsi_cmnd *sc)
 		      sc, sc->cmnd[0], scsi_cmd_to_rq(sc),
 		      snic_cmd_tag(sc), CMD_FLAGS(sc));
 
-	ret = snic_reset(shost, sc);
+	ret = snic_reset(shost);
 
 	SNIC_TRC(shost->host_no, snic_cmd_tag(sc), (ulong) sc,
 		 jiffies_to_msecs(jiffies - start_time),
-- 
2.35.3

