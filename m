Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795175066;
	b=A9u9Yc1n0anHCty6sTPoHGqPHqbOA5I3vGzAgwcPAATMMpsBpVOknBUB8Dmtx9jGzyEM
	 Dj9AimkQYIqPQIUQRKh8CIvuxnk8W1gmB02/wmKcF00Z20o5IAtJwvtfUdqWxZUomqWRS
	 xWEvga6OfWRG7u/ocm6G4UigtVPtIr9NSZWLXNtZD04KlZ8p4XOY7mbLDRZPg30zNSfS7
	 cq1uRoFxY3xZOl24sd34aAQ+dWFo6M3G9ay9NBoEqKuBfj/6YZWn3i61QsNr37NZUPW1d
	 ZrirJemMPOzIkMZXakeLPVShuuXvhqWomkKR7/WrRMSQdTnoO2OSbRJUMaiIy+XqUdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795175066;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=g6MTsOqU3k//pwl7FRMf2NFcyBzVHK48odAYYtmSl8k=;
	b=Yk9GW8Ueu5QIsMjoBERcahZXVupIdjoy//ITltWL43FHG51Iw7Z8UQfmexpSCMIAIo0K
	 DqQy5HSefQthbIuKw4n5nVhksGUNarjEHbhDnpNgEc1RtxNi2W9GmLeEVdxPbjVscyO9Y
	 Ydvh7mCxtva201MiQAsKTahDJsNLNVnPmewN403zBrNJW3p/HnC75crOximx55hOEHbn9
	 w2yF0GcJT0DczIFGr9T3hcj26YvSM1a9v1G/Y/JCXTiBQxt9GhdG4n5w+9Xi6w9tDM9MU
	 lXd5Wesbic5F2jU3BHVw4GJdwW/uX+cMOPjzoFsPohnKKLcoh34JKiOqkGT8ifPLmIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=isslab.korea.ac.kr;
	spf=none smtp.mailfrom=isslab.korea.ac.kr;
	dkim=pass header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ndNiefIw;
	arc=none smtp.remote-ip=209.85.215.181
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DBD606A333
	for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 11:44:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 30DBD606A333
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20260707.gappssmtp.com header.i=@isslab-korea-ac-kr.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=ndNiefIw
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-cd6acc50b8dso427331a12.3
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2026 03:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20260707.gappssmtp.com; s=20260707; t=1795175065; x=1795779865; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g6MTsOqU3k//pwl7FRMf2NFcyBzVHK48odAYYtmSl8k=;
        b=ndNiefIwHhnp907qsXI0c9K/ItUD/rtZCnpw9HPezTyq8jq9GLkPm9uxOlNcHbxcul
         LlTJjkbxO4OpGaQScrAJErz38c+VpkeOqTH7amXGcAojUYJuiq9E9tr+nADTroZrB82K
         pI8JYhQvv79zua4bVtG/+6YPRynJJWlBn9ouDECSZZjTiKZJ4rf5z+nBQ5oToVBRpB6U
         WiI3ptR36EQlW9z8UNDUv4TA/8gu9z/xFPmmxlS2w3KKYs1tPcYGnlzI/CYnJRYjJl7s
         uCgv+kuFxwrtChrwqEkfrTvDqYczol1tNRaIRAt/5PUltGoB5ADxkCbaaTNiZnfhwD/l
         FegA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795175065; x=1795779865;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g6MTsOqU3k//pwl7FRMf2NFcyBzVHK48odAYYtmSl8k=;
        b=dLMhsXw/GSorrXq/BU3+bu83a/OVy59RBZJmtGYjVVDi8zN51nLum7Fivmqu0zKiLc
         8mQ76jqka2l9nNjd3GKbzsFosBM26I13CcNnWvy6OJKPgaLNoIkuB9KhbsYQSDqKsGs4
         CgXtoj3D53QKxoEthbrxTI0lxQvQ/iHAmZTdaL08d32y1QVsCjLNLmHIPa26l6xl8Xp/
         GTZEMx/Tn/1qN5ehoqhRWiTayyK++YKchNp+X9ilPPcC5o0aw/Rm15xYR7RmEh786Pvx
         /85EP0gs6uPTM/dmKMWv7JQ3hFlYe1SH+V/sA9DJx5KeiTNS8lkNmsM34+GMEKJThzMU
         HYTg==
X-Forwarded-Encrypted: i=1; AL+hErGxmsZNF12Q1D+G8cJO+9ZQLBEz/EJEUwuvvhw/SC7x4Y1c+OqKgo3XsOPUGRb7cGP4ilm/nIwyxvgE@vger.kernel.org
X-Gm-Message-State: APuU4Z/rfS5K3AVsgHB8wn8dKmqwxWIhx4EvBsyPsa3Cb8Qps5htigZ5
	4zp8BvKpQQZ7cXzrRC4QaaQyTiJtnd0FInq1ZUAxiTbQ9KTSRLDx46Fi+fYrRGLBhrk=
X-Gm-Gg: AZFdTZc/qeAIQiirHSL1ipvfEmUcuSGgAvLpnHWzgMC2vpHSDM/+cfgh8UO92a18Hmu
	+8rseGlyf8sM42dhpzZMKISvLKMLTsQJZxug0CmVH6qsqWo9gzrn6y19X+a3zLwwV5Dg6Zbm4Y3
	h+7Z4umnCTxR265vetmo4tBP0a+2w/VJQk2SrWugVkHASqIoxR0XPFyxHKnowCWtyNbKsAplaNz
	w8jfb02f0eCL8TOS2JJMKLOS+Sz2PgllezrPrB+u9R/hJDzPB2tQILMvzN9W/jR7X8IRmCmMIRX
	EmxkZQLQu3NUhrrQaKvayg1Q8w7d8NUTNQhVxmtxtxUZswl5669dMiNrkReOi+9pOfTEaLgmsTt
	KfU2NFMrZIyB8phDKhFqSMrfNWGbyPiMraDKDeIBjiTpZOh5PWI8yO5AOUmYB+PIWFbN1wKZBb9
	jd88+m0QHYqVwNIkwMBzT+ij1i0SzsxVPXhjPQBE/zM1oIGlP+78Ghp2cjLpCwAAMKFkVJgQOkm
	O+0pQpe1uV2f7JClY3GF9a7vTj2+m+atBHDWKjJiauj5QVVTcYgUF3FE4cZxBIZFwU6rsXVlcfi
	4bIASd1jTBZo5u2/IqBCTsaQGvcT/Q4oWvnQ2Soq/QYnxN2Uv8jbSLUgXp+K1r3acVVHnS/IH15
	XzLjKjdxDv51rwu2XjFS6RwknqM9ufoVfnntM
X-Received: by 2002:a17:90b:442d:b0:3a7:8350:3f7e with SMTP id 98e67ed59e1d1-3b41c93c22emr2584256a91.44.1795175065541;
        Fri, 20 Nov 2026 03:44:25 -0800 (PST)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:8b25:951:ad8d:5cc1])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41adcafe0sm4355433a91.16.2026.11.20.03.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:44:24 -0800 (PST)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: mkp@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: bfa: bound the RSCN event list by the received frame length
Date: Fri, 20 Nov 2026 20:44:20 +0900
Message-ID: <20261120114420.3072586-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261016061513.962742-1-yhlee@isslab.korea.ac.kr>
References: <20261016061513.962742-1-yhlee@isslab.korea.ac.kr>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This is superseded by v5:
  https://lore.kernel.org/all/20261016155441.1607196-1-yhlee@isslab.korea.ac.kr/

Best regards,
Yehyeong Lee
