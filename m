Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D743E559B
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 08:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792139314; cv=none; b=Je5u6FTHanqtbGePJe+vejZHVkAYksshOxDKsxO6hMcDSbwG33lDttNwfxViuZsYZBMT7uF7a3Pio6XWxdHGwuMTBgNsNrTIAh2gGZGJKwtx2jmwIH6aOyQ83v1QEQrHKR/M8GlcQMFE52zwlgs58PLikskVojBtqwkvDoP8EuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792139314; c=relaxed/simple;
	bh=3FHL8H8WmJo3KmMRdVqq/3MRZml1VzjOBDNGQ7/pIfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iGixfyFMSQpoxEJeON53uhxSAjr8Z1j/ZUVeHSYsZbDVQ+KJDIvymvzejES+q9B7jPDLU436DQETA8tQY1Zdb6W/NWmZHFa6/ccmSd1Jtm1NnzbVRnC3mlTkhyETowVXKbWD+NfOIXF+HXPJLfciCWO04uyDLfZC4Fol6PIOgvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=ILv0tAgJ; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="ILv0tAgJ"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3acc96a256dso323636a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 01:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792139311; x=1792744111; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J2LRXjRZMsgsI6TbLIpT8JXpII70C8p2ozsHbUGAzqE=;
        b=ILv0tAgJyNFEqIqGMhEu9tF6o1Tt6aWKNBtFOzb3JqwZ34PUGsZp13wuf9fD3Nh8CK
         HnV7xIHCbGOaOFm/xfGX/kKrKbROssYb3bWr3GhaQkB6lD1Ty9LHrLwNxCzRuauAsUzh
         3+jMSbxxX8cISnvOVFv694kOrV8SOVI7FSeAN2OHX+fXUUQppUSeuMyB38aGwusBadF7
         j9Uqf7Yp5Q/3K9o7dsrmJGVHqQ+GHPmXqDcfYdIhzFQxMYQChhnUUGQlqep7yM8O4kGk
         6Rx/Pl8bLIn03D0LSjQXfmNpZnlWZkVnvPjcFgx30PLnYuUpu8N+Nk+3Ss/A14REhd8b
         QBkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792139311; x=1792744111;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J2LRXjRZMsgsI6TbLIpT8JXpII70C8p2ozsHbUGAzqE=;
        b=K1TYr0UaZWN3Nw72mcwe6MuooR4qWg/BCeXtkb8NnPpEnAyerAlLyMJBOwzV/rpVrw
         rVU/YH35iE7egCWFAlvfaF15emIzyXeqPMFgT0TC5KzOIhTu2aGUTQo6YwH8+fZrAkXr
         YI6tQ7rdhbWeWJOuu37s/OPIgSmTPAJ2I5wop/qDsnupypdEvMcHkGCoqcn+vGLCUjJY
         weMLRgYU4rs2TDY3CeKYF+T4c92pzO6Rg1hfdMH676ufBwlj1nrpbDbZH2ejJpnvS51n
         49duo7MIvDGydpuhHZ5PUDgeuKlHoMww/aozntAqjsRoMmItAndXZ8OIoc4PhMKUlT5f
         K0fw==
X-Gm-Message-State: AFq9FYIZo7s4yoZfxOAnvBNBp0Q0vO+WE8pw60yf7aHrTvTtkNxsLqEm
	h47FozIegDDFx3g+Rf6oikVSxozhS+s78CABoxZPLlJ9KGv5VpNQXMK6KShcpxSXz4o=
