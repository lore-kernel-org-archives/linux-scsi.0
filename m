Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E12331209;
	Thu,  3 Sep 2026 03:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406960; cv=none; b=pdBN0F6VIkLT/GW1ax7jcJdnON/RzuRLhp9FGxpx5D3TzA1/dH7SDR50QsVcHsM2pxe/VYno0JgiTsRFyl3vhUMVhZdefSbePwHlQN2G2tX0xts/8KZV04YhBL9Al045mCmNOkERPJXUzkTaBz/27jwdQYLFYQcsxim4cdXjSRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406960; c=relaxed/simple;
	bh=UKgyiLlf867sSalaINkPh2YN0NzU2Gmdlpeb83gD738=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROp4o3equbsxzQZ/U1HD9RTG9+87NHnSmQY0ntVYnEssShrQzrz7YjRnfQayqm3oJzWGuvHYiuFfCTr2pptvJE2xTjzVBxYhj3l/GWZ0goAsWh/TWXeMOQZFfNMTuCq+irzWB9ZVl/KRxDXEU0cXdly81I3NeQaBwlrItQjXW0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bc4wMSRs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bc4wMSRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ABB1F00A3A;
	Thu,  3 Sep 2026 03:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406953;
	bh=pY9Kd8k2h/nUKrON4W6nql61I5ap2cZ9FG2gcHGI33U=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Bc4wMSRsFrj1cw/DPtc9/d4EvUUI4TzaDApzj7JSdxAiYghEvmGlAM3xTjpdfAYhD
	 cNcOJ/kW4QctyHxfXNF/Za2sMxNtlus6Njm/E/tYW9VVscbeLS2ccwVBDLGtp0v85j
	 jEFsV7rNf34p4cTubzGTccky3i0KKNY7WLTifuNp6B/zI4m4UTb3ceRTZ5m/SuO2em
	 hXuKSpCvT39wfcf55XKKkseoG+0wrefcgqWBI1CrUPUUwE19Tavm/jcd5gmvh1ChwR
	 tO/vnI+qnC1lyG0J/DTCQBjllTbndzq8ARFjsfTBy5pIdLWWanOLrjKTd0hQrXpEuO
	 Q+bMPmXRXufGA==
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
Subject: [PATCH v2 10/40] scsi: ses: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:31 +0900
Message-ID: <20260903034201.112211-11-dlemoal@kernel.org>
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

Refactor the SCSI stroage enclosure driver to use the 16-bits sense_code
field of struct scsi_failure and replace all hard-coded additional sense
codes and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/ses.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 454886c24570..eefeb8b9a75c 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -72,6 +72,9 @@ static void init_device_slot_control(unsigned char *dest_desc,
 	dest_desc[3] &= 0x3c;
 }
 
+#define POWER_ON_RESET_ANY						\
+	scsi_sense_code(ASC_POWER_ON_RESET_OR_BUS_DEVICE_RESET_OCCURRED, \
+			SCMD_FAILURE_ASCQ_ANY)
 
 static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 			 void *buf, int bufflen)
@@ -89,15 +92,13 @@ static int ses_recv_diag(struct scsi_device *sdev, int page_code,
 	struct scsi_failure failure_defs[] = {
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = 0x29,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = POWER_ON_RESET_ANY,
 			.allowed = SES_RETRIES,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			.sense_key = NOT_READY,
-			.asc = SCMD_FAILURE_ASC_ANY,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
 			.allowed = SES_RETRIES,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
@@ -146,15 +147,13 @@ static int ses_send_diag(struct scsi_device *sdev, int page_code,
 	struct scsi_failure failure_defs[] = {
 		{
 			.sense_key = UNIT_ATTENTION,
-			.asc = 0x29,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = POWER_ON_RESET_ANY,
 			.allowed = SES_RETRIES,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
 		{
 			.sense_key = NOT_READY,
-			.asc = SCMD_FAILURE_ASC_ANY,
-			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.sense_code = SCMD_FAILURE_SENSE_CODE_ANY,
 			.allowed = SES_RETRIES,
 			.result = SAM_STAT_CHECK_CONDITION,
 		},
-- 
2.55.0

