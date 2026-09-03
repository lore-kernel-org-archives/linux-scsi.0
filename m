Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA5F38F927;
	Thu,  3 Sep 2026 03:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788406989; cv=none; b=fha1TjLZgYaiXXQH6tEpTeQ/gkg0i2J/bg6qSMBm3TARr/m/vFT703JX3quisi9gP62JYfdvKShCwKLlLdG1hqI1zjBET4+fsdS1+hEMitWuVe1wKiWyDooWqQEVd7df/6DEDLGQCPI7G066uMf+v22Kgg2GCCMri6XIG66m/xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788406989; c=relaxed/simple;
	bh=lPecab2c5dg+8wAmJipy+G4ikbG0a2M6m3u2QJr9/5o=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kuWEZ9aGsJDm1gn+AFfoq3nP3Q8fR3BfGJAF7UKsyEPaZ1NaMDaqpgXiaSPsh5VQ2vROKzfADbP6e6ANEq8Iz+M02Dm21+KAZjEweqGjJMQpMjnzVO4+ON5GMOa0giSmcsKcw3ULWi9YSGwarJcNc1PTi3uhnz+12Dt7qZF6alY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GLpVoNa3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GLpVoNa3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F201F00ACF;
	Thu,  3 Sep 2026 03:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788406982;
	bh=imnCiHKoT0eycGstj8YlxRyufJkrwvSvBUjdFONzfng=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=GLpVoNa3Ju23Jpz25jH9t1SDY082EtJ3yzEhD9aczhfiDzjcurSQmJzq6nTVjxcq6
	 fGYwC9QYoF7b3o7BEUxounikZS9wuyq05+stc5c1wi6VJXQFSpRko7aCDtwxRq84hH
	 jYcnz4YxDnyIXD0ZztlxsNGpwIBui1dPMiMZTz6GDUYSIjxa28UEkhLS22RfChAArY
	 1ITfouH9aCMqRcHf1roLwGDCQJbH+a/U7jDFtrbbx4l3mddRWJbFwo+OnpKv4sX/5y
	 svhdDaGh3RAdfdN65jDlbdNK0ZO0I7NWXCQTqSrVqb6qCAggPV4SzAlEBk62Fw/BMl
	 FZQKmVWnE4IyA==
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
Subject: [PATCH v2 26/40] scsi: lpfc: use 16-bits defined sense codes
Date: Thu,  3 Sep 2026 12:41:47 +0900
Message-ID: <20260903034201.112211-27-dlemoal@kernel.org>
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

