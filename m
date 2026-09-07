Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B363E6DC3;
	Mon,  7 Sep 2026 02:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749096; cv=none; b=iVCiwopZGpCW3jBq1zKdFlkyou2CPaKEVw+wsPwmQjM2xRqbkztbeQzup2wB/cHr4B8h53kpTCWERL1dYsz97HQ5UwEX4p+eRmtYdI7h7KOGYxWTNvMu5D9QH3A+6i44SfV9bXlw1GOlCXsOBozQYLxvU/hZcXX2H/o6u+a0aSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749096; c=relaxed/simple;
	bh=iMFNZlFYybHlLOz4hEf/VxPxF4ckTz/WT4sBcfOSieA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Guk0Z0XpIovmTLqu8KzhyNJNWfWRQ+56E0xOWqXghbYEz2YoXmrmW8QybFQdTuSa51LuVU+BXn98dPhfHV/lCVcVFIKFrtP5q1Iw/GEyoXbYsV5oRY+bzgiiUnjX6DdEtul32SOw/ebHjrwFAqzUO8PvgBACEkOBqv/O8q+IORI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cduJiSQ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cduJiSQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D52681F00A3E;
	Mon,  7 Sep 2026 02:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749095;
	bh=vGn4rrkCLI0Ht0/wdm7tDdqtNkdML/k+si/55LfEObM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=cduJiSQ/byDOvv80TifntLkzO7S8M0nw5oRNPVVkupwJMr5tNfSkweGWnlo5cOBRT
	 qhf7VhFXDIJ4YPca2Q1VdXnoHcAcR7Z3w3vzZtqipnbumdG91VklW80LzLaZ5Dfa8f
	 1psLxR5YOZkr3pjqqWTXafdFBNM0/G37vn3DQMx5NJ4GZ5CssU4iVNEops4lgCp90E
	 eiBvxiAB+7Bk2Yfzm4ZRCHB5pQJQ4Vtc6sMxciMvf6vJ3Ap5m9485BQ5rmPjiVx29K
	 kuKCxLOWH7FtG3bqUbNibshnjpDm2KG0ISmPAaAQoxURehjOzddbsnJ6JBDlfZssrO
	 /MPFZFwp8eD7g==
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
Subject: [PATCH v5 38/40] s390: scsi: use 16-bits defined sense codes
Date: Mon,  7 Sep 2026 11:43:41 +0900
Message-ID: <20260907024343.1046387-39-dlemoal@kernel.org>
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

Use the 16-bits sense codes and replace all hard-coded additional sense
codes and additional sense code qualifiers with the enum values defined
in include/scsi/scsi_sense.h. This helps with code clarity as the sense
codes being processed are easier to test and self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/s390/scsi/zfcp_ext.h  | 2 +-
 drivers/s390/scsi/zfcp_fsf.c  | 9 ++++++---
 drivers/s390/scsi/zfcp_scsi.c | 6 +++---
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
index 0eb9bc9d03e4..cafdeaf29195 100644
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -176,7 +176,7 @@ extern void zfcp_scsi_schedule_rport_register(struct zfcp_port *);
 extern void zfcp_scsi_schedule_rport_block(struct zfcp_port *);
 extern void zfcp_scsi_schedule_rports_block(struct zfcp_adapter *);
 extern void zfcp_scsi_set_prot(struct zfcp_adapter *);
-extern void zfcp_scsi_dif_sense_error(struct scsi_cmnd *, int);
+extern void zfcp_scsi_dif_sense_error(struct scsi_cmnd *, u16);
 extern void zfcp_scsi_shost_update_config_data(
 	struct zfcp_adapter *const adapter,
 	const struct fsf_qtcb_bottom_config *const bottom,
diff --git a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
index d407f16e77ef..1ea6ab720fc0 100644
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -2485,13 +2485,16 @@ static void zfcp_fsf_fcp_cmnd_handler(struct zfcp_fsf_req *req)
 		set_host_byte(scpnt, DID_ERROR);
 		goto skip_fsfstatus;
 	case FSF_BLOCK_GUARD_CHECK_FAILURE:
-		zfcp_scsi_dif_sense_error(scpnt, 0x1);
+		zfcp_scsi_dif_sense_error(scpnt,
+				LOGICAL_BLOCK_GUARD_CHECK_FAILED);
 		goto skip_fsfstatus;
 	case FSF_APP_TAG_CHECK_FAILURE:
-		zfcp_scsi_dif_sense_error(scpnt, 0x2);
+		zfcp_scsi_dif_sense_error(scpnt,
+				LOGICAL_BLOCK_APPLICATION_TAG_CHECK_FAILED);
 		goto skip_fsfstatus;
 	case FSF_REF_TAG_CHECK_FAILURE:
-		zfcp_scsi_dif_sense_error(scpnt, 0x3);
+		zfcp_scsi_dif_sense_error(scpnt,
+				LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
 		goto skip_fsfstatus;
 	}
 	BUILD_BUG_ON(sizeof(struct fcp_resp_with_ext) > FSF_FCP_RSP_SIZE);
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 3590113c2b74..ea4b968352f4 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -849,14 +849,14 @@ void zfcp_scsi_set_prot(struct zfcp_adapter *adapter)
 /**
  * zfcp_scsi_dif_sense_error - Report DIF/DIX error as driver sense error
  * @scmd: The SCSI command to report the error for
- * @ascq: The ASCQ to put in the sense buffer
+ * @sense_code: The combined ASC and ASCQ to put in the sense buffer
  *
  * See the error handling in sd_done for the sense codes used here.
  * Set DID_SOFT_ERROR to retry the request, if possible.
  */
-void zfcp_scsi_dif_sense_error(struct scsi_cmnd *scmd, int ascq)
+void zfcp_scsi_dif_sense_error(struct scsi_cmnd *scmd, u16 sense_code)
 {
-	scsi_build_sense(scmd, 1, ILLEGAL_REQUEST, 0x10, ascq);
+	scsi_set_sense(scmd, 1, ILLEGAL_REQUEST, sense_code);
 	set_host_byte(scmd, DID_SOFT_ERROR);
 }
 
-- 
2.55.0

