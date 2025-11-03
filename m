Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173451C3306
	for <linux-scsi@vger.kernel.org>; Mon,  3 Nov 2025 18:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762194144; cv=none; b=iztEavIVif7BU/6mugWVE/4w68OHTO0Ow2XzxDlsNHkCc4i68lnScqQ1edVKzqAsPXWnBe2SwxEwbC6Xzo383Rd8fvZ+knf4WK+P6g/QtIUmLv3N68zBvpOpKZSyn+ty0nelDyYAeiANnCva5yJmGbpIDhOWj/YVK/rf0acLXps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762194144; c=relaxed/simple;
	bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KuwuGVZskrftmk0EvmVXVsFCrrQmTQfjA2mHNLpvkjvPf6w02lnvo7vILC3NMfBepctwC/pKGULCD3Sw7vSDVpsU6tP/KYpH2K1JT9OCBX86gPCuIgFEPYdjB8CgOW8RPw5sRahc0zyE1U4PAzG+opDNpSNWiV34sB/u/Z8lEo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JSwb554f; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JSwb554f"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-786635a8ce4so17513977b3.2
        for <linux-scsi@vger.kernel.org>; Mon, 03 Nov 2025 10:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762194141; x=1762798941; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=JSwb554fKmClyMWwiljXGsEkLDNbwg+2uIqqJGEqGQDqeVRKI2xB5zhTr75c/SUlE6
         6wlTDm7brLFjHRutrs4KlyYLry92Vpf1uqG6X45Und/e10uG7Z/2Szvylr/fpnDmpAKR
         mh2h7tBwUkcYQjmiR3bi70h4oJP9CFiJn7IGiHBW8ksWH/EKlrMEtA8NuUyJyDIXtVl+
         JFh5kshHH/s7Wot6u1f0Yj48XvFbDUDVBOPutB6b1aqnmev6Ys3d4Re4b3GhZTdbHFmI
         46qK2S+aKhoJLmqgkNRn8yqG8sNRFbBu+MJ6ns9KggNooX2zZdy+rPgSbZFPUZ6fRQPy
         ALjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762194141; x=1762798941;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Eo8mcJx96u8VH4jn7nXN0WzI3pTAqmoosY5GMUzgLRE=;
        b=GVgfxJQobiQrJuDh18SIsdLs2VELuVf3BtAEX9MQpKJ2JlNhtxXsMH5qeDjhdbHUTw
         8xlL6ytp4UEhbwiEY8Td9kRk3pTeLHWjUkkGAxG4XHR/v65K8/hgO9eHTS+EVwB4X/kZ
         bxHHUNOzX08kj0O2q4DrUZoqp4ujXW/FVyww6E3o7UG0CmNY660Sf9qZN+0Y18PLORJx
         uQs8H1PuTXUKbj/Fk9ZkDs3j3swax1KCFE6+nY3YKYpoI9OxdQtpYf7jrSz3Kem5Tvbk
         7FpIxWv4u6M8L1ZfZPihGwnym1I7S+H5vNxJtq7tI4QG5EKRr3oFdJzTpTHFMXdZIRIe
         ivNw==
X-Forwarded-Encrypted: i=1; AJvYcCVH01gWRniqQUzCB6EfKCF2y4X34mxuq8uA1m1RBaQAVNCiwb9gRHwLTZ+8RY/UMnyHqEkr3786R4yp@vger.kernel.org
X-Gm-Message-State: AOJu0YxFSVvlCEt5oEw6QlFi5sADQ2t/XCYOT8IFz50D2Yklc8skoqrf
	6hVUvnSkfmfSQ0qrxBp1P+TSLToKF6UwFgRmfYRPekeiQCEYuyKT7BAkfWIhSBEZeY1pfgmKPo2
	vW17GAajfA7w2hAOkYAuWT72zSN/WS0A=
X-Gm-Gg: ASbGnctBWDw9g7bcAWiANruNaVLYPDjOnANnp7PWrd9fPIiSGS2vkqVL8HMqDycNMH1
	Gqg+Sec7KDjskTfKTcrXgQdX4HVL2d9PklkodsInNgEe5RdSzgQyKwgo+Bx30ti43iHuDY7vCjV
	RJux4R0/5InRMKH/Virpnra+6uGWkXn3ppYDU9Tn1j2/v7BgP5YGNzSU1gONM3mZKnaBA/CWprF
	QxRF6SPcA3RlVUqw/p9zL/i9YTh9S6cXao/eVi7M2P3Hla2WE7uq+3/kqIl0w==
X-Google-Smtp-Source: AGHT+IG5fl9Ca6IoFVXCby3OjpqI8VMpFebri/sOCkK+nWIHAzNm32WsbYNZ/ksmDEU40LCIfXNPgLPM3KOdt8Ty3tU=
X-Received: by 2002:a05:690c:e4ea:b0:786:5499:634b with SMTP id
 00721157ae682-78654996821mr73008517b3.23.1762194140728; Mon, 03 Nov 2025
 10:22:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251031095643.74246-1-marco.crivellari@suse.com> <20251031095643.74246-5-marco.crivellari@suse.com>
In-Reply-To: <20251031095643.74246-5-marco.crivellari@suse.com>
From: Justin Tee <justintee8345@gmail.com>
Date: Mon, 3 Nov 2025 10:21:45 -0800
X-Gm-Features: AWmQ_blcPg1mU0jAAEnoVK9uPDIOp9VK-IcJyOwAXQxd100Xu_HVOLJgLqbdWSM
Message-ID: <CABPRKS9eiAq6USotto=kJzhKxJvVWkQgm=eHFN11v5_hnKfM7g@mail.gmail.com>
Subject: Re: [PATCH 4/4] scsi: scsi_transport_fc: WQ_PERCPU added to
 alloc_workqueue users
To: Marco Crivellari <marco.crivellari@suse.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Michal Hocko <mhocko@suse.com>, 
	"James E . J . Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, James Smart <james.smart@broadcom.com>, 
	Justin Tee <justin.tee@broadcom.com>
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Justin Tee <justin.tee@broadcom.com>

Regards,
Justin
