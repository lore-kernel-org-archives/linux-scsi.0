Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B50044C33E0
	for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 08:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792052394; cv=none; b=kQ7zQ28l1SPYWQ9A5yvzpWlNQuXa23ux3FaKy4qFPmeQPc1+EFgNOB15DDvkXi5siiidgZVxaiiv09Ymw85IyHuVXnNMOtx3YxVfsXVpmiNdJWkZZlUTgLyywfKu3LYmB502aEolOyoVIfeP0s56u/soJgVqgFnJzy771ztsB3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792052394; c=relaxed/simple;
	bh=55fngw8U7i276yUTXQntdbIZF4Wd6ep68zhxSVkxCO8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2Ahv3tQQF1zZ/pmM0N0ho2+bTY9q+FmLWVXCt5T3uJIoC9rXUSV7mvvQc1qNTx6S++7iDf1AS6wP6S3R1XVOwN2GZE6uDUNOmmFFI/uXbF+fV28C0ykvoatOKEtcXnUcludO1sXK5Ilyb49oS5pFI39HOpoZGBfUQOHrcgc4j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=Q1kWCDh2; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="Q1kWCDh2"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cd5e6f0a22bso941721a12.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2026 01:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792052391; x=1792657191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i6VprNe7yjepyKxDyWl/GS5n+61wlhCAhAo3qvs5zaA=;
        b=Q1kWCDh27bUa03NhPCldjuS+wzOaEOIz1HLSErnfDS93x7VJqbS7EJh5vx6dtqe+UD
         RElTfA22CZ1s+/2nThKkzqhOQFI3YDxlqfRHmKxtT3+BVoQ/q7Y0Hl/lvd1xPkCD43XH
         Jzi6fZdAdXt4vgj+IxaFOCthiB648HDmx9KDRKJqCAyNPQ4gNy+9TS05qFFSPO+4pEi6
         /ob4e9rv6jle7QPo2MvGgbYzOyQRMqC7LK0JcaUTCf/+truXmFC9VLkJGnl3l2Q3jd2P
         QP4N6JE5mrR0TMqrXYka6KKsh01pqEFsexJ8ag00KiYMIwUS7GbDjMooGIx9il6YaUyN
         2csA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792052391; x=1792657191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=i6VprNe7yjepyKxDyWl/GS5n+61wlhCAhAo3qvs5zaA=;
        b=g1nBJDpWL32efICss9ASGEwZ4aXC9htWQJTspUFNFfsHDlf1bvquV89hV++XE0B9h0
         XW8JXRHX2ZeaaQWZJjaDY5r1X01fA2hSumHEAXAPqz/evd60NRw3DgxXwblFz9ZKL65/
         m/FmZZs1dirCnv+4CBy+2rSWla1M1AqgXV9FhZs0a7sK7OXbpo3gvGIjL09ByEP48XoK
         pstdDsmtFLgGL40ytvhobeUj6Xcd8fiIXeND60wLPspb01ZbpxF2cwMr/RDCGaanJ+bh
         NvgxpbZOig/LugEH8F9t7hkoeQBs88CdaR0MT9q2ERAuV+jJcpOWric9HH/O0HHL9LiY
         Ldkg==
X-Gm-Message-State: AFq9FYIHguRGMf2yN9CKf6TIvYndEITW2BHLbdvbFrptagD3vYttG6g6
	IeIxJEvs0BnOui5VJFI5MOiH5qslDboyEyFp8CCru6rTCsPp8d0mbnM9sGQejNVtYNg=
