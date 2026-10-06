Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B64F63D9DDF
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 09:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279294; cv=none; b=QsDxYuRTZ7/RTw3lLTpZkgcHU7L24HZLDeOWbYtjS8ObWa8Ubpkru0woEoY8HND75IwtRBvo5SYsVSSzfjSA7STou8dh29SIUkGhBxdddzERYrHizZYKZJ4IpxCv4feec/aUwFeK6dzY2slfs2eDU30bxEB6f86He14+LCmyIoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279294; c=relaxed/simple;
	bh=K1Cdy0hZLUv7y3GkdQGg491Yxdx0wxO32Vu+2QYlCcQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iUYsURGGPet+x8dEQusVx6Jj9ZDbRVBabQlhH/ch4nk8aMKmJP4BiimKym59FoRlpKJDGwv+7O3Jg7p3FiB62jXaERNMAiw4EkmGXYm+/9GIyNSeHP5gbU0KlWc9PtNpDMQh8WhMnbbYCUMJCybQ8Cy0iJxoF5l4qey+pcZCi4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FmbH++Q2; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FmbH++Q2"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3a0a55fa355so206592a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 02:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791279285; x=1791884085; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cL2jFqv3JPAJHulSvum0HPm0fQ5nZHPbZHfKCLsG7HQ=;
        b=FmbH++Q2Q4k/xIr9KgqRdDqC3nC1znkFPCfirIkSoCrxxKXwgnZll/WfU2t0S8XGUt
         sSOOSA3Qsi9p6uVfqW8G/12SpgM/zO9pO9pMyMg+dgZrMxskX3DAqHPWEfbZho72iUpO
         kLRgqWbKNWX5xGMmOh+x4Dc5DvYKU0rZuV45ctqotZYVwSdf/FC9HLcQNeL5u+mtjIC4
         o0TYBlXJ9cj4ZncBtwC2hOA/BS3bgFiIsTfU+tCTzM0YKMr+LLibgC/ODzRobkAm+34r
         SClfDUtMFpvqIvt6tRTH1RLgscNsAcvbHyj5J/qetOO0z+VqVrQvvjdeAuZRskNa0XjL
         5RjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791279285; x=1791884085;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=cL2jFqv3JPAJHulSvum0HPm0fQ5nZHPbZHfKCLsG7HQ=;
        b=drT+0rw+Ycq0CtEqMtxZfGORgGf2DlDHaUpCYc4p2okhkWM3RKlEuXwqhDrAfl2sMA
         OuJBZiVyp6rdq/qWu93XmFFmrcJdx4yQyxIXWN5rYvcjVUAI/49u9RSGm1nPefBALaOK
         2e5GZV+UJshW/E3y0Xh9vtu2B3veVxW8D0gNy8eyqeUMVEzSN0uYv53Ky77+5PK13JHu
         TYh3GQ1lBhJXf5j3df5o54BJr82SCo7twE37NGsi6szjinOHqMptmlotrzwn2ibIzR9K
         v6AvTBk3Lrm+H3zmWVwYVaO6VcQLBH9JIbynIXI3csPcJx52tteC8tnrQANwlJkx3rLt
         tEOQ==
X-Forwarded-Encrypted: i=1; AKwUvBwbFfdLNA1/SWmIWCwI/7HtgFlPcCDFJRnuoOXy2GZjej/W7QmHIkuHCIl8sVLVYJeJKkR3sD5cyy/F@vger.kernel.org
X-Gm-Message-State: AFq9FYKFk+bpO2BaCno/T8yWoI2nfaz2/sf5Ldi2NC1LSuoDe/hV9TF3
	zdlQJHv+4CCzMrDKA/YxPSRh3RPyY547rAjejDnhbDFbVAhs3yb06Clk
X-Gm-Gg: AYBFou0AA69BoqICSAhWriHUf4xcSj52ww1DePkopYPWoaSUJH8vQChJImA8UneCIU1
	U9ttOCMpTnu3yAj29E/9WvOMakWE7TNSWkk09CTaNvml3Vjidk4hkLw+nH4yj7aNlSRI9tlRf7d
	gSy7GDdEyK/mPqH4hnjwyfspDZjhue1Jw2HhmyMV1euNUZYSG/RG28uD7lkA5VrgLxXhPNJ93ym
	I7N2a6XbsNl8jhsjpw+9jfQ1TWQY2RuEbknR4tFf018PhjpxVHvh0lneNmHhJcy4BcDJFQlMexh
	4kKum/n0K9bwxaR7TZglMLGonS4SloElcXkW8b28FVRiWmXYnLhjg+CxRSaPMaqLfGMwP5aYzOi
	rFmdVrhNey7pidmg6E+nfxdyUpcdUbX6HIvdoUkThlVLYSI7QqlGIIGzWZKuAOgFC5G39DHtuaq
	wtvbbZC42DK77VPfCWAAGGweCiIODCqrltv0kbqd3eAzXqLHl0WVAGKLzyor0KqIjM2ROshQ==
