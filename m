Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779C83F329E;
	Mon,  7 Sep 2026 02:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749077; cv=none; b=vDyB8XuRw4hqJhb9hp8ftmCDnMXKzZ40ANexu/6IYWdx52WqHkzLvKF6r9fFQYiqJdfDBgI5RSQWTYxQu+NGOajMc/3ytdaTenW7qU6jMsv2rdw/eArWzmDmL2mWG2EVMsZnu9CxzD5v5I/eiNrzpU+pHJqep2AB4wEa0xez3sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749077; c=relaxed/simple;
	bh=2AiLdaBR9MX2KCO4KfJXV2HftBCOsObrkyisZOl5xgw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BKrZh4MBrzDqarAEsXz786GBQfvjbhAa+Z4j1TbAzj9ojM1RplWr4pl6kSATegjxN/XW5YxAn4wHG0oErs96TlXAZlXd33G2sCDTzkAI1xPBnNDUuu0DVu4sq9K4MFl5TtA42vcJtD7YNHmg51mKBDROs0WNZYZzV8xMaQbVk7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YmcMIkfN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YmcMIkfN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 277851F00A3D;
	Mon,  7 Sep 2026 02:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749076;
	bh=+067B6ajfkubqeFqsK9EFFhC/hmkdjoE7eciypFPjng=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=YmcMIkfNKVF3+35TcA3YwA3r2shJhwT2QGJ9laOV5sK50804NIYZ41b828pVXBXBE
	 HsA1SsokHW/ZmH2Jx7fiCCBOft5vVjZnDoOnJp0d4rZvltuTUGYCr+H7FOaIniZlWC
	 3eUxSPuENQhQ9n3Jl3BuggMkO2xDhVAXug+fH4LH96dftvM4RFiT6S6U+goGwNVCRG
	 x7rm3Net8SDlRRBMuuXyGensB+bTrP8lD/sWmklOMPJ9pcUD33+mCH5fkO6a6CPvBl
	 /LmxTiKy8eJS4xWhCtjZWg4ukydPKxdJaP6miz7k/jDoajOu//VD7zdP1jSPxQ5J8i
	 TqxZbH4FkABzw==
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
Subject: [PATCH v5 26/40] scsi: lpfc: use 16-bits defined sense codes
Date: Mon,  7 Sep 2026 11:43:29 +0900
Message-ID: <20260907024343.1046387-27-dlemoal@kernel.org>
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
index 50616b05488a..8dd876a1a78d 100644
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

