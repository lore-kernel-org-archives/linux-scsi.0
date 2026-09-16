Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE2474AB3DA
	for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 16:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789576131; cv=none; b=rRYLbsuHmEqbc7trjlyFlGFwu2JMezTvMLJsQ5xeRjb67KNg4IcvK9CjrsbW7VzrxYFZCd/tN8nghdTX5Lu94sUcaAZLgFGlqwMywN6SoKPD8vL4StXiLD51JmeyPRIRzWJnlZVwbv1mEmOg+EC9T4P/xKLjvzWl+6jtQ9aO86g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789576131; c=relaxed/simple;
	bh=sd8lC+4Cqbrm6JY6F2H3FLocfjos/39Rx7c2SQsUVHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YeguBgNX+VXbXzv6NfhJnX17e+HAXGDSIh29kUERj/pax7iazN88Blw67XX2gHyifzfzwbJidg+0I50/U4PrTOuJrIqTr8csiWGwsZzdKrC3dXnlfP9+mRZMYNaFmM07lR+YMQYDS9Zt56XPOu9egTvR5SWetlaHOD6s18P4zTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M+FaMes8; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M+FaMes8"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4c08393dfso886340a12.3
        for <linux-scsi@vger.kernel.org>; Wed, 16 Sep 2026 09:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789576129; x=1790180929; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sd8lC+4Cqbrm6JY6F2H3FLocfjos/39Rx7c2SQsUVHg=;
        b=M+FaMes8POydks9qxsVMwuSEEz6WSq2JFHH/frLsPfPq6TgAtbdGzf1lqOEGg7luDo
         QYQdKMS2m0pgVEa4DNqGCSZgdQQNjVVNrBnAfF3xWUV9bQty7Y8h7IG4YBlmkcHEA/e2
         0JCTw5EzZwofmPAbwdOI6XeD/QFB4eoXHduHuRZiAag9zfm8hnSuNHdSw8QCn4EOZkmP
         QbeCwZCQ1J8fqo8XZNBf0ZvDzcljnk62t3X7Bhu5dTwb2VUkIupAMyX6LlOeLEMsvdFN
         m47fuHlbyUwPxNxT9GDRV9WHoAeS4YdgZcq/+9pGePkj4HJvEEhdVVbeLILIYmUZMd4A
         cypQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789576129; x=1790180929;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sd8lC+4Cqbrm6JY6F2H3FLocfjos/39Rx7c2SQsUVHg=;
        b=l6J5quDb9WGbeT42U7CgwF4hIBZcNdbr+nG/m4kdkcXUpT9P8jGu1jpJdApNLfN7YE
         IBGFmGvjDYK0J0yTf8QR0xYgNgEAh/jWpU9Ip9Q4vY4Zi/Oeo89gzwDkIq5gIePfBrJk
         wyzHiD7r1d2VG6atGydAhTe7GFAM+io8aENSYkMOf8Ww51iSB07Ukyn9Thn2FLKHM/2T
         9oJ8qm6y2YwRbRQWDXtXVA3cYDzC/Wag3dIqSyKnXRs9Tlkqltb1VbOC0Qwl+K6ine89
         O5IMi2qBLmlOwz2RXzB5uvU3cr8zCApyertbKXJyn35QHwACMeEbPrYvFrP0HnfZeRhZ
         3ZLA==
X-Forwarded-Encrypted: i=1; AKwUvBz+FFdSC31k3jv1sk8odnW5duvGPwdZzGlANTvmabrDEdX//5NgxQrA0E5hNJ2zWSVKKe8Pona1iY7H@vger.kernel.org
X-Gm-Message-State: AFuF++kPIsMdovDjUHMdNEJsmf9f1HPuxpVbT8xkg+c2PTYrRJJFBNBh
	7OsnjJG3Ir6AtyUBZP7DoZZPq9TAbvIsjBGLAEkfAuG5Nw45epGC2bOL
