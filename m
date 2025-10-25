Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA25A3064A4;
	Sat, 25 Oct 2025 16:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408854; cv=none; b=QdxipdBfs4MBJOSrutX7HzeM8QpvWfLH1931Jdl4v9eLTscnnh9JvFpBIdJp+pV/7W/eqYlvvpmmu966nSOH2fI3119pbicLwiYBpL+nbv1Rqy4p8Uict91+4XKN7/+2JledAOW/37JThvo6jBRjbS1Dfh8PWEvxekuzCkm+i7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408854; c=relaxed/simple;
	bh=KI6+OsymNLyRak3/YPRgd2J+zh87z+gfsf2MC6/X6t8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mcCv5/02SWOV2dJHm/OL4YWJy+8UWxYG8/NvXO0PTfs54JWvoc7CkSQHu+uNBC6Rt93e5lr4RbHiCfeA+XDbU4UKkQ+X4JOnjHUWl4PIkOsX+Baf6SrvnePw2hHjMSzi6PTyTcwY8NqX/qhZmk/vuQhxZnv71ISqhGnKNY+uOME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i04IP3Hd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i04IP3Hd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B63BDC4CEFB;
	Sat, 25 Oct 2025 16:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408854;
	bh=KI6+OsymNLyRak3/YPRgd2J+zh87z+gfsf2MC6/X6t8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i04IP3HdTbN02UF79PsjWsLP0IRhHmasp78Ov2yFybtduRbtUpYIzMCngvzMFKEwv
	 Zj6vUexx8GOd6VsrR6BfuOss2wKk7dUgceD3X9kMvwRuO/v9C9QmUeUtMqkxkirNg5
	 HVvOrGltmibOUgvciK4n/DPHp1PSJpztXGpYpYNNgE4H4YDI5bNA1iWoct8MdwakT7
	 LM9uJmGg4rRljEk+KnAd6b5sMq9R0rEdpFguqJL30AGABhvqc0GpYoFPUl842sJfEG
	 ZCYtOBjPGa1q70p3BgARvR+BpQpbZMAGmbXSnmk5GEpq+tPHeATNH1ERZcNPZPfKhU
	 GBoDyUyDE5iNA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	paul.ely@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] scsi: lpfc: Check return status of lpfc_reset_flush_io_context during TGT_RESET
Date: Sat, 25 Oct 2025 11:55:32 -0400
Message-ID: <20251025160905.3857885-101-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit f408dde2468b3957e92b25e7438f74c8e9fb9e73 ]

If lpfc_reset_flush_io_context fails to execute, then the wrong return
status code may be passed back to upper layers when issuing a target
reset TMF command.  Fix by checking the return status from
lpfc_reset_flush_io_context() first in order to properly return FAILED
or FAST_IO_FAIL.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Message-ID: <20250915180811.137530-7-justintee8345@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES - returning FAIL/Fast-IO correctly from target reset avoids trapping
lpfc in a half-reset state.

- drivers/scsi/lpfc/lpfc_scsi.c:6112-6119 now propagates the status from
  lpfc_reset_flush_io_context(), so a flush failure surfaces as FAILED
  instead of always falling through to FAST_IO_FAIL; previously
  FAST_IO_FAIL was reported even when cnt != 0, leaving orphaned
  contexts behind.
- In the SCSI EH core, FAST_IO_FAIL is treated as a completed reset
  (drivers/scsi/scsi_error.c:1680-1694), so the old code caused the
  error handler to stop escalation while the adapter still had
  outstanding I/O—users would see hung commands after a target reset
  TMF.
- A FAILED return triggers the midlayer to keep escalating (bus/host
  reset), which is the only safe recovery once
  lpfc_reset_flush_io_context() reports 0x2003 (see its failure path at
  drivers/scsi/lpfc/lpfc_scsi.c:5969-5975); the fix therefore prevents
  long-lived I/O leaks and recovery deadlocks.
- Remaining changes are cosmetic (typo fix at
  drivers/scsi/lpfc/lpfc_scsi.c:5938 and cleaned log text at
  drivers/scsi/lpfc/lpfc_scsi.c:6210) and pose no regression risk.
- Patch is small, self-contained in lpfc, and has no dependencies—ideal
  for stable backporting.

 drivers/scsi/lpfc/lpfc_scsi.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 508ceeecf2d95..6d9d8c196936a 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5935,7 +5935,7 @@ lpfc_chk_tgt_mapped(struct lpfc_vport *vport, struct fc_rport *rport)
 /**
  * lpfc_reset_flush_io_context -
  * @vport: The virtual port (scsi_host) for the flush context
- * @tgt_id: If aborting by Target contect - specifies the target id
+ * @tgt_id: If aborting by Target context - specifies the target id
  * @lun_id: If aborting by Lun context - specifies the lun id
  * @context: specifies the context level to flush at.
  *
@@ -6109,8 +6109,14 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 			pnode->nlp_fcp_info &= ~NLP_FCP_2_DEVICE;
 			spin_unlock_irqrestore(&pnode->lock, flags);
 		}
-		lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
-					  LPFC_CTX_TGT);
+		status = lpfc_reset_flush_io_context(vport, tgt_id, lun_id,
+						     LPFC_CTX_TGT);
+		if (status != SUCCESS) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
+					 "0726 Target Reset flush status x%x\n",
+					 status);
+			return status;
+		}
 		return FAST_IO_FAIL;
 	}
 
@@ -6202,7 +6208,7 @@ lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
 	int rc, ret = SUCCESS;
 
 	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
-			 "3172 SCSI layer issued Host Reset Data:\n");
+			 "3172 SCSI layer issued Host Reset\n");
 
 	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
 	lpfc_offline(phba);
-- 
2.51.0

