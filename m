Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECD744A3F3
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 07:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791790730; cv=none; b=ibexbHpm1s1FqBVW2r5t+vdld8//7ZUz5twN2Xn4s3UskVMJOOjxp4TWo2CwkpH1aHVm9Lq8nQWd6MU0Yq79146tE0Cz3atfdk+Kbu/LmXzzvJrAR6JTnmmMhpPfwXQbgXvkie46dF8n4NaVgjq7+g6tq/L+RoE9GDN6Ko1jgzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791790730; c=relaxed/simple;
	bh=frGeHsp77ccEYIjltOywKMw92w1djyDNOnPEz2b3YKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ce6BIANzPpJPICodUxu6WGPvNwlBdhx36iofyIvxU4IVquj65vztuCPbz1jc9f8prvGTRVtepTKTbYYX7bBXTa5xCMpy7qzfAW5ON+3myxFu4p2CDUVF1qeMO7ffKk7azUmwzEOoZJBATrTPX1cd0koKor3nVjKWYL8+vHeYTwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=cpGnEkhc; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="cpGnEkhc"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-886e61fa30fso457285b3a.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 00:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791790728; x=1792395528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xXAFZNxdX2XaonrsCpg7wn2yHmpFEkowvimbfLrPCIY=;
        b=cpGnEkhcrA8DiFdOHhaLwRsJOWCdYdsfnn1bd5nRIRVyj751mvR+LEnm+PFM2p5mKb
         IIQ1q05awY9Lw9nw+MqlQ92ld6khwciCftkiAk58HAhqtnmybtFE0H1+zmz6TrKLmho/
         u5dR+JJWa0dN7QGQh18Wk0P5awF84pkM2XElkdT2PHc4A51Ujxir/ZKNVlKCADTUrtbF
         FaCPFhp/unAfKC5DlDmqoD+mM8vRPCjSzi/pIe/V/3Iak+xG0BSY1ulUh1ki0cVGJawV
         WFmf4EL9zc/ul1AwnuxZ04OboNTUk/1yKmP/0FY33RJhjJ0GHpmmDSXMb9M9hGavZfaQ
         +peQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791790728; x=1792395528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xXAFZNxdX2XaonrsCpg7wn2yHmpFEkowvimbfLrPCIY=;
        b=zboQHUotF4ePhFRVyvJq+ZF702RytOSmyGOtIVhVO3IWC6TccjTCl5520Q1O5P7wtz
         4re4R7F8ktNCU2G/CBtNRxXtBUyAJDxxgfhAhCJPoZT6WuiKd1KBSI0Kdqgn2cbEOHem
         Ql9mhdo7xGSHMQ4qWI4x65S27LZplIXxWCxrFEFZAIaNcY2EPP6NZt5TnHnlvEvb2knw
         qoXs4lw04sKm2Nwny4cEcrTD4fUp1ngpDDr76/MVTtpdVqzf7WA+3MJgOzlrWZu283zA
         ggYltKW62i2omy4e6n3Hz9PRdw2/wcH4iKzNqg1pHTWyb7H2qcr9yweGM12246RQgYtG
         ssHA==
X-Gm-Message-State: AFq9FYLAu+4V7O3oviCEzFO4Etgemk9lOxXsvRDRbCybkgsSqTFSaZVC
	/w9Anvj3+Y+aYFAFletFcwLkon5Xq0zN7/xv+QJEQDIQezJc98PkLFYJOzOfOQshR8E=
X-Gm-Gg: AYBFou0n/G2rlNVQaL7RIjlMTwjHX5WwXbgkHHTfEWchhKTOzktiP0Gin31647plv6i
	mX+ExeiOfWyvuiWV7/RRU+rPAB1BHoSzoWyfJB7hDNaatwVeOdqFgQ5AgSwW6yVIydcX5GSsywv
	wA+yp/kagEhISYnwpyreFF9BQ3iEzFpn1GOrzXHzaZRmoZNZV3tKVF2SsYnt9E/ll8qwxEVE/n9
	gEFbehasvarFfqn5CIioRJLgA2w+RihDPe3PBA4B8EBgkHdtou38dg2yUA3BAfm5G+fjfeDoCrN
	cDs0W7cDYH0wOIGFx1K/xbVtL1juyiv/YPv/hQQhyxcrlVPKoypf020/q+v8fFh1O0tfmXnucgl
	R8+Fmb/0M/L6MAjZs1c3R14P8yuYxy5HIOZYBtvoePx0c0q/h4l56QowC80JXAkJLIcDUo1PkZE
	L7Z4+9Snf5vzlBKJIzH6DFZcXtzLZ1AUBBi1apKlX4MSIOn3Xnh3USm2WVXLVITpUXXCVYvE9Y3
	HuBNc9xHgn8df94
X-Received: by 2002:a05:6a00:4b42:b0:888:4f06:903f with SMTP id d2e1a72fcca58-897c78d5fe8mr6613335b3a.38.1791790728027;
        Mon, 12 Oct 2026 00:38:48 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-898c9ee8bc5sm2148780b3a.60.2026.10.12.00.38.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 00:38:47 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	thenzl@redhat.com,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Subject: [PATCH 3/3] scsi: arcmsr: wrap the type B completion index before using it
Date: Mon, 12 Oct 2026 16:38:28 +0900
Message-ID: <7e1668a808bb282f43ca0e74189e678e40f03779.1791789900.git.yhlee@isslab.korea.ac.kr>
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
index 1381420d9fbd7..b73aaa0c8068c 100644
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
@@ -3662,7 +3662,7 @@ static int arcmsr_hbaB_polling_ccbdone(struct AdapterControlBlock *acb,
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

