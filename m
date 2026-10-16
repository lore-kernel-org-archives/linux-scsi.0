Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD99B48DB53
	for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 18:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792175182; cv=none; b=mIR2sBXUzeRM7SMJ02DorXFLadq/d71+nhQU4d2SpJVTfjsKpXTrHU8JOZdyPLyGf3IGhs4RSpxLPXZ9C1O/vSFXXKFAvJIsshWdpsJwuDwHIZ3Aw2yxC5lCyW5Ttls0MS30UqS8gOrEG2aLTA57L3iZ62o5Jg0U9ABSA0h3Ziw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792175182; c=relaxed/simple;
	bh=jkFOu7HnMRYPfDwUq4qbWlULVS0j3powUY361JQlms4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K8pFaveHz94xsYEt/sRxo60bMu01yif3ZD+z+fNQPQpdFfSMmvy+DUhtBp6aKHTFPun32iF4hmVDR62OETM+EJpkPbMLSdzcVLxR8ujXZIAFhjzWn7hRdpd/vklCDy6qSu1IgKKUkHHpVe1G3V8AQ3aaFfOm+rGs8lSN2skz8EI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=n+DuZRUF; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="n+DuZRUF"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3a4cdc9025bso247770a91.0
        for <linux-scsi@vger.kernel.org>; Fri, 16 Oct 2026 11:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1792175179; x=1792779979; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jkFOu7HnMRYPfDwUq4qbWlULVS0j3powUY361JQlms4=;
        b=n+DuZRUFf1W7l4I5AOagXYU2sSV+p6s8N3Gsta+sjvuaQdKlOujnt/ffhTFJSSPoFx
         uGbdG3BGNFKfluo/+JzJ2Zp6rIzDPV0osM0RVm8Lwz/dr8Hz+Xtak7FmoXjfy0hgQgEx
         Z0BiG7H4xHl3M9YLswz3/XC5L5Vb6A7OJDl5pm6Z6ovnYuqIjJmOdPLpv75vI+XcAVqd
         wqxMDhkPYRwTEQtSL+xRCvPQbXROTJHPRuhJE6yJv9kgRhhmdKwcwJPjHTl1NpBSwMGL
         zKgTLTeC85CHR2jnhpJYT68Xu/v0Y0GtU0GGPicS+BMtpU25FisJlnfWtboAMl4az54y
         MJjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792175179; x=1792779979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jkFOu7HnMRYPfDwUq4qbWlULVS0j3powUY361JQlms4=;
        b=YVNiZPz6KtH66UBVBxdEYh0KyG+HLHUgcCg8u4GVkzY6beP8pEQOKJlWmIE2EGAvoM
         QU4CstA15KJG6axlZQTJjyu0sWRyheS9wTDulTISTOkw98h/HHesdwdn8nLMWbr2kf2V
         J6ck7nHLyTTOmOVahmOWRmye7ieuvoJvnoMEG2VJaB8ND+xkPCZVhw+4eJwOrIuciMHc
         5TXePdslkBzLnMpHnnAfR5IAEuYi2750ZnAVHlh64aCCpKGGtmBf2tt4hCLpvWV/i56q
         eWQo4g/0h0r/ORdJj3GnWllH3lROD3KjvUygeyS7uuv80QQZY4Yw+ZFoelCc2ER2MvGA
         GJ5A==
X-Gm-Message-State: AFq9FYLllGaSKaIzapMa82N+HOLcM5V3ozCkE3QFat+eYPvM4a/QRy20
	tQAsg89A80HCQe5b9668NndVq0Y3RZYW0Eci8Kle8M5vGqa8mYLC86AJK+R0rVk8MKU=
X-Gm-Gg: AYBFou3gZQj8cxCNSuJvEFwKGvb2AqjJQZM3dkjG6d9dDl1wAtCpJgcFVnjw/XUpEXe
	ZmxowY0W4eARHm7OBgfteeIgoNpHIvxrtJ7lQERv/YeDhqPXTEDg+KrWVjWhfeDXBH2mvJM68wj
	duD9evKRyAywi102sohJCy5mEIkETRx7IJHMEy3NpiQkVdOTXbvjrA4KWCbPn7Dgvz7o26KiXjE
	p5tlknmo9cjPewr5///6MYSQ5Ko86u6v6dfedpS1VUNsOsRZG5QapPXJ8fm7QiWsocZyVFubPXh
	LCHm4Sg59m3y7QOZ8rZwAFIV9DyXHnqcCLlk4rO8lJG76rJhwke7VUNCvb1WHtUTctIg8z8Tqcw
	34GVzynAIMyyNLVc7bnUO6W9p/XWlmedknvy+McOGNR0DcST00Hm+/QNM3/6Q6+bxM6Axz55gxe
	a28dLrNimsRPLpVHbtONYwWyDHEDkEB1/ChpG4RzOrWfIQ1WgH81KW+aF1pa5g8M7rswIQ86jGL
	KQFnd5AZJ6y1EWRUBzwZw==
X-Received: by 2002:a17:90b:4c4f:b0:3ac:450a:fa46 with SMTP id 98e67ed59e1d1-3aceefbfc80mr546654a91.10.1792175178620;
        Fri, 16 Oct 2026 11:26:18 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:5e7a:332f:f584:a3d8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc46ecd32sm5203744a91.3.2026.10.16.11.26.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 11:26:16 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v5 2/3] scsi: bfa: drop unsolicited frames shorter than the headers they must hold
Date: Sat, 17 Oct 2026 03:25:59 +0900
Message-ID: <20261016182559.1750179-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016155441.1607196-3-yhlee@isslab.korea.ac.kr>
References: <20261016155441.1607196-1-yhlee@isslab.korea.ac.kr> <20261016155441.1607196-3-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On the 24-byte case: a frame of exactly sizeof(struct fchs_s) passes the new
guard, and the dispatch then reads els_cmd->els_code at offset 24. For such a
frame that byte is past the frame, but it is still inside the unsolicited-frame
buffer, which is a fixed sizeof(struct bfa_uf_buf_s) that claim_uf_post_msgs()
posts and patch 1 clamps the length to -- so this is a stale in-buffer read,
not an out-of-bounds access. The two handlers that use the length,
bfa_fcs_lport_echo() and bfa_fcs_lport_scn_process_rscn(), are both bounded at
24 bytes (pyld_len == 0, so the memcpy does not run; max_entries == 0, so the
walk does not run).

The minimum cannot be raised to also cover the ELS command word, because a
24-byte header-only frame is legitimate: ABTS is a Basic Link Service frame
with no payload and is dispatched from bfa_fcs_lport_uf_recv() at exactly
sizeof(struct fchs_s). Requiring more would drop valid ABTS frames.

Checking each ELS/BLS against its own minimum payload length is a separate
change; this series bounds the frame length itself -- the FC header below, the
posted buffer above -- and the two handlers that consume it.

Yehyeong
