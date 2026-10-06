Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905AF3DB320
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 09:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279289; cv=none; b=YYyZGubriLKRuoaue1KDicIHfC5CxgXdNfBsicjadshXZZx8SgXKFwxScnNhYpBIiDtV5IWHTMXtb/4EFhxInnYSeUfaob3Ubpg4kQin3jRBtMz5Y/LXB9oTJrx+C46Cx9NULVxymkTWMH+06TcSDCoJDPRr4Jy2rglFHraPK6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279289; c=relaxed/simple;
	bh=v2LleU7DjwKjyo5byw/PeaE+ykCm1p6AnsUT0DG35ug=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tDSShxUG8jJRTGBcXMRPicM/guJzJ8zTzkBUYdkDSgz9FsI4ucIIEgCSm1I3cSL7RhwwZhm1eaCDuIsyppg4hJsOYsZ8/LEbCD1X+s/uYaBewUkmLNTKyTmQcHifwaZEM/BcYASP4chWKyrhp3KLOJwK0etajwCK66Oar1/gb50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Xma5nqY0; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xma5nqY0"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3964dfb5b9aso845073a91.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 02:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791279281; x=1791884081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OiH8I2vivbUrNosTf6kMbDPyLsej137IHvnAUOusej4=;
        b=Xma5nqY0pynAzbViNIbPat6cJO99vODJZn1Mta03msl0n95hdeViM1BuTVZC/NDfo9
         JENZbkM+b3G/jrIaDOc8RpFvFrmRXxMYB2aF7lCi6D6fH4TnVZCp0Hti8jWQ9d4jd1x9
         LYZtcRFrP8gKwBtu79IA8WO58O4NtUWwDwpOOeGXv/B5xo4YWBrkdkk0QXtN6DSiCd6E
         EnujXyUE4hyvb0OpfvkyQ4bLSRT5bHRZJBnUpgDxrmY3Q2lNOD8SyFclG2meuO9wGtAq
         gOebO4eZD1HJ8zoijJI3Phy9M8EW8lOwZBwd3ntPUrhfxzG3s1E6FJ0OJHSOvCB4IlPH
         tIZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791279281; x=1791884081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OiH8I2vivbUrNosTf6kMbDPyLsej137IHvnAUOusej4=;
        b=nOOjWUdF0g/kYYtyoA/prWsk7dpt0QtP7qdh/1tBHZ+u7SZfJ9G/Eow7spmGQFVouB
         0J9ncuBVwcIXHNKSJySQhkUXqRPqA8vK27zSN31MInucFcqDLUXS/yROwV5GdRhvhNig
         +b6tRUu/PKrW3/SMhNp0Gt36NdipgqtJPGrf3f0BTzMcVcXVWrI7zEgPxey6SXdY1LYJ
         jmIc74VPrq6vq+TYXFF6ZwhpxevihowG3bUTLKxstCAo2C65Sxa38C9Aquw+GDR4wKDA
         dtPEeGFX2kBbYzgoiAtOAwl4LqygETSB/OiYcmymvg8ZFhKWf2mG6q+XQ4RN4eJ/in1U
         lQNw==
X-Forwarded-Encrypted: i=1; AKwUvByE1dU7fFemmUFoeCrM0k85kfy8GfquZbjn4MkfeVWbmAmIQd6G2k+DVGrphTCCfI32sbjtgmuSNOJ+@vger.kernel.org
X-Gm-Message-State: AFq9FYKX/yl/qQ5BHPDPtkEKgWPfhTJvwcxj+Auw3vD2RBD/kEPvtqeq
	WW6hZQSzCCHJhPdyruh2w/WoTCs9YFSLGXQc+yEkpdVjJhCSMlK+LFBH
