Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBE3385D69
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 09:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279284; cv=none; b=ocwOGnuFdpHEDRKyrA+P5H9PS+ruPbe4Dims/5oDty5sWO0LEgGbycFQDL9IJxgUp5bMHigd7x8l50ER1/W3NDTiDnZPxLtsMrLpNOpUFHsDH7Q4p+5Ly1HDJmlDZW7S7wVUaOgkIg6jUrcOuNmBMR8f7YszfTAgm9nQw142yic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279284; c=relaxed/simple;
	bh=/17/pkxULwrR3ZWDh3pQ4IHMHFbrL/DqCQWuvTPfDW8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nLg2XybrTFy9nd0cOzV4Bnr2PJQgsZR+8q8uDL2S/XDKQ5vcEmNoEgMZii0/qi8DDoeB/thbSRM+Ns81NbGpeV6pqr8E/CvR420bLUxKtcOc8q7qEyDhXU3bL7ttQkgB74EddRkVOhWeoIB9rMjwte0r/5nj4TvrlSCpj4C+7o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UTUV2iiT; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UTUV2iiT"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cc1cf287ef8so215106a12.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 02:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791279276; x=1791884076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PXtWrw3kC77K/UONiyNs9faB1JpghxxGQKJgWYuGIxs=;
        b=UTUV2iiTo+slfAUjtz5UZOrTgtPOOO/ulXRm6F2UdUN04zMOrRJXyx6g6o+i2zO1mN
         oEVdl+4r3qgXvvvRr2WXgJh4VTyxPrk3i65Gs9zioazrUgeiHcHUKPhUdrXVsgUpeC/+
         m/XZk4tqJNJqjic9IYy4RqVBUgRQEImxptWJt9qEAjIlFj/JlsQNlSPIzl1f7+s6LJFU
         OyE+HocKFTLkKld5nkAf6WfCaloHpYu91nOmh9QqAhwUM+1IGAJxtAKDLA1ELgDSZS17
         lVxTVfLej1Xwwiw9tCYO032m6am1fJ5fz9Rbp6bJ3Rq8XOIBdEzVUEyA/bb9Ug/ApArA
         RKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791279276; x=1791884076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PXtWrw3kC77K/UONiyNs9faB1JpghxxGQKJgWYuGIxs=;
        b=Lf5wzqrw6JoL31GAicELjpsyvFfw9GoQ4ZbLSZvBwsxxQut1bNhnrtqj3dxcbPV6eD
         MhZWetELs7q7ulggYxOgVpVdlfZj4DmhTXZWvgLZ7h0lzYJ8IsKVvQHTr1Wos9Jimbk+
         q0VshEDfHoNIW0eEY9M16J0WYytyHlOT7e7bjRQ6gnhOIt6Y87ofzbyPJ3WPVLU0cuJj
         ybBR9dSVf1jzdgpgS7UTQAIeMds6NV8OKhwfGtKLZBf7e8IyPwLTdO5+liwKbPeE4FcS
         d2kW8NwGUXv38UVGkeH3pDiIHsXZt2jgubA+7UZkWiuRrTycM3kGBZ9kmaVIhTAaxwk9
         my9g==
X-Forwarded-Encrypted: i=1; AKwUvBzv3CZVmMe/PwwsjwtpVyCfKgnRXuNYNboMQCT3ANFvn8l6yhe+8lC1h7IIOXJICsbB0OiqVBWt8nGY@vger.kernel.org
X-Gm-Message-State: AFq9FYLNIev1fI25K9E5ZKVB1U6i/cL2y4yPjbLZCCFOtruhx8Re4YXC
	q9xsImi8zWrITIc8PZENugTkbBfwjznv0nZxCAfLX8ISbscijFziLptA
X-Gm-Gg: AYBFou2eQgu4JbXh2hcgk59o/1yiggtBrJkXv0ZuzKne60+RKcUhaSZdgXneLjDEayv
	4KGqsCTPZwD2vlqNjfTR948XoT9ngNB/Wfoe4e7fgBwd5ufQkgY5S/5ErELn5dZqZpR1gfT+VuG
	fiYfVBWSWyqFeMxkwQrEs2qQ4QiHHtQfx2EjVktMpfK23GKcadGFPumz7YVKTwl9DoIpTHCAGul
	HgxLVWAP6LEx4W3PvOTJxjMK04r8qFR9jECxF4ABBI19AEjL503kRyJ73ukMO6QSJwCqrVAq5Uc
	2xGESHahSPDUVE8iahAhSeocA1z9rVqXI6dlBAijl+G0yu1NiEhU/NAAZka1Ys7aSLMGqR8DWWp
	0/FGXeGe4znBcHfM1EsACyKvb6R7jbuOsB/vjcx6auliSDTxvpQf/vdoloDCYC0K4dVpGAvr2DX
	EdV4E9GVrAXB20n0ye6+zrzR38fsW1wQnL3WsWxnvRiSivtjfRjo+4izT5Yq/zGWESAx667w==
