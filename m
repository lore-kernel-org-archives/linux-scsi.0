Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 553DF44C4FB
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 15:55:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166104; cv=none; b=uLE9EC3CuZ/dt89mYw6q/Qn1Ln0KX+GKroC+hVcpKnO9s9QfYn246TsvZGzacTdus5Z12mCeMO7P28eYBAbRngvruo6mG0zr7UhkT91xdKtTFBIXNVrjAR0aZhXjWcMP+A20eARD637h/tWyyKaoYq9beCoJS6zxRwgZ5Gxqjgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166104; c=relaxed/simple;
	bh=3FHL8H8WmJo3KmMRdVqq/3MRZml1VzjOBDNGQ7/pIfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YtZ+pfKK0j7silhL9+cahrW04PYe7K2FLGhathYGm6iGJ1vIl8h2haP+t43oHUuQjuFOHZdH7kOSj0l3G+JVBP/BV5Ovg7l7UgHZIzEQKLwO1mmghiKKy5uNQ9hOqINPpHxISknosb2Eo1B7P21TAPI+dp5cvEggw6LbkdfjWRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=dsCMNsmP; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="dsCMNsmP"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc52c1b8286so108291a12.1
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 08:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792166102; x=1792770902; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J2LRXjRZMsgsI6TbLIpT8JXpII70C8p2ozsHbUGAzqE=;
        b=dsCMNsmPgf1gKW6zL0vlBMHZkyr6k0NAJVT7gamrsC7wBYkda9JuMSX9IylZWdJtqy
         hdWvcSzsVeNGWWDdHO0xUttJeOGDuIvo8xjWhIhF8usCFSW3HvW947U5e9xzunulWXUB
         KqgGiDb1hbNJXnFmgX/IIss9SIlkeVeKQ8BYATw3PAaUeYnqItGNJfs4WznkAb6nCQC6
         xA8o0AfrlSZb7jgqnojTL2MkldiNgj0b+wVhSZ9kgHFHUqK+AoNUev5WnOf7TPuuEiEt
         98ZqRn90Dq9e2yfrYoNlwKrk7axR8sbk3HkhvRJGMbnaAk5VxddLsYv+agtl9aBhJrk7
         yiVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792166102; x=1792770902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=J2LRXjRZMsgsI6TbLIpT8JXpII70C8p2ozsHbUGAzqE=;
        b=q7JgcsPKY1WGcz/7Q1hUbesejV1Y5cAiep+HqSB840w/BQuwxzGmZMTj8JpJ1zamld
         7OD2fbDiTw2BKJq9KycW5/quI/bkd5Py4E1KOVFGaj+swHU2tXXDOXF4iz3KPlBaJMfk
         WMRHrfRj1Ng9B9waar2yj46+B3czEqTNzxcXifNwXy9x6ZEOVCFtN7O7pzF0QJjNWYDL
         rE5Msd9J0JHOYRmmgJY9Vw+JsOySjThfU/Mw0cf8pJJQKBwQqLUdEdAGd7s2LTydXiRE
         w3YYz7NlKr68OJ8jZZKeavWwEO+5RqLCrZR6g8U0xODhAWpc73I+NqxN6TCE5agjFQ5G
         vA9w==
X-Gm-Message-State: AFq9FYI9k9A31VdYH0BWwbYuLdRV1RP7YXc6easSAqwm8ulLLFPwxkgZ
	nygCMlNlV88YmxzmEXGa2Q5/nOhgpDTXJdcIariyEk/IEWkc4YoygZ/FkAXZwwW6gn3tYPl7jqO
	W7sb6
X-Gm-Gg: AYBFou3HxnjT0XvHbLrsjtZibRX5UGF86M89C6ROIBz6iow50UjOjY4qQ+ptTO9/FDm
	v7xPCIVfdnmOxKuY6wlIllwSHEUfkG06IBNFpo0Dpnhz3ngeYvwNBSovveN6/aamDT7wvvivi9f
	8AXgKRbd46jaYPlcgw+s8BRwGkzpHWkXD6PgMPk8qYeIUqywlaivg8IBShZbxEUCErdm/hUex4f
	AqQJbW+O1/1cRANLVd0LHRVQU5gamM8xxbARCmkZmiZShr5GRP9YlaIlPv0iAY9mlSiKfRF3/EN
	OAMtE74dQ8M1sg7IfpNfC3s9rw/MCzm7yXSgTPWOWq99zCR07NpRn9uiBX8znq5na6sMScCkMWg
	kq355xjf9IGvxAFhjg0LyYApdEfRUr+j5ALYYku1bp3c2ZjeGcZv7Opw7caGyb+pJJe8YSbflrX
	IlbXlX2J82hkRuYscmS0pHdNVNfbd2X8j6QJlpgw/p9vGynbsZs1hLLH4Cu1Zw+eAz8yXuDE15n
	nWrOoLokEM9aza2F3kIIg==
X-Received: by 2002:a05:6a21:3981:b0:3e2:1927:3acc with SMTP id adf61e73a8af0-3e21927d82dmr782314637.13.1792166101596;
        Fri, 16 Oct 2026 08:55:01 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:5e7a:332f:f584:a3d8])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd65ab63cadsm983076a12.4.2026.10.16.08.54.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 08:55:01 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v5 1/3] scsi: bfa: clamp the received unsolicited frame length to the buffer
Date: Sat, 17 Oct 2026 00:54:39 +0900
Message-ID: <20261016155441.1607196-2-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016155441.1607196-1-yhlee@isslab.korea.ac.kr>
References: <20261016155441.1607196-1-yhlee@isslab.korea.ac.kr>
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

