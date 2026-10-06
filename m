Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299A83DC4CD
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 09:34:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279299; cv=none; b=dgDEjqZANlBRYK2J8wiNsMUkrQXhe56LBFyewshC10EyilYxWGZYfR4/0Ow3XXqQ9UpeePEtHH2K3Cg+Vbs914jiwleVFqGbvmIZs4CxiobYrRlFr+4spfPA/DXj2X3OqMe9f5rrqTgV2VR/GSkrdthbIiKhT9wdo7lMpojQdlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279299; c=relaxed/simple;
	bh=WsLJKfD4eIsxgUWDfay5EKa72kdZ0tjnBWJyqqBv1+k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=US14PHihEo1rW3f0wvlwIZmLXsnxVDljCd5yYnsGIMuG/3s2EENLXFSBSeZxd1l/G83qZ/RumEuyn43ryhYvZgwwjYq50oJSY4EK5B/qbXgf+HauYVQDSC+7DTdkNt3OuK1itcx7Zy9Cu90uN/2pQWptZz0s/LgFPNj5ZD7KGAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fjYC2duS; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fjYC2duS"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3a0a55fa355so206652a91.3
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 02:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791279294; x=1791884094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1uz8HoiiEKQyA9qDT7OXJyTdmhx4sEKhN2lImiOzD/E=;
        b=fjYC2duSkBPmoSUheHcKoESsWy1QBtkE/rMGy5MOYYCN4WapRELVFzH8a8Ecnw4/lE
         haJUGx8FOCrJLEqly8GnYPgsGmCHiDTRE5YIST3PmjAnU/o6hnG+JSLf7PuECaU0AD6J
         +D+JwKa9akCqwCVGOh3Jp7NLOkOYVSrwypAhwyhD0181KPnVGha6S+1eXssq4faBG7AK
         lxPWuiPDFbcjf188Ig7LNWW8FHfpeF1OnuXUDHiGUV7QYfvZMEQA1ZC2S/X78mp109nj
         WYkCdwUm5TpHL3UtvK3+182W30TwgBFBhxmr1NAR4Y5RBrahKWS/5UoCiXq9Gs0c7oZ9
         9R7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791279294; x=1791884094;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1uz8HoiiEKQyA9qDT7OXJyTdmhx4sEKhN2lImiOzD/E=;
        b=VJ6xEQhxLOQvemYnvbBv0mdOh6czx9/9uKg6a+ksirDE+j8Ge2kRf5sxWpA4iHy9xs
         kU88xa7TR91/9c6duVWY6xvvs2nSJvh4BGUcYuXU0L9Vt6DlktlqDnEG+XCERvdcGbg8
         FXFrBuHAVwazrEceowoPRVkRnssRughjGMsTOmnQ1HBCevBbkK2Vo4+fr36PsAIgaYhx
         ZrJJ0APvaFqYlkqXzju/nDc5lMFJB8Blxe1SvUE4qIHQIOt3kpQQoP1GAwqzRxMaHsGu
         WD+UhM2fbmqP8MNiJe+WU9N46HnJIBybAD56O9wbiEvC2ryUTgDXs2AFnNsT90cGUFfX
         1RZw==
X-Forwarded-Encrypted: i=1; AKwUvBxW5ArOVel8dFbvKJ3QmVAtbtQvpPu1ih4jRFYNiSAW70t1xq7Kd7TIogqZUOS2NACzuzJ3alG/GyR3@vger.kernel.org
X-Gm-Message-State: AFq9FYLgFozoavpiZbWLoy49MH/JEV8PPyDw13IS9IyULk3wrXJsr2FV
	pK/NWPa7NpNHF3jFhnJTarCNTSVr8ppZB9yF0I531ejpNdhX/NLtsN8o
