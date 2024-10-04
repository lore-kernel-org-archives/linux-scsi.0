Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E351E9DEE;
	Fri,  4 Oct 2024 18:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066038; cv=none; b=o/m7NuHYbtd9i1z5qy4m/Inf0AZZsW6nWNt8PnuqDOLJ5J1DuFefi/6oa6dy90CV1mJRqaouDdspnhLlQqa4c5mpSIIAqZMCCBlyy9kTWaSQk9jXYS0QIrDvWa92ZlWu3n3cW121fBu7ysIA5Zh2Oy6rfXa4CYfW5XQr+NiZ4Kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066038; c=relaxed/simple;
	bh=71tXeMLHpsGE6ROS/v+Ilu9Z2YiZCqenHptpyEmS+lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdVHfkPDCvKEKZFpnD6Ep+xiHP3x/RrsMms8M5lI4e9+FdAkrnvF13mVhenSGsXgjYpQmgsWRl9bgikbSBEZv1j3C6Ko7H7JQTNOC9eXz+UxZAFX4GETbzrWDwCUwl3MEVGf0egRxT1tp7qLTS83+q+hDm5bRzvqLRThPzuhxqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LAxql1e4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LAxql1e4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020C4C4CECD;
	Fri,  4 Oct 2024 18:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066038;
	bh=71tXeMLHpsGE6ROS/v+Ilu9Z2YiZCqenHptpyEmS+lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LAxql1e4fQufeXtoRKYHjBB8y5fEiPn2pG44paZwb0QGcWLcyiZxWFxxgZi6TTj2r
	 yTSgF9f2rrXR6ctxgvNhpnI/qNhXjK+mPq0IuPa+c5zSIKVCAedLvOQhVnZpuSr8zP
	 snY/+PZChY/YTb3s6NqSdccXW+XYfk8k/DxsqS+yGYpO7ba97cbcFjN9OO6cV9HUXG
	 tMCt4jbURehF6uPn2LCeXpZPCyrnqdKvB/3GEMqiq+Mr7rloe0Ezyw9voXKYWvU0YD
	 SStfxjs6c4VhUBHpCfbjrE2qrgOqwWF3h9cKEeD3FpMQUK/FtXkohL5LKrz3PzlkCt
	 4RYJDhzbuQ58w==
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
Subject: [PATCH AUTOSEL 6.11 68/76] scsi: lpfc: Add ELS_RSP cmd to the list of WQEs to flush in lpfc_els_flush_cmd()
Date: Fri,  4 Oct 2024 14:17:25 -0400
Message-ID: <20241004181828.3669209-68-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004181828.3669209-1-sashal@kernel.org>
References: <20241004181828.3669209-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.2
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
index 929cbfc95163b..c06234ff8064b 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9641,11 +9641,12 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
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