X-Gm-Gg: AYBFou30HXhyIiEF0SragQfShztEE2TQfJLwxX2s7prk63dGORSmVV2Oeks6+VIrN3h
	2TSk7h6J+Jaqm527DEJJTMbQiXFHh38JjanQmoZQgNgKCB5+o85TOPfUkcqkbDlvbuEHedvxFmK
	9LJ1FbjIx6eq3UMW/u3hJnTu9lcqsTkwfV0/LTd8+WZLljNoWr0b9LywrxaSPe/jnXmpXNr8MJh
	Y/lnItLQJiJ8DlEfKl83ll393mDfqUPnXrXlrnwh6oje7ppOaNjfOV3uueNYaSCNZShogY7vOlz
	qN1/EykXtRq99cYp4CQeLLAL51S+Ld/i4+0MwPPnu2NWiJXidPSQlgsjU/WSQVYrdoD0qHXf8vr
	OUCkWppklyUiKSun+4jVgfrgfa1zBUemVqXSwI3s6BPt+V9kR1b58XhAhf1Ps8wqF462TR/jUdP
	m7DXamuPLY1VEFlCnwzb9DycR0fMhmQgfQ0lvvqgx2M6qBE0lLZimhlWXp2VeWnn5fQpuOycZVv
	YT8GA==
X-Received: by 2002:a17:90b:518d:b0:3ac:9c37:9429 with SMTP id 98e67ed59e1d1-3ac9c379aa3mr4790623a91.52.1792139310414;
        Fri, 16 Oct 2026 01:28:30 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc48f19d9sm3088933a91.11.2026.10.16.01.28.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 01:28:30 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 1/3] scsi: bfa: clamp the received unsolicited frame length to the buffer
Date: Fri, 16 Oct 2026 17:28:16 +0900
Message-ID: <20261016082818.1237059-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016082818.1237059-1-yhlee@isslab.korea.ac.kr>
References: <20261016082818.1237059-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

uf_recv() takes the received length of an unsolicited frame straight from
the firmware's completion message:

	uf->data_len = m->xfr_len;

	WARN_ON(uf->data_len < sizeof(struct fchs_s));

The only check is that lower bound, and it only warns. xfr_len is 16 bits,
so a length of up to 65535 is accepted for a frame that was DMAed into a
buffer of sizeof(struct bfa_uf_buf_s), which is what claim_uf_post_msgs()
posted to the firmware in the first place:

	buf_len = sizeof(struct bfa_uf_buf_s);
	uf_bp_msg->buf_len = cpu_to_be16(buf_len);
	bfa_alen_set(&uf_bp_msg->alen, buf_len, ufm_pbs_pa(ufm, i));

bfa_uf_get_frmlen() hands that length to the FCS, which passes it down to
every unsolicited frame consumer, and they believe it. The worst of them
is bfa_fcs_lport_echo(), which takes the length as a memcpy size:

	pyld_len = rx_len - sizeof(struct fchs_s);
	if (pyld_len > len)
		memcpy(((u8 *) bfa_fcxp_get_reqbuf(fcxp)) +
			sizeof(struct fc_echo_s), (echo + 1),
			(pyld_len - sizeof(struct fc_echo_s)));

The destination is the fcxp request payload buffer, which is
BFA_FCXP_MAX_IBUF_SZ, and the response payload buffer for the same fcxp
sits immediately after it. A reported length above 2328 makes that copy
run past the request buffer, so this is a write, not a read.

Cap the length at the buffer that was posted. A normal frame is not
affected: FC_MAX_PDUSZ is 2112 and the posted buffer is larger than that,
so the cap only takes effect for a length the buffer could never have
held.

Fixes: 7725ccfda597 ("[SCSI] bfa: Brocade BFA FC SCSI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/bfa/bfa_svc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index df33afaaa6735..1ccf2e994a671 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -5453,7 +5453,7 @@ uf_recv(struct bfa_s *bfa, struct bfi_uf_frm_rcvd_s *m)
 	list_del(&uf->qe);	/* dequeue from posted queue */
 
 	uf->data_ptr = buf;
-	uf->data_len = m->xfr_len;
+	uf->data_len = min_t(u16, m->xfr_len, sizeof(struct bfa_uf_buf_s));
 
 	WARN_ON(uf->data_len < sizeof(struct fchs_s));
 
-- 
2.43.0

