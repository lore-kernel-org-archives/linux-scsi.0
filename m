Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE0532DCF72
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 09:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761643637; cv=none; b=Fkx7lzWBMAoOWwFrEaqLS+pBtzMK17kfIX7TkeWlhcjWHNoTqscURtroYs9rvjjnyMGwmUySBahxFlSrXpq5de7hovBMIrrSEKtA8g+Z6KYEDFqSvOL8CDwRyvO7m1MQC8W69wTIiwoGOLd8/zYTM2b9uoV2MMLbT27lc95dAAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761643637; c=relaxed/simple;
	bh=DsG824BG8VfrLx/6GzaL6ozW38lprUU+gBBb9yNSXYw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=RkhakGhiQiYlHOHzBOeaVY5tZoZRRotkgqP9KUiEg5sRu4Wv2F7F20pSscB+dgpEVFiq6EkxkmTrF79ASkljUcVzqNK0au4qXrEtsKaOKeAU1ZbtKCyF8WXsblW8ba1a8yr6zkVQ3RD/eFIWprn7hldXDKGaFLoyWOReXwHEwI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h0Jh9HCx; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h0Jh9HCx"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4710683a644so47729805e9.0
        for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 02:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761643634; x=1762248434; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DsG824BG8VfrLx/6GzaL6ozW38lprUU+gBBb9yNSXYw=;
        b=h0Jh9HCxWH3WgcRsfOoWNnfYjlWgK3a33g6srrkEBfI4owgCUVQ/PpK3nc2NCj5Ojk
         T8lTpmDMcdy5gn4t7XV2hvkFfLHkoYKYt6W/pJW1LkHQV82j1174rwnFcJNORmHPoAJ4
         l/H4QIZCVp7+OG+efqptCsWvCBxyPr6EnLB1gTRfnrq/3RHI+vdBjL0OAsMMIG3LY8HR
         6greRl3srF2doVq9IXJDvQpS6hPrShiJGwAuSEJssLM98M2r4JDxRlhxDNCUihrrctBL
         naFYUaC+htSIBnq5xFyrRETuFraQxWHRzp4P2XyJKj1F1aV5DZCqQhl6G+gO35r8jjfb
         Piaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761643634; x=1762248434;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DsG824BG8VfrLx/6GzaL6ozW38lprUU+gBBb9yNSXYw=;
        b=ES0f+Lnw8rP1Bg6jl3jnIPgVqWNxXOWijSwQeZl/USpIEOvW2vhhSGf+l3u6B6N5DV
         AbOc1VaWjG88GRPHvmMUk29ROGNoiKt+76ofm3mqsFPIa/Q19eCEieqsmIqAGKEjoee+
         IuYq0LqW6+UvzmFHh9gfvTfrraIGCiwASEbSzKLGRwVkSe/r2QPh5PWtZc5vorSLyn0P
         rtiNAueugduL3hX7MioRIgt6Fnp7N0BO/e8bhZS/JqUridtBN9L98C18xo4aVqdKaghL
         r8ih3ffboaYuYBWP4GI17VxrHimWEA4bt/bCXCoj8bPWdeqc1VQNYly/GKuOx2wbf6dj
         aalA==
X-Forwarded-Encrypted: i=1; AJvYcCWzCRwix+gb9WnhSC2LHMJXa9ZTVES2LAdo0VRJHwBABajDRjV+W0jiX7PYMzfMSKvXFAejfqI5Yxei@vger.kernel.org
X-Gm-Message-State: AOJu0YzMzvlBw7h92bq3YXEhgReCtDbKzHNLG8tBfLXvB87rctE2i/Ow
	ryprs77rn4SWIYliAEpUGRb72Dwr2DgwQAt4O4uIjy7mBaSPfapmWstF
X-Gm-Gg: ASbGncvtrjFYsTH80JGnjzWNQQ6p/sBQon6EUnotXu3+3NKyO0QPXaao4OHvnVmV2oG
	gA0N/PSdqHc0N1ZGT4HlnLCQx24MjZFohpTXp4zEzsUiUMT2iseTKhaIyAHjViLn90DPlFy8wN3
	LnXs4iF4dmQ+qocD4zJlOjQbin403FuAg3mjrnVC41jDnXTJKYlnbFadeRHa7nxqCxJqmUDqMgg
	XJOcoM1mfE9omq43Syi318TEMn4WLD5ZpLKv+Hbd0xquAeP6IWGbcGw1xXl66eCwA+hTMcbcM+X
	Rcn/AvLFLf0lrcpgGU6/RdONl+SmaXuzCSmGYcLgZZpXHhcHK0s/Re1wiK7n29aUXuSAWaxZG4h
	jDr2lqS6NsOb3Xm0+eWkpxDyl4ugfCYWgWg/02j6W3+ExxctU4iJVE3Ns8dNms3m5mrSxvpXNje
	Enj9v8wleZ
X-Google-Smtp-Source: AGHT+IFmOkjQj68F8VI31v9M3Y6OgGcvj3za+ejQNvU6hmFmye4E4LQ/qtufcgSAJlri8epePhV7mw==
X-Received: by 2002:a05:600c:1515:b0:475:da17:a98b with SMTP id 5b1f17b1804b1-4771816ea42mr12818405e9.13.1761643633888;
        Tue, 28 Oct 2025 02:27:13 -0700 (PDT)
Received: from [192.168.1.187] ([161.230.67.253])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475dd03585esm184226025e9.6.2025.10.28.02.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 02:27:13 -0700 (PDT)
Message-ID: <7094ec529a800d6e29e51047ce93d21013dc914c.camel@gmail.com>
Subject: Re: [PATCH] scsi: pm: Drop unneeded call to
 pm_runtime_mark_last_busy()
From: Nuno =?ISO-8859-1?Q?S=E1?= <noname.nuno@gmail.com>
To: Bart Van Assche <bvanassche@acm.org>, nuno.sa@analog.com, 
	linux-scsi@vger.kernel.org
Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 28 Oct 2025 09:27:48 +0000
In-Reply-To: <8e3342b7-e8cc-44a4-a746-d35cb95613ce@acm.org>
References: <20251027-scsi-pm-improv-v1-1-cb9f0bceb4be@analog.com>
	 <8e3342b7-e8cc-44a4-a746-d35cb95613ce@acm.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.1 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Mon, 2025-10-27 at 09:37 -0700, Bart Van Assche wrote:
> On 10/27/25 8:20 AM, Nuno S=C3=A1 via B4 Relay wrote:
> > There's no need to explicitly call pm_runtime_mark_last_busy() since
> > pm_runtime_autosuspend() is now doing it.
>=20
> "now"? Please mention the commit that introduced this behavior change in
> the description of your patch.

Yes, commit 08071e64cb64 ("PM: runtime: Mark last busy stamp in
pm_runtime_autosuspend()") introduced it. I'll put it in the commit message=
.

- Nuno S=C3=A1

