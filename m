Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8074D2EC6;
	Tue,  8 Sep 2026 09:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858233; cv=none; b=JjvXy1kp1YAUbrnqvvvWl3In9Q3K/1lIpyktIFbDAZOHQRbLW3Ytcc0pOTIQvvdan9MmJsvKU7Ci69UTAyCrobDerPUsjSEGBngeq4zbYGVzVGsG6TphAorJbXdYSkdyu7aL/3xvkXT+QWjhhFr7YlMb95Bg2G8kjBCcwu/hIeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858233; c=relaxed/simple;
	bh=/ltVIe74pJk2Xyyq00XziecGW1ApiC/lRZGEDELvt34=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOfPI2SYdmiKIRHSQn+5d/xHg9c7FX6x+fJRUYBgEneVg1v4rqboLz9tP2oykQ8UWIrYN7rCiNTSGW0h3lpW4W3h/P912UglAAfbckwU8RIY0oulRAT8jm1eu2EavBhUPQc0UpMKhKNqy2WwSCaz84/8Rs8ojfk3tmVbMkAnxtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=If81APJ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="If81APJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0701F00A3E;
	Tue,  8 Sep 2026 09:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858229;
	bh=Fn5M+LaHDqN6qy+2UjQAyg3fC8XWkOobuXJg7Ia3J/M=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=If81APJ5wWgKjLWtsnUSYPX52b4ckzz8oL13+uXsTEy44m+Ze2NxJWM3MPcCqarLF
	 ixJE5Uop7PodLrno+YzXMSxj4rlaiCUyFqNt7dcJi55I8B0/mcMhrplpTy8+VgLOAk
	 wlvqeMalroyhZepgA4u7EFDhdJu3xz1Nom7QhH9CVImDBjDd2yaR5PNpR6Jc+AoG94
	 QYoqvQRS1tRd25V5YJvvErZzqqCYiclicI2e0WmoVIKmDTD4VV2RPhKIFqnZm3NE6c
	 pZaesyrZCLJ6CGs2l+t//4Lwv/j1wQwjMIcpBqB+HuqWxU7iFD1TodwZzYE/hjYFvP
	 MxHZ3GPE992ig==
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
Subject: [PATCH v6 16/40] scsi: device_handlers: alua: use 16-bits defined sense codes
Date: Tue,  8 Sep 2026 18:02:44 +0900
Message-ID: <20260908090308.1085097-17-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908090308.1085097-1-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor the SCSI ALUA devie handler driver to use the 16-bits sense_code
field of struct scsi_sense_hdr and replace all hard-coded additional sense
codes and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_alua.c | 55 ++++++++--------------
 1 file changed, 19 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index d81ec47a7140..87ac0a6d63e5 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -433,61 +433,43 @@ static enum scsi_disposition alua_check_sense(struct scsi_device *sdev,
 {
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
-			/*
-			 * LUN Not Accessible - ALUA state transition
-			 */
+		if (sense_hdr->sense_code ==
+		    LU_NOT_ACCESSIBLE_ASYMMETRIC_ACCESS_STATE_TRANSITION) {
 			alua_handle_state_transition(sdev);
 			return NEEDS_RETRY;
 		}
 		break;
 	case UNIT_ATTENTION:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x0a) {
-			/*
-			 * LUN Not Accessible - ALUA state transition
-			 */
+		if (sense_hdr->sense_code ==
+		    LU_NOT_ACCESSIBLE_ASYMMETRIC_ACCESS_STATE_TRANSITION) {
 			alua_handle_state_transition(sdev);
 			return NEEDS_RETRY;
 		}
-		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00) {
+		if (sense_hdr->sense_code ==
+		    POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED) {
 			/*
-			 * Power On, Reset, or Bus Device Reset.
 			 * Might have obscured a state transition,
 			 * so schedule a recheck.
 			 */
 			alua_check(sdev, true);
 			return ADD_TO_MLQUEUE;
 		}
-		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x04)
-			/*
-			 * Device internal reset
-			 */
+		if (sense_hdr->sense_code == DEVICE_INTERNAL_RESET)
 			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x01)
-			/*
-			 * Mode Parameters Changed
-			 */
+		if (sense_hdr->sense_code == MODE_PARAMETERS_CHANGED)
 			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x06) {
-			/*
-			 * ALUA state changed
-			 */
+		if (sense_hdr->sense_code == ASYMMETRIC_ACCESS_STATE_CHANGED) {
 			alua_check(sdev, true);
 			return ADD_TO_MLQUEUE;
 		}
-		if (sense_hdr->asc == 0x2a && sense_hdr->ascq == 0x07) {
-			/*
-			 * Implicit ALUA state transition failed
-			 */
+		if (sense_hdr->sense_code ==
+		    IMPLICIT_ASYMMETRIC_ACCESS_STATE_TRANSITION_FAILED) {
 			alua_check(sdev, true);
 			return ADD_TO_MLQUEUE;
 		}
-		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x03)
-			/*
-			 * Inquiry data has changed
-			 */
+		if (sense_hdr->sense_code == INQUIRY_DATA_HAS_CHANGED)
 			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x3f && sense_hdr->ascq == 0x0e)
+		if (sense_hdr->sense_code == REPORTED_LUNS_DATA_HAS_CHANGED)
 			/*
 			 * REPORTED_LUNS_DATA_HAS_CHANGED is reported
 			 * when switching controllers on targets like
@@ -517,12 +499,12 @@ static int alua_tur(struct scsi_device *sdev)
 				      ALUA_FAILOVER_RETRIES, &sense_hdr);
 	if ((sense_hdr.sense_key == NOT_READY ||
 	     sense_hdr.sense_key == UNIT_ATTENTION) &&
-	    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a)
+	    sense_hdr.sense_code ==
+	    LU_NOT_ACCESSIBLE_ASYMMETRIC_ACCESS_STATE_TRANSITION)
 		return SCSI_DH_RETRY;
-	else if (retval)
+	if (retval)
 		return SCSI_DH_IO;
-	else
-		return SCSI_DH_OK;
+	return SCSI_DH_OK;
 }
 
 /*
@@ -619,7 +601,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		 * transition. So set the state to 'transitioning' directly.
 		 */
 		if (sense_hdr.sense_key == NOT_READY &&
-		    sense_hdr.asc == 0x04 && sense_hdr.ascq == 0x0a) {
+		    sense_hdr.sense_code ==
+		    LU_NOT_ACCESSIBLE_ASYMMETRIC_ACCESS_STATE_TRANSITION) {
 			transitioning_sense = true;
 			goto skip_rtpg;
 		}
-- 
2.55.0

