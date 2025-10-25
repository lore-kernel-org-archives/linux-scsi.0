Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9F030FC13;
	Sat, 25 Oct 2025 16:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409674; cv=none; b=ireeVyXlmkntd9vi+6yVOBXjmB43IgSSxEpefuVICsJOU5DWjZ54XnALuTCPJpqLzAdQp32NftRtx8eN2g/8csqZJQkN1pOIy7yy8gk4ozYWVPQdFQacwMWTmB5KuKug7EZkuFFxtnE4KRHcLgj9lzMFpWWrkA1FX/+6ZbP2cHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409674; c=relaxed/simple;
	bh=T0mqn26u8+0AJ/VrFHWdPKGNP39N6gxdiXb71giJLww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pRpJj8fJ4bqFIwv8ojMCBW50SCcr9o0CVAgJUUtLGlGUC7WckCJZ8tqy+n9G7oRHQnficld+RfExpftzCZDtjzvRG+NZk4xaHWsvuU6+Y2d7cIL1/1LzHyTFSxQCeRDowV0n+FByL73J11W/9kQEzJus/+w3nwEnpH4Gp2cKY9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MzhfEXFt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MzhfEXFt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28E2C4CEF5;
	Sat, 25 Oct 2025 16:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409674;
	bh=T0mqn26u8+0AJ/VrFHWdPKGNP39N6gxdiXb71giJLww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MzhfEXFtwihlLKZDZ/U78sIQHLSxLzSXbIBl2qv6SBwbdrWUSW59aT6cVCkRlytqS
	 YZdgoXkMkadSRE2c9T8ZWxyCBE/2JTQ4EYzSLGYXcIHHJ1xVQmknpW1vLgbu/t6C5V
	 4w9XC05lfuea6OxkND9QmJMAYbMPG/x/Cs9TAtFWT2AvBXaajuoRezmjMYGEg1QYT9
	 PFZ24GivAnq6QFgpjz3numSgt5IlQLoWmdJcSW8p5xRkKPcALpuTqRR3yHhTTcAubZ
	 maW4SG8kug+i0y83SQJeLrfjUZTUmQAwJyWUxk3yK6ctt40dF/OjvLXdcqw356+EHx
	 0stgn/TGDoGiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Justin Tee <justin.tee@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>,
	paul.ely@broadcom.com,
	linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-6.12] scsi: lpfc: Decrement ndlp kref after FDISC retries exhausted
Date: Sat, 25 Oct 2025 12:00:47 -0400
Message-ID: <20251025160905.3857885-416-sashal@kernel.org>
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

[ Upstream commit b5bf6d681fce69cd1a57bfc0f1bdbbb348035117 ]

The kref for Fabric_DID ndlps is not decremented after repeated FDISC
failures and exhausting maximum allowed retries.  This can leave the
ndlp lingering unnecessarily.  Add a test and set bit operation for the
NLP_DROPPED flag. If not previously set, then a kref is decremented. The
ndlp is freed when the remaining reference for the completing ELS is
put.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Message-ID: <20250915180811.137530-6-justintee8345@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES
- In the failure branch of `lpfc_cmpl_els_fdisc()` the driver used to
  log the exhausted retry and drop straight to `fdisc_failed`, leaving
  the fabric `ndlp`’s initial kref outstanding; only the completion-held
  reference is released later at `out:`
  (`drivers/scsi/lpfc/lpfc_els.c:11252-11271`).
- The new `test_and_set_bit(NLP_DROPPED, …)` + `lpfc_nlp_put(ndlp)`
  sequence (`drivers/scsi/lpfc/lpfc_els.c:11267-11269`) mirrors the
  established pattern for retiring nodes safely once that initial
  reference is no longer needed
  (`drivers/scsi/lpfc/lpfc_hbadisc.c:4949-4954`, with the meaning of
  `NLP_DROPPED` defined in `drivers/scsi/lpfc/lpfc_disc.h:197`).
- Without this drop, every fabric FDISC failure that exhausts retries
  leaks the `ndlp`, keeping discovery objects and their resources
  pinned; that is a real bug that can accumulate across repeated fabric
  login failures.
- The fix is small, localized to the terminal failure path, and guarded
  by the bit test so it cannot double-drop an already-released node,
  which keeps regression risk low.
- The affected logic exists unchanged in stable kernels, so backporting
  would directly eliminate the leak there without pulling in broader
  dependencies.

 drivers/scsi/lpfc/lpfc_els.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index fca81e0c7c2e1..4c405bade4f34 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -11259,6 +11259,11 @@ lpfc_cmpl_els_fdisc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_vlog_msg(vport, KERN_WARNING, LOG_ELS,
 			      "0126 FDISC cmpl status: x%x/x%x)\n",
 			      ulp_status, ulp_word4);
+
+		/* drop initial reference */
+		if (!test_and_set_bit(NLP_DROPPED, &ndlp->nlp_flag))
+			lpfc_nlp_put(ndlp);
+
 		goto fdisc_failed;
 	}
 
-- 
2.51.0

