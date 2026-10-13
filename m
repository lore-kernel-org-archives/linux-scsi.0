Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06CE452B1F9
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 17:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791912953; cv=none; b=UFj7Oi+oOEJyRvTp89e+Xb15lFbpgzNxNzWJw6jDtKJX3My/3QLqdcKLE0GbrjqO4ela0ryJspW4zhGghfqJwoS1MBwBDUG1s4ufu9yOqZMFBB4cyuOGVKK7kK7rIcpXLNduRmX4FZ4QUC8C8RvJ/gi5tGFtWz/2C26KS1ICNVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791912953; c=relaxed/simple;
	bh=lgDJ0JtWigmwOVnRmfUIilQcNGRXRE2L0/dPjGSB/6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ch6hlpdAJ45BZOXrHrx74rrcRxdsZwcDbCIsx9aqOXbfrFluGm/GrxebmjG0Ulm+oFJjh5+tDtsyW8s+EUPqHHfLo7MLA3WtiVoEmSFJRoGIR+XITEJ1m71pr7sXoJtN03orL+8viP5TksvhvdoOk/BT8bkClbD/fS5HPmnneGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=e/vdyxsS; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="e/vdyxsS"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cd61a2dfd7aso31805a12.1
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 10:35:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791912949; x=1792517749; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XvR/1ROxn6YzE4aqrudO/0g8Dfn5SQqN2g0aeRLqJ5I=;
        b=e/vdyxsSAqay+ilYXvnwdyNbraHvM5qvSo05Pn342eqBME6naAIJxHsnGoVbWCSFtY
         oZl6HTBU5EtJcw+PxCNK71K42J0pa2yoiJVbgs36HqlKKFyznoQcYc1Bl/TNnY6oREx6
         YoMcYy1u5JI0MQQpNJbzpWlqmGiXpeBLm5G4O9/3UUFHw18GgGvkiK8pCkvsIOufthsH
         ASUQWCedgRAtgv/egm1u1NZa3dY4wlNeoyiAjQA0m1ig6Scqdd+BmGlAYGL5YJ1m+5dq
         /SyeUNAWZWF4MhDT1KIXfifZo8WAmjj/JYfWFaPpWoNYSvq7HfTcPB0+eC2gKvYRxCY5
         t5Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791912949; x=1792517749;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XvR/1ROxn6YzE4aqrudO/0g8Dfn5SQqN2g0aeRLqJ5I=;
        b=vwvQVfd3WzVis1gij93sw9WCmDZ5RPPY5NQ7QdqiQ6VXnvv3k+wpJSge2Ly9C5jppZ
         RdB9H8RCOPSSapKgjIgnA44Va874RHzCWhYe0dulK7jkKkfKURiESyZZhvYq8Ng30F+J
         Q8RniBB94nDf/lvM3BI+F+fiewXyL6ObVLfsecGzI7Mgq0KOUvb47DL7DLSQ7/xUeUUt
         Ujqb9dMtTg4AC+v4oxXyR748bYBLe2YaVicXITnf4T8TDFuCN6mP9ALiM4nzcVXwLWxK
         siU6KHUl3ul5wdXbsW+bR35ivsoxDzuICku29rBTWdi+EGCE52mTruGaa6Mqut2NArHd
         vpSw==
X-Gm-Message-State: AFq9FYJJ91iP9nqTDzueK+S41N35g46l36BZGWPkf4j5AAv2NUMENZIr
	fPoGhXqHgkGdOGX3BNqKqgqttFi+piKuC3vPzHYnjbzMc4m0yKo/2BfzTS2Td9r7pdpC07Eal1t
	x0H2gk4k=
X-Gm-Gg: AYBFou2+Z8XPTTLZsChCgIHpWxcBw2K+dut1mtOyOp+vW7cXKaJwcqQVVRER1Vkw22s
	OKSjrsSX5Id3YRM2hkb7Jl0d2c8Yxg4b9+ENST97MJP21n8P1/18OIKiF7nFBzDZt4uk3lrxYX9
	E8WrWhdWRY/9OCgtnkpTK2S/F1PuDaGKtLVN1Snv/mJOpChg00Qhi+Ak3w1fL+BhH6fGoLlI9RB
	jxvoVxP/QmDGf2v4LZOpy8D7fHiIuNrtUtlx0yW7DgU/cFRCusEK/3CwnQg8iLr7omv63o/XBQC
	TE85TeJgL3/tLfk7kQNu39PSVL0kNR9rG6lEUGG1dZBOwmgLz+4f9FplovmjY++WiHHMlJrAj/f
	MWsLU6FAXl/fWgDHIjxhmUUlfcmlhl9vm4MkYpvibvEmLPX4IS0BROYBrzh/Ni28ohCgZEZv0hK
	97oHqNSEDA583M6MVKBON07adzsr3EocQ2PSBSBcc+HvTegKJKYdLjnGjylOBaT85ZQIZb4/UuX
	W4q9mAZ2KpBRN3Jaz3+
X-Received: by 2002:a17:90b:5346:b0:3a8:1830:8b9f with SMTP id 98e67ed59e1d1-3ab3a9118aemr9797166a91.16.1791912949063;
        Tue, 13 Oct 2026 10:35:49 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c51c:be8a:c517:276])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac6325e7afsm133859a91.3.2026.10.13.10.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 10:35:46 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-bot@kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH 2/2] scsi: mvumi: reject an out-of-range handshake frame length
Date: Wed, 14 Oct 2026 02:35:36 +0900
Message-ID: <20261013173536.3414059-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-170111@kernel.org>
References: <20261013161620.3210533-1-yhlee@isslab.korea.ac.kr> <20261013161620.3210533-3-yhlee@isslab.korea.ac.kr> <sashiko-outbox-170111@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the review.

[High] double fetch: fixed in v2 -- the handshake frame_length is now read
once into a local that feeds both the bound check and the checksum, so the
device cannot change it in between:
  https://lore.kernel.org/linux-scsi/20261013173145.3412863-1-yhlee@isslab.korea.ac.kr/

[Medium] endianness: frame_length is a native u16; mvumi reads and writes it
without byte-swapping everywhere -- the existing mvumi_calculate_checksum()
calls and the driver's own frame_length stores -- and mvumi.h uses no __le
types.  The bound check follows that convention; converting only here would
disagree with how the field is used elsewhere.

[Medium] handshake abort: this patch already replaces the unbounded-length
infinite loop with a bounded rejection.  The remaining behaviour -- the
handshake timing out on an error return -- is the driver's existing recovery
path, shared with the checksum and page-code errors.  Making
mvumi_handshake_event() fail fast on that return would also abort the
FW_STATE_STARTING restart that mvumi_handshake() performs when the firmware
reports a non-OK status, so it is a separate change that needs the handshake
protocol semantics, not something to fold in here.