X-Received: by 2002:a17:90b:5101:b0:3a8:6b84:234d with SMTP id 98e67ed59e1d1-3a87254fb70mr329706a91.6.1791279284761;
        Tue, 06 Oct 2026 02:34:44 -0700 (PDT)
Received: from gmail.com ([188.253.12.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543ab76bsm3905277a91.13.2026.10.06.02.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:34:44 -0700 (PDT)
From: Jia Jia <physicalmtea@gmail.com>
To: "Martin K . Petersen" <mkp@kernel.org>
Cc: Jan Engelhardt <jengelh@inai.de>,
	Hannes Reinecke <hare@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	James Bottomley <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jia Jia <physicalmtea@gmail.com>
Subject: [PATCH 6/8] scsi: target: limit DIF block CRC to each data sg
Date: Tue,  6 Oct 2026 17:33:36 +0800
Message-Id: <20261006093338.27342-7-physicalmtea@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261006093338.27342-1-physicalmtea@gmail.com>
References: <20261006093338.27342-1-physicalmtea@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

sbc_dif_generate() and sbc_dif_verify() CRC one logical block from the
data sg.  When the first entry is shorter than the block, the remainder
is read from the next entry with

    crc_t10dif_update(crc, daddr, block_size - avail)

That length is not limited to the next sg->length.  A 512 byte block
split 256 + 100 + 156, with the 100 byte entry ending on a page, reads
156 bytes into the next physical page.

vhost-scsi can build that layout from one guest data buffer.  Software
verify and software INSERT both use this CRC.  Walk later entries and
read only the bytes each one actually holds.  The helper unmaps the
current data page and may leave a later one mapped, with the same
kmap_local_page() calls as the rest of the walk.

KASAN reports:

  BUG: KASAN: use-after-free in crc_t10dif_update+0x91/0xf0
  Read of size 1

  crc_t10dif_update
  sbc_dif_verify
  target_execute_cmd
  vhost_scsi_write_pending
  transport_generic_new_cmd
  __target_submit
  target_queued_submit_work
  process_one_work
  worker_thread
  kthread
  ret_from_fork
  ret_from_fork_asm

Fixes: 18213afbd8ce ("target: handle odd SG mapping for data transfer memory")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_sbc.c | 54 +++++++++++++++++++++++++-------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index c0aeb8886743..76dbc986e887 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1310,6 +1310,44 @@ sbc_dif_prot_copy(struct scatterlist **psgp, void **paddrp,
 	return true;
 }
 
+/*
+ * CRC the rest of one logical block.  @need is the byte count still
+ * unread.  Take only what each following data sg holds.
+ */
+static bool
+sbc_dif_crc_rest(struct scatterlist **dsgp, void **daddrp, int *offp,
+		 unsigned int need, __u16 *crc)
+{
+	struct scatterlist *dsg = *dsgp;
+	void *daddr = *daddrp;
+
+	kunmap_local(daddr - dsg->offset);
+	while (need) {
+		unsigned int take;
+
+		dsg = sg_next(dsg);
+		if (!dsg)
+			return false;
+
+		daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
+		if (!dsg->length) {
+			kunmap_local(daddr - dsg->offset);
+			return false;
+		}
+
+		take = min_t(unsigned int, need, dsg->length);
+		*crc = crc_t10dif_update(*crc, daddr, take);
+		need -= take;
+		*offp = take;
+		if (need)
+			kunmap_local(daddr - dsg->offset);
+	}
+
+	*dsgp = dsg;
+	*daddrp = daddr;
+	return true;
+}
+
 void
 sbc_dif_generate(struct se_cmd *cmd)
 {
@@ -1358,15 +1396,11 @@ sbc_dif_generate(struct se_cmd *cmd)
 		avail = min(block_size, dsg->length - offset);
 		crc = crc_t10dif(daddr + offset, avail);
 		if (avail < block_size) {
-			kunmap_local(daddr - dsg->offset);
-			dsg = sg_next(dsg);
-			if (!dsg) {
+			if (!sbc_dif_crc_rest(&dsg, &daddr, &offset,
+					      block_size - avail, &crc)) {
 				kunmap_local(paddr - psg->offset);
 				return;
 			}
-			daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
-			offset = block_size - avail;
-			crc = crc_t10dif_update(crc, daddr, offset);
 		} else {
 			offset += block_size;
 		}
@@ -1543,15 +1577,11 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 		avail = min(block_size, dsg->length - dsg_off);
 		crc = crc_t10dif(daddr + dsg_off, avail);
 		if (avail < block_size) {
-			kunmap_local(daddr - dsg->offset);
-			dsg = sg_next(dsg);
-			if (!dsg) {
+			if (!sbc_dif_crc_rest(&dsg, &daddr, &dsg_off,
+					      block_size - avail, &crc)) {
 				kunmap_local(paddr - psg->offset);
 				return 0;
 			}
-			daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
-			dsg_off = block_size - avail;
-			crc = crc_t10dif_update(crc, daddr, dsg_off);
 		} else {
 			dsg_off += block_size;
 		}
-- 
2.34.1

