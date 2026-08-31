Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D853546D2;
	Mon, 31 Aug 2026 02:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788141926; cv=none; b=IgFANG/8CC0QwFRtOIrZtCy44qFlUW4Zg+r5ugXWoEtBocGrV6wfb24F96VJsxj4qCJDjw6v7JrzubCU9ZN1vyeo8o1L7nHvgM93zyS2pJh06QNad0rQrANG7wenLNRdsmSrKwmScznfL4X6wSZtNAsBuA/SlE9nV3czs2oPtTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788141926; c=relaxed/simple;
	bh=Y/pa32ZLULKdfFwskd2EbXbwrhs+4GtAKvasoqUJM3c=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ijT9MvKq++/BXCsWr9JFyC96lR+nI4hODUrR1vwd5c3I/OHtk8XGilFimjuLjjDeRNBFgE/4LmeCmK/ue+KTOrvQ+686bCj4LyiPv403witlkxzL8zO+UfLGsccpDFMX1dsjo+OERZlzcugO8oAxqD5uOLFrwYl7bFelPOMzoic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xa6vwFOy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xa6vwFOy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39361F00A3D;
	Mon, 31 Aug 2026 02:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788141924;
	bh=+8AYMkAmS+FSe65C6qGqZLZRk0gQ6eTo+ZUu7CmiV3g=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Xa6vwFOyGf0XaGxX17YRj/zycC8s1jnA0p4XSSzqYqJUkckIw/wRAXysvhAqnZN4P
	 kM5vc6ExC1O4sUDxsXbyxDvHKcw5Gh+xvCiDVNgz6FeKNAVrFOU+ykp0kDaRTFYFSw
	 ikDdWH37RIS7AdtYDPQY0wyqogPV7sdskDuoPdBxBE2Dn8pImh61q4cIgIrp9BfvLz
	 zjCgiGonNXfnoyKXp+ym2HKExdCY33PIX4TUHhNkIxbPlaEEDvOTgMBb4SbusdZ2PT
	 IB+OgVBdooaYw19T6p/vo8tm+dYoIK4d1ioUpM239srrlzBe491W5l4XfZuEcnlh+j
	 UoYtDvOMG5qqQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 13/37] scsi: device_handlers: hp_sw: use 16-bits defined sense codes
Date: Mon, 31 Aug 2026 11:04:27 +0900
Message-ID: <20260831020451.585944-14-dlemoal@kernel.org>
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

Refactor the HP sw device handler driver to use the 16-bits sense_code
field of struct scsi_sense_hdr and struct scsi_failure and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 27 +++++++++------------
 1 file changed, 11 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
index 3431e1ce95fd..e400a317d9f3 100644
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
@@ -60,9 +61,8 @@ static int tur_done(struct scsi_device *sdev, struct hp_sw_dh_data *h,
 		fallthrough;
 	default:
 		sdev_printk(KERN_WARNING, sdev,
-			   "%s: sending tur failed, sense %x/%x/%x\n",
-			   HP_SW_NAME, sshdr->sense_key, sshdr->asc,
-			   sshdr->ascq);
+			   "%s: sending tur failed, sense 0x%02x/0x%04x\n",
+			    HP_SW_NAME, sshdr->sense_key, sshdr->sense_code);
 		break;
 	}
 	return ret;
@@ -85,8 +85,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
 	struct scsi_failure failure_defs[] = {
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = SCMD_FAILURE_ASC_ANY,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
 			.allowed = SCMD_FAILURE_NO_LIMIT,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
@@ -133,14 +132,9 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
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
@@ -167,7 +161,8 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 
 	switch (sshdr.sense_key) {
 	case NOT_READY:
-		if (sshdr.asc == 0x04 && sshdr.ascq == 3) {
+		if (sshdr.sense_code ==
+		    LU_NOT_READY_MANUAL_INTERVENTION_REQUIRED) {
 			rc = SCSI_DH_RETRY;
 			break;
 		}
@@ -175,8 +170,8 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
 	default:
 		sdev_printk(KERN_WARNING, sdev,
 			    "%s: sending start_stop_unit failed, "
-			    "sense %x/%x/%x\n", HP_SW_NAME,
-			    sshdr.sense_key, sshdr.asc, sshdr.ascq);
+			    "sense %x/%04x\n", HP_SW_NAME,
+			    sshdr.sense_key, sshdr.sense_code);
 		rc = SCSI_DH_IO;
 	}
 
-- 
2.55.0

