From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 45/47] snic: use dedicated device reset command
Date: Wed, 28 Jun 2017 10:33:11 +0200
Message-ID: <1498638793-44672-46-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53825 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751900AbdF1Idf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:35 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Use a dedicated command to send a device reset instead of relying
on using the command which triggered the device failure.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/snic/snic_scsi.c | 52 ++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/snic/snic_scsi.c b/drivers/scsi/snic/snic_scsi.c
index ec11293..f50d274 100644
--- a/drivers/scsi/snic/snic_scsi.c
+++ b/drivers/scsi/snic/snic_scsi.c
@@ -2136,57 +2136,53 @@
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
-		      sc, sc->cmnd[0], sc->request,
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
 
@@ -2196,7 +2192,7 @@
 	ret = snic_dr_finish(snic, sc);
 
 dev_rst_end:
-	SNIC_TRC(snic->shost->host_no, tag, (ulong) sc,
+	SNIC_TRC(snic->shost->host_no, snic_cmd_tag(sc), (ulong) sc,
 		 jiffies_to_msecs(jiffies - start_time),
 		 0, SNIC_TRC_CMD(sc), SNIC_TRC_CMD_STATE_FLAGS(sc));
 
@@ -2347,7 +2343,7 @@
 		schedule_timeout(msecs_to_jiffies(1));
 
 	sc = scsi_host_find_tag(shost, snic->tmf_tag_id);
-	if (!sc) {
+	if (!sc || CMD_SP(sc)) {
 		SNIC_HOST_ERR(shost,
 			      "reset:Host Reset Failed to allocate sc.\n");
 		spin_lock_irqsave(&snic->snic_lock, flags);
-- 
1.8.5.6
