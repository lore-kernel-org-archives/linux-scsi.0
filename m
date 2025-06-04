Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7919224CC;
	Wed,  4 Jun 2025 00:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998422; cv=none; b=ZVdL8TaZuAmBAGxtA2tyR0VtrNI9m8kd/7aNKOreX4HU2E4PSoqJRNwbYYk0nT2B4W4+fNJ7vNqizvrs1exS6v+JJvKmgFqx43QcU3ZFtjTqATbsN3h9q0v/if6WqodZhqYVgp29iwGk4bffQj5HmQzjAVyxW9HwrajjvjZV0zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998422; c=relaxed/simple;
	bh=WpIZ8RQbkISoRhgS2e6jSC0jYP06scqEu1F9/yTILgY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=up8D+fxYtZuyCsXvF9hlTXlz712Ilbxu7GtG1uEsoBurfbc4CIQbmWRQxPy0dRAN0lhmBgp/DSIboBish8jyoC190xntt/2DbwLNK2e+krxhQ+chOk1r3IWgldH7HeOmwf93uGzcYERaVbrXvq/M7jtnPJp8uDRjsXtbpoAfHR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OW4tWHR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OW4tWHR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB0B3C4CEED;
	Wed,  4 Jun 2025 00:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998422;
	bh=WpIZ8RQbkISoRhgS2e6jSC0jYP06scqEu1F9/yTILgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OW4tWHR873yP3suehjFFcqJGRPFjkDyTMHU6N1KVk6xNdEEaQhXpqC5kM4npUly0m
	 RWjQy6C/06fnhwjENupLHQihNNil/oNtAzXMLgvanxf8QKWXIiKDy8pA60PZJBwH9W
	 Wev2J5J/Zz1DlQcmi7RaaWekM2Bj4q23hemW6+g1UM0/LHPN27/wKL9cWOh0yezYEd
	 N7IbQJHgT3mNcyh5bZmfSQih5dx5A2GvGw8Xsisoy9NF9YE/bCq4wnRaBGczF1JbUo
	 xhsit+7hfPnZi7ZTJHRj+UzZYN6L30O9DOioMm8yIjLEimhEJHe0IHxIjMhNbhUbsX
	 8xpKrU7J03pKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 073/118] scsi: lpfc: Fix lpfc_check_sli_ndlp() handling for GEN_REQUEST64 commands
Date: Tue,  3 Jun 2025 20:50:04 -0400
Message-Id: <20250604005049.4147522-73-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
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
index 179be6c5a43e0..b5273cb1adbdb 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5053,7 +5053,7 @@ lpfc_check_sli_ndlp(struct lpfc_hba *phba,
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

