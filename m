Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88197217D2A;
	Fri,  4 Oct 2024 18:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728066507; cv=none; b=eGEfcHdwP9DRZkdCKoNAvL1iZd/Ly9gmsCuBybvjuhzEEjMEGDQNSoCMlvQXbHjTc8vmZtfVVNsZXWQuknr7O2yi2cAu9EoI+4QDZxbyV6KmwVkllpuUjLsNzjdJsNydqOG7w+4ggqBl7JZIs2dPl4NpROhYzfO8mwKrYpWe+E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728066507; c=relaxed/simple;
	bh=qyOfzkGfQgV8Icp4eZdCffZ5rqJqLdy+aRN6/0efj8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KvrjVFKR52K7mZGv8YbnzVMh80I0+Optx7T8m6bjSXfib9T3ezm4foTLKBEY3Q1b7hSl6ILyKcazAKk0tM+EbJSZIUnU9HAEg0Ft08RMYvHmEO/KpkXEycE7uSXbmRVW7/+x2Sa2qnD8xLwQf9iB8UNkkS/ZkJysPYavo3u3ChQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qUmqR+yC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qUmqR+yC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6ABC4CEC6;
	Fri,  4 Oct 2024 18:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728066507;
	bh=qyOfzkGfQgV8Icp4eZdCffZ5rqJqLdy+aRN6/0efj8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qUmqR+yCi+Z4AF3cfFAFHddbMn6dc5esE16xfKikmKYc2KKN87CAMR3RrVMSMAYOl
	 PLoqZ/nXpPep9fS8FnynvqfCIXJh/4jgstzlbX+ykRCuC4U+kUWq/JSTiri7kViuDo
	 AlA2LrEKxnDdzAc3ywb+4wGmDSwannH+gSCjB7GEJ58d5s62yd7W47HSVQVs2JhAt0
	 9GVoICxMwHafmpsg8cARRIkisDS4MTRNptSJH3hzAdGBqXzK75PPszP7ZFycX+2d5P
	 r4JbI9Hiux80bON7zrSkqnlpUqeytkcYZb0TfED3G/oZLWyWUru5ZIHJ5vvtK/iz4L
	 CR3fK7Pxr09BA==
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
Subject: [PATCH AUTOSEL 6.1 38/42] scsi: lpfc: Add ELS_RSP cmd to the list of WQEs to flush in lpfc_els_flush_cmd()
Date: Fri,  4 Oct 2024 14:26:49 -0400
Message-ID: <20241004182718.3673735-38-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241004182718.3673735-1-sashal@kernel.org>
References: <20241004182718.3673735-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.112
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
index 05764008f6e70..0b1a81ac24765 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -9450,11 +9450,12 @@ lpfc_els_flush_cmd(struct lpfc_vport *vport)
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

