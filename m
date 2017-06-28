From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/47] snic: reserve tag for TMF
Date: Wed, 28 Jun 2017 10:32:37 +0200
Message-ID: <1498638793-44672-12-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53812 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751559AbdF1IdU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:20 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Rather than re-using the failed command the snic driver should
reserve one command for TMFs.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/snic/snic.h      |  3 ++-
 drivers/scsi/snic/snic_main.c |  3 +++
 drivers/scsi/snic/snic_scsi.c | 51 ++++++++++++++++++-------------------------
 3 files changed, 26 insertions(+), 31 deletions(-)

diff --git a/drivers/scsi/snic/snic.h b/drivers/scsi/snic/snic.h
index de0ab5f..46837ee9 100644
--- a/drivers/scsi/snic/snic.h
+++ b/drivers/scsi/snic/snic.h
@@ -310,6 +310,7 @@ struct snic {
 	struct list_head spl_cmd_list;
 
 	unsigned int max_tag_id;
+	unsigned int tmf_tag_id;
 	atomic_t ios_inflight;		/* io in flight counter */
 
 	struct vnic_snic_config config;
@@ -380,7 +381,7 @@ struct snic_global {
 int snic_abort_cmd(struct scsi_cmnd *);
 int snic_device_reset(struct scsi_cmnd *);
 int snic_host_reset(struct scsi_cmnd *);
-int snic_reset(struct Scsi_Host *, struct scsi_cmnd *);
+int snic_reset(struct Scsi_Host *);
 void snic_shutdown_scsi_cleanup(struct snic *);
 
 
diff --git a/drivers/scsi/snic/snic_main.c b/drivers/scsi/snic/snic_main.c
index 7cf70aa..0530ca1 100644
--- a/drivers/scsi/snic/snic_main.c
+++ b/drivers/scsi/snic/snic_main.c
@@ -538,6 +538,9 @@
 					 max_t(u32, SNIC_MIN_IO_REQ, max_ios));
 
 	snic->max_tag_id = shost->can_queue;
+	/* Reserve one reset command */
+	shost->can_queue--;
+	snic->tmf_tag_id = shost->can_queue;
 
 	shost->max_lun = snic->config.luns_per_tgt;
 	shost->max_id = SNIC_MAX_TARGET;
diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index 05c3a72..56b0eb4 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -1022,17 +1022,6 @@
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
@@ -1043,7 +1032,6 @@
 	}
 
 	sc = scsi_host_find_tag(snic->shost, cmnd_id);
-ioctl_hba_rst:
 	if (!sc) {
 		atomic64_inc(&snic->s_stats.io.sc_null);
 		SNIC_HOST_ERR(snic->shost,
@@ -1733,7 +1721,7 @@
 {
 	struct snic_req_info *rqi = NULL;
 	struct snic_tgt *tgt = NULL;
-	struct scsi_cmnd *sc = NULL;
+	struct scsi_cmnd *sc;
 	spinlock_t *io_lock = NULL;
 	u32 sv_state = 0, tmf = 0;
 	DECLARE_COMPLETION_ONSTACK(tm_done);
@@ -2246,13 +2234,6 @@
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
@@ -2327,11 +2308,13 @@
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
@@ -2356,6 +2339,18 @@
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
@@ -2373,6 +2368,10 @@
 	ret = SUCCESS;
 
 reset_end:
+	SNIC_TRC(shost->host_no, sc ? snic_cmd_tag(sc) : SCSI_NO_TAG,
+		 (ulong) sc, jiffies_to_msecs(jiffies - start_time),
+		 0, 0, 0);
+
 	return ret;
 } /* end of snic_reset */
 
@@ -2387,21 +2386,13 @@
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
1.8.5.6