X-Gm-Gg: AYBFou1xzthRwyX0OIOJpzNwtf5O1Z7IO5wdWkFM/29gszl3pJgIDRVF01xmRjfyl6M
	15A2Cx+JKA5IioKr629/nsuZFdBNCuEVIZef9u07c7O/7bB2wa+3mOv1qWjGc1xPq0rP3SpUSyy
	wAfWESJJNYYCSvcQ7gBshOIY5STOwUm3N3MdShQZ5MXooR9RYIVm+g6KGTmpdcpZUpOc1t/qjHC
	HkZiEkC9Xln0r9TSTifHmcWfhNEILhf7EzRR+tkQR9lmd6bAvRjS1o2r6JI5nX4GB8G3n+bKUcy
	uImbF6JZfVA7Wvbj+A+kczn3h4A/xUffiYT10Y5xNlNgM6Vi6imbOXdaR2R2m9LBcVxT0vR/emp
	8fECX+AoXBVpbngEiSL1Tq2/8cWNJ926/ioPWfuVpvCOsFnHN/5leVM1gyzYDZYk5l1Ztimfvv/
	Qz96v/oABCT9UokjL8iSsWMKAKuCBImEAwK5byDv+ORAa7iJXcrp9RfowjU9+cuZSQ/zR58F+te
	d5rm+SE
X-Received: by 2002:a17:90b:4d02:b0:39d:f247:bab with SMTP id 98e67ed59e1d1-3a87267ea23mr746760a91.6.1791279280466;
        Tue, 06 Oct 2026 02:34:40 -0700 (PDT)
