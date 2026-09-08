Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 250394DA52E;
	Tue,  8 Sep 2026 09:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858225; cv=none; b=D6nH/gl+EtXkVMwo6SG1IrhCX6NN6yk+t6v0DiTvLqxB0TkjFqxviitII1M/2U5uvxpg5ApbPnpVlTT7Z8hh95ALvJ9Yc6Aa+GZvqMyOIoJFSF+YqMCpoS+6ERQqpl+//IlhZ3OSEhQlz9w2MdD0BA+TnLZKj7CRIwAWyPXge1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858225; c=relaxed/simple;
	bh=J6b8CO7B7kAOj70WagUL1sid4/gCRqDAOCQATECtW2A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y9KcuXBGCczXpiMv4TVnlHE2ROKnkvM7K8ZJkFpwCWU8vDJ2lZcbZ8n3svJIuLeA/xU332CFXOF6lpuvQyzAqwu/xl28GWShqKWX+d+KgYPitpOits25VwynreJxBlsXKyD9lmX+NkkFS9TFo8u50bbxM8/IuOrLwIqpCzl2LtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oIdD8YUf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oIdD8YUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559191F00AC4;
	Tue,  8 Sep 2026 09:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858218;
	bh=S8Zyyxuf6udO0SXP5gyNArmw0qPax96ryBFXJ/C5BFA=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=oIdD8YUfobWaJnLKCpU6jIo7gC58aFaIwQ7sceTbId/aDHMguPkVSMFFrErzearN7
	 6PmdQDvyDU6FkwWZsyzdj316TH+Wn6Y5W/l+I8iq63nVF0qyUt+WK6xyWtWEekkL59
	 dGCeK0NThxGW7Ng0PjKthSfKyKYa/7k68lQxkXmRwzVzVRiGpAM7jI79efgiHeOBJt
	 RaHamWTZEAU3ZGcQNByp5wRL8FPXkKw39qXQyaS0l0nO4bjkpiJlX+2onkbD3siUn7
	 XDPR/GwPoFq5bD5852H3rIr+SWpZo0ov0zNzvztngG7KFPSj66owMnf2+M9Mt4DYX7
	 R/dZ3bUzJ3gUg==
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
Subject: [PATCH v6 10/40] scsi: ses: use 16-bits defined sense codes
Date: Tue,  8 Sep 2026 18:02:38 +0900
Message-ID: <20260908090308.1085097-11-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908090308.1085097-1-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
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
Reviewed-by: Hannes Reinecke <hare@kernel.org>
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

