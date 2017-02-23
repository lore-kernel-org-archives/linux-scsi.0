From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/2] scsi: remove scsi_execute_req_flags
Date: Thu, 23 Feb 2017 16:02:37 +0100
Message-ID: <20170223150237.21710-3-hch@lst.de>
References: <20170223150237.21710-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:60661 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751041AbdBWPbx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Feb 2017 10:31:53 -0500
In-Reply-To: <20170223150237.21710-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

And switch all callers to use scsi_execute instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/device_handler/scsi_dh_alua.c  | 16 ++++++----------
 drivers/scsi/device_handler/scsi_dh_emc.c   |  7 +++----
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 10 ++++------
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  7 +++----
 drivers/scsi/scsi_lib.c                     | 11 -----------
 drivers/scsi/sd.c                           |  9 ++++-----
 drivers/scsi/ufs/ufshcd.c                   | 10 +++++-----
 include/scsi/scsi_device.h                  |  8 ++------
 8 files changed, 27 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index d704752b6332..48e200102221 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -151,11 +151,9 @@ static int submit_rtpg(struct scsi_device *sdev, unsigned char *buff,
 		cdb[1] = MI_REPORT_TARGET_PGS;
 	put_unaligned_be32(bufflen, &cdb[6]);
 
-	return scsi_execute_req_flags(sdev, cdb, DMA_FROM_DEVICE,
-				      buff, bufflen, sshdr,
-				      ALUA_FAILOVER_TIMEOUT * HZ,
-				      ALUA_FAILOVER_RETRIES, NULL,
-				      req_flags, 0);
+	return scsi_execute(sdev, cdb, DMA_FROM_DEVICE, buff, bufflen, NULL,
+			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
+			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
 }
 
 /*
@@ -185,11 +183,9 @@ static int submit_stpg(struct scsi_device *sdev, int group_id,
 	cdb[1] = MO_SET_TARGET_PGS;
 	put_unaligned_be32(stpg_len, &cdb[6]);
 
-	return scsi_execute_req_flags(sdev, cdb, DMA_TO_DEVICE,
-				      stpg_data, stpg_len,
-				      sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
-				      ALUA_FAILOVER_RETRIES, NULL,
-				      req_flags, 0);
+	return scsi_execute(sdev, cdb, DMA_TO_DEVICE, stpg_data, stpg_len, NULL,
+			sshdr, ALUA_FAILOVER_TIMEOUT * HZ,
+			ALUA_FAILOVER_RETRIES, req_flags, 0, NULL);
 }
 
 static struct alua_port_group *alua_find_get_pg(char *id_str, size_t id_size,
diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index f1578832ec7a..8654e940e1a8 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -276,10 +276,9 @@ static int send_trespass_cmd(struct scsi_device *sdev,
 	BUG_ON((len > CLARIION_BUFFER_SIZE));
 	memcpy(csdev->buffer, page22, len);
 
-	err = scsi_execute_req_flags(sdev, cdb, DMA_TO_DEVICE,
-				     csdev->buffer, len, &sshdr,
-				     CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
-				     NULL, req_flags, 0);
+	err = scsi_execute(sdev, cdb, DMA_TO_DEVICE, csdev->buffer, len, NULL,
+			&sshdr, CLARIION_TIMEOUT * HZ, CLARIION_RETRIES,
+			req_flags, 0, NULL);
 	if (err) {
 		if (scsi_sense_valid(&sshdr))
 			res = trespass_endio(sdev, &sshdr);
diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index be43c940636d..62d314e07d11 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -100,9 +100,8 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 		REQ_FAILFAST_DRIVER;
 
 retry:
-	res = scsi_execute_req_flags(sdev, cmd, DMA_NONE, NULL, 0, &sshdr,
-				     HP_SW_TIMEOUT, HP_SW_RETRIES,
-				     NULL, req_flags, 0);
+	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
 	if (res) {
 		if (scsi_sense_valid(&sshdr))
 			ret = tur_done(sdev, h, &sshdr);
@@ -139,9 +138,8 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 		REQ_FAILFAST_DRIVER;
 
 retry:
-	res = scsi_execute_req_flags(sdev, cmd, DMA_NONE, NULL, 0, &sshdr,
-				     HP_SW_TIMEOUT, HP_SW_RETRIES,
-				     NULL, req_flags, 0);
+	res = scsi_execute(sdev, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+			HP_SW_TIMEOUT, HP_SW_RETRIES, req_flags, 0, NULL);
 	if (res) {
 		if (!scsi_sense_valid(&sshdr)) {
 			sdev_printk(KERN_WARNING, sdev,
diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index b64eaae8533d..3cbab8710e58 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -555,10 +555,9 @@ static void send_mode_select(struct work_struct *work)
 		(char *) h->ctlr->array_name, h->ctlr->index,
 		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
 
-	if (scsi_execute_req_flags(sdev, cdb, DMA_TO_DEVICE,
-				   &h->ctlr->mode_select, data_size, &sshdr,
-				   RDAC_TIMEOUT * HZ,
-				   RDAC_RETRIES, NULL, req_flags, 0)) {
+	if (scsi_execute(sdev, cdb, DMA_TO_DEVICE, &h->ctlr->mode_select,
+			data_size, NULL, &sshdr, RDAC_TIMEOUT * HZ,
+			RDAC_RETRIES, req_flags, 0, NULL)) {
 		err = mode_select_handle_sense(sdev, &sshdr);
 		if (err == SCSI_DH_RETRY && retry_cnt--)
 			goto retry;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b0cb3e0713f3..f5e45a252485 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -289,17 +289,6 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 }
 EXPORT_SYMBOL(scsi_execute);
 
-int scsi_execute_req_flags(struct scsi_device *sdev, const unsigned char *cmd,
-		     int data_direction, void *buffer, unsigned bufflen,
-		     struct scsi_sense_hdr *sshdr, int timeout, int retries,
-		     int *resid, u64 flags, req_flags_t rq_flags)
-{
-	return scsi_execute(sdev, cmd, data_direction, buffer, bufflen,
-			      NULL, sshdr, timeout, retries, flags, rq_flags,
-			      resid);
-}
-EXPORT_SYMBOL(scsi_execute_req_flags);
-
 /*
  * Function:    scsi_init_cmd_errh()
  *
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index be535d4215c4..c7839f6c35cc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1508,9 +1508,8 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 		 * Leave the rest of the command zero to indicate
 		 * flush everything.
 		 */
-		res = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0,
-					     &sshdr, timeout, SD_MAX_RETRIES,
-					     NULL, 0, RQF_PM);
+		res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+				timeout, SD_MAX_RETRIES, 0, RQF_PM, NULL);
 		if (res == 0)
 			break;
 	}