Received: from gmail.com ([188.253.12.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543ab76bsm3905277a91.13.2026.10.06.02.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:34:40 -0700 (PDT)
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
Subject: [PATCH 5/8] scsi: target: copy a DIF verify tuple across prot sgs
Date: Tue,  6 Oct 2026 17:33:35 +0800
Message-Id: <20261006093338.27342-6-physicalmtea@gmail.com>
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

sbc_dif_verify() loads an 8 byte t10_pi_tuple while i < psg->length.
A protection sg shorter than 8 bytes still enters the loop.

vhost-scsi keeps each sg inside one page. Eight PI bytes that start
at page offset 4092 are mapped as 4 bytes at that offset and 4 bytes
on the next guest page. The first sg still satisfies i < length, and
the tuple read continues into the next physical page.

Software verify runs when the fabric does not advertise DOUT_STRIP.
vhost-scsi advertises only DIN_PASS and DOUT_PASS. With
fabric_prot_type 1, a WRITE is TARGET_PROT_DOUT_STRIP and
sbc_dif_verify() reads the guest PI buffer.

Copy the 8 byte tuple across protection sg entries before the check.
Four bytes at the end of one entry and four at the start of the next
stay one tuple.  A tail with no following entry fails the command.

KASAN reports:

  BUG: KASAN: use-after-free in sbc_dif_verify+0x5ab/0x790 [target_core_mod]
  Read of size 4

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
 drivers/target/target_core_sbc.c | 117 ++++++++++++++++---------------
 1 file changed, 60 insertions(+), 57 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 12275ebad95c..c0aeb8886743 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1492,81 +1492,84 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 	       unsigned int ei_lba, struct scatterlist *psg, int psg_off)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct t10_pi_tuple *sdt;
 	struct scatterlist *dsg = cmd->t_data_sg;
 	sector_t sector = start;
 	void *daddr, *paddr;
-	int i;
 	sense_reason_t rc;
+	unsigned int poff = psg_off;
 	int dsg_off = 0;
 	unsigned int block_size = dev->dev_attrib.block_size;
 
-	for (; psg && sector < start + sectors; psg = sg_next(psg)) {
-		paddr = kmap_atomic(sg_page(psg)) + psg->offset;
-		daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-
-		for (i = psg_off; i < psg->length &&
-				sector < start + sectors;
-				i += sizeof(*sdt)) {
-			__u16 crc;
-			unsigned int avail;
-
-			if (dsg_off >= dsg->length) {
-				dsg_off -= dsg->length;
-				kunmap_atomic(daddr - dsg->offset);
-				dsg = sg_next(dsg);
-				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
-					return 0;
-				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-			}
+	if (!psg || !dsg)
+		return 0;
 
-			sdt = paddr + i;
+	paddr = kmap_local_page(sg_page(psg)) + psg->offset;
+	daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
 
-			pr_debug("DIF READ sector: %llu guard_tag: 0x%04x"
-				 " app_tag: 0x%04x ref_tag: %u\n",
-				 (unsigned long long)sector, sdt->guard_tag,
-				 sdt->app_tag, be32_to_cpu(sdt->ref_tag));
+	while (sector < start + sectors) {
+		struct t10_pi_tuple sdt;
+		__u16 crc;
+		unsigned int avail;
 
-			if (sdt->app_tag == T10_PI_APP_ESCAPE) {
-				dsg_off += block_size;
-				goto next;
-			}
+		if (poff >= psg->length && !sg_next(psg))
+			break;
+
+		if (!sbc_dif_prot_copy(&psg, &paddr, &poff, &dsg, &daddr,
+				       &sdt, false)) {
+			cmd->sense_info = sector;
+			return TCM_LOGICAL_BLOCK_GUARD_CHECK_FAILED;
+		}
 
-			avail = min(block_size, dsg->length - dsg_off);
-			crc = crc_t10dif(daddr + dsg_off, avail);
-			if (avail < block_size) {
-				kunmap_atomic(daddr - dsg->offset);
-				dsg = sg_next(dsg);
-				if (!dsg) {
-					kunmap_atomic(paddr - psg->offset);
-					return 0;
-				}
-				daddr = kmap_atomic(sg_page(dsg)) + dsg->offset;
-				dsg_off = block_size - avail;
-				crc = crc_t10dif_update(crc, daddr, dsg_off);
-			} else {
-				dsg_off += block_size;
+		pr_debug("DIF READ sector: %llu guard_tag: 0x%04x app_tag: 0x%04x ref_tag: %u\n",
+			 (unsigned long long)sector, sdt.guard_tag,
+			 sdt.app_tag, be32_to_cpu(sdt.ref_tag));
+
+		if (sdt.app_tag == T10_PI_APP_ESCAPE) {
+			dsg_off += block_size;
+			goto next;
+		}
+
+		if (dsg_off >= dsg->length) {
+			dsg_off -= dsg->length;
+			kunmap_local(daddr - dsg->offset);
+			dsg = sg_next(dsg);
+			if (!dsg) {
+				kunmap_local(paddr - psg->offset);
+				return 0;
 			}
+			daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
+		}
 
-			rc = sbc_dif_v1_verify(cmd, sdt, crc, sector, ei_lba);
-			if (rc) {
-				kunmap_atomic(daddr - dsg->offset);
-				kunmap_atomic(paddr - psg->offset);
-				cmd->sense_info = sector;
-				return rc;
+		avail = min(block_size, dsg->length - dsg_off);
+		crc = crc_t10dif(daddr + dsg_off, avail);
+		if (avail < block_size) {
+			kunmap_local(daddr - dsg->offset);
+			dsg = sg_next(dsg);
+			if (!dsg) {
+				kunmap_local(paddr - psg->offset);
+				return 0;
 			}
-next:
-			sector++;
-			ei_lba++;
+			daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
+			dsg_off = block_size - avail;
+			crc = crc_t10dif_update(crc, daddr, dsg_off);
+		} else {
+			dsg_off += block_size;
 		}
 
-		psg_off = 0;
-		kunmap_atomic(daddr - dsg->offset);
-		kunmap_atomic(paddr - psg->offset);
+		rc = sbc_dif_v1_verify(cmd, &sdt, crc, sector, ei_lba);
+		if (rc) {
+			kunmap_local(daddr - dsg->offset);
+			kunmap_local(paddr - psg->offset);
+			cmd->sense_info = sector;
+			return rc;
+		}
+next:
+		sector++;
+		ei_lba++;
 	}
 
+	kunmap_local(daddr - dsg->offset);
+	kunmap_local(paddr - psg->offset);
 	return 0;
 }
 EXPORT_SYMBOL(sbc_dif_verify);
-- 
2.34.1