X-Gm-Gg: AYBFou2ELeBKEtU6aO+7qFYgJ0nZ+8/BkoGHPe99Aviou+G9VSCWwXcnyXgJW4yPgjr
	IyU1B0LaDD1qItMll7WYArNGHBnRQjiUa4L/3osonKXoAvXxX1fQVosVpkMxgrBgTYGIu9CVeKc
	tNsxnaAUHJy3vqsYQnTC2U2RA2GnJLbElxohr9WuFeFGxs/dAbPnJt4rG8rz0tbnD+zyQCv6l2q
	Ca4ZvmeSdMvg5Tl2nG3+2ZHT1ceIp7/s4VDPIMzTz0nd/blu3tZLnX+pkqUrIXJ7sDhRtZpuYbN
	AaK/7pEK37NCT7XPBW+njq2xs+wgnXeWMMvmuSkhYsGHxtFlclHn1ElAQkCMaWxxm/IzcsoJfyr
	U9H1tdRImKvHrK9Xx8RN76SfEHHJkazcs9USh3ZXYbQeYSm7mzlF62auYvwmOJ8fAaA97fG35Gg
	4Mo6yRL0wFxFhhy0GNmIRZJk7kDM84oUfvUyuVXZ0DFfwnoJyhNiuYUmR32okje7GXaeaPVQ==
X-Received: by 2002:a17:90b:384d:b0:3a4:c11d:b794 with SMTP id 98e67ed59e1d1-3a8730eacd9mr324677a91.14.1791279293582;
        Tue, 06 Oct 2026 02:34:53 -0700 (PDT)
Received: from gmail.com ([188.253.12.30])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8543ab76bsm3905277a91.13.2026.10.06.02.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:34:52 -0700 (PDT)
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
Subject: [PATCH 8/8] scsi: target: skip an escaped DIF block inside the data sg
Date: Tue,  6 Oct 2026 17:33:38 +0800
Message-Id: <20261006093338.27342-9-physicalmtea@gmail.com>
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

sbc_dif_verify() treats an application tag of 0xffff as one skipped
logical block and adds block_size to the data cursor.  The next tuple
folds that cursor across a single sg entry.  When the block spans more
entries, dsg_off remains past dsg->length and the following CRC reads a
full block from that offset.

A 512 byte block split 256 + 100 + the remainder, with the 100 byte
entry ending on a page and the first tuple escaped, reads the next
block from the next physical page.

Walk every data sg the skipped block covers.  Those data pages are
mapped with kmap_local_page(), including the page the cursor moves to.

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
 drivers/target/target_core_sbc.c | 46 +++++++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 76dbc986e887..7c4f66c2607a 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -1521,6 +1521,46 @@ void sbc_dif_copy_prot(struct se_cmd *cmd, unsigned int sectors, bool read,
 }
 EXPORT_SYMBOL(sbc_dif_copy_prot);
 
+/*
+ * Drop @len bytes of the data sg.  An escaped PI tuple still covers one
+ * logical block, which may cross more than one sg entry.
+ */
+static bool
+sbc_dif_consume(struct scatterlist **dsgp, void **daddrp, int *offp,
+		unsigned int len)
+{
+	struct scatterlist *dsg = *dsgp;
+	void *daddr = *daddrp;
+	int off = *offp;
+
+	while (len) {
+		unsigned int take;
+
+		if (off >= dsg->length) {
+			kunmap_local(daddr - dsg->offset);
+			dsg = sg_next(dsg);
+			if (!dsg)
+				return false;
+
+			daddr = kmap_local_page(sg_page(dsg)) + dsg->offset;
+			off = 0;
+			if (!dsg->length) {
+				kunmap_local(daddr - dsg->offset);
+				return false;
+			}
+		}
+
+		take = min_t(unsigned int, len, dsg->length - off);
+		off += take;
+		len -= take;
+	}
+
+	*dsgp = dsg;
+	*daddrp = daddr;
+	*offp = off;
+	return true;
+}
+
 sense_reason_t
 sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 	       unsigned int ei_lba, struct scatterlist *psg, int psg_off)
@@ -1559,7 +1599,11 @@ sbc_dif_verify(struct se_cmd *cmd, sector_t start, unsigned int sectors,
 			 sdt.app_tag, be32_to_cpu(sdt.ref_tag));
 
 		if (sdt.app_tag == T10_PI_APP_ESCAPE) {
-			dsg_off += block_size;
+			if (!sbc_dif_consume(&dsg, &daddr, &dsg_off,
+					     block_size)) {
+				kunmap_local(paddr - psg->offset);
+				return 0;
+			}
 			goto next;
 		}
 
-- 
2.34.1

