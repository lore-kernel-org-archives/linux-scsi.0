Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5D51DED70
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 11:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739966263; cv=none; b=YW5rbXvkbAYVyhGnQwBhig973eo+IQ4GefH/Kq40Ffdg1C/om+lWe67FEZAQbIUQ071OJ/iSO+qc30pO2uSc37yyy+62//m73a2KaBseMBIJdCkeSzeuMahKvlepUmJhm7u2et/nO2Os6KKkCGudzehYAvqFJCoXYGleTWMZ5Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739966263; c=relaxed/simple;
	bh=mKPuqkaO5/tQYVpdTMpg9OTc7P54WtoXIuwWQ6pX94g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oQrQMWYkZYvGibQcPNQlI7+8rgfZPiqnfk17AbnsaKQcUtD4N86QDRDn4N6PrcBhFAq8RKBkiG3T9WIkNxQ0lpQuHUVecTlhmZNKzb5GmLC8xUg89YftS6PmyEG8Ahd8RW2vomOB/0c76WxI4FBiOL94VgVxzqsWtOBvAtYjnnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gIkp8IRK; arc=none smtp.client-ip=209.85.219.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gIkp8IRK"
Received: by mail-yb1-f175.google.com with SMTP id 3f1490d57ef6-e589c258663so7109335276.1
        for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 03:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739966260; x=1740571060; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mKPuqkaO5/tQYVpdTMpg9OTc7P54WtoXIuwWQ6pX94g=;
        b=gIkp8IRKJvgifB+QHtNUPsXi+sJP3TWPAXop0Z8xNea0lMDpyVyYQgGyx9/O35fxad
         sZBwD0Jj4qyyuFj0X5RFitM6o76ynm/wnBSL0aNKjRahAgrP6Suq44IMyyO+Y/tSwqLv
         KaavDcj1TQkMWmdZtS6VUX+Byn1pdfwYEIhdS8iQF5wpprFLdHB/Nv6JRd12HaiFzMU4
         iJpJo0WOOES+8gz3pdSbeQ+na1UvdxnyaLfOkIxo/Vm6y15zlzwQTFUQXGtVP8l7xB80
         K7+WM2r6WkfdsiOCmXFMeTgieczVAUtlfx0wtZm16zb5PWgAOglN9BU2qKHU/QOZnvrJ
         c/dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739966260; x=1740571060;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mKPuqkaO5/tQYVpdTMpg9OTc7P54WtoXIuwWQ6pX94g=;
        b=ng1RsJaXVYTeOMOHMNDlUg1InbtBHgCUzz9r4HwWgXSc06jdpBwMUeckK8RyobvL5q
         I044AOwJ9Xp8xlX/HQpRQeHTeA2PaB2pd7YoEBFVlSpsJJImnS18ekjmYJFhiXHc9YTj
         /npJWrqB3ISw4rMChSKsnl/ABqYAV7hfdJAowxHjjHTITAKyUTtR7tWiJW+25gzm9xWs
         8oUHYQIPv+uc3xwj8IaE3lbO3WcH+pbct13WAREVG+7AvWq4tWXfscjrKWnbjiPc3Dtx
         IbiDTGLXzIc1YihGg0nIoBH9v8k7jcTomwl4C1XA+w1Ur74hyXC5zDT+2MLyzqvqR/lB
         hO3g==
X-Forwarded-Encrypted: i=1; AJvYcCXjfy/S0/dnil1Uvidqd89RH304G6yALwsV8lqHbRs3zcGXZjNwRb/1mnr9n4MPuZp66mI0jGmT/W1F@vger.kernel.org
X-Gm-Message-State: AOJu0YzgP9mZl7avigyrYf0SpijcPJ2FGmWGx5RpgRorIHd9N6ly/aqI
	1ssX7vCKi9ljH6t/fPnnQ4Q3x+sNM7C7rfHa7aoWe8kzts/8vwsFiu4aFntN6rP9AnXhGNb6k2s
	0UvAx7PEGfPW/MVIEiwX6iJ7esOjUZujR59xqig==
X-Gm-Gg: ASbGncvT+0FvVc3MHLzpdkoewg6ZQeUW5kHyUuFfSR4WR+FiKhnlAo1K/G8w0cU0g8Q
	kg6/3xR8a3DNOIno1QTQkgktE91LLoUxU1CNk/WCPWcTj68ZPAwfguI7Wdw0j2QijFsIzIi7+Ww
	==
X-Google-Smtp-Source: AGHT+IHmLjRjhz37Ix+o6XyPakdzY6Uu3F+3kxUa8H2huII1zroZajXD9MVDQwO7EqR3XOK/hrhvfu283vamhduicEA=
X-Received: by 2002:a05:6902:d49:b0:e5e:1062:bcf7 with SMTP id
 3f1490d57ef6-e5e1062c055mr980483276.13.1739966260274; Wed, 19 Feb 2025
 03:57:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1738736156-119203-1-git-send-email-shawn.lin@rock-chips.com>
 <CAPDyKFq+pWXq75xEtfkeCkmkdZtfp9dAFej4M+6rO6EAUULf=w@mail.gmail.com>
 <yq14j0y25hd.fsf@ca-mkp.ca.oracle.com> <CAPDyKFqsiBaSV--a_SvJ1n0733XXjSoONztf0e=jsGTZhKxQJw@mail.gmail.com>
In-Reply-To: <CAPDyKFqsiBaSV--a_SvJ1n0733XXjSoONztf0e=jsGTZhKxQJw@mail.gmail.com>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Wed, 19 Feb 2025 12:57:04 +0100
X-Gm-Features: AWEUYZm5qq0kCFH5BGU-KOAykNEjhYZd727rd8VcRiDAXDF4w-LfbABoCwlPr4U
Message-ID: <CAPDyKFqMJRXRYymhijyWD-e=ScvEc_qbAmJBi--WsJd+zkQu6A@mail.gmail.com>
Subject: Re: [PATCH v7 0/7] Initial support for RK3576 UFS controller
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shawn Lin <shawn.lin@rock-chips.com>, 
	"James E . J . Bottomley" <james.bottomley@hansenpartnership.com>, Rob Herring <robh+dt@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Heiko Stuebner <heiko@sntech.de>, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	YiFeng Zhao <zyf@rock-chips.com>, Liang Chen <cl@rock-chips.com>, linux-scsi@vger.kernel.org, 
	linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-pm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Feb 2025 at 16:20, Ulf Hansson <ulf.hansson@linaro.org> wrote:
>
> On Wed, 12 Feb 2025 at 22:56, Martin K. Petersen
> <martin.petersen@oracle.com> wrote:
> >
> >
> > Ulf,
> >
> > > If so, may I suggest that I pick patch2, patch3 and patch4 via my
> > > pmdomain tree and share them via an immutable branch, so they can be
> > > pulled into James/Martin's scsi tree?
> >
> > Sure, that's fine with me.
>
> Okay, great! I have picked up the patches and pushed them to the below
> immutable branch, which is based upon rc2.
>
> git.kernel.org/pub/scm/linux/kernel/git/ulfh/linux-pm.git rockchip

Hi Martin,

We got a report about an issue in the branch above a couple of days
ago. The problem has been fixed and I have just published it to the
branch above.

If you already pulled-in the branch to your tree, please pull again to
get the fix too.

Kind regards
Uffe
