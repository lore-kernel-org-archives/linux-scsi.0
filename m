Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289FF345749;
	Thu,  3 Sep 2026 03:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406973; cv=none; b=U1ak35X64Xe9ekxJ4etj5q1yrhwRZv7btCyZD2o3he5r702IfQj/Tz7RxEY2te3K2DOBaSX3rezfC5y9EDhl8Wszy2lj89XVY8xu+xO6VRtztCwkrSAmyWG/1YHtOh16EM6hGYXyKcZViyB9G6zg0ZY1uN5Dp+wFGpuSll/U0NQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406973; c=relaxed/simple;
	bh=W8SDKK89LAx+SNXJ9pzeBlwvj+DqDWV7Rf2GfCgvtfk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EgsYx+gITUEziiXyDtNl1HY2CZvo0v85V24NtEcqVtA6/JhsAOqX3bocq/HSPrfPx1MBzsxtLD1oQERNL3YtexJ8Rm1O4uVSkv44J3q5IMnHWAAViQ/WJ8hIG28+kxXOa8tQQU54HAOAZt8NMLbuoUKbwlT75DBiHNZ+6KCgxFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FrwpJn6Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FrwpJn6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D221F00A3F;
	Thu,  3 Sep 2026 03:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406964;
	bh=UNXUBAZ8ICfIyb8tEaDoT3lH671WaEtZb+b1MjV/MHw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=FrwpJn6Yj9j087m2mkNpr6yzwD2/OGpdGZsmoYIhKwwGtxuzoRDR0Fg+9WXbuAc8V
	 1ZyAIhKhR3LArviTu7HkuBu7npXtP3tXmQM1gYLnY3AW/05RUZ63Xz1YFtZujNd740
	 aBT0cHSVweJWBw6hEL/39mEefj5Dirhi9fJJgL3J/AhqJrpYNDKfrW/jtV2hOVv/0R
	 x+XOzO6l++FtXdpxPHxhqqqIkGEf0ZC8p9UuxlFhG+2vlKdie9QGaKByqjcQwiQZ/T
	 jHpN1gbPRutUR3Da/iipxwoFqwjFZXsrJNhkliy8Jy6yCC270IqHloDYPnNm/XWMS0
	 BDuhJHpKB1ruA==
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
Subject: [PATCH v2 16/40] scsi: device_handlers: alua: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:37 +0900
Message-ID: <20260903034201.112211-17-dlemoal@kernel.org>
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

Refactor the SCSI ALUA devie handler driver to use the 16-bits sense_code
field of struct scsi_sense_hdr and replace all hard-coded additional sense
codes and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
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