X-Gm-Gg: AYBFou3WxqTxxFlqt6PKd/p6qYrX8DlC0Q9zivj8bGBxXGBGB/kUdIzzV2hzxA/hEgM
	SXlRGI+9xA0tlrNgyv9ns+ozF4+LSxoMWlajCqhUeuFhW4QD63iPfyT7+cXVjrCQMUiR/Y+/qaD
	MrMs59FAVAo2CXwfDhPWpRUHUb6+NbYO18Qda2NwMDE5fVORHjixPi3Q32PHItBysOUpT5jKevz
	JFUDs8RCr3/nIpudJEgpTDEwpvaAvEIM1TYrZlnPh9niiiPfRjuOzSMjVpER28vFgF/0LWf5lUU
	qmmy4rt1gBH/4Q+NDeoVbL/UjXj1AB7uASldHiZVMxXL7WMvYxV69gBXaAxE9OyUMAlwaq/Sx0T
	J/C6w8hm/EwfiawHXC2td0hdrSWw3t1Sox+p72HI6GPqChHstKVi5Xa9lMX9pUzYyJrPkT2VF3j
	7QroeEK61e+aeQjM2pTK6chKbttXgtK+wlQlvGfunu+1VF+9r5JlYDhQ5gWuL8GEJvpw==
X-Received: by 2002:a17:90b:5105:b0:39d:f18c:5f05 with SMTP id 98e67ed59e1d1-39e1e25a054mr7305861a91.2.1789576129023;
        Wed, 16 Sep 2026 09:28:49 -0700 (PDT)
Received: from jm-X870 ([2001:e60:20dd:7c28:de1c:fff7:d3a4:d8c7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e360a9210sm217191a91.15.2026.09.16.09.28.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 09:28:48 -0700 (PDT)
From: Jaemyung Lee <ldc.jml@gmail.com>
X-Google-Original-From: Jaemyung Lee <jaemyung.lee@samsung.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Jaemyung Lee <jaemyung.lee@samsung.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	bjorn3_gh@protonmail.com,
	Benno Lossin <lossin@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	work@onurozkan.dev,
	linux-kernel@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH RFC] drivers/rufs: add Rust UFS host controller driver
Date: Thu, 17 Sep 2026 01:28:38 +0900
Message-ID: <20260916162838.2557370-1-jaemyung.lee@samsung.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <2026091124-treason-trickily-bc52@gregkh>
References: <20260912-rufs-private-v1-1-716db733e655@samsung.com> <2026091124-treason-trickily-bc52@gregkh>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 2026-09-11 at 22:27 +0200, Greg KH wrote:
> Many many years ago, the USB subsystem tried to bypass the SCSI midlayer
> for its storage driver, and while it was a "quick solution" at the time,
> in the end, it didn't work out and we dropped the driver as it just made
> no sense to keep duplicating all of the logic all the time.
>
> So I wouldn't recommend it, as long as UFS builds on top of the SCSI
> commands and the like, you should not attempt to duplicate it in a
> separate driver, no matter how much "simpler" it initially seems to be.

Thank you for pointing us to the `ub` history. I had not considered that
case when working on RUFS.

After reviewing the current SCSI and UFS paths in more detail, I agree that
the initial normal-I/O implementation is not evidence that a standalone
driver remains simpler. The difficult parts are exactly the parts that are
still missing: sense and retry policy, abort and reset escalation, late
completion, power management, device discovery, and existing userspace
interfaces.

I think the next step is to identify concrete problems in the current UFS
integration and compare a standalone design with focused improvements to
`ufshcd`. If the complete design only reproduces SCSI functionality and its
corner cases, a second path would not be justified.

> 30 files and 10000 lines doesn't seem that simple :)

That is fair. Calling the design simple at this stage was not right. The
driver is already substantial while several hard areas are not present.

I will treat the earlier failed approach as a design constraint, not as
history that can be dismissed because UFS is a different device class.

Regards,
Jaemyung
