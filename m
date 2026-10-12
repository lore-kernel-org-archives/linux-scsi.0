Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E52C443C19
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 07:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791790728; cv=none; b=ZbU/0PQj9epthgS7HB856BvxwbWEtx6o/ca0aegewiIs2zhrrYmSq4SxuYOT6ycGqxVL6jBjwY62RrSrwdfto6zdg43lCbf0PphAgM3CYNAHfIvwiTx7e6CoN1BjgBYxh4vq6n/op3JtPZz0WgLP+BDbP343W3AYQQ66bgTQw2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791790728; c=relaxed/simple;
	bh=DeHgONwGOvPKRhitMl7KjVlAN7+DHObUJO88XdfNGlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F4FHjyHaECSTw13YKQYJzp3INzVf2Po/RyJ2xfowqoW7IjgYJsXDvKXo/WW6eF1bIwl0Gr4L/Mmr6gyg//yR8LDlsg1yuvA+HiMaH568sGJfSpNrcadroaXs6ivLA8BDBOifVBbDAN9hV3f5E93WFuVxIT4UWrYiqi+7cSzGwto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=DP4BM9vc; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="DP4BM9vc"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-885cd98d226so665382b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 00:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791790727; x=1792395527; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UlInBA7JKl335oYahoEr7gxTOB8Q4akEw+e1sscDqpY=;
        b=DP4BM9vcHaREqUEGAunyWoaK6I58XffbGvjO33XETGen7mqz7AdO4TNLZJswyHCZfd
         wtGbDdTpa+sztzbxxcgtulsimDGxxk5IOFKpU/8TPd+I3waTQk9k0nfOgCzXr+cbKkHw
         TBXsmd4SGYq/srZMaN/HukVDK4/+sbdH1wimxX1Z7+dLkxLvwYlh1SkdsgutVThItbrS
         yLvfFNqXcq1b3I3C8aaTO4ZGWY0z+Y2uY7GEQCVbgSTricgDDEQ7ySajhFfIiHvan3W/
         SngF86KZs7x31k0wT0QzNPogSDa6WBEL7Vzc/e/lQq8LcfyU6wBNs0rMunp13eC/Embx
         xEvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791790727; x=1792395527;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UlInBA7JKl335oYahoEr7gxTOB8Q4akEw+e1sscDqpY=;
        b=Ie0QAnl5k864+088pFLmensj4dWyK33MeSJp3WTj0D2Mff3OjbO+K91Evd3dytAZfC
         JPhz6cGH6Ra4/VFbK8rBupoqm0I/Kga38xTiSCD53FJOgYUopZ55+MAs4wFlQcXTPppy
         q5YXBTyc3N6nUvcbsidxTyqaS9lEVUMjB95J805XShTNGM9f/zzvCCqrBzrjE1yqpaW8
         9aGHkrgYQ2Iny/zkWwcK8Cm8DLDI7NJDdnuR+qjDWWtWfySniXXt0LpqBL0ZCHC+Ywm0
         4jIfrBoGcEh+BvHicfkz1Z6aGqZa6Iv4tBucNqJgSy6rtRX0JmDh0R0Gk/kD/OL3swZF
         HFpQ==
X-Gm-Message-State: AFq9FYJxSouU5rTGDxNAErQj7u93RE0/ZV6R0iiys9LBF7ChfH2TrF/9
	bCvZD3b0knqzxGMLUKT8MZxw72qzFf/OWQTGm+L2ClZfS78Yc8ItamyQeU7yi/FSdWY=
X-Gm-Gg: AYBFou1bhBCLK3CJt47vaMGu83CA6NMufvS/oXqjg8RvBLX7/hbyMm5KQgtLjMziF4K
	yIdmmhi4gdnYcXK7K1zvxxB8QFIGFOuIxgHP4A5jkrxipuAzRBZI+Q+e+9maROBBk8zQcfrv8yp
	qyV37kq95zW9WW/fOWo/sTejS7h4EsKggWUe1/CdFm09oPJqd2kJnyMnHE9G5anzadqdnTvse/L
	fok5JG9ZBmKoILIgoCc5weXrD+X/koMaNLrth4Q7k9hWv386YL+UvN7/oD0yqFkRpIkhMsmzRif
	3TulLmrG7UHHwcSNBdd+UModOWYKGmcwWNPq9lS3noZzQnxuZn43oV2WgqGALmEUQ1Wj3tqYbov
	feBtMA47S2UdB3CPKB8kwpTx0cQlPfoFPf5kzVil97AGtmlrZBPgl2qnDMbCLfSWiJamWo+qSx0
	dgwEohDrz1+IFMdO27BNcIVQlLy+gV2kYf1e0slDvFfqd8KQaOVeOLoYV9SdZtDLaofeCBZXPfM
	FQa2okdU3Dfd2P7
