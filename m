Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62175280CD5;
	Fri,  4 Sep 2026 00:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481644; cv=none; b=B5baD2t7OPfONp34xrg8UGKNyrZxK7G/BHclqwgXFIkksSDZEovvGJ6JYNWd0kZpivQfUugyI243sU3R1sg52iiW/ANE+rXt2F4wRX25jwZ1We3khUO1ONLgJrukKwkZlxsUBgUpCYZtRCm3EZsljhXL1i54ytGONLKOgPc7Dq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481644; c=relaxed/simple;
	bh=sIMKjJ7dsyTCxJ3imfTKd6WHTdSCosVSuPHPWK5tErY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ow9+8PiKUZZ4DGfm5Dcu0rc4upLJva1Eau2ELhKOZnZC10GV6HeKtym1ZqQ5y7Y4TU0gi5idIakaiq+fn+bcbqzqW4LtIEuNdncKtrNXZy8yr1mzJnH1lMdbuyI2K4rtzCZYvsc/5SiMMyrBHlof0/3uNNCiArYAQNy8viUKXC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvMEBnkb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvMEBnkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1331F00A3F;
	Fri,  4 Sep 2026 00:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481642;
	bh=h7+bLMSnKQOrXGLcG0qV2AXpoC9KL2kuM6IVbNs/QEI=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=hvMEBnkbMrevmqX+SCAi0FUz6ifT80TudfIy/v2q49S8dH8EFpPkERauYChnzHExA
	 g76MluLtWZrBdqML6i2AzViiOb4Ac0e1/oS1n+xPreASIOHiOVqkB4zuo8TnK9YvbS
	 G71jJkJ/AqG6EkSdvY7f1dKGvuPbecwQ+f9JyEBNP+1sPjcMKU7QOxO1l6U4sXA3j0
	 L4qLXZS7uUnwLCIqa361Fb66ezUX44mDduoxRCCMgP2ntarFM7UipaARkMFmzhq5k6
	 9g9nmb2376vFrWE7Oudn8lRY5YIIiayQfXle5kJUbAIBVz0XF4x+fK5KfnMom//JmM
	 x6TmO3cMWetsw==
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
Subject: [PATCH v3 14/40] scsi: device_handlers: rdac: use 16-bits defined sense codes
Date: Fri,  4 Sep 2026 09:26:18 +0900
Message-ID: <20260904002644.157668-15-dlemoal@kernel.org>
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

Refactor the NetApp E-Series RDAC SCSI device handler driver to use the
16-bits sense_code field of struct scsi_sense_hdr and struct scsi_failure
and replace all hard-coded additional sense codes and additional sense
code qualifiers with the enum values defined in include/scsi/scsi_sense.h.
This helps with code clarity as the sense codes being processed are easier
to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 45 ++++++++++------------
 1 file changed, 21 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 75c9cc291e38..742534c99386 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -493,7 +493,8 @@ static int mode_select_handle_sense(struct scsi_device *sdev,
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
 		"MODE_SELECT returned with sense %02x/%02x/%02x",
 		(char *) h->ctlr->array_name, h->ctlr->index,
-		sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
+		 sense_hdr->sense_key, scsi_sense_asc(sense_hdr),
+		 scsi_sense_ascq(sense_hdr));
 
 	return SCSI_DH_IO;
 }
@@ -515,34 +516,28 @@ static void send_mode_select(struct work_struct *work)
 	struct scsi_failure failure_defs[] = {
 		{
 			.sense_key = NO_SENSE,
-			.asc = SCMD_FAILURE_ASC_ANY,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			.sense_key = ABORTED_COMMAND,
-			.asc = SCMD_FAILURE_ASC_ANY,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = SCMD_FAILURE_ASC_ANY,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
-		/* LUN Not Ready and is in the Process of Becoming Ready */
 		{
 			.sense_key = NOT_READY,
-			.asc = 0x04,
-			.ascq = 0x01,
+			.sense_code = LU_IS_IN_PROCESS_OF_BECOMING_READY,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
-		/* Command Lock contention */
+		/* Command Lock contention (not a standard sense code) */
 		{
 			.sense_key = ILLEGAL_REQUEST,
-			.asc = 0x91,
-			.ascq = 0x36,
+			.sense_code = scsi_sense_code(0x91, 0x36),
 			.allowed = SCMD_FAILURE_NO_LIMIT,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
@@ -674,33 +669,34 @@ static enum scsi_disposition rdac_check_sense(struct scsi_device *sdev,
 {
 	struct rdac_dh_data *h = sdev->handler_data;
 
-	RDAC_LOG(RDAC_LOG_SENSE, sdev, "array %s, ctlr %d, "
-			"I/O returned with sense %02x/%02x/%02x",
-			(char *) h->ctlr->array_name, h->ctlr->index,
-			sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
+	RDAC_LOG(RDAC_LOG_SENSE, sdev,
+		 "array %s, ctlr %d, I/O returned with sense %02x/%02x/%02x",
+		 (char *) h->ctlr->array_name, h->ctlr->index,
+		 sense_hdr->sense_key, scsi_sense_asc(sense_hdr),
+		 scsi_sense_ascq(sense_hdr));
 
 	switch (sense_hdr->sense_key) {
 	case NOT_READY:
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
+		if (sense_hdr->sense_code == LU_IS_IN_PROCESS_OF_BECOMING_READY)
 			/* LUN Not Ready - Logical Unit Not Ready and is in
 			* the process of becoming ready
 			* Just retry.
 			*/
 			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x81)
+		if (sense_hdr->sense_code == scsi_sense_code(0x04, 0x81))
 			/* LUN Not Ready - Storage firmware incompatible
 			 * Manual code synchonisation required.
 			 *
 			 * Nothing we can do here. Try to bypass the path.
 			 */
 			return SUCCESS;
-		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0xA1)
+		if (sense_hdr->sense_code == scsi_sense_code(0x04, 0xA1))
 			/* LUN Not Ready - Quiescense in progress
 			 *
 			 * Just retry and wait.
 			 */
 			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0xA1  && sense_hdr->ascq == 0x02)
+		if (sense_hdr->sense_code == scsi_sense_code(0xA1, 0x02))
 			/* LUN Not Ready - Quiescense in progress
 			 * or has been achieved
 			 * Just retry.
@@ -708,7 +704,7 @@ static enum scsi_disposition rdac_check_sense(struct scsi_device *sdev,
 			return ADD_TO_MLQUEUE;
 		break;
 	case ILLEGAL_REQUEST:
-		if (sense_hdr->asc == 0x94 && sense_hdr->ascq == 0x01) {
+		if (sense_hdr->sense_code == scsi_sense_code(0x94, 0x01)) {
 			/* Invalid Request - Current Logical Unit Ownership.
 			 * Controller is not the current owner of the LUN,
 			 * Fail the path, so that the other path be used.
@@ -718,12 +714,13 @@ static enum scsi_disposition rdac_check_sense(struct scsi_device *sdev,
 		}
 		break;
 	case UNIT_ATTENTION:
-		if (sense_hdr->asc == 0x29 && sense_hdr->ascq == 0x00)
+		if (sense_hdr->sense_code ==
+		    POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED)
 			/*
 			 * Power On, Reset, or Bus Device Reset, just retry.
 			 */
 			return ADD_TO_MLQUEUE;
-		if (sense_hdr->asc == 0x8b && sense_hdr->ascq == 0x02)
+		if (sense_hdr->sense_code == scsi_sense_code(0x8b, 0x02))
 			/*
 			 * Quiescence in progress , just retry.
 			 */
-- 
2.55.0

