Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2AF23FFF84
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 08:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792139314; cv=none; b=OjVcRqaQ4cOVSMpe9x0OC0yT2EL4ByGJvmR/72KuAiRXONRGkHgKxSLT44ubOF1+0XGHt+7iIKkErbxLSAvrR3RxULhBc68CC6H3JqFFrt0o1lT+CEcRU7b2Xq4Nkro0324XYr9DmRIsEniaIa+3yNolwbjl9JaHH2Zo9HAB81o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792139314; c=relaxed/simple;
	bh=56DHsbFjbbt032La1ZDE5ZQ6b4jYchWtNS/Q4wqnSSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IXrCgPnwOVoyuoEhXRUQolcyfJIOY9+gxi+9N3cEjAJEGceUbg/Fv9LwU+bfdCpEFXaDsBBiRKYq35oWDJ8NjXeqp/utxeGPWZ+UxzGMfNwkIo+T05MnzfvTsWhmjOlLYo2CZVZxtEIhMhFkqY/pcjrRP01Tqye2Ykj+hw7+KGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=NEVNAb/h; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="NEVNAb/h"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3acc96a256dso323646a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 01:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792139312; x=1792744112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3OFybTCapRj1qkibinKvw/kI5UMMbhQYY44MQA34050=;
        b=NEVNAb/hFkhuBggq2r+sSNzQPZ1rV6n848g9w2pr7CmWzTCLrgPFCZP+JqP3845Vzw
         Z7x1fRrIhjDCyzHQjGERPwm8PL+gh3b24y+wrxnDrxWoVH0TJsAm0OiyuEUIhrOo+tj/
         lPWzY/y8iaa5DB/bBYwDaEcF1H53bDz1QtNkvIABBHTVEXUCaIiX4tk5F8Vq+GDS7GIe
         N8SAX4eEkibhFcrqWe06l8ih1j6ZMlBwP1paPB8dhx415TBx9rR4yUoxvsOX5xWnRakS
         PqBGgwtG86Od9pGCiAIyHGN3n2q5uT+NgtJNQSLTXT8A4bmli1xcQrMFMzxgHjqIg3C1
         b9zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792139312; x=1792744112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=3OFybTCapRj1qkibinKvw/kI5UMMbhQYY44MQA34050=;
        b=DckerG8Shzd779Ndz5rIwgTIR8Os/LOy0Y3iYV7llwen4KbzhxF2kWI9jumkTg442D
         Kp0MdeRdQVvuS5SPALX9BKD4vbcdEUqgB0bUgkGaUOtvDQ5h/NvLD1Qa4BQ0kApeBlZB
         pQiEdVgnNUXnUXRtbQtsUgJatoa5YaqGNrJxAl8ukK400vLjVNhV0R4nU7eAYeqd8I6g
         HQfmnKvsenqHdMGmZyZ3VVngg5F/kqXdhPsukALiTqILOa18nJj3QZTCxxuiPy3Y96nz
         2W5XrCJ0Uq/1L2/VYm1Anop0pBtTy6vRqPJPmuH0E5KT9KsrtgE9iZp+LZI9l3LHeemN
         xpog==
X-Gm-Message-State: AFq9FYJki6cJlyfX519W1qgup/OpNfRtXo+8U2tiwHOoFEq4vD4tTmJm
	//TvfddAAYpJwWaq8KXzTEBs9LGiw3kyvDsThJeJjZ3VnwyFQKt75jnaKStY6XxGhG4=
X-Gm-Gg: AYBFou1bi4RB0fgpWh5KeAFpqe5S3sOcqn9pcMbCD1J+DtV2uYa64S2aUegxm+9RuRY
	SOZ8Wjg38xWZxz7KNZfOXHkrI2De+JuNRVRLnGOW1yO+qu+jPvCpZrbyS8NTZnuHx7Dc0kkxQTp
	x8KXdflvXeLF6+2/k9ijZdAFlx7oN9V6NE06ZrnnQqEpA2O6gpguIZR0D6KVh7nFnywTEHBLdX1
	xMn5JnyMiStTv+sBtYB47mwNZ4PPEnmysmVc6jYPCrNj/0sWngxPu1vNv5jSmqkA6pmsSyDLTmY
	umE5n4waQiyBF8LQpZhOfRPm/BwLs0oe6j0HmfCXj20R9JCM+qcg4hVf9ykdgSxNK7zHE9MrTns
	byJ44N63VQRodOeiv7YlePf6NmZ8LPLL4tZqdMP8raJUwKZdcKepSDlDOb/lfVJG4QZVKjS9SkZ
	NvT9wUgcA6t4pyDDEw23D/3s2K1RFbMzxINi9CW1EWvwdjqQCAHH3cQGO0dNkG7a8FFiGUkqQPk
	JcS30G2T/DjbEP5
X-Received: by 2002:a17:90a:1582:b0:3ab:9f1a:3825 with SMTP id 98e67ed59e1d1-3ab9f1a4af4mr10274048a91.4.1792139311983;
        Fri, 16 Oct 2026 01:28:31 -0700 (PDT)
Received: from yhlee-960QFG.. ([125.131.91.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc48f19d9sm3088933a91.11.2026.10.16.01.28.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 01:28:31 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: [PATCH v4 2/3] scsi: bfa: drop unsolicited frames shorter than their VFT header
Date: Fri, 16 Oct 2026 17:28:17 +0900
Message-ID: <20261016082818.1237059-3-yhlee@isslab.korea.ac.kr>
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

bfa_fcs_uf_recv() keeps the received frame length in a u16 and, for a
frame that carries a virtual fabric tagging header, steps over that
header:

	fchs = (struct fchs_s *) (vft + 1);
	len -= sizeof(struct fc_vft_s);

Nothing has checked that the frame is long enough to hold the header it
says it has. A frame too short to hold its own VFT header makes the
subtraction wrap, so len comes out near 65530 instead of going negative,
and that length is what bfa_fcs_fabric_uf_recv() and
bfa_fcs_lport_uf_recv() then hand to every ELS handler. Any of them that
believes it reads up to 64 kB past the frame buffer.

Drop the frame instead, the same way the block right above drops a frame
whose virtual fabric id is unknown.

Fixes: 7725ccfda597 ("[SCSI] bfa: Brocade BFA FC SCSI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
---
 drivers/scsi/bfa/bfa_fcs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/bfa/bfa_fcs.c b/drivers/scsi/bfa/bfa_fcs.c
index 9b57312f43f50..711d2ed83a7aa 100644
--- a/drivers/scsi/bfa/bfa_fcs.c
+++ b/drivers/scsi/bfa/bfa_fcs.c
@@ -1552,6 +1552,11 @@ bfa_fcs_uf_recv(void *cbarg, struct bfa_uf_s *uf)
 		/*
 		 * skip vft header
 		 */
+		if (len < sizeof(struct fc_vft_s)) {
+			bfa_uf_free(uf);
+			return;
+		}
+
 		fchs = (struct fchs_s *) (vft + 1);
 		len -= sizeof(struct fc_vft_s);
 
-- 
2.43.0

