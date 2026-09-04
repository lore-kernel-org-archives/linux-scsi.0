Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B109E23FC5A;
	Fri,  4 Sep 2026 00:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481636; cv=none; b=hiZnt8+io3zpIddyBri8POppYD1D9pawFW2zpMFEPPNdBVPkwFRRAPQxttEhluEdpWi2laxoKYq404WyRZNHkQA0SExF/RuZyWwUBCHUxH2gZvDT/VCs5LVWZnblaUX45uITeyp47d+DKwKkPpWIbCop8s9gDO+LSb0seI3+hYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481636; c=relaxed/simple;
	bh=UKgyiLlf867sSalaINkPh2YN0NzU2Gmdlpeb83gD738=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vhq8Vgp+xwZN4I9YJkmxRgAyr0RsTgo9qM5JO8yYnEEwTQzc1XGmA8mA68KMsdu9FEEEeFnuteSyqz7DV6kd2HEXt9eScfNPQB7jEoF/JB/Wzmef1QgVCqRMD+/LRUCybf9aZe2MntAi8Fqw/S/mE1mKXj6gvLhRdz6OAdiK12k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dy64cudL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dy64cudL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC40F1F00A3F;
	Fri,  4 Sep 2026 00:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481635;
	bh=pY9Kd8k2h/nUKrON4W6nql61I5ap2cZ9FG2gcHGI33U=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=dy64cudLCi1hO0/uiZ+dLjCDwcm/ojReAhGMLW/cZKUR04dpUIo6gHJQO68e7AXQN
	 mm4/OLI1KMEwWCjc+UqXANuzJbnAgDEG6Yx+GhxO/htB3oagVX+ao0dBz0KdedOMNA
	 29Fbp6k+JTZrJYnGVTIVXSGF2VDKKw8juXddYItcZXhRMyiKosgm/WkmIWxgLJmvlp
	 ARH15HGC59une+mohh1fZZNEs5JCqC/ohz6cMkfqy8ssh0RUW6uO6GKvReJHiwKrWc
	 Fu5gNZo5IhNAZzb7EO4yDrRqpPbMkPiIVReA9LZ6m675aABr6HM79sAZlLciMW7zJb
	 kiyA1y+NFe+2w==
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
Subject: [PATCH v3 10/40] scsi: ses: use 16-bits defined sense codes
Date: Fri,  4 Sep 2026 09:26:14 +0900
Message-ID: <20260904002644.157668-11-dlemoal@kernel.org>
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

