Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FC8204A1E;
	Wed,  4 Dec 2024 17:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331622; cv=none; b=R5WJbEVjmuKHZGFkQ6Gl3rUSMsFApz0sqhmMt4Bw8wR+X32nCEPpa+lI13hleEX4S45H3RDa4AhNoJHOCXzv+KS84Y7ebjX+32Idw8l7/Mfl1V2MIVfUoOllryM+P0A5os6x4DzeVSqs4ooeo2WnsAE2kqJN8/1iRRhlP3pBnUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331622; c=relaxed/simple;
	bh=q7IXKpaI1TkzlYWOkjYJObT8QGqZyZO0o9GpeFqExvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kvSLasSKJ8H9YVGg/hVMxkj6Td6iTyhVtkOA6S55TkyADNjsLAr3E7eeE3biOVWuhieCgMvV13ntSPYLppP/W2PV/aeex5o5KBfy//6bVSvotJrm2GSVU2j/zmFLbF34pfpl5je7U/dLHEuZjJqsDmk7RKzjR7yEecroT/AUWZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L4dujHU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L4dujHU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03616C4CECD;
	Wed,  4 Dec 2024 17:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733331622;
	bh=q7IXKpaI1TkzlYWOkjYJObT8QGqZyZO0o9GpeFqExvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L4dujHU1dHzy4TU+JQWlPSHnat2j/jsO0oaa4/wic9SMttBTp/dQ2wDMx6Ecoycya
	 KkHpqmq+KLhWWLPLYL5PrDvwb/TNSUCiiTqSWu1knq8/5PqlV1x9r58PekhBtCJmFn
	 ArHmSZJ4pFtn1MOunUflXPKz5g0z292bsc6bUYEhztqAQpt2Hk6WDJvtHVV0aSHzIw
	 0r1pK3FiPmeR771xhPl7vrSX7BVN+P6d3oK1+X2Ksyk9qgx10uRTSW8Q7Tkgkwg90Y
	 Qfk2SLeq9/X1VOTQWbv51ZeZAMA+prXA8vcW03DjboqBDTeJivbASwFX9Osni4dzsx
	 KU4lopEjBFeAQ==
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
Subject: [PATCH AUTOSEL 6.11 17/33] scsi: lpfc: Check SLI_ACTIVE flag in FDMI cmpl before submitting follow up FDMI
Date: Wed,  4 Dec 2024 10:47:30 -0500
Message-ID: <20241204154817.2212455-17-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241204154817.2212455-1-sashal@kernel.org>
References: <20241204154817.2212455-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.11.10
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 98f8d3588097e321be70f83b844fa67d4828fe5c ]

The lpfc_cmpl_ct_disc_fdmi() routine has incorrect logic that treats an
FDMI completion with error LOCAL_REJECT/SLI_ABORTED as a success status.
Under the erroneous assumption of successful completion, the routine
proceeds to issue follow up FDMI commands, which may never complete if
the HBA is in an errata state as indicated by the errored completion
status.  Fix by freeing FDMI cmd resources and early return when the
LPFC_SLI_ACTIVE flag is not set and a LOCAL_REJECT/SLI_ABORTED or
SLI_DOWN status is received.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20241031223219.152342-6-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_ct.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 134bc96dd1340..ce3a1f42713dd 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2226,6 +2226,11 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		ulp_status, ulp_word4, latt);
 
 	if (latt || ulp_status) {
+		lpfc_printf_vlog(vport, KERN_WARNING, LOG_DISCOVERY,
+				 "0229 FDMI cmd %04x failed, latt = %d "
+				 "ulp_status: (x%x/x%x), sli_flag x%x\n",
+				 be16_to_cpu(fdmi_cmd), latt, ulp_status,
+				 ulp_word4, phba->sli.sli_flag);
 
 		/* Look for a retryable error */
 		if (ulp_status == IOSTAT_LOCAL_REJECT) {
@@ -2234,8 +2239,16 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			case IOERR_SLI_DOWN:
 				/* Driver aborted this IO.  No retry as error
 				 * is likely Offline->Online or some adapter
-				 * error.  Recovery will try again.
+				 * error.  Recovery will try again, but if port
+				 * is not active there's no point to continue
+				 * issuing follow up FDMI commands.
 				 */
+				if (!(phba->sli.sli_flag & LPFC_SLI_ACTIVE)) {
+					free_ndlp = cmdiocb->ndlp;
+					lpfc_ct_free_iocb(phba, cmdiocb);
+					lpfc_nlp_put(free_ndlp);
+					return;
+				}
 				break;
 			case IOERR_ABORT_IN_PROGRESS:
 			case IOERR_SEQUENCE_TIMEOUT:
@@ -2256,12 +2269,6 @@ lpfc_cmpl_ct_disc_fdmi(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				break;
 			}
 		}
-
-		lpfc_printf_vlog(vport, KERN_INFO, LOG_DISCOVERY,
-				 "0229 FDMI cmd %04x latt = %d "
-				 "ulp_status: x%x, rid x%x\n",
-				 be16_to_cpu(fdmi_cmd), latt, ulp_status,
-				 ulp_word4);
 	}
 
 	free_ndlp = cmdiocb->ndlp;
-- 
2.43.0