X-Gm-Gg: AYBFou3nQqp2Gi0EHbbGUW/YlnQxL6BSsbi5oX8a1WH053QsQPqk/PdQRD5I4pcGjh0
	jeEWzNI7b6/0DMByYYCyZV2NwlgLy1DnH4HMThIsIlRrxny5Jvz8LJ8a+AsISldsxdkzg7ivNC9
	CjmwQL/yww5oAE65gGWY9Tq0+vN7Z9v32xOfz7umdDQo+tFi65L6wL/asVTgRGG6jFu0XvaK9oB
	E33VUw1DjEF0P6I30TuQAsf0N7H9+FqwbXya7z2IRTRXDeT+j0eCP/Xpu6cqo39VB38bpSwdob1
	CbxwbNJTH61FMXy0f5IZVmuE2ViiA20GF9Qc4KKg7KLFreb/uE11HQjAS4+A4cJqRhq0xAp7XOl
	GFmtshPi7X8+83DefT+3HSSNRgr3+w/UCEpDYhxAp4C28pYVHhasTrj3GRyTEv8+In1LLjcS6sY
	h3xSndUs20ACpKG522Zy77f8ziocgLAQzN1w6KhW++P8M1x/IJGBTz5do4CN+XpiGfisnDY1pJw
	sYaFw==
X-Received: by 2002:a17:90b:1b06:b0:3ac:adce:60b2 with SMTP id 98e67ed59e1d1-3acadce66cfmr116114a91.2.1792052390946;
        Thu, 15 Oct 2026 01:19:50 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac943e755bsm3319784a91.2.2026.10.15.01.19.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 01:19:48 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v2 1/5] scsi: aic94xx: bail out of escb_tasklet_complete() on a bad EDB index
Date: Thu, 15 Oct 2026 17:19:30 +0900
Message-ID: <20261015081935.4168771-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015081935.4168771-1-yhlee@isslab.korea.ac.kr>
References: <20261015081935.4168771-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

escb_tasklet_complete() derives the empty data buffer index from the done
list opcode the sequencer wrote:

	int edb = (dl->opcode & DL_PHY_MASK) - 1; /* [0xc1,0xc7] -> [0,6] */

DL_PHY_MASK is 7, so the subtraction yields -1 through 6, and the
function already says that anything outside [0,6] is wrong:

	if (edb > 6 || edb < 0) {
		ASD_DPRINTK("edb is 0x%x! dl->opcode is 0x%x\n", ...);
		...
	}

The block reports the problem and then falls through to let it happen.
edb is used twice afterwards: asd_bytes_dmaed_tasklet() adds
ascb->edb_index to it to index seq->edb_arr[], and the out: label at the
end of the function hands the same value to asd_invalidate_edb(), which
indexes both escb->eb[] and seq->edb_arr[]. asd_assign_edbs2escbs() gives
the first ESCB edb_index 0, so for that one edb == -1 reads
seq->edb_arr[-1], one pointer before the array, and dereferences whatever
it finds.

Finish the check the way it reads: return instead of falling through.

Whether the sequencer can really report an opcode that makes this zero is
not something the tree answers. It is firmware loaded with
request_firmware(), the done list opcode is described only by the comment
above, and there is no Documentation/ file and no MAINTAINERS entry for
this driver. This is not a claim of a reachable out-of-bounds access,
only that the driver goes on to index an array with a value it has just
decided is invalid. The intent to bound what the sequencer supplies is
already in the same file, in asd_bytes_dmaed_tasklet():

	size = min(size, (u16) sizeof(phy->frame_rcvd));

which clamps a device-supplied length a few lines after indexing
seq->edb_arr[] with a device-supplied index and no bound.

One consequence worth naming: an ESCB dropped this way is not invalidated
and so is not reposted to the sequencer, because the repost happens
inside asd_invalidate_edb(). That takes one empty buffer out of
circulation per malformed opcode. It is the lesser of the two, and
recovering the ESCB instead would mean choosing some other buffer to
invalidate, which this index cannot tell us.

Fixes: 2908d778ab3e ("[SCSI] aic94xx: new driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/aic94xx/aic94xx_scb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 08c8dad9ad621..d050e5325b943 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -421,6 +421,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 			    le64_to_cpu(ascb->scb->header.next_scb),
 			    le16_to_cpu(ascb->scb->header.index),
 			    ascb->scb->header.opcode);
+		return;
 	}
 
 	/* Catch these before we mask off the sb_opcode bits */
-- 
2.43.0

