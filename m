Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F358F55792
	for <linux-scsi@vger.kernel.org>; Wed, 22 Nov 2023 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="se6rW82k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD26C433C8;
	Wed, 22 Nov 2023 15:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700667140;
	bh=wkCvBo8jEkVfRTkbglYo4Y8OHDg05/CV6/9Vs8YdR8g=;
	h=From:To:Cc:Subject:Date:From;
	b=se6rW82kVocMdGPK4qlRzBGluXE4h2xOM+5IM4DNM/SZuKhc12aoeCC9ZnIjH2NKk
	 4EZ6tb7r+IPal0h//+fZpmr3hIdurkjsGRf3DSWPrvwrLUzdi6znEeySKbhnlPlnhH
	 KTHrvQr5jekdTbDfsIW2UyE0lYvDQwRv51XV98i+PAdjfIhg9Ea2z3PMEKCccrZCtJ
	 nSYR+4qg7hm/sXzvgMbbTRAw647A6BrOCPhPzdfrfxrA/8N4SFzYrgs67ZzbKErj3o
	 P2RWhv9dowUX6pD0UWpvRqOEKPxR9zfPFUDXxB5euSPIre0ZBOy2B5G0fzBCMhxZNn
	 Pzqh7ocbdvrHQ==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Mike Christie <michael.christie@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Martin Wilck <mwilck@suse.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	jejb@linux.ibm.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 01/17] scsi: sd: Fix sshdr use in sd_suspend_common()
Date: Wed, 22 Nov 2023 10:31:30 -0500
Message-ID: <20231122153212.852040-1-sashal@kernel.org>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.2
Content-Transfer-Encoding: 8bit

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 3b83486399a6a9feb9c681b74c21a227d48d7020 ]

If scsi_execute_cmd() returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. sd_sync_cache() will
only access the sshdr if it's been setup because it calls
scsi_status_is_check_condition() before accessing it. However, the
sd_sync_cache() caller, sd_suspend_common(), does not check.

sd_suspend_common() is only checking for ILLEGAL_REQUEST which it's using
to determine if the command is supported. If it's not it just ignores the
error. So to fix its sshdr use this patch just moves that check to
sd_sync_cache() where it converts ILLEGAL_REQUEST to success/0.
sd_suspend_common() was ignoring that error and sd_shutdown() doesn't check
for errors so there will be no behavior changes.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Link: https://lore.kernel.org/r/20231106231304.5694-2-michael.christie@oracle.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 53 ++++++++++++++++++++---------------------------
 1 file changed, 23 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6effa13039f39..ac5e917f7abd6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1642,24 +1642,21 @@ static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
 	return disk_changed ? DISK_EVENT_MEDIA_CHANGE : 0;
 }
 
-static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
+static int sd_sync_cache(struct scsi_disk *sdkp)
 {
 	int retries, res;
 	struct scsi_device *sdp = sdkp->device;
 	const int timeout = sdp->request_queue->rq_timeout
 		* SD_FLUSH_TIMEOUT_MULTIPLIER;
-	struct scsi_sense_hdr my_sshdr;
+	struct scsi_sense_hdr sshdr;
 	const struct scsi_exec_args exec_args = {
 		.req_flags = BLK_MQ_REQ_PM,
-		/* caller might not be interested in sense, but we need it */
-		.sshdr = sshdr ? : &my_sshdr,
+		.sshdr = &sshdr,
 	};
 
 	if (!scsi_device_online(sdp))
 		return -ENODEV;
 
-	sshdr = exec_args.sshdr;
-
 	for (retries = 3; retries > 0; --retries) {
 		unsigned char cmd[16] = { 0 };
 
@@ -1684,15 +1681,23 @@ static int sd_sync_cache(struct scsi_disk *sdkp, struct scsi_sense_hdr *sshdr)
 			return res;
 
 		if (scsi_status_is_check_condition(res) &&
-		    scsi_sense_valid(sshdr)) {
-			sd_print_sense_hdr(sdkp, sshdr);
+		    scsi_sense_valid(&sshdr)) {
+			sd_print_sense_hdr(sdkp, &sshdr);
 
 			/* we need to evaluate the error return  */
-			if (sshdr->asc == 0x3a ||	/* medium not present */
-			    sshdr->asc == 0x20 ||	/* invalid command */
-			    (sshdr->asc == 0x74 && sshdr->ascq == 0x71))	/* drive is password locked */
+			if (sshdr.asc == 0x3a ||	/* medium not present */
+			    sshdr.asc == 0x20 ||	/* invalid command */
+			    (sshdr.asc == 0x74 && sshdr.ascq == 0x71))	/* drive is password locked */
 				/* this is no error here */
 				return 0;
+			/*
+			 * This drive doesn't support sync and there's not much
+			 * we can do because this is called during shutdown
+			 * or suspend so just return success so those operations
+			 * can proceed.
+			 */
+			if (sshdr.sense_key == ILLEGAL_REQUEST)
+				return 0;
 		}
 
 		switch (host_byte(res)) {
@@ -3847,7 +3852,7 @@ static void sd_shutdown(struct device *dev)
 
 	if (sdkp->WCE && sdkp->media_present) {
 		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		sd_sync_cache(sdkp, NULL);
+		sd_sync_cache(sdkp);
 	}
 
 	if ((system_state != SYSTEM_RESTART &&
@@ -3868,7 +3873,6 @@ static inline bool sd_do_start_stop(struct scsi_device *sdev, bool runtime)
 static int sd_suspend_common(struct device *dev, bool runtime)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
-	struct scsi_sense_hdr sshdr;
 	int ret = 0;
 
 	if (!sdkp)	/* E.g.: runtime suspend following sd_remove() */
@@ -3877,24 +3881,13 @@ static int sd_suspend_common(struct device *dev, bool runtime)
 	if (sdkp->WCE && sdkp->media_present) {
 		if (!sdkp->device->silence_suspend)
 			sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
-		ret = sd_sync_cache(sdkp, &sshdr);
-
-		if (ret) {
-			/* ignore OFFLINE device */
-			if (ret == -ENODEV)
-				return 0;
-
-			if (!scsi_sense_valid(&sshdr) ||
-			    sshdr.sense_key != ILLEGAL_REQUEST)
-				return ret;
+		ret = sd_sync_cache(sdkp);
+		/* ignore OFFLINE device */
+		if (ret == -ENODEV)
+			return 0;
 
-			/*
-			 * sshdr.sense_key == ILLEGAL_REQUEST means this drive
-			 * doesn't support sync. There's not much to do and
-			 * suspend shouldn't fail.
-			 */
-			ret = 0;
-		}
+		if (ret)
+			return ret;
 	}
 
 	if (sd_do_start_stop(sdkp->device, runtime)) {
-- 
2.42.0

