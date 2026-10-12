Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B551C471423
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 09:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791795737; cv=none; b=r0zPDWDsqamUmzbLZasFVRwXwOIAgTNC/161qb5oDqlX9wlBhcRWve7ie0jKWCAeDokIWV2PJ+nJsO5IioNICp7tJnzinWuSKuz2FHfZZOG3ARildKMdn8HG3uiZNB0+FP78UEqfFv5p5jK+vPH0FFnSofYxa+sJM/xTMR71PnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791795737; c=relaxed/simple;
	bh=AlXKd1yeOH2Vu7G06y/CA/VPoGcy25+0dR5pAcrfU0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ot3qKX5ZSBdttZrzbPxZe94HKi+9VxVPKKDEEcFb9oo7xyhPIJ4HXP+xqqoM+aO4nGh3SqULDnPTUgBg3HS3J4O6iSQ4DF5FvbOzQB4dO9zsPFEqJWmWE8HMTsoRxS4XlPnlakrkRWmq4e1FKNP3Kmu+MCBr0Azvj3BXCdWf/lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=n1xxS8Ye; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="n1xxS8Ye"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d6d28aa26cso7206245ad.2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 02:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791795735; x=1792400535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7+RS3qtPpCNvzQb8IiMJLF8fnk/CkQQbrLAsNhPE88k=;
        b=n1xxS8Ye25vU8VSPlpsiH6lSt9mgB9EsLAtFg4c2o2iQhuNB/oZx5OirCPPNjpdheg
         yJdyzQS6LX9Z/lqD6y5rkpBGnJbZ3sljFcLjK/hjIEUpINbwx8HEkueOOR+MTeUcbNO6
         nd9MN800dv9vJNYGuMOQXlgrwMpb4KujUyvrfhLRmZepJ6WFWssSgfL8HSdQPK/lBBjA
         yjE3nzjA1zIxXhiTLcGc1qwGdAASVDyIbKEAVTzjLkQiiFjIpP/Li8tVxRkkOcAswkGQ
         uF33OLQ/NgCm1JzWFVlpmUjoAf2ZHftN7HNxNhcTH0rJyf+UNQxAfm0C+2FHJ19eIgsv
         nwIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791795735; x=1792400535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7+RS3qtPpCNvzQb8IiMJLF8fnk/CkQQbrLAsNhPE88k=;
        b=MmZ9hK791BWmhaxdHY9II8ULm+FFGFb7iqdvCJjIki5osTWvKXNVJTrdozcg8uvSgF
         /1rWAYe2xUQ6J8DmBSuK96VfTKbY1YGh9Qi4pOWY1QrlWPajdvu8/D21QWCKXS0TKnyB
         +e25PA0CyxE0BfxjVVdZ+PsVdbNaL8wpJX9WZgXsRNGdDVjoYl8i5zNzfplBGtmbXgi+
         Qs+YKHUMwk3nRUuF8pQL6zo+ywS9R+JcXI9cS5aTRVyYx2YkBvmB6ssAppUJy+IE3Ve7
         YNDDdF80piaX2a3wfXhGA0LUHVzns2YxronzV4ra4wN+WxCR2u48WeWFbIlgU292WO/y
         4JJg==
X-Gm-Message-State: AFq9FYK0x0tyQ3+7gYOHdahV0K1S9K3EqwV79HOgVhZ4/3VzzpZVUvuz
	/43mcxe2fTCCln0PEX10KrJL8+CyAXjC6xRDN0C/ZmQsFi9nWgs84wOPXXTKV0CVL2Q=
X-Gm-Gg: AYBFou3ATFFFAEDfwiQLQ3MW8B80f4G4WAv/hck+JPpkaYbOXI4xs69mP8iY00pWtHc
	8PJ6ZbDCQjVp8EvgTh4Tk29ovhW4+0HtEVtt+2hm9nN+wKOa6KmFsg2pMJgRJIOJYu3H+t8G4Gs
	8z6efUi3dcmeOpHgggUHaShGqjlFXG3l0KBtz8iDZl0LNnLFoQvdq7drKfvVwiJBNeDQ2+G/RtC
	IaHWPLyOAM0JAjq+Fa4hmYqd+npFvUK2uGRy94JWagLA3YvDVeIoG9eJlS/IcoSs6i4OnWTiYCs
	Ei8Ixq8AK/ggwbUfhGMHRJCfcssGve9eHL5ZFOAOXOyIcn2xSk54nkKKHNtyxBEipTikirPLvMj
	9AF36zO6ABeDfa/y43E7Js9bctsKgEbjTUGrFjDStZY3W8mxfPvlpxdqQupERPw5B7BwDqCPy8A
	IdNSFlS/dyY3XVWLf4gHoQMlzAY3pJnfMYBk995PaSa2F7kWU3VuGfuHP/Ez0VjCwtVx0sHRVcd
	ealpw==
X-Received: by 2002:a17:902:ecd0:b0:2dd:ad74:ac2c with SMTP id d9443c01a7336-2e842bd5890mr80732945ad.30.1791795735038;
        Mon, 12 Oct 2026 02:02:15 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e8422e4ebfsm41638795ad.78.2026.10.12.02.02.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 02:02:14 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	thenzl@redhat.com,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH v2 3/3] scsi: arcmsr: wrap the type B completion index before using it
Date: Mon, 12 Oct 2026 18:01:48 +0900
Message-ID: <d212c8fcde795a43e070d827d1d9d3fe4fcbe65b.1791792888.git.yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791792888.git.yhlee@isslab.korea.ac.kr>
References: <cover.1791792888.git.yhlee@isslab.korea.ac.kr>
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
index 9519715883b5a..c2c62ad6c6502 100644
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
@@ -3669,7 +3669,7 @@ static int arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,
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

