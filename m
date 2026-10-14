Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0AD5519A6
	for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 15:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791991473; cv=none; b=enWn/HufobO+5IjhlS3YkmzEbWa2Tt80XAWc2d3hly707isvtUraYtXgw2UAoeglcqbZJljYo8wCWqqKCSuym/o6pTgHgSdSnIyzgHAgpm3NgRwcQ/FqZdkNZAJikui33o12zlZaSR0AagQag2ZPLLdY+uz1AnYI8RFLipheaP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791991473; c=relaxed/simple;
	bh=j7lxWLDV11oCPAd9zrLwY8YtZWMYkppFEMxTV68KR2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X5H9jdsUXL19mbf3PuDTibDPWCXPIhJCCV/Iue8ca49e/vB5qp7fJJsYAIb5Kn5s3xwrmb5SJuOm0N+TFpc5ZuXLZCyERk+mHgx8R808jlu/Nlp5dXRO7JbCbJcVPwHYGouwX7fta7PVSvY5wGR4ADMi0erwJ3qz/CCIpz5HnsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr; spf=none smtp.mailfrom=isslab.korea.ac.kr; dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b=DlPjgH+R; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=isslab.korea.ac.kr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=isslab-korea-ac-kr.20251104.gappssmtp.com header.i=@isslab-korea-ac-kr.20251104.gappssmtp.com header.b="DlPjgH+R"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3ab4178ee33so2396924a91.3
        for <linux-scsi@vger.kernel.org>; Wed, 14 Oct 2026 08:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isslab-korea-ac-kr.20251104.gappssmtp.com; s=20251104; t=1791991472; x=1792596272; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X+A8usko4cfoywAC26NwTGT/rqph25xWtjEIyd5GKa0=;
        b=DlPjgH+R4eVy0Q9DUapa12egNiHPhSBPBBtUFEwylIHo2+kQgJZFk8LDZsedaol2Gj
         xbw4MRAClT2NdIJVJEbZHI3at8c0HZzR2hEmvIXuHCRGjaCtalKV57gSfSGQ57MohQMT
         HMb59FqY8lrOqK5rzJEFk8JDpY3tlTV8VxLilPVl0tui3BTW6O6tXTbg0yGrCWHK1s1s
         6NJSJ3TnJkE4CMe0ZBWqNofomfYkNLUzmvWByY5iYwJD+UWtIV+w0A0Z5W4Wxoqsllzv
         fz6QWELI2ZhLUw6DJi1Yi+B9MfaiykbRIqg1nc+heDwrqi5GD1l5p+asIJsefUGOGXie
         WOlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791991472; x=1792596272;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X+A8usko4cfoywAC26NwTGT/rqph25xWtjEIyd5GKa0=;
        b=jAEwfvY6P7eL6PUIdhcqHb/uh45oZ/rKnY6mz2n2vWz5UszrpzyWJ0Uf9OMkrQjH9K
         5djSatows5Ur2+XaVeF140A/HAV3fSTMQ+aYeuFQ1e3zL6dTY9mieVp9joUDsjKCk1hw
         IrSxJxfyTWr7YX88IH7QzSPjxwtjQkUF/si0qthW8dcFKl4IXLQZSh04ViMcReoIyWya
         yghAE1cqUL04sS2t3PYNtPOsLbzSCygAnIgqDqOATOBHo5bjraTSl8MoE8E2DMKhZjzG
         Q/asmKAVT1oNnrtcrzdEm1tY1TZVHD9a86d6gJ+o/1IZeK6O4KPUja2xufK/lJnMqM+e
         508Q==
X-Gm-Message-State: AFq9FYLDFVPN+XdF74lovYajwYXF/Cuc9gewyPsMNeqnc6zCkd0H91lX
	skB9OZbVSLlR7kKyy8aMw3gtAlI2w7AomCDvrBi0YSz3i7u5fAcl9NB43W7LN3ppVIaR/0eNklj
	Glm7D
X-Gm-Gg: AYBFou2ytyjEOxz8p7v/gSa0+c7mIdzdT9qRw/I5whp0Y8d0VxLYXGNvNpfvl0/xb1i
	FAmF/kGyXfUi/jheJWKmyi088VaAy8MG6+JJFWVXvzRGXOrIkMDc1XNaBOlQ9AsdrRBbOEMMJ7Q
	8ssUm5EaocBkE4AFGxRBOz8VYK98ZbdsBnkm7hmlXBPXymI8dNNQaQ2IdnCTrbgTvJhMxcKRFUh
	SDwzCbL2jcF4wSVvBlX+4kenQGnujhCsWRAV5hIYAZaILTLcVSj70eypia4CkUo7Ii/iTgYM6kQ
	EIBfNoIoA+Rb4Bw9t3iGRaC7MsOYJ3CPkoOWMZwvrL7DTPWVhdCg+drvoYyekFfoMW5HrHukq+j
	OBFD/wZVQptbWiplhHLDe//jlzM99TH3YyflaD/H1zzvwAAqXW2qnP2eGFGyx/eH6IAcAuq5Pul
	BZM5AF8T0mQxg11gMuTmDQMi6jfeh+HwnwEKQYf7KWakm8SghvQD2XdsWy5+39K7sRzt+G4e+zf
	CSsICNps2c5+7Enu7TV
X-Received: by 2002:a17:90b:3d82:b0:3a8:f70f:2437 with SMTP id 98e67ed59e1d1-3ab3ab3771fmr11573342a91.50.1791991472168;
        Wed, 14 Oct 2026 08:24:32 -0700 (PDT)
Received: from localhost.localdomain ([2406:5900:1044:110c:1c49:61ee:8c8:3f4c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac9373f5c4sm58461a91.3.2026.10.14.08.24.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 08:24:31 -0700 (PDT)
From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
To: "Martin K . Petersen" <mkp@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	yhlee@isslab.korea.ac.kr
Subject: Re: [PATCH v4] scsi: mvumi: reject handshake sizes that overflow the list allocations
Date: Thu, 15 Oct 2026 00:24:25 +0900
Message-ID: <20261014152425.3637406-1-yhlee@isslab.korea.ac.kr>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261014134104.3528958-1-yhlee@isslab.korea.ac.kr>
References: <20261014134104.3528958-1-yhlee@isslab.korea.ac.kr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Please drop this patch.  It is superseded by

  [PATCH v5 0/6] scsi: mvumi: bound the values the firmware supplies
  <20261014151914.3632701-1-yhlee@isslab.korea.ac.kr>
  https://lore.kernel.org/linux-scsi/20261014151914.3632701-1-yhlee@isslab.korea.ac.kr/

where it is 4/6, with one addition: it also rejects an entry size too small
to hold the frames the driver puts in the entry.
mvumi_internal_cmd_sgl() writes one scatter-gather element at payload[0]
whatever host->sg_tablesize says, and the max_sg subtraction in
mvumi_io_attach() wraps when ib_max_size is below
sizeof(struct mvumi_msg_frame), so the lower bound was missing from this
version.

The series also folds in the two-patch length series I posted separately
and adds three more bounds from a full pass over the driver.
