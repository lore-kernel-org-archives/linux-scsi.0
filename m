Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C393E3EAC8B;
	Mon,  7 Sep 2026 02:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749058; cv=none; b=toYAratjLb1ZsYcOGlQgeH1Ny//KHtnOaBs0IVKQ3jI/CutS3Jma2Wrmv34U9l+1G4Kv5acHODMc0gVy58VgLoeXaWLJxcwY/lScyRLx1xKWimPt9b+F3C7FDnyDxDZEP6FbmZ7No24nkBvrVnGRpqjVRVzWE7YFG528mYxHIj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749058; c=relaxed/simple;
	bh=hBLUXp7sV94Wqw2Vn+zNw/McVQPxUGnd8IPzrGIvui8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izWU70N+XX+WyQD8tmRiVGZxln2at3B3rRF0hSzIyDAnx9hlObal3rhUxgSpqbX75KfmUzqj8NOLpkishtWaqHfF5gQnUpednDi8aUy8GHLIRq0sF7Bt4lr59OgZ2YpszGvhrgYLLckfbd+t1zv5StUWcT/LCjOh6cmyKF8QWaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gz3KSqOL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gz3KSqOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3249F1F00A3A;
	Mon,  7 Sep 2026 02:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749056;
	bh=YNvn6oAofhdxhphXLtm7zPeYpkI2/zLmI2dTU3DLhAk=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=gz3KSqOLr1EeB4Bwyzas6umxyPPABCwZqxSOkkX1nhekQOFll3IEa2EpxsVEtUIOe
	 jryfvqTHZM+3s2GfUAVuNVeljhXb16xCRwWy58zoFoEvHxBMLYe0aNoSv8IAkFxmA8
	 b8imv3FNySDxcFqx1fTPblfJijmosnunLQqXFmDv3S/9DBtj/j/yY6KdSbQ3OfcyFj
	 ieVBNz/PuB5VuQCKZR+M3uWrVTyqrbFiVIFBtBgmxeMPd5A8rAtwrPi3PyfyNrD2Kb
	 Ds3vtkUAaaZPJA5wNCjUtgcsJwLf75cNCtrq2zl1HUFDkSCnIrfFHNYGPmCFKe+aoS
	 jDpnI9chthbOQ==
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
Subject: [PATCH v5 13/40] scsi: device_handlers: hp_sw: use 16-bits defined sense codes
Date: Mon,  7 Sep 2026 11:43:16 +0900
Message-ID: <20260907024343.1046387-14-dlemoal@kernel.org>
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

Refactor the HP sw device handler driver to use the 16-bits sense_code
field of struct scsi_sense_hdr and struct scsi_failure and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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

