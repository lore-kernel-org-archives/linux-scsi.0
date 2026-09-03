Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4629E361945;
	Thu,  3 Sep 2026 03:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406957; cv=none; b=FiOuysWRPuno8VOcfTNdepoFnLVnrRiQMvi37TMj/vlabykgDVUMHWki4ruw6rkixCCY/+n6Sxbj042aClQ4jCg1TdWpf+ApSRWhhEvAepOQ8io3xJwoWqs5uhm9dQfMDTs25VQNqOxpyJlQjhj3nIBmAl9H3GjMaLoeYhX9Zzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406957; c=relaxed/simple;
	bh=/3AJ69cDq1k+AIfJkE2+9goiQFjJp6kLYAe/C3GRcAw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QeBaFwCnJSDCQg9J2iJJPQRdSqYHvG7SzJMW/M6R+Fs8dP8tw/Q9LLS/gbXtoKxv8jz5xSLJzPLx7tklbYRON+VmG4yUGZvUZZ6XpkXPfJ7clYc7F/OFsWPZNuAWV/B1m6Zo3WEvLAZHq7JHtm2thnEZbM1OO/Afv/3gctgM3yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aVzP7Wro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aVzP7Wro"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542FF1F000E9;
	Thu,  3 Sep 2026 03:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406951;
	bh=bRE8CgICC6+hmpJsl5Jln+T0X+UFtzjeMju14k+kigw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=aVzP7Wrogg6LehFtGtiSLdDsb3m1UKnvTyFOftEbdJQXlUkx3V+ARoW/4LMN0lY8O
	 mj/dtUIeV9FAXhpc+ByJK4dHmDtwoFMOZg38ojQi+V3Sz8gpIEdwlamtJkH/bb3bv5
	 R/lXgmzO28gdtcSWkGjrwkrDlgS6ZG2kFpLWf5T4WlRoQIAw0j+FyLeNjycl5B40eY
	 O/f5OwbYJTmKcxxGAKj6pr2KsZY8jhNYoGh9zNCn9xaCAH8JLpj3VPm5Tt7FgNNSxP
	 Mrk5B5StHDNsVWDkD/3ltes4shna+e0jF/Dy70/hqmce+EGwQ5cD5gySsnXzTE3Voh
	 NrBGI+o7vXT2w==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v2 09/40] scsi: sr: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:30 +0900
Message-ID: <20260903034201.112211-10-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903034201.112211-1-dlemoal@kernel.org>
References: <20260903034201.112211-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the SCSI CDROM driver to use the 16-bits sense_code field of
struct scsi_sense_hdr and replace all hard-coded additional sense codes
and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sr.c       |  3 ++-
 drivers/scsi/sr_ioctl.c | 29 +++++++++++------------------
 2 files changed, 13 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index c36c54ecd354..4f2e8d1be6da 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -253,7 +253,8 @@ static unsigned int sr_check_events(struct cdrom_device_info *cdi,
 	 * (ASC 0x3a).
 	 */
 	cd->media_present = scsi_status_is_good(ret) ||
-		(scsi_sense_valid(&sshdr) && sshdr.asc != 0x3a);
+		(scsi_sense_valid(&sshdr) &&
+		 scsi_sense_asc(&sshdr) != ASC_MEDIUM_NOT_PRESENT);
 
 	if (last_present != cd->media_present)
 		cd->device->changed = 1;
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 089653018d32..e4ec0f63cdcc 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -226,9 +226,8 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 			err = -ENOMEDIUM;
 			break;
 		case NOT_READY:	/* This happens if there is no disc in drive */
-			if (sshdr->asc == 0x04 &&
-			    sshdr->ascq == 0x01) {
-				/* sense: Logical unit is in process of becoming ready */
+			if (sshdr->sense_code ==
+			    LU_IS_IN_PROCESS_OF_BECOMING_READY) {
 				if (!cgc->quiet)
 					sr_printk(KERN_INFO, cd,
 						  "CDROM not ready yet.\n");
@@ -250,9 +249,7 @@ int sr_do_ioctl(Scsi_CD *cd, struct packet_command *cgc)
 			break;
 		case ILLEGAL_REQUEST:
 			err = -EIO;
-			if (sshdr->asc == 0x20 &&
-			    sshdr->ascq == 0x00)
-				/* sense: Invalid command operation code */
+			if (sshdr->sense_code == INVALID_COMMAND_OP_CODE)
 				err = -EDRIVE_CANT_DO_THIS;
 			break;
 		default:
@@ -303,9 +300,8 @@ int sr_drive_status(struct cdrom_device_info *cdi, int slot)
 	if (!scsi_test_unit_ready(cd->device, SR_TIMEOUT, MAX_RETRIES, &sshdr))
 		return CDS_DISC_OK;
 
-	/* SK/ASC/ASCQ of 2/4/1 means "unit is becoming ready" */
-	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == NOT_READY
-			&& sshdr.asc == 0x04 && sshdr.ascq == 0x01)
+	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == NOT_READY &&
+	    sshdr.sense_code == LU_IS_IN_PROCESS_OF_BECOMING_READY)
 		return CDS_DRIVE_NOT_READY;
 
 	if (!cdrom_get_media_event(cdi, &med)) {
@@ -318,18 +314,18 @@ int sr_drive_status(struct cdrom_device_info *cdi, int slot)
 	}
 
 	/*
-	 * SK/ASC/ASCQ of 2/4/2 means "initialization required"
 	 * Using CD_TRAY_OPEN results in an START_STOP_UNIT to close
 	 * the tray, which resolves the initialization requirement.
 	 */
-	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == NOT_READY
-			&& sshdr.asc == 0x04 && sshdr.ascq == 0x02)
+	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == NOT_READY &&
+	    sshdr.sense_code == LU_NOT_READY_INITIALIZING_COMMAND_REQUIRED)
 		return CDS_TRAY_OPEN;
 
 	/*
 	 * 0x04 is format in progress .. but there must be a disc present!
 	 */
-	if (sshdr.sense_key == NOT_READY && sshdr.asc == 0x04)
+	if (sshdr.sense_key == NOT_READY &&
+	    scsi_sense_asc(&sshdr) == ASC_LU_NOT_READY)
 		return CDS_DISC_OK;
 
 	/*
@@ -338,13 +334,10 @@ int sr_drive_status(struct cdrom_device_info *cdi, int slot)
 	 * any other way to detect this...
 	 */
 	if (scsi_sense_valid(&sshdr) &&
-	    /* 0x3a is medium not present */
-	    sshdr.asc == 0x3a)
+	    scsi_sense_asc(&sshdr) == ASC_MEDIUM_NOT_PRESENT)
 		return CDS_NO_DISC;
-	else
-		return CDS_TRAY_OPEN;
 
-	return CDS_DRIVE_NOT_READY;
+	return CDS_TRAY_OPEN;
 }
 
 int sr_disk_status(struct cdrom_device_info *cdi)
-- 
2.55.0

