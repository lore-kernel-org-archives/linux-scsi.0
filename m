Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C9344F549
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 11:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791805292; cv=none; b=hLjnChTAovqcAv/SQzovrsJLTIz1xAra2ckTSqAmWNau7pRfSqL9YCND3HFBaJe6jSJFC3tZUAmGDVufBiiCJdIe54Reow8qD1nTI9x7bZvbLgsUKXYleWjCL5+EIdUyY3rfw/LPTTLLtipHvXrkaP1V85RLBtV/F2t+FY+mifE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791805292; c=relaxed/simple;
	bh=95jCYiJWQiCrs/vInDlMxb9wHLPwGaoq+Y3wOL6bs/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dib5/wiNE+bl6hORsnGSHAAJ+IdUeRHV2Sn5DgdNH4CGRKSMTtJtyJP0NMRfAWDqyLCf9WeUhzosMbWY+3qnRNwY17aBztQ1hS4giwEJdFUoii6rJ7GZlCNZe8vpZpSPOl5W1ecTPdQ3BbW8e5r32M6yICuwOhLtneyAV1VTarA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=Kra58w4S; arc=none smtp.client-ip=74.125.82.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="Kra58w4S"
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-141395927feso3017125c88.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 04:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791805290; x=1792410090; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qCV9uGPk0pzpjywYVsVOm5n8J7lulX2bkipjkVr5CFQ=;
        b=Kra58w4SuUQJDRCsqBuQjrF3OLPuHY/ogD+pCUUVRmXJ/TuvtT4KZ/chkMtnJ0n+4f
         KedKA1zKwJUPg0hygIi/XeOXzT/PjZfRLgebRXDuu35oc4ZWX6VQd42kcxAFjQNcVn92
         RK0NLxYkgf3tez9MNZowsvXNGd3S4VbnqDITV+4uK6Rf/959TWflkN4lw2g3HiofnmJo
         Wjv1ZNr2JB5g0+v5H60/BZXXpqFtEUJSumEuS6Ts9PBo7TevCxg/NmO6Ing5KjgOGlML
         xhzp6JGIQZznA/9sbHAXF7487vIWkr7lDsOrEtfCTGV1SRV81AjMNOG66rlSLW8Eyqgy
         EQ8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791805290; x=1792410090;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qCV9uGPk0pzpjywYVsVOm5n8J7lulX2bkipjkVr5CFQ=;
        b=TCmy7hMn0pMGKif76Ac+FLqBsJxoXA4h0C6ExYQelh5qT5OnRJRShG7mzkFnn++Mas
         umb0MNZYN2oF/Y1Dx7HYurc1epwv7B6HX/06rAY3aUMIRYy0GdIw3hsJqlcAQ4yutMOH
         AINLRswyfz3zoB12VaDcq1I6nkFfVOrkIiqtfaLjyQN+pfy7BdrutzGOLnYA8gj6YaDF
         IPfvLQbZ5VdsL02+8GPyID7l40dT5wYRYXSMgtQtagfd/2h8uTvvQ/TlbWdIeZQPgZK0
         i4UCnx+83dGbhS5dGAl29bgW9jaOtwfGJJ0WUB5aXApTC8vdHLFrbfH8AmuvMVK41iqH
         FJSw==
X-Gm-Message-State: AFq9FYKUSUrzGLBAbz/DZ39AhCW+1kYFru1giF5F/OvfY43kZY3ZhyPq
	KDmZd20h1Cc8NA+VdN9NddGneMLxxhqh16PsJWlCCON+LQHhPLUHYLB3mlJODyxuY88=
X-Gm-Gg: AYBFou3KNcbhZjj78uxCKgpl55B7y5FUF9LYNAArrEkY3Mt9FDabQZDIMGTsByQZJxl
	JDcxtdhabE4GlL3c5vmD/8OqwxxvzUIfXX7USWtaAPvDQDPO2mp+q5Ye2z+tCTK6lFJhc383di/
	jvkdb9+bZEfcm4Yi8HyrFNfoM8jE3AzohyfFEFVoWurKZHTzYMZeLIhElefnXtUcW8z1rNGdXzx
	1J9crotx4K58f5+u49OqiLHISc9eVWXKzXCHC7abptgpaNjmQ5q2DLEpbsCXysEBMDYbFeTCx2v
	xcYT9shg8xD7ldVnZ2TkIo4WT8rSBaR5BLoSMTFJ1dSMhWCGfagb2ZTigDn9MeViOStVSxtdnnv
	HHUSSo7jI/M2mDFQ3f3xBXxq4x8Ro4lDW2dG4YESSNp/75+RY7NH8V/zKkNphWIc57+TIBJTcMA
	ElVp90piPf0uktJecTgmnTnh8JubNKEkv4/zkWD2D6xtw8hhCUHscNDxIMn2yMHxSUEdlYqVPtc
	jTPZXBIyztijmRTr9rKew==
