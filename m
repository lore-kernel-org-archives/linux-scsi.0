Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4BD29346F;
	Mon, 31 Aug 2026 02:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141929; cv=none; b=J/JVP3+fysRhDg7sjacHqid/Wov2Alwl2owjuwAcOWNxRcBj+7EbRfAhGkuKdbzZb2Hjj4owwoF9Wnuqh5Y2COIhFdLBgAHvSqZig629E4H1q8t0AG9omkuKBrAQHVyZez7sx3tBPflBFR9R93BhKQIcDtFeX8PckoLUTWHQ/bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141929; c=relaxed/simple;
	bh=Gwkz9O5ADk446n6ArRNYlXj6SMK//mDHByGFKu7PoDY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKlANXLyOYYJRHadMK0KSwxB1Jk+aVzbq1P9TIpkvtSKGeI6Q+4KewHN81HBT1lAamzQy4bU053rxz/xd4BSIAlRXoDD5Z7XT43qlsEQBUg+sGrGr0lveCFlhY+g6KMLdk5DKyV7RRYnsvOT8zXf/61g6SbzJfZhUnNfOKX2oJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SrzX+2fn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SrzX+2fn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC971F00A3E;
	Mon, 31 Aug 2026 02:05:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141928;
	bh=AwLFb9hShX6baBx4cxlLsUZJOwRrbkAOfmwNP7hlR0c=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=SrzX+2fng9+YUAbB2icM6JdfxZ7Uogf8Jp1eM8Mztho81buuz6m0VQwm70dmtHR0K
	 wBXSZ8BV8Tfq47RnO1byCPW8NRlxXsCBM7yEf8Tp2zJbAbXrbzbPPf+D58nrDS033l
	 JLtTQFsBSLBkgmkh3Lcm2eD/BG3FWgIrgifumeJ1sPFDMNMazuA6uYyOa8rqYpVmG1
	 8YmAdkpxb9JtBN9f1SjvEmUnbpK0ekVUeyF0jjGqbS09CAS+PjxOKkQybPoKrN5UMB
	 JFpUnwCPTO6Z+/YN+zDn4agvqKl+BGQusYiCBiHDqoCO468ZTMNvoDpDmyH+ZBdv49
	 AU4PS3hIGpzxg==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 15/37] scsi: device_handlers: emc: use 16-bits defined sense codes
Date: Mon, 31 Aug 2026 11:04:29 +0900
Message-ID: <20260831020451.585944-16-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831020451.585944-1-dlemoal@kernel.org>
References: <20260831020451.585944-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the EMC SCSI device handler driver to use the 16-bits sense_code
field of struct scsi_sense_hdr and replace all hard-coded additional sense
codes and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_emc.c | 30 ++++++++++++-----------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index ff41b51ef462..ee97570cb110 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -103,12 +103,12 @@ static int trespass_endio(struct scsi_device *sdev,
 	int err = SCSI_DH_IO;
 
 	sdev_printk(KERN_ERR, sdev, "%s: Found valid sense data 0x%2x, "
-		    "0x%2x, 0x%2x while sending CLARiiON trespass "
+		    "0x%04x while sending CLARiiON trespass "
 		    "command.\n", CLARIION_NAME, sshdr->sense_key,
-		    sshdr->asc, sshdr->ascq);
+		    sshdr->sense_code);
 
-	if (sshdr->sense_key == 0x05 && sshdr->asc == 0x04 &&
-	    sshdr->ascq == 0x00) {
+	if (sshdr->sense_key == ILLEGAL_REQUEST &&
+	    sshdr->sense_code == LU_NOT_READY) {
 		/*
 		 * Array based copy in progress -- do not send
 		 * mode_select or copy will be aborted mid-stream.
@@ -117,18 +117,18 @@ static int trespass_endio(struct scsi_device *sdev,
 			    "progress while sending CLARiiON trespass "
 			    "command.\n", CLARIION_NAME);
 		err = SCSI_DH_DEV_TEMP_BUSY;
-	} else if (sshdr->sense_key == 0x02 && sshdr->asc == 0x04 &&
-		   sshdr->ascq == 0x03) {
-		/*
-		 * LUN Not Ready - Manual Intervention Required
-		 * indicates in-progress ucode upgrade (NDU).
-		 */
+	} else if (sshdr->sense_key == NOT_READY &&
+		   sshdr->sense_code ==
+		   LU_NOT_READY_MANUAL_INTERVENTION_REQUIRED) {
+		/* Indicates in-progress ucode upgrade (NDU). */
 		sdev_printk(KERN_INFO, sdev, "%s: Detected in-progress "
 			    "ucode upgrade NDU operation while sending "
 			    "CLARiiON trespass command.\n", CLARIION_NAME);
 		err = SCSI_DH_DEV_TEMP_BUSY;
-	} else
+	} else {
 		err = SCSI_DH_DEV_FAILED;
+	}
+
 	return err;
 }
 
@@ -288,7 +288,8 @@ static enum scsi_disposition clariion_check_sense(struct scsi_device *sdev,
 {
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x03)
+		if (sense_hdr->sense_code ==
+		    LU_NOT_READY_MANUAL_INTERVENTION_REQUIRED)
 			/*
 			 * LUN Not Ready - Manual Intervention Required
 			 * indicates this is a passive path.
@@ -305,7 +306,7 @@ static enum scsi_disposition clariion_check_sense(struct scsi_device *sdev,
 			return SUCCESS;
 		break;
 	case ILLEGAL_REQUEST:
-		if (sense_hdr->asc == 0x25 && sense_hdr->ascq == 0x01)
+		if (sense_hdr->sense_code == scsi_sense_code(0x25, 0x01))
 			/*
 			 * An array based copy is in progress. Do not
 			 * fail the path, do not bypass to another PG,
@@ -319,7 +320,8 @@ static enum scsi_disposition clariion_check_sense(struct scsi_device *sdev,
 			return SUCCESS;
 		break;
 	case UNIT_ATTENTION:
-		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
+		if (sense_hdr->sense_code ==
+		    POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED)
 			/*
 			 * Unit Attention Code. This is the first IO
 			 * to the new path, so just retry.
-- 
2.55.0

