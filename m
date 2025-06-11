Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847AD26529B
	for <linux-scsi@vger.kernel.org>; Wed, 11 Jun 2025 09:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749634568; cv=none; b=vA4WgXzaBdxFt7Yi/esPUUm+4zPRboT4wABUx3UqkURQLxbdug/AjTBorX35yS5WZzAXqeO4yWHUwJLXs+c0yPbZ538CQDdNoF+hWiWA8DMMcYYVqISw3tsYB+ETQI1HTaLo10YVk9tqx03f4DdmgyH+1rK8baDA6TuFNNnNT10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749634568; c=relaxed/simple;
	bh=7TFDURLpRqzUV1xyT+vLDnTY7LwyV+Jtuj28PDBZDHI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=UFgtyMiB7nw6kFcn7C9sv8L3GFOgpyGkt42/VyYqJXm36JcaL+v5TR/DZdfu9OIhEMzEYdQQATNXnN9kriY9c8foX6M6ocmuW+gBRoyKr9kthWVR067JLf/p4Bw7mFIpMw4JWG9wB1f0DCjyR5omLw62QWLVnfBkPRpRsYeOBA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uuBozvWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uuBozvWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC45C4CEEE;
	Wed, 11 Jun 2025 09:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749634568;
	bh=7TFDURLpRqzUV1xyT+vLDnTY7LwyV+Jtuj28PDBZDHI=;
	h=From:To:Subject:Date:From;
	b=uuBozvWRgNs1DhmdMzD4BPgENFIKl39VwIVFJdx/VJ6yQv0lcNWqmBWotYfHLHfiA
	 TnsyqWvLx+Z5ZFr6kFWB5HtSvht5mt9thTOsxqXdj7t0lXTuF8rmYF3GMzeIaUWauL
	 /r1MPPBzXhhY2mNuh/T/SvvoI+s0404ypR+cDH3Tk5jQovPexC4YnH9+M6IRIodjJb
	 jnFGqUdwXc8EmuZ2fGtaZpOoI7+h2k/QuBe4j0luH7U3+5EgBhkYiuZTKwrnxEdBfy
	 DrpxghfvTbhWpDt1EykZEfElpTVerB6gLaQxofNVuokRakZagz+cfv8t5r0/1u0TEq
	 fFvXYAu36Zq+w==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH v2] scsi: Remember if a device is an ATA device
Date: Wed, 11 Jun 2025 18:34:21 +0900
Message-ID: <20250611093421.2901633-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

scsi_add_lun() tests the device vendor string of SCSI devices to detect
if a SCSI device is in fact an ATA device, in order to correctly handle
SATL power management. The function scsi_cdl_enable() also requires
knowing if a SCSI device is an ATA device to control the state of the
device CDL feature but this function does that by testing for the
presence of the VPD page 89h (ATA INFORMATION page).
sd_read_write_same() also has a similar test.

Simplify these different methods by adding the is_ata field to struct
scsi_device to remember that a SCSI device is in fact an ATA one based
on the device vendor name test. This filed can also allow low level
SCSI host adapter drivers to take special actions for ATA devices
(e.g. to better handle ATA NCQ errors).

With this, simplify scsi_cdl_enable() and sd_read_write_same().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
Changes from v1:
 - Add simplification of sd_read_write_same()

 drivers/scsi/scsi.c        |  7 +------
 drivers/scsi/scsi_scan.c   |  3 ++-
 drivers/scsi/sd.c          | 13 ++++---------
 include/scsi/scsi_device.h |  5 +++++
 4 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 518a252eb6aa..534310224e8f 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -708,20 +708,15 @@ void scsi_cdl_check(struct scsi_device *sdev)
 int scsi_cdl_enable(struct scsi_device *sdev, bool enable)
 {
 	char buf[64];
-	bool is_ata;
 	int ret;
 
 	if (!sdev->cdl_supported)
 		return -EOPNOTSUPP;
 
-	rcu_read_lock();
-	is_ata = rcu_dereference(sdev->vpd_pg89);
-	rcu_read_unlock();
-
 	/*
 	 * For ATA devices, CDL needs to be enabled with a SET FEATURES command.
 	 */
-	if (is_ata) {
+	if (sdev->is_ata) {
 		struct scsi_mode_data data;
 		struct scsi_sense_hdr sshdr;
 		char *buf_data;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 4833b8fe251b..160c2f74c7e7 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -909,7 +909,8 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	sdev->model = (char *) (sdev->inquiry + 16);
 	sdev->rev = (char *) (sdev->inquiry + 32);
 
-	if (strncmp(sdev->vendor, "ATA     ", 8) == 0) {
+	sdev->is_ata = strncmp(sdev->vendor, "ATA     ", 8) == 0;
+	if (sdev->is_ata) {
 		/*
 		 * sata emulation layer device.  This is a hack to work around
 		 * the SATL power management specifications which state that
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3f6e87705b62..daddef2e9e87 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3459,19 +3459,14 @@ static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
 	}
 
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, INQUIRY, 0) < 0) {
-		struct scsi_vpd *vpd;
-
 		sdev->no_report_opcodes = 1;
 
-		/* Disable WRITE SAME if REPORT SUPPORTED OPERATION
-		 * CODES is unsupported and the device has an ATA
-		 * Information VPD page (SAT).
+		/*
+		 * Disable WRITE SAME if REPORT SUPPORTED OPERATION CODES is
+		 * unsupported and this is an ATA device.
 		 */
-		rcu_read_lock();
-		vpd = rcu_dereference(sdev->vpd_pg89);
-		if (vpd)
+		if (sdev->is_ata)
 			sdev->no_write_same = 1;
-		rcu_read_unlock();
 	}
 
 	if (scsi_report_opcode(sdev, buffer, SD_BUF_SIZE, WRITE_SAME_16, 0) == 1)
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 68dd49947d04..6d6500148c4b 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -184,6 +184,11 @@ struct scsi_device {
 	 */
 	unsigned force_runtime_start_on_system_start:1;
 
+	/*
+	 * Set if the device is an ATA device.
+	 */
+	unsigned is_ata:1;
+
 	unsigned removable:1;
 	unsigned changed:1;	/* Data invalid due to media change */
 	unsigned busy:1;	/* Used to prevent races */
-- 
2.49.0

