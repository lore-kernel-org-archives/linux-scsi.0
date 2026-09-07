Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B033EB0F4;
	Mon,  7 Sep 2026 02:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749062; cv=none; b=VHyDbumD5skKmk82MjWW2wI4Bg/u6bFr+TZ42LrHQkLmnuweyOm7bj3EH+1KJd/Tcs2yGmbymDBlNk4jD1M1Vf2ChPIf4AsISUoh2htKMjUaeI8bsSmcPb05l88kOsEosrUHL6li4VbmryYRlInF+wwD36W0rsqs2TJiY/F1FUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749062; c=relaxed/simple;
	bh=W8SDKK89LAx+SNXJ9pzeBlwvj+DqDWV7Rf2GfCgvtfk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iOWunle671EmlhhwPutCBR7YTnS7shtiynqUBkrmWCTeN86l640pJA3eamOnbxYL8CykAXkKZlmbCvpV+kHi6ogvLXAg0i/LzYxe2a/7+j5h3O9T0+N3Lh733VQr0q/hU+93bw2CqOTJGomRN6wTCqzfgB3qxRP67RnBBLj11uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PJU/hYXN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PJU/hYXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5D31F00A3A;
	Mon,  7 Sep 2026 02:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749061;
	bh=UNXUBAZ8ICfIyb8tEaDoT3lH671WaEtZb+b1MjV/MHw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=PJU/hYXNR3TglN7+YNrobVYmjhNLmiP0SS7tspR77z2yiPbuX5atRDWjlVQz1I+Qa
	 cJ+LpvY6fyMIxIkahlUerFNK3KDrOYjBEfDg7PF0N0PscTOf4FLyGuxx/TlFFUMHpi
	 6l11ZcSO7bSJEY9IrAkwj/FBNxzA0gya8odIuBMJ3kEJLnMRAI1Tci1inPB6UObATs
	 w9mhHfCya7MWVA41vMb/ROUwJ4wyn+ZR1JrtoYZTcBbFroJm7l5Uzk0ALp57OG5Y2g
	 ewhUM4tUP8rKkn9WtlI+Q696lnCznhep0f3+s01QhCNzgqp0xEXIwThwwadXLhWmjE
	 yUtcuglaLjnhg==
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
Subject: [PATCH v5 16/40] scsi: device_handlers: alua: use 16-bits defined sense codes
Date: Mon,  7 Sep 2026 11:43:19 +0900
Message-ID: <20260907024343.1046387-17-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907024343.1046387-1-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
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

