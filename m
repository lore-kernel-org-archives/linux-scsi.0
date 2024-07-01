Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DFB571747
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jul 2024 09:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719825893; cv=none; b=mx3vRHWD+Te4+PpvrPqTm5+dACnPB1gu16GCMSNS9Z17yRVI0tE2i7hrx901dhQKBgtpDQpuvvSGdApjKTYYgm34AMhCan/AOOE4x4JyWHx1MlqRZl+Bo9vaopktnpGsVn0GyYbvm9crY8seOJy2Vi/AczR75j9pJPq+iHVPHRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719825893; c=relaxed/simple;
	bh=7I9bi1Xz0xdV8O6F+yNSwvKERe2yfwyrZuNsWUBsnsc=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=M2UAsY3LEHAeVCTN+CQBgQAXMNeDk+iQw/WHTsh7aMQ7WcXKfDem/XWG8MKoC2JQScSsTmoCLphDEz05Fd3s/pKNjmEbKKBWnqjuPZgVhfFE3rmgnsc1hKqbTaAGL5l9nL002w3I4I/ivG0A4tExn6yZANnuujUhdKe3I6yu8oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tCXFVxI/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tCXFVxI/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838ECC32786;
	Mon,  1 Jul 2024 09:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719825893;
	bh=7I9bi1Xz0xdV8O6F+yNSwvKERe2yfwyrZuNsWUBsnsc=;
	h=From:To:Subject:Date:From;
	b=tCXFVxI/oq9SKVFf/Hn1lz6syKc15ZUlZhLVcv3Uq0aSW1jv4g11qfpRu5p1Enlgu
	 6gvKelQAFpn1KlzW651NpzePdUiVDfRe3oTxckuSIi+xhvm2VjE7sM4b0wT8r3uPt9
	 GzAOEF/z8bEzhHKrA6jfVaNnK6pvmz0YxL3Sp1HXGceOcB5xVEkLu756tO89xdKGAF
	 plK7Pqxxuftcv12o6i9ayuunmvFXWB3f0hpOGBgFwYDJBs2Y2jFuVglkb8CxCha7WR
	 COVVBnksn4rlyx7yXS5KUqG17cwQG1qsIfCuSWeGKFPNRkKIXY4CnYXgq9i4RdMj05
	 0NWR9MK2BPVjA==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: sd: Do not repeat the starting disk message
Date: Mon,  1 Jul 2024 18:24:51 +0900
Message-ID: <20240701092451.122800-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The scsi disk message "Starting disk" to signal resuming of a suspended
disk is printed in both sd_resume() and sd_resume_common(), which result
in this message being printed twice when resuming from e.g. autosuspend:

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
---
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

