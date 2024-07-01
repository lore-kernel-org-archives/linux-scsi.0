Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FEF381B0
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jul 2024 21:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719870809; cv=none; b=g/thiCnhIDP/J6yqxt4fhPQy8QcjEvdyvXZfApF/hnRM3el/DDimMzOzkt43yDCzSB/dtcheGcqBou8C0aJeatSXns5k1i6sU0LUAj/yA5aFOVTanSnrZJrjFVaf2Af+q/Nw6Rtin4FpCbO4HRHhi4C4A4AhP7hlsWcDnEsObow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719870809; c=relaxed/simple;
	bh=xqQLxlrpfnSpk1Ipnzb/eU4eodQQxX3Dl16Lv+mdN6g=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=J21PgKNSU3P6+WdQ18dPZ8x4i2Dl8UhiO7ScJAVT0PBndO5OskFNJSqEhryS2WdaFSjQUt6UJSUCQyIhItQI1c7U2A9ORDVnn/+lQW37Q6do4EVIRblbKnbuFNRRrG6a8v240FXvY5aC8NgDwrLbiWYnxbO1X1uz+1Y6qfG2MH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sOZVx6Xm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sOZVx6Xm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC5BC116B1;
	Mon,  1 Jul 2024 21:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719870808;
	bh=xqQLxlrpfnSpk1Ipnzb/eU4eodQQxX3Dl16Lv+mdN6g=;
	h=From:To:Subject:Date:From;
	b=sOZVx6XmFmR0VBfEd/WhTBZ2AGTmevgt6Dz9BcMhNfCsPANKvaNuhnjN9gkahSThq
	 SWcigh1My7JYGg4eQvv+Gf89c1Iqmxxv8ImTv9QrzLZZjzwOKWV3DOlnWXgEn/k3Uz
	 14iZc/UXRY/ATGe03bRMibHg6XHpGPRTTp9lnn3G4IGNIizBHtw8P3NJUJMRLDUppj
	 iC0CruNVo55+SvSwGWtdrKxMMGWcWl/3YBwKptPjdpKOFZLk8cDviW6IwzfZYavvsV
	 0AKJOiMHxZFhxM5bZ0+dJHeh7COvtcTBMCVoiiN2jzrucxo5u/PThk9QDtsfwCh5Z4
	 SqtlX95Eamh5g==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2] scsi: sd: Do not repeat the starting disk message
Date: Tue,  2 Jul 2024 06:53:26 +0900
Message-ID: <20240701215326.128067-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The scsi disk message "Starting disk" to signal resuming of a suspended
disk is printed in both sd_resume() and sd_resume_common(), which
results in this message being printed twice when resuming from e.g.
autosuspend:

$ echo 5000 > /sys/block/sda/device/power/autosuspend_delay_ms
$ echo auto > /sys/block/sda/device/power/control

[ 4962.438293] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[ 4962.501121] sd 0:0:0:0: [sda] Stopping disk

$ echo on > /sys/block/sda/device/power/control

[ 4972.805851] sd 0:0:0:0: [sda] Starting disk
[ 4980.558806] sd 0:0:0:0: [sda] Starting disk

Fix this double print by removing the call to sd_printk() from
sd_resume() and moving the call to sd_printk() in sd_resume_common()
earlier in the function, before the check using sd_do_start_stop().
Doing so, the message is printed once regardless if sd_resume_common()
actually executes sd_start_stop_device() (i.e. scsi device case) or not
(libsas and libata managed ATA devices case).

Fixes: 0c76106cb975 ("scsi: sd: Fix TCG OPAL unlock on system resume")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
---

Changes from v1:
 - Fixed typo in commit message
 - Added Bart's review tag

 drivers/scsi/sd.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6b64af7d4927..1b7561abe05d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -4119,8 +4119,6 @@ static int sd_resume(struct device *dev)
 {
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
-	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
-
 	if (opal_unlock_from_suspend(sdkp->opal_dev)) {
 		sd_printk(KERN_NOTICE, sdkp, "OPAL unlock failed\n");
 		return -EIO;
@@ -4137,12 +4135,13 @@ static int sd_resume_common(struct device *dev, bool runtime)
 	if (!sdkp)	/* E.g.: runtime resume at the start of sd_probe() */
 		return 0;
 
+	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
+
 	if (!sd_do_start_stop(sdkp->device, runtime)) {
 		sdkp->suspended = false;
 		return 0;
 	}
 
-	sd_printk(KERN_NOTICE, sdkp, "Starting disk\n");
 	ret = sd_start_stop_device(sdkp, 1);
 	if (!ret) {
 		sd_resume(dev);
-- 
2.45.2