@@ -3296,8 +3295,8 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	res = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-			       SD_TIMEOUT, SD_MAX_RETRIES, NULL, 0, RQF_PM);
+	res = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+			SD_TIMEOUT, SD_MAX_RETRIES, 0, RQF_PM, NULL);
 	if (res) {
 		sd_print_result(sdkp, "Start/Stop Unit failed", res);
 		if (driver_byte(res) & DRIVER_SENSE)
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8b721f431dd0..dc6efbd1be8e 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6915,9 +6915,9 @@ ufshcd_send_request_sense(struct ufs_hba *hba, struct scsi_device *sdp)
 		goto out;
 	}
 
-	ret = scsi_execute_req_flags(sdp, cmd, DMA_FROM_DEVICE, buffer,
-				UFSHCD_REQ_SENSE_SIZE, NULL,
-				msecs_to_jiffies(1000), 3, NULL, 0, RQF_PM);
+	ret = scsi_execute(sdp, cmd, DMA_FROM_DEVICE, buffer,
+			UFSHCD_REQ_SENSE_SIZE, NULL, NULL,
+			msecs_to_jiffies(1000), 3, 0, RQF_PM, NULL);
 	if (ret)
 		pr_err("%s: failed with err %d\n", __func__, ret);
 
@@ -6982,8 +6982,8 @@ static int ufshcd_set_dev_pwr_mode(struct ufs_hba *hba,
 	 * callbacks hence set the RQF_PM flag so that it doesn't resume the
 	 * already suspended childs.
 	 */
-	ret = scsi_execute_req_flags(sdp, cmd, DMA_NONE, NULL, 0, &sshdr,
-				     START_STOP_TIMEOUT, 0, NULL, 0, RQF_PM);
+	ret = scsi_execute(sdp, cmd, DMA_NONE, NULL, 0, NULL, &sshdr,
+			START_STOP_TIMEOUT, 0, 0, RQF_PM, NULL);
 	if (ret) {
 		sdev_printk(KERN_WARNING, sdp,
 			    "START_STOP failed for power mode: %d, result %x\n",
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index cb4c8c889da0..6f22b39f1b0c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -413,17 +413,13 @@ extern int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 			unsigned char *sense, struct scsi_sense_hdr *sshdr,
 			int timeout, int retries, u64 flags,
 			req_flags_t rq_flags, int *resid);
-extern int scsi_execute_req_flags(struct scsi_device *sdev,
-	const unsigned char *cmd, int data_direction, void *buffer,
-	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
-	int retries, int *resid, u64 flags, req_flags_t rq_flags);
 static inline int scsi_execute_req(struct scsi_device *sdev,
 	const unsigned char *cmd, int data_direction, void *buffer,
 	unsigned bufflen, struct scsi_sense_hdr *sshdr, int timeout,
 	int retries, int *resid)
 {
-	return scsi_execute_req_flags(sdev, cmd, data_direction, buffer,
-		bufflen, sshdr, timeout, retries, resid, 0, 0);
+	return scsi_execute(sdev, cmd, data_direction, buffer,
+		bufflen, NULL, sshdr, timeout, retries,  0, 0, resid);
 }
 extern void sdev_disable_disk_events(struct scsi_device *sdev);
 extern void sdev_enable_disk_events(struct scsi_device *sdev);
-- 
2.11.0
