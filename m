Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D63C2586E0;
	Tue, 29 Jul 2025 08:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753779503; cv=none; b=uQW5+zqjVmfop9imijkoxS9zfnbalaAVoL2HMByQ/Aq+0mjN9tkVVxSblRKzncbynEoQXntyLFCAIlFzBT+Sf3vmDx7oBIp4XyqzlQzGt3eMyKe+eErID59JUwwwWfv8mzAk9yMLAFHd9EOcehwJtaPfeg1pL1J2eR6wqE6sbyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753779503; c=relaxed/simple;
	bh=W6M54otn3SvVum5fzDoqL8d+nK/jDuDbcJdl6OhFUh4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ffu2DVys5sWcVP1mDq+752PubUw5ivkB7MoInRrXs+owoDutw51Cls6SpKezWm4y2RNkUy6TPVNfm6+uaaDSFIxKEHHyEsstiXq1YGpT1xxrshTZbRwv4cZHfoSvPC/LG/hdsqvK2o4in9j6o7XvXQhL9A2hAY5s/xmlxoyvN7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=maS+UQ9x; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="maS+UQ9x"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-60867565fb5so8317117a12.3;
        Tue, 29 Jul 2025 01:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753779500; x=1754384300; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9cEMDa3aLwAjGk+mYlrmS2BXToBWPi98g1WTE9orR6k=;
        b=maS+UQ9xUGPc+6IVInGRwx68OviIj5vVZXp2icPRuowN6idoOHj/G1L/nHfG0kCjdk
         x+ZH3FH1iwDzzeG7kRX615QQRLSpIGyUpWti59AEb8zd7ryRbZUH5IVLat+zsUqAOjM5
         euLVlREcvX0MRcxOiuC1yPeRZ9/gbK6Us0PsOCNt1W8AMXA4pzMl+X5b3o0ZqlXYY0Lt
         ID39yCVZwXp7452JO5TfepElaacvi7iFM7hGkPurX17R+2Gp7FOy2njLj4TtNDCf+gVK
         pdvobG7cDS0P4QSKGbMIlCfAC5ushD5/3dMEJP48vkXDbOTHcqGGgRD+jMKWUqmc+Ctq
         NyRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753779500; x=1754384300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9cEMDa3aLwAjGk+mYlrmS2BXToBWPi98g1WTE9orR6k=;
        b=qQmuvmH/p/hohLQEACQZkWFs6p9Ulee0GT3XQmJIxfHI/Uwf6NIm93r7NQXsHDOYv5
         l8QZEsaikfWqfoz0C1hcWcJCR31o3XhRyS2M8IeYE7RCfyJVLIqV2LWnUO4A1HFAj+wJ
         tu0qWkVnI+V6/96XttkqQj8MfPLI/1iwCzYTd6K2bWBfBZHY5uG0FRHrFtV/iI6PjhVp
         9xjN8SEv2VS02xB4KHgZF50BKDcrQqfImHYB1AQAOSJAqkqgNXArG9ir+/Vk7W+SiI6J
         4HfBqqBIHqImm1H7IAmtvOJ8vfJljEZXlQR5V2NkfPy8EQ0Y5Swi4vbpjRt10nuEayei
         I7gw==
X-Forwarded-Encrypted: i=1; AJvYcCVuXjQe1N80ytB4alxdgCUgpJM8EUQHtf3kls1uzwDZsYSpGB7JJmTPpG7z809xxHIViIO5tEDm4ZjFBw==@vger.kernel.org, AJvYcCWwyDvR3rFfjalIggC5oA1QBPX4jVxzMqdP4WVpeo9co9K5/D44GK4qI8JKXmxYzETyETdeLbLZeiRnwA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxSBKWeTpFZFtgzU4kVtZ9hhpafKNQtAihICQIQUcxcuHG75o/f
	m0T3152y1IenY+mdW3D4v8OAhuGqTtgbHmuYGgIFF3LIm70pQGAAAPxLzTwTWg1+3yiNSx2BfDj
	L89RN+vNEE96kim5wofY6k5jLz022MAQ=
X-Gm-Gg: ASbGncuc2gWm21386EhbXfkEQVsk0XixAb0Ey5KEdMqoy4ZP2p3KcI8aJOOtTe4cvHK
	ziI/lPkzM4upk3OQN0xtnl9T+4/bsYTbrVDMcS/1WcdAIXHBWgu0Kxi/ayXMjPJRyoyfRsuY9h9
	id+ZXOkklVbzUorYcoORdGbWleO3Rt/C4oj56ZrdgwZtudxsp1ObPJSpQ1IkuHM2GKSslzzYrLN
	ieMTL7kt7fuoxVXKFA=
X-Google-Smtp-Source: AGHT+IG6Btn4D62i61GTeahmN3XXy/fWUvLkX1tmurIgkSJZdzTcBLxz/MoFPtpfK3zY4u7/sqI2FdTEUyAlENCj+qc=
X-Received: by 2002:a05:6402:26c9:b0:615:1072:f34d with SMTP id
 4fb4d7f45d1cf-6151072f736mr9191847a12.15.1753779500321; Tue, 29 Jul 2025
 01:58:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250728163752.9778-1-linmag7@gmail.com> <20250728163752.9778-2-linmag7@gmail.com>
 <aIh5HY1nVGusQ9Yb@infradead.org>
In-Reply-To: <aIh5HY1nVGusQ9Yb@infradead.org>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Tue, 29 Jul 2025 10:58:08 +0200
X-Gm-Features: Ac12FXydrUc1KfbMt61O_tdNCkOAdA0oPwD-BlPeGy3YRVdpiOs72ppYE78eFck
Message-ID: <CA+=Fv5QwEmgoHj=N-A-Ur1=XJMhP0QSoaWfdiw22RGvrGbgFdg@mail.gmail.com>
Subject: Re: [PATCH 1/1] scsi: qla1280: Make 64-bit DMA addressing a Kconfig option
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-alpha@vger.kernel.org, martin.petersen@oracle.com, 
	James.Bottomley@hansenpartnership.com, macro@orcam.me.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2025 at 9:32=E2=80=AFAM Christoph Hellwig <hch@infradead.or=
g> wrote:

>
> Compile time options like this are annoying as they require
> distributions to pick a default.  Why not at least a module option
> even if it just a workaround?

I see your point, I've been looking at how the driver for the NCR53C8XX
SYM53C8XX family of PCI-SCSI controllers does things. The driver
has a SCSI_SYM53C8XX_DMA_ADDRESSING_MOD compile time
option for setting DMA parameters.

The qla1280 driver has different code for 32-bit and 64-bit mode of
the driver, implying that 32 or 64 bit modes need to be selected at
compile time.

However, it would work just using the 64-bit version
of the driver but, while defaulting to a 64-bit DMA bit mask, making
it possible to limit the DMA bit mask to 32-bit via a kernel module
option. This would make it possible to avoid using the
"monster window" for DMA transfers on tsunami based Alphas.
If the driver is built in 32-bit mode, this module option would simply
have no effect.
