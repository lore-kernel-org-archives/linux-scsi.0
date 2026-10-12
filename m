Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC2642AF8A
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 12:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791807377; cv=none; b=cKOJz8Lx+KR4ZZQA+8aikwfeM3C4ErOYaY8968A7AsL8CyvRNQcSTYi+uQHwg7P4UhpzFAPrndEBfcUVpGNmaiBTeTJUQ7toemszfQG5f7zpJTZyzYsVqPRawwBOT3jV04lfzDB0xFU3F9P0rr7Zv464O5ANAPYssIKt8qU/jkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791807377; c=relaxed/simple;
	bh=ug2SZVPl89ENEQR7M1tByPrxlFqHv5XwrZnkPgJJuQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgUAfG/7xOYO+c1NO6ydlLktmHSHMtFBSanU2CfJ1iWrA3X2W6Id9ziEht5zQAGDNTtQro708uKaez4mOJ3Xdp931km2tLUzA3b+2m24AYaSiAMIrxr/KwEgVv9HLErO6QMv8r80vgsxkyfCnywb/9dDiXAFe8vc35I65/kkYWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=G+zOpt5e; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="G+zOpt5e"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3a7fecf8440so851971a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 05:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791807375; x=1792412175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ug2SZVPl89ENEQR7M1tByPrxlFqHv5XwrZnkPgJJuQw=;
        b=G+zOpt5edgc3wQ+KBedQNRN8GXFUukTMSSSUdekB8uMIxES0gzSYGzWDHGMwK8VZRn
         vjA7PEmZZt35JTS3AwoLT6KUBn+3LPVvexOMJSN7QHIO205LjRZ+7aakpfCX5ZF4TmtF
         Lqqh5npD1MUvCKT56OnESNpa8EmINFvbsNYaZJULELCdz0cOinC4SdUsYFF3mTzFYWuc
         MWcGyDuiOP94xTTuy/cGGyI+qYPXVEj1ITIX8Cdbmq3gfu0VAGD7Hz1vqjOu6YkH0nXI
         CDblkHTZaprFQdHDHcOrBcieiLFcuUW2PmGzThB2b9+PPokGch5zAj6cpQpfz+tpvqIk
         J4Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791807375; x=1792412175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ug2SZVPl89ENEQR7M1tByPrxlFqHv5XwrZnkPgJJuQw=;
        b=AJiHoIcoMD2Wjp0yzKQAFr9otC2D6ZJubDR7SM4uJBkofUS6SGQ1wM/XgtWBZzk3ny
         7fShUp5JdzyDRJx5a3Wmp2fEVetz92pdlcXl1Z8gfVcpXORdKDtfSx/oBH8nMOALjZne
         dxI15pi5Ts4fQMzSFQhDeIdcZWg2Divy9MTy/ibuLnht4jOaCD7JAUy44q7ai5Bk/3Ut
         SWLg+zsBbTvtEs3TelkSthJTrI3mhbjX0jd9mKNiTGWVD3NyKpyT+s8oFrjig37BKGsO
         PDMTEwQs81HIqXGno5PlEj1udImC5hVWPFRWtfAzs26i1Gq8WV+boBLCSEm2mi2Cr8jJ
         tT2Q==
X-Gm-Message-State: AFq9FYITFX9XIbDO1w5uS2f9G3v+nPqEvoKzufKdqkjKciAsQDLOB6D3
	QTsAB5vZOMHsTRWm3fF5jfgF4sin/FnAl4uXB/5TTtbh0qwBzdUF0D/IrSDvHKx6oqDv0VsE67U
	WAUw2qeQ=
X-Gm-Gg: AYBFou0Ne9gD8XZb4sEu0ROFgjzFe1Sn0a9Cw/fpyekMpXXQtlnyWVV/ZfvfRjVoL8x
	YXtk+I9FDFsdSPKxb4PxObzplIwdHk2mnM6rQbeWMtKrDBgyYIx5jFXv9kQmqMCnhb3Wxpdd+OB
	BTYUUCSJ0TI5vTHrztkO16pGjtF3h1MqzMahHLOD1DCOFQNcdzCk1YgRBhepoB86//ab6RgrbR0
	kRdOw44srZxQKwlRoVbhGiy67exhlahIwH3XtR+e80JfrqE16kPR//ZGH1U+4D+OuV+55nGopYU
	UgNc40ZLSt851abqyCGSPZd+jynNx97waRh8TkXb6vpXn+v1IU3auYMSSDDMoLz1gZqxA/YZU5Z
	wW9MyXkZUkd97PsXvsebtTWAZdN+9agHDBypHmUIlO8R/T+tqg6mhwcIiU4zuyCHvOVmGv4pA/f
	ZWCVNL53yiedFU81JFYJ8VgoQXFBzND+nOTkt7yep1W15Ay0zGZlUH1VHCzoC1nZppQzDijvozo
	xsAeiMsZA6YGNUJqg38VA==
X-Received: by 2002:a17:90a:c88b:b0:3a5:1b:34a5 with SMTP id 98e67ed59e1d1-3ab3af73a91mr7437909a91.49.1791807375539;
        Mon, 12 Oct 2026 05:16:15 -0700 (PDT)
Received: from yhlee-960QFG.Davolink ([2406:5900:1044:110c:7bd2:1202:246d:44ce])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ab38ff0ce7sm17212536a91.15.2026.10.12.05.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 05:16:15 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: linux-scsi@vger.kernel.org
Cc: ching2048@areca.com.tw,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	thenzl@redhat.com,
	sashiko-reviews@lists.linux.dev
Subject: Re: [PATCH v3 1/3] scsi: arcmsr: bound the firmware-supplied message length
Date: Mon, 12 Oct 2026 21:16:02 +0900
Message-ID: <20261012121603.2335651-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-168035@kernel.org>
References: <cover.1791803953.git.yhlee@isslab.korea.ac.kr> <adc1e1512a87ff16e99d066c2e96e18a1d28e610.1791803953.git.yhlee@isslab.korea.ac.kr> <sashiko-outbox-168035@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Agreed, and as you note this predates the patch. The clamp here only stops
the out-of-bounds write into the 128-byte staging buffer and deliberately
leaves the rqbuffer accounting alone.

The double fetch is a separate issue: the free-space check in
arcmsr_iop2drv_data_wrote_handle() and the reader each read data_len on
their own, so the firmware can grow it in between and advance rqbuf_putIndex
past the unread data. rqbuf_putIndex is masked with ARCMSR_MAX_QBUFFER, so
this corrupts the message stream to userspace rather than stepping outside
rqbuffer. I would rather fix that on its own by reading the length once and
passing it down, so this series stays a pure bounds fix; I can send that
separately.

Thanks,
Yehyeong
