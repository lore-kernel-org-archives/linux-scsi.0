Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F1737DABE;
	Thu,  3 Sep 2026 03:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406970; cv=none; b=f055obEgpnCG0j/4Hc9FutB6f5X7gVIK1ucrj+W2gasItCepfvtxmzDZU4BkIQrskkeJTNmsndssZbSfylhqml7MeFCFsSqMPwJI2TVoyiyXuf96cLD0EZvg1kH2CiNTYw3Z1yGUoe1X4kzBCe1VGZXZKJfkaexXOaSHElq4+gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406970; c=relaxed/simple;
	bh=Zrny4kVyjNcVCM8jDZ+WLVr4ZOAcLvAA56jPMbDs+hI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nugjVgTQMCrWwZZ4PatVjVD5wh2q9usjUNkF30tUqvvDo3QbaE5KWDRSxGCjwLS2smQQ6oR6k4Wykj/WB78zPNF/Z3cTBgIkJblpDyXSZRogoHZRe7Umiuwi/v7pmKkUPhPR7z7yZzgHIFm54kJUw840XXRPR0n+bjfryW7SDZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NVTNpC5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NVTNpC5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359EF1F00A3E;
	Thu,  3 Sep 2026 03:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406962;
	bh=Wq2O31rVUsmAND4iJLnv+ct8nXlKYJzJ5m4tzACLXk0=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=NVTNpC5RAeJUBDQhgV+uvlJBmDcZZsWVQekx292Ckpv31S2POyYeH7WbKOCUYRjDN
	 NsmszsxZa7gHq0500U9iP2wO9mT7bFTF+vFIhPGuQyDjkh1+qWWJkPbGIBfuoYmJVU
	 20J4jCXL82CvHEf1HYvUuB2h4SeZGaoU0xrdm9wmWsNKho+btLVwxYjFTib5N1Dqq9
	 qQjeM/+LxBWsHIWVONfo5Bs3PKBSq8qZUpdfjcyjC9evKfTJtfbI5SNVcKHmCzCJRH
	 OXp+NBAszs2EqiFPnfeAyNe/juQtGy9XASHzTRqmFOKLFaF24sgDfSuZL9KIqI6ZFY
	 xMriaer5KFauQ==
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
Subject: [PATCH v2 15/40] scsi: device_handlers: emc: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:36 +0900
Message-ID: <20260903034201.112211-16-dlemoal@kernel.org>
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

Refactor the EMC SCSI device handler driver to use the 16-bits sense_code
field of struct scsi_sense_hdr and replace all hard-coded additional sense
codes and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_emc.c | 28 ++++++++++++-----------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_emc.c b/drivers/scsi/device_handler/scsi_dh_emc.c
index ff41b51ef462..4b0ea6045ba3 100644
--- a/drivers/scsi/device_handler/scsi_dh_emc.c
+++ b/drivers/scsi/device_handler/scsi_dh_emc.c
@@ -105,10 +105,10 @@ static int trespass_endio(struct scsi_device *sdev,
 	sdev_printk(KERN_ERR, sdev, "%s: Found valid sense data 0x%2x, "
 		    "0x%2x, 0x%2x while sending CLARiiON trespass "
 		    "command.\n", CLARIION_NAME, sshdr->sense_key,
-		    sshdr->asc, sshdr->ascq);
+		    scsi_sense_asc(sshdr), scsi_sense_ascq(sshdr));
 
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

