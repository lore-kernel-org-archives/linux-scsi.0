Received: from sender-of-o57.zoho.eu (sender-of-o57.zoho.eu [136.143.169.57])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CD634D2EC5;
	Thu,  6 Aug 2026 19:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.169.57
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786044263; cv=pass; b=URZpu10YRe6Wrwz9OV44FR3W3BNeyDy8EmWQf1zGFSZejxosMkDL+Q0vVTUPE75eqjwTZK/3XLs4zwAKhHznhURY/V3V35/51m+Azk6CWaSP59xfKBq+X4HNQHzm2i11yFD36c571z4UU4mbdQiHH2e1F5cZGUQahab2Z3EjVsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786044263; c=relaxed/simple;
	bh=wnKu+FgPijdgZ7wQCNpgJJnUvujcvv4NLraMqraCZiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcp5YcSHX3BwDY6yAjoI8e/wv8w6IFTz2oNR+ETie7nYH1UJ+2Y13rZpGhH77soRmoB/RK5Bt/dHjZddx4J2CN5iehdXsZ13QVOQu+CBLXlX14mYOAQP1v8bWPfxZ2U0LYU+BCSxrRNUrpo/YQ0kTQ0hsWLVCHg/LCahiJUcn78=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com; spf=pass smtp.mailfrom=iusegentoo.com; dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b=ocA97hgn; arc=pass smtp.client-ip=136.143.169.57
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iusegentoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iusegentoo.com header.i=ali@iusegentoo.com header.b="ocA97hgn"
ARC-Seal: i=1; a=rsa-sha256; t=1786044241; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=I1ygPnSwPjf706+snJYWNnWCLcNtTGWPvA1fvRwEUAfLxR1Zdg5LDfqw1YvSl0lMK5e3g5m3h+Bnz+PCce8dsfSU64M/K/nmBOoc+xeYeCvHbgbL2z7SqZQ2DmMOY7NuYyXvuOQscMdRDnZCXTCGYf1vdD6almSvYY8rChS+g40=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1786044241; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=rIxsQTrJGRlSuvbcERHIP5fAC7xK052RKLG0Z9nVQa0=; 
	b=L24zViv5qiLzgGFXNGsn5g0uER9rWxSLo/JvblUAQ9okxX0YxX4PuWLVO5Y9Sjx5j85bLUmy9GH83X5NkTaKkIaarFpAsizKZik2CDesmWjYmwfwujIoi0DGDxj7JtF9DYdZYLtm+/RChbf1e0yChsRvGxP0E9alIs6LA54xJd4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=iusegentoo.com;
	spf=pass  smtp.mailfrom=ali@iusegentoo.com;
	dmarc=pass header.from=<ali@iusegentoo.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1786044241;
	s=zmail; d=iusegentoo.com; i=ali@iusegentoo.com;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=rIxsQTrJGRlSuvbcERHIP5fAC7xK052RKLG0Z9nVQa0=;
	b=ocA97hgnw3+wfEr/B2gx4RIf3GE8UPvHIOnkgCoey6GW7rg07+3yed3uwRPAxSly
	TeIyzzkxX2bZ+0AfaJSxsGJAONJaQuCa96PaVivWDkFl96nosVZW2d84+c5659G3/Jx
	3IKi1minUkuD1zbMaSpMa7JyaXUiGVVP3SZXou1k=
Received: by mx.zoho.eu with SMTPS id 1786044240160677.4841809777805;
	Thu, 6 Aug 2026 21:24:00 +0200 (CEST)
From: Ali Ahmet Memis <ali@iusegentoo.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	Ram Vegesna <ram.vegesna@broadcom.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] scsi: elx: efct: free the HIO when the WQE cannot be built
Date: Thu,  6 Aug 2026 19:23:42 +0000
Message-ID: <20260806192345.328621-3-ali@iusegentoo.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260806192345.328621-1-ali@iusegentoo.com>
References: <20260806192345.328621-1-ali@iusegentoo.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

efct_els_hw_srrs_send() and efct_hw_bls_send() allocate an HIO, ask sli4
to build a WQE into it, and give up when that fails without putting the
HIO back:

	if (sli_els_request64_wqe(&hw->sli, hio->wqe.wqebuf, hio->sgl,
				  &els_params)) {
		efc_log_err(hw->os, "REQ WQE error\n");
		rc = -EIO;
	}

Nothing has been submitted at that point, so no completion will arrive to
release it, and the entry sits on hw->io_inuse until the adapter is torn
down. Each failure costs the pool one entry, and once it is empty
efct_hw_io_alloc() fails and no further ELS, CT or BLS frame can be sent.

Release the HIO on those paths. The efct_hw_wq_write() failure below is
deliberately left alone: it can return an error while this request is
still queued on wq->pending_list, so the HIO cannot be handed back there
without more care.

Fixes: dd53d333aadb ("scsi: elx: efct: Hardware I/O submission routines")
Signed-off-by: Ali Ahmet Memis <ali@iusegentoo.com>
---
 drivers/scsi/elx/efct/efct_hw.c | 38 ++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/elx/efct/efct_hw.c b/drivers/scsi/elx/efct/efct_hw.c
index 15c37ff1d52e..6cc48fa3e656 100644
--- a/drivers/scsi/elx/efct/efct_hw.c
+++ b/drivers/scsi/elx/efct/efct_hw.c
@@ -2609,6 +2609,7 @@ efct_hw_bls_send(struct efct *efct, u32 type, struct sli_bls_params *bls_params,
 	if (sli_xmit_bls_rsp64_wqe(&hw->sli, hio->wqe.wqebuf,
 				   &bls, bls_params)) {
 		efc_log_err(hw->os, "XMIT_BLS_RSP64 WQE error\n");
+		efct_hw_io_free(hw, hio);
 		return -EIO;
 	}
 
@@ -2820,24 +2821,27 @@ efct_els_hw_srrs_send(struct efc *efc, struct efc_disc_io *io)
 		rc = -EIO;
 	}
 
-	if (rc == 0) {
-		hio->xbusy = true;
+	if (rc) {
+		efct_hw_io_free(hw, hio);
+		return rc;
+	}
 
-		/*
-		 * Add IO to active io wqe list before submitting, in case the
-		 * wcqe processing preempts this thread.
-		 */
-		hio->wq->use_count++;
-		rc = efct_hw_wq_write(hio->wq, &hio->wqe);
-		if (rc >= 0) {
-			/* non-negative return is success */
-			rc = 0;
-		} else {
-			/* failed to write wqe, remove from active wqe list */
-			efc_log_err(hw->os,
-				    "sli_queue_write failed: %d\n", rc);
-			hio->xbusy = false;
-		}
+	hio->xbusy = true;
+
+	/*
+	 * Add IO to active io wqe list before submitting, in case the
+	 * wcqe processing preempts this thread.
+	 */
+	hio->wq->use_count++;
+	rc = efct_hw_wq_write(hio->wq, &hio->wqe);
+	if (rc >= 0) {
+		/* non-negative return is success */
+		rc = 0;
+	} else {
+		/* failed to write wqe, remove from active wqe list */
+		efc_log_err(hw->os,
+			    "sli_queue_write failed: %d\n", rc);
+		hio->xbusy = false;
 	}
 
 	return rc;
-- 
2.55.0

