Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF43E178205;
	Fri, 29 Mar 2024 12:40:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711716020; cv=none; b=KBwc+CI3uQ/jx6L4cCsgFU4JMUTQzRiexAUq9n33h/ET6xOl3ZkH1uMuFbEEW0Y1h9S7yFl6JFg7KMvuhWGGEOBjZcKwQ5tJxZw0RWsGFJbXf1seUapMyCBkyjbopqcz5Vi6iwq5A45fbMtVFyhbvJtAgvjt3G69bxebntQ12Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711716020; c=relaxed/simple;
	bh=24mpTUxu3EPleptzaMEqL9rwWlByY7e/6uMWdLp/ep4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rF4RJpfSnkz9HxrPlli+utfG5VQ9gOCOpnYvMNNj2xImzUbgxLN1KoCAwIEMUe1oEYhvRCrY7SsRXE1wl9KlbEjrQi57TP53b3zsdZ5sqsETKK8qYq8u//02hl0CR8zET8gksCvB++xM2SpvWh/PM8o8oTghpRHJaVRY6jsPgvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RC1guOuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RC1guOuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48036C43390;
	Fri, 29 Mar 2024 12:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711716020;
	bh=24mpTUxu3EPleptzaMEqL9rwWlByY7e/6uMWdLp/ep4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RC1guOuCeO2FNHVMCIXPErpU2xuxwrpIm2xBaaPmdsNUczjYQvRY4tL7Nz7P5I0ls
	 EsWG9JljX5O7Wo/l0ob7HzsfSteHUzbMsZNzqMWuKO3K1oX2YuyM8gLosB/UhyM4ds
	 1/qYoogQuzCAQCtQI+/jsgOg61aTS6b96fvj0UP+Up1jAbTOHqfeV7IM8Nxs4gMNkt
	 1AeBKDWK5KGqcX2yD5msnJnaS6hrfzeb5w9DYHdvmK0ZnqMqkDmX+buqj/9FhRGZlS
	 1lgI3vAPy4XQaHXjFOWQ3I4AmheUyv3bNK1kP9/97ob8Y3/CESCkm2YZRG8MKL0bRq
	 gD16fKOgK5vRg==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	james.smart@broadcom.com,
	dick.kennedy@broadcom.com,
	jejb@linux.ibm.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.8 18/98] scsi: lpfc: Fix possible memory leak in lpfc_rcv_padisc()
Date: Fri, 29 Mar 2024 08:36:49 -0400
Message-ID: <20240329123919.3087149-18-sashal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240329123919.3087149-1-sashal@kernel.org>
References: <20240329123919.3087149-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.8.2
Content-Transfer-Encoding: 8bit

From: Justin Tee <justin.tee@broadcom.com>

[ Upstream commit 2ae917d4bcab80ab304b774d492e2fcd6c52c06b ]

The call to lpfc_sli4_resume_rpi() in lpfc_rcv_padisc() may return an
unsuccessful status.  In such cases, the elsiocb is not issued, the
completion is not called, and thus the elsiocb resource is leaked.

Check return value after calling lpfc_sli4_resume_rpi() and conditionally
release the elsiocb resource.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Link: https://lore.kernel.org/r/20240131185112.149731-3-justintee8345@gmail.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index d9074929fbab8..b147304b01fa1 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -748,8 +748,10 @@ lpfc_rcv_padisc(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 				/* Save the ELS cmd */
 				elsiocb->drvrTimeout = cmd;
 
-				lpfc_sli4_resume_rpi(ndlp,
-					lpfc_mbx_cmpl_resume_rpi, elsiocb);
+				if (lpfc_sli4_resume_rpi(ndlp,
+						lpfc_mbx_cmpl_resume_rpi,
+						elsiocb))
+					kfree(elsiocb);
 				goto out;
 			}
 		}
-- 
2.43.0

