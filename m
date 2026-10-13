Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEF352F29B
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 18:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791915217; cv=none; b=jtcPx8jb2czzxHUfVKwxSncUslJYLyiMxY3nOCIlKmnCF+ZhUt7WIOontOY9VgLj3HV1TrFmkQqycnoSyRND2cx47NMuWHMZCB+5xU/B9j7dGTdtwgxJdlrnh5SkoHtw/FoomDX6QFWlLV0r0gTHgIjH7AnP+EXtS+k6+gIrRHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791915217; c=relaxed/simple;
	bh=p/LeoY8oW4ZcMNr9MNsFO8YGI1ZLRh8OYU4+K6O6RMY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0OXsm3lYLhq5tvYuBVKCXo25r5/xH7glhb7kE+YKKBAHUBO4OuoaakTGAU8Ci9IJauUqKdZKg5VXaNOI8FKdTUhdI+2rdydIlObldDUhGbrSDKby/qPTcaib5MzBawYoLyyRJBZZyG4bSHNFaqkvOsU19ECGkrzr9wsrQuUREM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=YMaghwkW; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="YMaghwkW"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-88a627ce016so1065823b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 11:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791915216; x=1792520016; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7VhuK/BYJoyJDHlMffiVTc+pqt7ZYhMeD2kIg//kcPM=;
        b=YMaghwkWir7ydsrEDWXUDqx0UgwS0GpOsL/wD0jzcGLiBCpKfz7/kgugEb5hD0manA
         bR5Zhtnx2umoqHQMh67dJwQ5QBzWhqpAoqe5x1588Lxzw3hNlQxL1m3oaxjLLg1Rf4o4
         qwJFqLyNRQOvu6B9gDeSMzEouj6rEbeJjLL2Vhb1gdfKeyNazbYCoZRgFXkrEbUrebu4
         BCRgD3NFDInVz7R0rthZH8bzTqYaDtwhroIbledyliLL7lizjoIDKhK/eI8pY/iLEj87
         JZJSumfhRwADNTE8c72Tj8pl+o9xDSJDu6FUi7CZSFht+N3kf8a0DN5lxDmITkaXxslh
         kjHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791915216; x=1792520016;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7VhuK/BYJoyJDHlMffiVTc+pqt7ZYhMeD2kIg//kcPM=;
        b=FETukcBVaYdg2+v+TYdDLH19zi2v4eVoTVsSmfHENAQJnJHrronJl4DAXffyP7zIkI
         jK8rJNSYh6gOx7q9qCjYXn7/l9YF9bnf/n2JXX4ht7KHrDjQj7jGuzX+FbrD9YuGaG94
         lfHpTFyNFLNmXbWQCClXqrxQ9o0mC0hL9crPFzjOQfY88Ei4YzwH9ExK7O1mUwTxahNN
         XRw6PyEGzKK/kqZlbQuQ8Y2NG1CLP47t+3pT7DE7IGkuLCyiFN7z/CJ8umj1ZFI/k/8V
         cU31HC0wPb96bXOpK7YJ8PuXWqug1/XjEQz9mLgI+V3LI37JwmJAPSyvk0i/7vPRbomB
         bIfQ==
X-Gm-Message-State: AFq9FYLI/MXoGK4Yks86ybeYab4XZ+Y9YsKFYuzz+zjZG+xtLUd8GUro
	goEyEdmuvgaVn8rByiKt0oh3fOcseIszOOPHh61WTC6HWunppfR9EUZko2Fd0sUVxIY=
X-Gm-Gg: AYBFou3YHDu3Gg2Nol5HOuYQgBk98AOo1jp4c+7HrTTq6j0NrQbW8TR4CbV4km52+LM
	aZ/iEXFgmX258wW9uMbR7/3uX3bfJQtRaj2QSGKMcyhjh0Q+9N40ejxkK7EQXCfmmDqVlVxplVv
	Q9Gxc4PM3U7xI1VVNzNSw3ewp4hBFOcbVX6+Y5mT7Y+04zghIgWMPaJOGLpLNW9FW/biSIf0yBF
	eNcmmX4wAuoYFX8wUGy33H6pTi/3GMNy+kxEJqVjE5fOwxpcmLrnjbEo+XR7DcuT4SHGWSSaI4l
	omJgS14b2J9jqIgDiLTFQOVm4iyOpWSZg8aQ4bClPwOBtTiXEUdPwjzxGNE9w1o0MtYkxG15410
	cF1u0zLBlEEMPccyIrw40t13iBBpYdNgKiFa7JF97aqBUxs73DNRwi7p1e2QDJ7fjezfv9omGBZ
	hRByXG3zCPijClY/ptfjZNiP3hyvXVBbI91CQByGpTcbuwcvtw1fyNUFUOuPitaDwrV/B+tzs7Z
	2GmknOPBJK2ubQ7R0jNwfe5SaJi/qI=
X-Received: by 2002:a05:6a21:483:b0:3e0:da23:874e with SMTP id adf61e73a8af0-3e16bdae7acmr12155970637.21.1791915215614;
        Tue, 13 Oct 2026 11:13:35 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c51c:be8a:c517:276])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e082e4sm5923184a12.10.2026.10.13.11.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 11:13:35 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-bot@kernel.org,
	"Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v2 2/2] scsi: mvumi: reject an out-of-range handshake frame length
Date: Wed, 14 Oct 2026 03:13:20 +0900
Message-ID: <20261013181320.3421771-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-170275@kernel.org>
References: <20261013173145.3412863-1-yhlee@isslab.korea.ac.kr> <20261013173145.3412863-3-yhlee@isslab.korea.ac.kr> <sashiko-outbox-170275@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Thanks for the re-review.

I answered the endianness and handshake-abort points on the v1 thread --
briefly: frame_length is a native u16 that the driver reads and writes
without byte-swapping everywhere, and the error return matches the existing
checksum/page-code paths while this patch already replaces the infinite
loop with a bounded rejection:
  https://lore.kernel.org/linux-scsi/20261013173536.3414059-1-yhlee@isslab.korea.ac.kr/

On the two new points:

- READ_ONCE: v2 already compiles to a single load of frame_length here (the
  bound check and the checksum use the same register), so the double fetch
  is not present in the object code.  I can wrap the read in READ_ONCE() to
  guarantee that at the language level if you prefer.
- allocation sizing: you are right -- max_io and the cl_in/out entry sizes
  from the handshake page feed an unchecked multiply in mvumi_init_data()
  and can under-allocate.  That is a separate bug from the frame_length
  bound in this patch; I will address it in its own patch.
