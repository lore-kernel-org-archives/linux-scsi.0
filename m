Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040E83E866B;
	Mon,  7 Sep 2026 02:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749053; cv=none; b=BIGmcjZw93rcMKw1S6ojLIDUXZvSj7qwfu36xvvfP6NJ823cviT27swbYHMXRCy4QKQH3nNmCkRLeDbomOPUbbLDnR2qvggb6uN5dkGX49JVNP5SLz5cf+3+ddWb3SjnFrPZoyKK52gv3cLrZCAiVlF7IwuNeThi9xkOX31oc1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749053; c=relaxed/simple;
	bh=wNd2+MjSTEjIvpY/XJee6q52CTaEFKluQmww9CUzG74=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZyBxMMIipmsN2Bm2OJyJzpX8C1zWkeB0CUp3CeDgzT9uNPZcq4h+et0kXU4u/5Y1PdupbVyg2wDaavvJbwX/2H4l6xrpXSrGvzphbTmug//EA5OZbHHWtvDK2813jEPlaansKUpav5WHZm0EwXxz43iLnFqXr1IyOSFVCJXo4qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AtBd9ric; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AtBd9ric"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 915BF1F00A3D;
	Mon,  7 Sep 2026 02:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749051;
	bh=65m7Ww3g0ELUZ1I4+ziWhjxBbjPw3/ChlZisZFOkFbI=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=AtBd9ricTgGiHhl5K9cR7M9GHJzhvexrX565fWRn8W2e7KGAy/rC4PU2C/ZbcP7Os
	 ZwYZ0UhWyjD9F/qbxQlDJALnFOQqvAKvi04o3VGceyu91BLl0KMWzHGI93OmpPheEA
	 PcRh84WZie8qRi1+0lNoQzKyATg+d2q6jFPCNRpmBQCG1zkr2A0ElQWo/wVxQSkKGy
	 6Wy9rX0IJ6CTNBzgpwWoT7ipP63G1D2OmxUf0eib2e4MFEAc8ukCnpqP4nf3YqpW+g
	 mJA8hErFttzR2CMXSIKvbeFtR8Z2JxxcTJU6fjFDjJPsfX6YwL6PKi2JJiPDffQCB3
	 dkdPAkkiXT5gA==
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
Subject: [PATCH v5 10/40] scsi: ses: use 16-bits defined sense codes
Date: Mon,  7 Sep 2026 11:43:13 +0900
Message-ID: <20260907024343.1046387-11-dlemoal@kernel.org>
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

Refactor the SCSI stroage enclosure driver to use the 16-bits sense_code
field of struct scsi_failure and replace all hard-coded additional sense
codes and additional sense code qualifiers with the enum values defined in
include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
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

