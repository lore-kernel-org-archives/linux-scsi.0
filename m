Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6484518154
	for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 15:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791904406; cv=none; b=fWbp/h/LA6RL1PRR4K185RgHH1hfTLS7svEgTzWNlZhj9XfA30Sj6iluYN4bKUiPJNq9KdTZXt5ZLILxaSWPw0BYGhkJ4efkZvfdZPX7rljXIb3ruo27/1J2zBax9BlseuvoRt+aUHZ0ZGtJD5QLNDdgDDjuelLNDLCyUf2x3AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791904406; c=relaxed/simple;
	bh=v1oMUlr0j+OWLBDHKzTtuO91b3I1/3rK/UpKQ22TafQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mmvv98BIpy4b81CofZpWuezsxnRu3uQs617Zw2kiE2sJtT1waDqPpvPaZU+OHopYg2h7gQeqHciO5jcnkZiFR3XfzyALMoBWS0pOIrc3SSlwJ6K2JO2Z8/e2p3VQetrGFrRjB3kjZXEdF5beHR4SonCvY5MP55f232gB0bMVFZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=BO/JMK64; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="BO/JMK64"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cd6028ff33fso1045906a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Oct 2026 08:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791904405; x=1792509205; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2xsC6RbLkcpl6vUO8QFll7KRyQolqiQv4TDUNdnm1Dc=;
        b=BO/JMK64Z74MaNO+q7zVPWzD7WKKGsiQ3vTyCGp/RfLfZPfZ/T//OhVTs3ONKwg2FX
         A8WaCm1M01iu8gS+88iYKgL38CsDLs20272kd8u+I3+z+9OCcXYA0PUA1MzPs652aZIj
         2yPupmVDDRExiLYvxY9NdG9TzmYXEm3+qxGhCJokC68LTVnmb34z0JQ50/gbDhkpwZ0a
         2mOYpfTqH/qjQBjvR0i5TtsyJG8Nq5YwlF9ymrjPwRfrFpV99sPD+gPmBVMLpLERkoEZ
         HYuC55kzisFI4KWky9V5Msgl9H4EseUS/78eUwTA0r4IZBrakLh4BCgO9Sg+AX1pYkPN
         YUVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791904405; x=1792509205;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2xsC6RbLkcpl6vUO8QFll7KRyQolqiQv4TDUNdnm1Dc=;
        b=Lcmyj4pFxRMlnR1Gra2vunA1Xj5CcyaNulDDbQD2cIB61llDWaMRtL0ygJL3dLStJE
         X00DgbGfmGFhAdwbBUE1q9Ei5GPWQDn0+ZQb4liuXHv8RwRvt8wEM/nz72VcT11Z2VMn
         rEuqs7XfXYCEtlnM5ZIhGulqCgDVONqbLTQZ60wM55V1hVblSdNDtGF7M+0wkyPmKVvp
         67m67/CpCQNZqQ3XG7gjSS6jx/qqpmAo1+QR5zMpVrCOsHuY+NBk2qajGahEzbKgqdAf
         U0sPxInp4+G+iQfYf7trFQ4i9UJpQn62ihowDCePOlBcKAPDAjmzFhGmJ71bMojXVgPm
         5BDw==
X-Gm-Message-State: AFq9FYIzYQyFzaFpYgNVp2uZ2/vUllzXeN5pb2NnqJAXCXgYQDiXn/Kv
	3UWELHEm7+Rait1bDzLjGdBe+4QfpLlcTgPncXJAiJd7+49X+XJV7CDqCJhMPJFfpfI=
X-Gm-Gg: AYBFou2k7vu1MFYGh6yaJAPMo8ETwnqFB/rJuheV7TKcdVmE9aGkcvTOOKUhv3WebyI
	BbXvpBGcRIyKEVsBgQD3zJD0Nam01ifPAnFjeODLbjCOUd9PFktB054Jmt6p7+L/LHxZpCx4G3f
	kct/c3dLBIq1fKm998jpOiMIFgq1kIG1z5l3qS0i4KDTJISqo4343B3Fof1yADLFCixU9PAHerB
	Q9P5Jmc6C7xwxB/kLiWqrhviadirGXuxMBWmTMgohtYtOcvr19Nz9w69oPdFeqsO6k1PuBu4O4d
	m/PXx2bjzzP29f5KSxFjM7yUJtyXNVZOTesvMH89FOhIB56jfHRoo/WcQ7NZU3QP91XR29apwKq
	T3ZHnuMHnMBCmaWOojSC43Nw4aYppjLVvwqwThnY46cRK9SdruOZgMCQSmLpSCwDj7RjYc1/z9z
	jhGdz3hi9q6TxIKFxJu4oMMdP9UkBlY9JCSOIMACPa9O1+fK4rWhHBlk4zFAf2O0h/oZVnbfIsP
	1DHAAt/W6sL9OiJbpxc
X-Received: by 2002:a05:6a21:8217:b0:3dd:85a9:55b7 with SMTP id adf61e73a8af0-3e16be2b1e4mr12853348637.34.1791904404981;
        Tue, 13 Oct 2026 08:13:24 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:c51c:be8a:c517:276])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd614dfa382sm1462434a12.26.2026.10.13.08.13.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2026 08:13:24 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: sashiko-bot@kernel.org,
	mkp@kernel.org,
	James.Bottomley@HansenPartnership.com,
	aacraid@microsemi.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH 1/2] scsi: aacraid: bound the SRB sense data copy to the source buffer
Date: Wed, 14 Oct 2026 00:13:03 +0900
Message-ID: <20261013151303.3169745-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-169890@kernel.org>
References: <20261013140214.3156938-1-yhlee@isslab.korea.ac.kr> <20261013140214.3156938-2-yhlee@isslab.korea.ac.kr> <sashiko-outbox-169890@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch only bounds the sense-data copy; it does not touch
scsicmd->result or the srb_status switch.  The result set in the
status != ST_OK block is in fact overwritten unconditionally by that
switch (every case assigns scsicmd->result with '='), so it is
pre-existing and independent of this length change; I have left it alone.
Resent as v2 (with the HBA patch dropped):
https://lore.kernel.org/linux-scsi/20261013150420.3168223-1-yhlee@isslab.korea.ac.kr/
