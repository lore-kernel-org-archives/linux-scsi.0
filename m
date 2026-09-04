Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFAE248F7C;
	Fri,  4 Sep 2026 00:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481642; cv=none; b=M74Nbqtbf9GPT++Tr+znRQir1ZCphC4XwYAqr4qBu9lT9zbtygjP0WpX7uxUSCnPn56xlYamq5My+uFaeroEBn+TQJilchdrdDptALgVA1xJ7FOH8geJ63WIhsnT60jH8tbq7t/IjHiLF96v2ZWIXGaXYDnGGVwWH8CbLiALAgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481642; c=relaxed/simple;
	bh=+ro/Xg8E61wmsgyq+k2dC0zLPx8G66gcFcguSdy117A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bGPtEdfkFrZjxSa9RFCEJNbNXS8eRfv4frE7DOkq8sfJEH7rEDIRVjWYVpD5hsCQrI+a56ugKnAnlLoCWE1CuwnfSh5qni1L5+buNDD8dVnZd/ZiNL9zhZc+38QjbxRwjfaKYwJQ8Dm8FydWu1Fvgxa82yO9IeeJQ7P777cyixk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hvifcD0f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hvifcD0f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297FC1F000E9;
	Fri,  4 Sep 2026 00:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481640;
	bh=cs9H4qj/FC8oc1B8LkzZiBLHNKg4nRkU0a+azNT3/2o=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=hvifcD0fSu5/MLLBh9Q2IV5T6kGfv+jvcr1bAMVdWa1bBijbYb394h0o7sBT8Fzcj
	 Zc+SweTW3axHAnm4rvLSaKgpDK85QGAkWwqlFrdJIizOLHFBw73e0pO9KTVq8dhLBE
	 REJXC/0+1j6s/QPD/mwDtJU/0ZevPfI1WU0qWPG7gyBfqF0ovkTobyBnWnco7dYjst
	 UVOVn6wfapJ5B4NmwLKnVpE5CgL4NgGMhHMTS5ouFxaM8wuuQKK4mcTJjnBKPlKYSK
	 FOQd15NooK1/0Ebpun1Z9ja0E2Afl5YpDS4YpmO++aZ2/VR3P55jK0/LqoHkY3ULlC
	 R1Sm2fA5UMmoQ==
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
Subject: [PATCH v3 13/40] scsi: device_handlers: hp_sw: use 16-bits defined sense codes
Date: Fri,  4 Sep 2026 09:26:17 +0900
Message-ID: <20260904002644.157668-14-dlemoal@kernel.org>
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

Refactor the HP sw device handler driver to use the 16-bits sense_code
field of struct scsi_sense_hdr and struct scsi_failure and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 25 +++++++++------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 3431e1ce95fd..d8653452ed2b 100644
--- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
+++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
@@ -47,7 +47,8 @@ static int tur_done(struct scsi_device *sdev, struct hp_sw_dh_data *h,
 
 	switch (sshdr->sense_key) {
 	case NOT_READY:
-		if (sshdr->asc == 0x04 && sshdr->ascq == 2) {
+		if (sshdr->sense_code ==
+		    LU_NOT_READY_INITIALIZING_COMMAND_REQUIRED) {
 			/*
 			 * LUN not ready - Initialization command required
 			 *
@@ -61,8 +62,8 @@ static int tur_done(struct scsi_device *sdev, struct hp_sw_dh_data *h,
 	default:
 		sdev_printk(KERN_WARNING, sdev,
 			   "%s: sending tur failed, sense %x/%x/%x\n",
-			   HP_SW_NAME, sshdr->sense_key, sshdr->asc,
-			   sshdr->ascq);
+			    HP_SW_NAME, sshdr->sense_key,
+			    scsi_sense_asc(sshdr), scsi_sense_ascq(sshdr));
 		break;
 	}
 	return ret;
@@ -85,8 +86,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	struct scsi_failure failure_defs[] = {
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = SCMD_FAILURE_ASC_ANY,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
 			.allowed = SCMD_FAILURE_NO_LIMIT,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
@@ -133,14 +133,9 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 				REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER;
 	struct scsi_failure failure_defs[] = {
 		{
-			/*
-			 * LUN not ready - manual intervention required
-			 *
-			 * Switch-over in progress, retry.
-			 */
+			/* Switch-over in progress, retry. */
 			.sense_key = NOT_READY,
-			.asc = 0x04,
-			.ascq = 0x03,
+			.sense_code = LU_NOT_READY_MANUAL_INTERVENTION_REQUIRED,
 			.allowed = HP_SW_RETRIES,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
@@ -167,7 +162,8 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 
 	switch (sshdr.sense_key) {
 	case NOT_READY:
-		if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
+		if (sshdr.sense_code ==
+		    LU_NOT_READY_MANUAL_INTERVENTION_REQUIRED) {
 			rc = SCSI_DH_RETRY;
 			break;
 		}
@@ -176,7 +172,8 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 		sdev_printk(KERN_WARNING, sdev,
 			    "%s: sending start_stop_unit failed, "
 			    "sense %x/%x/%x\n", HP_SW_NAME,
-			    sshdr.sense_key, sshdr.asc, sshdr.ascq);
+			    sshdr.sense_key, scsi_sense_asc(&sshdr),
+			    scsi_sense_ascq(&sshdr));
 		rc = SCSI_DH_IO;
 	}
 
-- 
2.55.0

