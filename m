Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3653120B7B5;
	Fri,  4 Oct 2024 18:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066400; cv=none; b=Ey1f17mu9TO10B+CjB7UQ1T/3+KdVHVdudHgfY99XpqywsAwl21UauynmyhZ2m/NWDBWf3+X8bz0/8jgLjofXEZvbaHo+hjo4sN5fUNmiM3YD+/kG2ZsKTBcD99inoQEjyLeu6jHRZC2hHaiNRp3iMU1nIYfwmOntJ1l+4XV2cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066400; c=relaxed/simple;
	bh=ia6VpCnu+/+PQosCJ7ANY2FEmMQox2nbSJXCBtYqnHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apMkT2DAB2YfoPSXp3cHMWf40Fv78QTyoHNyQQ/U+03iwNtq3yDw8Okuv1TeiidV3Uv2s+xzOCxzVSt999pcnV25rAmoKp7Jk88dSRfEhjaUc8YzA6GJeOz5pZbXQGfmCv5x8WqSdOqK9lXn55nOg2L01maH3ky9vkqA1vm03l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ma5y5sVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ma5y5sVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BEFAC4CECE;
	Fri,  4 Oct 2024 18:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066400;
	bh=ia6VpCnu+/+PQosCJ7ANY2FEmMQox2nbSJXCBtYqnHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ma5y5sVFfh/od/D1GFGInxXXdY973L7f9Zy86RA4ZeilVhh5e+0glIA90FM8Frmr8
	 SGAd84KAXd1pEMluuAvMVyYRsEiCdRX8pcpGMFT9g9dbghG12XdxfhJO8uE+genPCR
	 d5VL9TDNus1BW20AjjFNEvgmkm8GMuaC9toksMZqlAGLbPb4AbEmwJdw/smdSSwxLQ
	 vREfrFuQe+HIx+JWr6tfsez8zXn6cA2ERFB4yGqC1e6bV+0dmx0lNoyT/YNr3x2kbt
	 M3ntuYFXAHCdir5m5KBRlxc6g1Ib8YXZU6AeMbegIjiQrvpTtAP6SP0MNQfDziYncc
	 UwOzOiY/KSkqg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 53/58] scsi: lpfc: Add ELS_RSP cmd to the list of WQEs to flush in lpfc_els_flush_cmd()
Date: Fri,  4 Oct 2024 14:24:26 -0400
Message-ID: <20241004182503.3672477-53-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004182503.3672477-1-sashal@kernel.org>
References: <20241004182503.3672477-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.54
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 93bcc5f3984bf4f51da1529700aec351872dbfff ]

During HBA stress testing, a spam of received PLOGIs exposes a resource
recovery bug causing leakage of lpfc_sqlq entries from the global
phba->sli4_hba.lpfc_els_sgl_list.

The issue is in lpfc_els_flush_cmd(), where the driver attempts to recover
outstanding ELS sgls when walking the txcmplq.  Only CMD_ELS_REQUEST64_CRs
and CMD_GEN_REQUEST64_CRs are added to the abort and cancel lists.  A check
for CMD_XMIT_ELS_RSP64_WQE is missing in order to recover LS_ACC usages of
the phba->sli4_hba.lpfc_els_sgl_list too.

Fix by adding CMD_XMIT_ELS_RSP64_WQE as part of the txcmplq walk when
adding WQEs to the abort and cancel list in lpfc_els_flush_cmd().  Also,
update naming convention from CRs to WQEs.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240912232447.45607-2-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_els.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 44d3ada9fbbcb..739508e0a45f3 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9644,11 +9644,12 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
 		if (piocb->cmd_flag & LPFC_DRIVER_ABORTED && !mbx_tmo_err)
 			continue;
 
-		/* On the ELS ring we can have ELS_REQUESTs or
-		 * GEN_REQUESTs waiting for a response.
+		/* On the ELS ring we can have ELS_REQUESTs, ELS_RSPs,
+		 * or GEN_REQUESTs waiting for a CQE response.
 		 */
 		ulp_command = get_job_cmnd(phba, piocb);
-		if (ulp_command == CMD_ELS_REQUEST64_CR) {
+		if (ulp_command == CMD_ELS_REQUEST64_WQE ||
+		    ulp_command == CMD_XMIT_ELS_RSP64_WQE) {
 			list_add_tail(&piocb->dlist, &abort_list);
 
 			/* If the link is down when flushing ELS commands
-- 
2.43.0

