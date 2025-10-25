Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2263A32AAAC;
	Sat, 25 Oct 2025 16:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409772; cv=none; b=EKoAzBZBn++pI8UEUZj3XA1l6vl6F0AK5LmhIk3ihoLLDrveic5+/v0KIeiLY5NVKVW7cOD8n2/rpG0A8dQak8E4R2LPVTRx8gVt1gVlIb6kGIcU9gr3ABNaALpG+N1jc0LGhb1dCLdH/jcJLJZJgdWtST2sUvZzPqlAEeqczTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409772; c=relaxed/simple;
	bh=t58dezqz4gN5IwHByHWrAXrcxcmxkrdM49NVnbP9aiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JDuadvV8+dGwQARrSaAp8DVLVBHa5fGCv1aELDqYV86F68eZGPwgruSQ4i5fadTTAvbGeHYDogpzBK3+kF/ybioD2kDPclOBjD9A7YsyiU5kcgR/ca4HJrDvoUmqAULwWbP8yQ77DpQVSJw37ynIpKm27aq4xeNWH8yIDDxOP4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SiGtk6hI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SiGtk6hI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F45CC4CEF5;
	Sat, 25 Oct 2025 16:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409772;
	bh=t58dezqz4gN5IwHByHWrAXrcxcmxkrdM49NVnbP9aiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SiGtk6hI253r1zL9O/R84y3pmtBHE0cv0Yxgw7D5a6QalyWrKNPyGvJGu2lmo1xJZ
	 vIC8Qivda4rXLyUEgM/vnk58rXFQ95ioA+LA4qMRltWJ3sAbTQj+vOdxT7TYVCw//r
	 2/8xRJuw3gY6wgEzYsgQSqYDf++EVFhk4X+JFEwC/HoHrPyi0bsy6cCCD1jd0wBVAV
	 /ftAhDRo8q/du8516XWWu7SL/ijP50j/imBGTc9Mw6lK/FP1W0vwtWgMMUaxyLspxB
	 Ouf8BDT2JCUlBKcDItEwCx0veO1cDGtXRAi4Q3A24TUyZ1Be3Q2UtrX6zugnLclS4O
	 DlXw/mRxqcLcA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	paul.ely@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.15] scsi: lpfc: Remove ndlp kref decrement clause for F_Port_Ctrl in lpfc_cleanup
Date: Sat, 25 Oct 2025 12:01:30 -0400
Message-ID: <20251025160905.3857885-459-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit a4809b98eb004fcbf7c4d45eb5a624d1c682bb73 ]

In lpfc_cleanup, there is an extraneous nlp_put for NPIV ports on the
F_Port_Ctrl ndlp object.  In cases when an ABTS is issued, the
outstanding kref is needed for when a second XRI_ABORTED CQE is
received.  The final kref for the ndlp is designed to be decremented in
lpfc_sli4_els_xri_aborted instead.  Also, add a new log message to allow
for future diagnostics when debugging related issues.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Message-ID: <20250915180811.137530-5-justintee8345@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
**Why Backport**
- `lpfc_cleanup` no longer drops the last reference for NPIV fabric
  nodes up front, so those entries now flow through the normal discovery
  teardown path instead of triggering a premature `lpfc_nlp_put()`
  (drivers/scsi/lpfc/lpfc_init.c:3059-3076). The old short-circuit let
  the ndlp hit a zero kref while exchanges were still draining.
- During ABTS processing each aborted ELS exchange takes its own
  reference (`lpfc_nlp_get`) before parking on `lpfc_abts_els_sgl_list`;
  if the cleanup path has already removed the final reference, the
  second `XRI_ABORTED` CQE arrives with a dangling pointer, leading to
  crashes or RRQ cleanup failures
  (drivers/scsi/lpfc/lpfc_sli.c:1399-1407).
- The final release of those references is already centralized in
  `lpfc_sli4_els_xri_aborted`, so keeping the extra kref alive until the
  CQE arrives matches the intended life cycle; the new log line simply
  aids diagnosis (drivers/scsi/lpfc/lpfc_els.c:12020-12029). Any ndlp
  that never sees its CQE still gets dropped by
  `lpfc_sli4_vport_delete_els_xri_aborted` when the vport is torn down
  (drivers/scsi/lpfc/lpfc_els.c:11953-11979).

**Risk**
- Change is tightly scoped to the lpfc driver, removes an overzealous
  `kref_put`, and relies on existing cleanup paths; no API shifts or
  cross-subsystem dependencies. Impact of not backporting is a real NPIV
  crash/UAF when ABTS races with vport removal, so the bug fix outweighs
  the low regression risk.

 drivers/scsi/lpfc/lpfc_els.c  | 6 +++++-
 drivers/scsi/lpfc/lpfc_init.c | 7 -------
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 4c405bade4f34..3f703932b2f07 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -12013,7 +12013,11 @@ lpfc_sli4_els_xri_aborted(struct lpfc_hba *phba,
 			sglq_entry->state = SGL_FREED;
 			spin_unlock_irqrestore(&phba->sli4_hba.sgl_list_lock,
 					       iflag);
-
+			lpfc_printf_log(phba, KERN_INFO, LOG_ELS | LOG_SLI |
+					LOG_DISCOVERY | LOG_NODE,
+					"0732 ELS XRI ABORT on Node: ndlp=x%px "
+					"xri=x%x\n",
+					ndlp, xri);
 			if (ndlp) {
 				lpfc_set_rrq_active(phba, ndlp,
 					sglq_entry->sli4_lxritag,
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 4081d2a358eee..f7824266db5e8 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3057,13 +3057,6 @@ lpfc_cleanup(struct lpfc_vport *vport)
 		lpfc_vmid_vport_cleanup(vport);
 
 	list_for_each_entry_safe(ndlp, next_ndlp, &vport->fc_nodes, nlp_listp) {
-		if (vport->port_type != LPFC_PHYSICAL_PORT &&
-		    ndlp->nlp_DID == Fabric_DID) {
-			/* Just free up ndlp with Fabric_DID for vports */
-			lpfc_nlp_put(ndlp);
-			continue;
-		}
-
 		if (ndlp->nlp_DID == Fabric_Cntl_DID &&
 		    ndlp->nlp_state == NLP_STE_UNUSED_NODE) {
 			lpfc_nlp_put(ndlp);
-- 
2.51.0

