Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3A52353EEB;
	Mon, 31 Aug 2026 02:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141928; cv=none; b=kbGV+BtkbmeOI8zVc3hj58DHiWmyQjHcHzw6gUbTC3Nnl3f7b52Zid87PxbazqKMdLGFtA6rUj/PWH8U7ZnmZ6T6YwB2TKzNbnrQzwFogqqgkL9vKr/5RuiCRi6L1HIVO/0+lOJBcprbKjRiMjVzScgEXSthJd7tbTVXc7qakag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141928; c=relaxed/simple;
	bh=H7qZmSsdQfLNa61PKmHVAPOuPxbHxj3rJv6mKtbEJ/U=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTe7dC1ibCvx+1k/fxGxHu7vsQd/vk6kcWXajxkIoqODiHhV97z8pfN+Raywv3XMJxq4lVGkYAWIfrqkyTbb5KxUT2PMmeh6SqlqLRuQzZ30Ox2iN/5UZEkxKJps2SVxzZfjYMjHFACFyhYihYjQZqeJPqa1p3uFKG8UdKdEZYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L5uAe3U4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L5uAe3U4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407781F000E9;
	Mon, 31 Aug 2026 02:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141926;
	bh=mEkCLZk8ejcgV5GCpqGqtpqceQjG0s6zIF+qe/n6BlM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=L5uAe3U4xFVA+I/iwuOk965qJQqho0wzKQ5qeC8ghKHihl/Q4QQs6jx7Z5KYPHqtL
	 WvOHa3+tNUcKxkdxL+tD+jEkUmtuUOfl2oROc+67c/GTVUBVJwtC5JAtzVh6doB1Y7
	 0f14FQ3r8x0A2v0sQ40MtTL2NpdOxzNLJA6BcvOkA2NhXgDG1PhkKSdqWXEFzF9ePi
	 ou0thP4XSSBbyY0KTujeOqGWY9EGcF/saCe+7J+zAdZmATE1eVptNNRKytZEHSTHVx
	 Nh1hi2NAJiMDVetx2hVPYZZhZyLBM527wg86cGeVcINqU0Gx08SOr6cP0uMYMxWgVG
	 H/CZIMRdpRjcQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 14/37] scsi: device_handlers: rdac: use 16-bits defined sense codes
Date: Mon, 31 Aug 2026 11:04:28 +0900
Message-ID: <20260831020451.585944-15-dlemoal@kernel.org>
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

Refactor the NetApp E-Series RDAC SCSI device handler driver to use the
16-bits sense_code field of struct scsi_sense_hdr and struct scsi_failure
and replace all hard-coded additional sense codes and additional sense
code qualifiers with the enum values defined in include/scsi/scsi_sense.h.
This helps with code clarity as the sense codes being processed are easier
to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_rdac.c | 41 ++++++++++------------
 1 file changed, 18 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c b/drivers/scsi/device_handler/scsi_dh_rdac.c
index 75c9cc291e38..1ca1aaf7cb40 100644
--- a/drivers/scsi/device_handler/scsi_dh_rdac.c
+++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
@@ -491,9 +491,9 @@ static int mode_select_handle_sense(struct scsi_device *sdev,
 		return SCSI_DH_IO;
 
 	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
-		"MODE_SELECT returned with sense %02x/%02x/%02x",
+		"MODE_SELECT returned with sense 0x%02x/0x%04x",
 		(char *) h->ctlr->array_name, h->ctlr->index,
-		sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
+		 sense_hdr->sense_key, sense_hdr->sense_code);
 
 	return SCSI_DH_IO;
 }
@@ -515,34 +515,28 @@ static void send_mode_select(struct work_struct *work)
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
@@ -675,32 +669,32 @@ static enum scsi_disposition rdac_check_sense(struct scsi_device *sdev,
 	struct rdac_dh_data *h = sdev->handler_data;
 
 	RDAC_LOG(RDAC_LOG_SENSE, sdev, "array %s, ctlr %d, "
-			"I/O returned with sense %02x/%02x/%02x",
+			"I/O returned with sense 0x%02x/0x%04x",
 			(char *) h->ctlr->array_name, h->ctlr->index,
-			sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
+			sense_hdr->sense_key, sense_hdr->sense_code);
 
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
@@ -708,7 +702,7 @@ static enum scsi_disposition rdac_check_sense(struct scsi_device *sdev,
 			return ADD_TO_MLQUEUE;
 		break;
 	case ILLEGAL_REQUEST:
-		if (sense_hdr->asc == 0x94 && sense_hdr->ascq == 0x01) {
+		if (sense_hdr->sense_code == scsi_sense_code(0x94, 0x01)) {
 			/* Invalid Request - Current Logical Unit Ownership.
 			 * Controller is not the current owner of the LUN,
 			 * Fail the path, so that the other path be used.
@@ -718,12 +712,13 @@ static enum scsi_disposition rdac_check_sense(struct scsi_device *sdev,
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