X-Received: by 2002:aa7:9308:0:b0:878:3705:571d with SMTP id d2e1a72fcca58-896a47e04b0mr5745255b3a.41.1791790725190;
        Mon, 12 Oct 2026 00:38:45 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-898c9ee8bc5sm2148780b3a.60.2026.10.12.00.38.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 00:38:44 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	thenzl@redhat.com,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH 2/3] scsi: arcmsr: check the completion index the adapter reports
Date: Mon, 12 Oct 2026 16:38:27 +0900
Message-ID: <f0e71746bcdaabb1e105297ed86ddcf2245b0c86.1791789900.git.yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791789900.git.yhlee@isslab.korea.ac.kr>
References: <cover.1791789900.git.yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On adapter types E and F the adapter reports a completed command by
writing its slot number into the completion queue, and the driver turns
that number straight into an array subscript:

	cmdSMID = acb->pCompletionQ[doneq_index].cmdSMID;
	ccb = acb->pccb_pool[cmdSMID];

cmdSMID is a uint16_t taken from DMA memory the adapter writes, so it
can be anything up to 65535, while acb->pccb_pool[] has
ARCMSR_MAX_FREECCB_NUM (1024) entries of which only acb->maxFreeCCB are
ever filled in.  Nothing compares the two.

arcmsr_drain_donequeue() cannot stand in for the missing check: it
starts by reading pCCB->acb and pCCB->startdone, so by the time it can
notice anything the bad pointer has already been loaded and
dereferenced.  arcmsr_hbaF_postqueue_isr() rejects the single value
0xffff because that is its queue-empty sentinel, which leaves
1024..65534 accepted.

Reject an index the driver never handed out, in the two interrupt
handlers and in the polling path.

Measured with a KASAN build and a crafted completion queue.  struct
AdapterControlBlock is 17504 bytes with pccb_pool at offset 496, so a
reported slot of 60000 reads 480496 bytes in, past the end of the
controller block entirely:

  BUG: KASAN: use-after-free in arcmsr_hbaE_postqueue_isr+0x242/0x2d0 [arcmsr]
  Read of size 8 at addr ffff88800bf354f0 by task init/1

and the pointer it picked up then faults in arcmsr_drain_donequeue:

  RIP: 0010:arcmsr_drain_donequeue+0x27/0x360 [arcmsr]
  Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

A smaller out-of-range slot such as 2000 still lands inside the
controller block (offset 16496), so there is nothing for KASAN to
report; the driver simply reads an unrelated field of its own
AdapterControlBlock as a command pointer and faults on it in the same
place.

Fixes: 235090241c55 ("scsi: arcmsr: Add code for ACB_ADAPTER_TYPE_E")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 255f1d898079f..1381420d9fbd7 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2677,6 +2677,11 @@ static void arcmsr_hbaE_postqueue_isr(struct AdapterControlBlock *acb)
 	pmu = acb->pmuE;
 	while ((readl(&pmu->reply_post_producer_index) & 0xFFFF) != doneq_index) {
 		cmdSMID = acb->pCompletionQ[doneq_index].cmdSMID;
+		if (cmdSMID >= acb->maxFreeCCB) {
+			pr_err_ratelimited("arcmsr%d: bad cmdSMID %u from iop\n",
+					   acb->host->host_no, cmdSMID);
+			break;
+		}
 		ccb = acb->pccb_pool[cmdSMID];
 		error = (acb->pCompletionQ[doneq_index].cmdFlag
 			& ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
@@ -2706,6 +2711,11 @@ static void arcmsr_hbaF_postqueue_isr(struct AdapterControlBlock *acb)
 		cmdSMID = acb->pCompletionQ[doneq_index].cmdSMID;
 		if (cmdSMID == 0xffff)
 			break;
+		if (cmdSMID >= acb->maxFreeCCB) {
+			pr_err_ratelimited("arcmsr%d: bad cmdSMID %u from iop\n",
+					   acb->host->host_no, cmdSMID);
+			break;
+		}
 		ccb = acb->pccb_pool[cmdSMID];
 		error = (acb->pCompletionQ[doneq_index].cmdFlag &
 			ARCMSR_CCBREPLY_FLAG_ERROR_MODE1) ? true : false;
@@ -3880,6 +3890,11 @@ static int arcmsr_hbaE_polling_ccbdone(struct AdapterControlBlock *acb,
 			doneq_index = 0;
 		acb->doneq_index = doneq_index;
 		spin_unlock_irqrestore(&acb->doneq_lock, flags);
+		if (cmdSMID >= acb->maxFreeCCB) {
+			pr_err_ratelimited("arcmsr%d: bad cmdSMID %u from iop\n",
+					   acb->host->host_no, cmdSMID);
+			continue;
+		}
 		pCCB = acb->pccb_pool[cmdSMID];
 		poll_ccb_done |= (pCCB == poll_ccb) ? 1 : 0;
 		/* check if command done with no error*/
-- 
2.43.0

