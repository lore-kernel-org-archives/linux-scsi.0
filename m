Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB921DF267
	for <linux-scsi@vger.kernel.org>; Fri,  6 Jun 2025 05:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749187825; cv=none; b=QCzY6YU6bn1EgPxFXjBWdJRolD9PCn58Vdta0fNWXq77AOIwsWXeMHACI8/t5tzzWSUHgPVu+fJktKsfVT6hICCIMU88g0spniTTa7xxXsl3bKdTRECnPMH4A/M07guan9A4xl87+WTk6O7EdPbOuffoZFHS9BneVZh2c3B5b4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749187825; c=relaxed/simple;
	bh=qpjqnZZxhIh1mX+2sepEN9o6mJaj9rs188S6+aoOhcI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=jOoOf4mmQ6cJW8f/HCKTj5kaFc3F5A1/xlMMnmQi6a/AafayOony7fr6Bfg+tef2jV8btuDNepWu5tIISxnc0m1HXYYQtdCiVLD1FoY9LW/C5l/9XSQ0B68+DUUICDlrMeTaVUtxhn4uLVUaZGPIi7QZPSdbCzolyNWnPN7Pyvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=daUHU6+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="daUHU6+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 152C5C4CEEB;
	Fri,  6 Jun 2025 05:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749187824;
	bh=qpjqnZZxhIh1mX+2sepEN9o6mJaj9rs188S6+aoOhcI=;
	h=From:To:Subject:Date:From;
	b=daUHU6+jYQZZFgxbFzRgtV9Nthqem70HkV7R0hKlBBvBcg2CpB4vrmaV0jRIr3h+B
	 FqU2daJaK4NvHiWFvTuk8mSnK4LLpNvXyYGUPttXmhOtZvbuU8TrpbEZ1pc/LrfYgi
	 aoQQH5oGY+OO6IeplPkrNVmkqkRECdaGgfttLb6LGVjZW7XAkYoPSeftQoWC/zWHa/
	 s7EMaIgzT5eoHj8jq+TTqTPmsfS1KODr/+9cLXAkRsYfDiUFEJf7uO2d0HCGjydGKm
	 bWXnunlIBIjZ+47JjXs7BUXzr5UljWoNS9o3hW+1p7Obu0IQl6XgTY8yewDL0W9YR2
	 3uI9N+okK49rA==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Subject: [PATCH] scsi: Remember if a device is an ATA device
Date: Fri,  6 Jun 2025 14:28:44 +0900
Message-ID: <20250606052844.746754-1-dlemoal@kernel.org>
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

Simplify these different methods by adding the is_ata field to struct
scsi_device to remember that a SCSI device is in fact an ATA one based
on the device vendor name test. This filed can also allow low level
SCSI host adapter drivers to take special actions for ATA devices
(e.g. to better handle ATA NCQ errors).

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/scsi.c        | 7 +------
 drivers/scsi/scsi_scan.c   | 3 ++-
 include/scsi/scsi_device.h | 5 +++++
 3 files changed, 8 insertions(+), 7 deletions(-)

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