X-Received: by 2002:a05:7022:b057:10b0:160:a80f:3ed2 with SMTP id a92af1059eb24-16a5dbfecb9mr12854417c88.10.1791805289820;
        Mon, 12 Oct 2026 04:41:29 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:7bd2:1202:246d:44ce])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1746482c978sm8725533c88.13.2026.10.12.04.41.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 04:41:29 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	thenzl@redhat.com,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH v3 3/3] scsi: arcmsr: wrap the type B completion index before using it
Date: Mon, 12 Oct 2026 20:41:03 +0900
Message-ID: <459990a0367f7268c0056098f6e2631700e20327.1791803953.git.yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791803953.git.yhlee@isslab.korea.ac.kr>
References: <cover.1791803953.git.yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

struct MessageUnit_B lives in the dma_alloc_coherent() area shared with
the adapter, and holds the completion ring next to the index into it:

	uint32_t	done_qbuffer[ARCMSR_MAX_HBB_POSTQUEUE];
	uint32_t	postq_index;
	uint32_t	doneq_index;

arcmsr_hbaB_postqueue_isr() takes doneq_index from there and subscripts
done_qbuffer[] with it, and only afterwards reduces it:

	index = reg->doneq_index;
	while ((flag_ccb = reg->done_qbuffer[index]) != 0) {
		...
		reg->done_qbuffer[index] = 0;
		index++;
		index %= ARCMSR_MAX_HBB_POSTQUEUE;
		reg->doneq_index = index;
	}

So the first iteration uses the value as it was found, unmasked.  An
index beyond ARCMSR_MAX_HBB_POSTQUEUE (264) reads past done_qbuffer[]
and, should the word it finds be non-zero, stores a zero there as well.
arcmsr_hbaB_polling_ccbdone() has the same ordering.

Reduce the index where it is read instead, which leaves the rest of the
loop unchanged.

Measured with a KASAN build.  struct MessageUnit_B is 2176 bytes with
done_qbuffer at offset 1056, so a reported index of 600 reads 3456 bytes
in:

  BUG: KASAN: slab-out-of-bounds in arcmsr_hbaB_postqueue_isr+0x1f5/0x270 [arcmsr]
  Read of size 4 at addr ffff88800c08cd80 by task init/1
  ...
   which belongs to the cache kmalloc-4k of size 4096
  The buggy address is located 1280 bytes to the right of

Fixes: 1c57e86d75cf ("[SCSI] arcmsr: initial driver, version 1.20.00.13")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index e635b76daae9a..d13bd0febb81a 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -2568,7 +2568,7 @@ static void arcmsr_hbaB_postqueue_isr(struct AdapterControlBlock *acb)
 	bool error;
 	unsigned long cdb_phy_addr;
 
-	index = reg->doneq_index;
+	index = reg->doneq_index % ARCMSR_MAX_HBB_POSTQUEUE;
 	while ((flag_ccb = reg->done_qbuffer[index]) != 0) {
 		cdb_phy_addr = (flag_ccb << 5) & 0xffffffff;
 		if (acb->cdb_phyadd_hipart)
@@ -3671,7 +3671,7 @@ static int arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,
 	/* clear doorbell interrupt */
 	writel(ARCMSR_DOORBELL_INT_CLEAR_PATTERN, reg->iop2drv_doorbell);
 	while(1){
-		index = reg->doneq_index;
+		index = reg->doneq_index % ARCMSR_MAX_HBB_POSTQUEUE;
 		flag_ccb = reg->done_qbuffer[index];
 		if (flag_ccb == 0) {
 			if (poll_ccb_done){
-- 
2.43.0

