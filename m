Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11DD530D402;
	Fri,  4 Sep 2026 00:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788481664; cv=none; b=flyMraKR08ybNSBCmSVQL2jxwjCa8W1vKTpamMqOz7WJX4B1f8tdja/6dje0MkA3FRHSQiflXbTbBd30EG+gfwAX1uCzgIfnYIgIDRuUPMwePXRyOkBxLiGYfkzDP86qTs32nQida/Ezdnl5TurLDDJJVtf9zPRO8UmkQRofEhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788481664; c=relaxed/simple;
	bh=lPecab2c5dg+8wAmJipy+G4ikbG0a2M6m3u2QJr9/5o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajSN/pGXkxB5Ym74ZnWkruZvL5QoRuaimvuUeak4oZNpd2AYTfSo/JEsQZA/dhKr+g4kBWd3XqCridvdRqQ64riWslO/S6nom1D0p24ZY0MDOyBX5QS8/32FCkr2h+5fbp6kHWImfrFiVc/M9A50fjzCvl9bcsZlc3i9saHWnsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fi8cTnJY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fi8cTnJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 958CE1F000E9;
	Fri,  4 Sep 2026 00:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788481663;
	bh=imnCiHKoT0eycGstj8YlxRyufJkrwvSvBUjdFONzfng=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=fi8cTnJY/sAqWGVMw+0M87wU3lg05CGHa8LsxQbaz97aTxbUi1CEoQSqI3qfzs2h+
	 2nSAcQ443rKk12vG/j3jDv4h4JtK6zrj669yieFzbVqefRsnmSEsTSaxKCVzRDln2L
	 v+95sdSTqtysjN6GkyQTn5WOX7KmbGwqeyA736SOF7LzSlC7VcACrdrUU6yJDzP+zO
	 rwx36uUgzJNZJ6+SYeVvdEoKSaTCDm6Eb69RGsjLdi1NGFUAz66ItWMGXnyRlCqx3W
	 SLlVehc5oBBZbA+jvyEGkIlldv3SiK/hH4TqmMeiC9hyuzoEErimo4vxw1VimIaF5+
	 UEXAAgtFnUnhQ==
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
Subject: [PATCH v3 26/40] scsi: lpfc: use 16-bits defined sense codes
Date: Fri,  4 Sep 2026 09:26:30 +0900
Message-ID: <20260904002644.157668-27-dlemoal@kernel.org>
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

Refactor the lpfc driver to use scsi_set_sense() and replace all
hard-coded additional sense codes and additional sense code qualifiers
with the enum values defined in include/scsi/scsi_sense.h. This helps with
code clarity as the sense codes being processed are easier to test and
self-documented.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 8a795c65e3c3..849d4de91b38 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -2848,7 +2848,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 	}
 out:
 	if (err_type == BGS_GUARD_ERR_MASK) {
-		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);
+		scsi_set_sense(cmd, 1, ILLEGAL_REQUEST,
+			       LOGICAL_BLOCK_GUARD_CHECK_FAILED);
 		set_host_byte(cmd, DID_ABORT);
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
@@ -2857,7 +2858,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 				sum, guard_tag);
 
 	} else if (err_type == BGS_REFTAG_ERR_MASK) {
-		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x3);
+		scsi_set_sense(cmd, 1, ILLEGAL_REQUEST,
+			       LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
 		set_host_byte(cmd, DID_ABORT);
 
 		phba->bg_reftag_err_cnt++;
@@ -2867,7 +2869,8 @@ lpfc_calc_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd)
 				ref_tag, start_ref_tag);
 
 	} else if (err_type == BGS_APPTAG_ERR_MASK) {
-		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x2);
+		scsi_set_sense(cmd, 1, ILLEGAL_REQUEST,
+			       LOGICAL_BLOCK_APPLICATION_TAG_CHECK_FAILED);
 		set_host_byte(cmd, DID_ABORT);
 
 		phba->bg_apptag_err_cnt++;
@@ -2970,7 +2973,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 	if (lpfc_bgs_get_guard_err(bgstat)) {
 		ret = 1;
-		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x1);
+		scsi_set_sense(cmd, 1, ILLEGAL_REQUEST,
+			       LOGICAL_BLOCK_GUARD_CHECK_FAILED);
 		set_host_byte(cmd, DID_ABORT);
 		phba->bg_guard_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
@@ -2983,7 +2987,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 	if (lpfc_bgs_get_reftag_err(bgstat)) {
 		ret = 1;
-		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x3);
+		scsi_set_sense(cmd, 1, ILLEGAL_REQUEST,
+			       LOGICAL_BLOCK_REFERENCE_TAG_CHECK_FAILED);
 		set_host_byte(cmd, DID_ABORT);
 		phba->bg_reftag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
@@ -2996,7 +3001,8 @@ lpfc_parse_bg_err(struct lpfc_hba *phba, struct lpfc_io_buf *lpfc_cmd,
 
 	if (lpfc_bgs_get_apptag_err(bgstat)) {
 		ret = 1;
-		scsi_build_sense(cmd, 1, ILLEGAL_REQUEST, 0x10, 0x2);
+		scsi_set_sense(cmd, 1, ILLEGAL_REQUEST,
+			       LOGICAL_BLOCK_APPLICATION_TAG_CHECK_FAILED);
 		set_host_byte(cmd, DID_ABORT);
 		phba->bg_apptag_err_cnt++;
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP | LOG_BG,
-- 
2.55.0

