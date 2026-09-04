Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0614C29AB02;
	Fri,  4 Sep 2026 00:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481635; cv=none; b=uxARXoVuZawdvPZTHsGlswrRikn1BJVu4GXhNGLuW1/udAhdN9x0TwJBBybKJVipGR/fMBp32B0F9/ZcQRrEQytCdVtp1avVLV9QIUPVK+ZqChG73c/+0jfVzvVcoH3Efuj7FU9RKx/HGgJEibc35yFv0U76IiyuJPKU8zZISTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481635; c=relaxed/simple;
	bh=/3AJ69cDq1k+AIfJkE2+9goiQFjJp6kLYAe/C3GRcAw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SHmJKcgG8NT7B5Dzl3hSMto3qm2SBJ2CT+dRBjjBJe98EaP0D68+ocrt9cVwARSuvBRq+1XgAaG5/v9Gu0QumhibKR9XWaIfD/92e3JJlww4RQGM5TYeG7FPAkS9O4cRxVe6MHmoS0X1+SBjzQZf4eIQaz6bjLfg93ZDP4YNjv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8F1FXsR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8F1FXsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 389DC1F00A3E;
	Fri,  4 Sep 2026 00:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481633;
	bh=bRE8CgICC6+hmpJsl5Jln+T0X+UFtzjeMju14k+kigw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=W8F1FXsRE8HKEI8VJ2gSgpPDkFolOjQQLAJ3Z1adpq2sYYllSsqElnKrq+O2yfQAS
	 e1IwW3dvRAIWCCz+fAojiyhOuOy9iU6pXTv3UorAON7lGYZDZlR6QCGGRX35nEbUp+
	 2iJo4AxZkrp14b8pZBLPT3+b+wGj5Dw+LtHkMBK+f/nI41tfGv/TrcwxsmJD60UH8w
	 ThuI5zJ5nxy0NE5DHNSG6x12/OzgpNhOKbJ8i+X3JiCSio6HrL81Iip0bnkePt67qM
	 oN1AEAunedVPeHSTSltbXqK9nqv/dE0pjnrl+j4baPw2L55jL1hYEmSk22uohYgEEn
	 hnNjNR2yuTeCw==
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
Subject: [PATCH v3 09/40] scsi: sr: use 16-bits defined sense codes
Date: Fri,  4 Sep 2026 09:26:13 +0900
Message-ID: <20260904002644.157668-10-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904002644.157668-1-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
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