X-Received: by 2002:a17:90a:e707:b0:3a4:b418:94cf with SMTP id 98e67ed59e1d1-3a8734ecd7fmr672055a91.14.1791279276383;
        Tue, 06 Oct 2026 02:34:36 -0700 (PDT)
Received: from gmail.com ([188.253.12.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543ab76bsm3905277a91.13.2026.10.06.02.34.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:34:36 -0700 (PDT)
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
Subject: [PATCH 4/8] scsi: target: copy a DIF insert tuple across prot sgs
Date: Tue,  6 Oct 2026 17:33:34 +0800
Message-Id: <20261006093338.27342-5-physicalmtea@gmail.com>
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

sbc_dif_generate() walks each protection sg and stores an 8 byte
t10_pi_tuple while j < sg->length.  The store is not limited to the
bytes that remain in that sg.

vhost-scsi maps a protection buffer with iov_iter_get_pages2() and
keeps each sg inside one page.  Eight PI bytes that start at page
offset 4092 become two sg entries, 4 bytes at offset 4092 and 4 bytes
at offset 0.  The first entry still takes the loop.  For DIF Type 1
the ref_tag store is 4 bytes at paddr + 4, which is the next physical
page.

Software INSERT reaches this function when the fabric does not
advertise DIN_INSERT or DOUT_INSERT.  vhost-scsi advertises only
DIN_PASS and DOUT_PASS.  With fabric_prot_type 1, a READ is
TARGET_PROT_DIN_INSERT and the generated tuple is written into the
guest PI buffer.

Copy the 8 byte tuple across protection sg entries.  Four bytes at the
end of one entry and four at the start of the next stay one tuple.  A
tail with no following entry is left unwritten.  The walk maps each
page with kmap_local_page().

KASAN reports:

  BUG: KASAN: use-after-free in sbc_dif_generate+0x20c/0x640 [target_core_mod]
  Write of size 4

  sbc_dif_generate
  target_complete_ok_work
  process_one_work
  worker_thread
  kthread
  ret_from_fork
  ret_from_fork_asm

Fixes: 66a3d5bc47d2 ("target/sbc: Add sbc_dif_generate software emulation")
Signed-off-by: Jia Jia <physicalmtea@gmail.com>
---
 drivers/target/target_core_sbc.c | 181 ++++++++++++++++++++++---------
 1 file changed, 132 insertions(+), 49 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index adef903652ac..12275ebad95c 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1250,72 +1250,155 @@ sbc_execute_unmap(struct se_cmd *cmd)
 	return ret;
 }
 
+/*
+ * Copy one 8 byte PI tuple to or from the prot sg.  The data page sits
+ * above the prot map, so a prot sg change drops and restores it.  A
+ * short tail releases both maps and returns false.
+ */
+static bool
+sbc_dif_prot_copy(struct scatterlist **psgp, void **paddrp,
+		  unsigned int *poffp, struct scatterlist **dsgp,
+		  void **daddrp, void *buf, bool to_prot)
+{
+	struct scatterlist *psg = *psgp;
+	struct scatterlist *dsg = *dsgp;
+	void *paddr = *paddrp;
+	void *daddr = *daddrp;
+	unsigned int poff = *poffp;
+	unsigned int len = sizeof(struct t10_pi_tuple);
+	u8 *p = buf;
+
+	while (len) {
+		unsigned int take;
+
+		if (!psg || poff >= psg->length) {
+			if (daddr)
+				kunmap_local(daddr - dsg->offset);
+			if (paddr)
+				kunmap_local(paddr - psg->offset);
+			daddr = NULL;
+			paddr = NULL;
+			psg = psg ? sg_next(psg) : NULL;
+			if (!psg) {
+				*psgp = NULL;
+				*paddrp = NULL;
+				*daddrp = NULL;
+				return false;
+			}
+			poff = 0;
+			if (!psg->length)
+				continue;
+			paddr = kmap_local_page(sg_page(psg)) + psg->offset;
+			daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
+		}
+
+		take = min_t(unsigned int, len, psg->length - poff);
+		if (to_prot)
+			memcpy(paddr + poff, p, take);
+		else
+			memcpy(p, paddr + poff, take);
+		p += take;
+		poff += take;
+		len -= take;
+	}
+
+	*psgp = psg;
+	*paddrp = paddr;
+	*poffp = poff;
+	*dsgp = dsg;
+	*daddrp = daddr;
+	return true;
+}
+
 void
 sbc_dif_generate(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct t10_pi_tuple *sdt;
-	struct scatterlist *dsg = cmd->t_data_sg, *psg;
+	struct scatterlist *dsg = cmd->t_data_sg;
+	struct scatterlist *psg = cmd->t_prot_sg;
 	sector_t sector = cmd->t_task_lba;
 	void *daddr, *paddr;
-	int i, j, offset = 0;
+	unsigned int poff = 0;
+	int offset = 0;
 	unsigned int block_size = dev->dev_attrib.block_size;
 
-	for_each_sg(cmd->t_prot_sg, psg, cmd->t_prot_nents, i) {
-		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
-		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
+	if (!psg || !dsg)
+		return;
 
-		for (j = 0; j < psg->length;
-				j += sizeof(*sdt)) {
-			__u16 crc;
-			unsigned int avail;
+	paddr = kmap_local_page(sg_page(psg)) + psg->offset;
+	daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
 
-			if (offset >= dsg->length) {
-				offset -= dsg->length;
-				kunmap_atomic(daddr - dsg->offset);
-				dsg = sg_next(dsg);
-				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
-					return;
-				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-			}
+	for (;;) {
+		struct t10_pi_tuple sdt;
+		struct scatterlist *mark_psg;
+		unsigned int mark_off;
+		__u16 crc;
+		unsigned int avail;
 
-			sdt = paddr + j;
-			avail = min(block_size, dsg->length - offset);
-			crc = crc_t10dif(daddr + offset, avail);
-			if (avail < block_size) {
-				kunmap_atomic(daddr - dsg->offset);
-				dsg = sg_next(dsg);
-				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
-					return;
-				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-				offset = block_size - avail;
-				crc = crc_t10dif_update(crc, daddr, offset);
-			} else {
-				offset += block_size;
-			}
+		if (poff >= psg->length && !sg_next(psg))
+			break;
 
-			sdt->guard_tag = cpu_to_be16(crc);
-			if (cmd->prot_type == TARGET_DIF_TYPE1_PROT)
-				sdt->ref_tag = cpu_to_be32(sector & 0xffffffff);
-			sdt->app_tag = 0;
+		mark_psg = psg;
+		mark_off = poff;
+		if (!sbc_dif_prot_copy(&psg, &paddr, &poff, &dsg, &daddr,
+				       &sdt, false))
+			return;
+
+		if (offset >= dsg->length) {
+			offset -= dsg->length;
+			kunmap_local(daddr - dsg->offset);
+			dsg = sg_next(dsg);
+			if (!dsg) {
+				kunmap_local(paddr - psg->offset);
+				return;
+			}
+			daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
+		}
 
-			pr_debug("DIF %s INSERT sector: %llu guard_tag: 0x%04x"
-				 " app_tag: 0x%04x ref_tag: %u\n",
-				 (cmd->data_direction == DMA_TO_DEVICE) ?
-				 "WRITE" : "READ", (unsigned long long)sector,
-				 sdt->guard_tag, sdt->app_tag,
-				 be32_to_cpu(sdt->ref_tag));
+		avail = min(block_size, dsg->length - offset);
+		crc = crc_t10dif(daddr + offset, avail);
+		if (avail < block_size) {
+			kunmap_local(daddr - dsg->offset);
+			dsg = sg_next(dsg);
+			if (!dsg) {
+				kunmap_local(paddr - psg->offset);
+				return;
+			}
+			daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
+			offset = block_size - avail;
+			crc = crc_t10dif_update(crc, daddr, offset);
+		} else {
+			offset += block_size;
+		}
 
-			sector++;
+		sdt.guard_tag = cpu_to_be16(crc);
+		if (cmd->prot_type == TARGET_DIF_TYPE1_PROT)
+			sdt.ref_tag = cpu_to_be32(sector & 0xffffffff);
+		sdt.app_tag = 0;
+
+		pr_debug("DIF %s INSERT sector: %llu guard_tag: 0x%04x app_tag: 0x%04x ref_tag: %u\n",
+			 (cmd->data_direction == DMA_TO_DEVICE) ?
+			 "WRITE" : "READ", (unsigned long long)sector,
+			 sdt.guard_tag, sdt.app_tag,
+			 be32_to_cpu(sdt.ref_tag));
+
+		if (psg != mark_psg) {
+			kunmap_local(daddr - dsg->offset);
+			kunmap_local(paddr - psg->offset);
+			psg = mark_psg;
+			paddr = kmap_local_page(sg_page(psg)) + psg->offset;
+			daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
 		}
+		poff = mark_off;
+		if (!sbc_dif_prot_copy(&psg, &paddr, &poff, &dsg, &daddr,
+				       &sdt, true))
+			return;
 
-		kunmap_atomic(daddr - dsg->offset);
-		kunmap_atomic(paddr - psg->offset);
+		sector++;
 	}
+
+	kunmap_local(daddr - dsg->offset);
+	kunmap_local(paddr - psg->offset);
 }
 
 static sense_reason_t
-- 
2.34.1

