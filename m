Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37E9623FC5A;
	Fri,  4 Sep 2026 00:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481645; cv=none; b=UjOmIbwinnaaqrafZo+kX2EQ9vtrlslK/iLCI4ryitrhMKoOtCDQ0xinF5M1qlSGyCPA1tbpfEAvPboTZj7Zzs7ZplF5ckKiwLbYH68ADoGk83bpLW33TB2JL4DeUu6et9HScKCNrayiN4jCErYyEvYZZOcqwLfk/zSqSiYUwDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481645; c=relaxed/simple;
	bh=Zrny4kVyjNcVCM8jDZ+WLVr4ZOAcLvAA56jPMbDs+hI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwSrrA7YQ9kHRwKuFCKxUYpY2ciOehkYPadPPenwYQ3MXMPyXy+fClzWbH0qzUWoJE+SWWvpu+cQ2yCgaXat+XUJC2CQWyp9e1Izyfy8v9yM+BpwVXb1Q262XCO0c1I8VKb42O9Zb/+SB+YbUYSqGL5bdjsJa2Vo9kid2P9nhV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OozX6G+Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OozX6G+Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6B21F000E9;
	Fri,  4 Sep 2026 00:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481644;
	bh=Wq2O31rVUsmAND4iJLnv+ct8nXlKYJzJ5m4tzACLXk0=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=OozX6G+YIEnhW9ugTMRnuR0AgkpIqOpppNM33fI/jHQYrqec8WCOioJXdC62bj3/k
	 3EcXkKHzrJ8SngRnGLCx0jlbPgZRu8Wt23aTqESEKkU3jtb+xnOPNPkhhjk9i5rIXm
	 zchIZCWYZWPeCJf5Z2FScl4ye6RkuTtvLDoaFkK/yBzcbjDsbBveVyc/mTLPVmk+Hs
	 QFof4j4X+UYki21kBUkv2C1nRq1uwt+eQT2c84UeQsLWORU+OBbXITVH23q4gmFKfl
	 DnJGbhYdmry2aa7Gzlk5QF4QsBIv9FXY5JNX2wkMcP9qzMPfzmQYN7/AzvL1wIriF9
	 p7RDG5MhI+qhw==
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
Subject: [PATCH v3 15/40] scsi: device_handlers: emc: use 16-bits defined sense codes
Date: Fri,  4 Sep 2026 09:26:19 +0900
Message-ID: <20260904002644.157668-16-dlemoal@kernel.org>
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

