Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350A020CCCC;
	Wed,  4 Jun 2025 01:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998999; cv=none; b=KNxYdH/UZPToTG2taHwCDwWvonWN6kPnwj15Gh76xN7evyx/6i+4ab3G/1mvy91flVWOmJFtS5D/lgk3miVOJyDGbiTmK6PzU3FbUMjYURF/je5hoChWcV4UxeVb17PQwJacxyaW9uTwsEpq/QZd1rIGZqP6gkXEFU5XMutTKzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998999; c=relaxed/simple;
	bh=A376Bn8WO8WsxFncenPUTeZj1biacg8HuQ8qBqV+Rg4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sp7s8MxbuPy0tt3gulFu1OM6zRHFaPWglR8la5nRQ4T3gmEPl4GnWMTryEHxfEGvH1OuRJpiaQcCN076/kBrf9BgyvgGEcfE33ksoDRLa02SyJHLjQ5MpgJvjPdR6JRHngfO7C5PEPQlBD6e9qeDiUDzxCHMBfha5fCoQoozPoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UXEVUfJs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UXEVUfJs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B96C4CEEF;
	Wed,  4 Jun 2025 01:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998999;
	bh=A376Bn8WO8WsxFncenPUTeZj1biacg8HuQ8qBqV+Rg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXEVUfJs+y+QAO2c2b+lc2BuG9fvwG6h6B7k9h1eT85YAWtH6pqLPwy7KVSSpfo0h
	 ElTTSeL3q7HknlKJmphPb74QBaaGrUiRuIMw1DxmBXiE81safHcDHUlFem/1rxfuRG
	 35KtktoGFhISs4iwnA5J3YikVtvhDiMw+NcHHD2Qgws8kn//Sud9f0MPorh32AGKGu
	 oZmBBWpR6EaQ+0MmbYWskVcItlHFYiVfwebiDDg1vj38ouv2BVvKU/7jobk8QEQHbS
	 g91iNaUJleQFYBN/AlpyKd3KU1ugfJbbct2R3J46ut01Pifc9Qn54GdAeOOs0QUnnv
	 yMLejpJlA7/hg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.6 37/62] scsi: lpfc: Fix lpfc_check_sli_ndlp() handling for GEN_REQUEST64 commands
Date: Tue,  3 Jun 2025 21:01:48 -0400
Message-Id: <20250604010213.3462-37-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010213.3462-1-sashal@kernel.org>
References: <20250604010213.3462-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.92
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 05ae6c9c7315d844fbc15afe393f5ba5e5771126 ]

In lpfc_check_sli_ndlp(), the get_job_els_rsp64_did remote_id assignment
does not apply for GEN_REQUEST64 commands as it only has meaning for a
ELS_REQUEST64 command.  So, if (iocb->ndlp == ndlp) is false, we could
erroneously return the wrong value.  Fix by replacing the fallthrough
statement with a break statement before the remote_id check.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20250425194806.3585-2-justintee8345@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my detailed analysis: **Reasons for Backporting:** 1. **Fixes a Clear
Bug**: The commit addresses a specific logic error where
`CMD_GEN_REQUEST64_CR` commands incorrectly fall through to use
`get_job_els_rsp64_did()`, which is designed for ELS requests and may
return meaningless data for generic requests. 2. **Small and Contained
Change**: The fix is minimal (changing `fallthrough;` to `break;`) and
affects only the `lpfc_check_sli_ndlp()` function in
`drivers/scsi/lpfc/lpfc_hbadisc.c:5056`. 3. **Low Regression Risk**: The
change makes the code logic more precise by ensuring each command type
uses its appropriate validation method. This reduces the chance of false
matches rather than introducing new behavior. 4. **Affects Critical
Functionality**: The `lpfc_check_sli_ndlp()` function is used to match
IOCBs to node lists, which is fundamental for proper SCSI I/O handling
and could affect data integrity if nodes are incorrectly matched. 5.
**Similar to Accepted Backports**: This fix follows the same pattern as
Similar Commit #2 (Status: YES), which fixed missing validation in lpfc
node handling code. **Evidence from Code Analysis:** -
`get_job_els_rsp64_did()` extracts destination ID from ELS request
structures (`iocbq->wqe.els_req.wqe_dest` or
`iocbq->iocb.un.elsreq64.remoteID`) - For `CMD_GEN_REQUEST64_CR`
commands, these ELS-specific fields may contain unrelated data - The
incorrect fallthrough could cause `lpfc_check_sli_ndlp()` to return 1
(match) when it should return 0 (no match), potentially leading to I/O
being associated with wrong nodes **Stability Criteria Met:** - ✅
Important bug fix affecting I/O path - ✅ No new features introduced - ✅
No architectural changes - ✅ Minimal regression risk - ✅ Confined to
lpfc driver subsystem This is exactly the type of targeted bug fix that
stable trees are designed to include.

 drivers/scsi/lpfc/lpfc_hbadisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 0ad8a10002ce3..2179b26271665 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5101,7 +5101,7 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
 		case CMD_GEN_REQUEST64_CR:
 			if (iocb->ndlp == ndlp)
 				return 1;
-			fallthrough;
+			break;
 		case CMD_ELS_REQUEST64_CR:
 			if (remote_id == ndlp->nlp_DID)
 				return 1;
-- 
2.39.5

