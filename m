Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CC3470EAD
	for <linux-scsi@vger.kernel.org>; Sun, 20 Sep 2026 17:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789924244; cv=none; b=NLIhMJpkOtRJ192mvu4LztdgMuVsRuh799ch5ea4KV3rIOFi1rjZoPc3Ot0sqdqusJ/lax29LN4vBsO1kxvByy4z13EwU1OJvoj9hqfLBCel2bmKe8ZBIq73OXDsT7GFCRKWnwKJ5BNWrr0Gwo5fHJKR4AzVajJsFyxe7c82yHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789924244; c=relaxed/simple;
	bh=m/K1OkPa5NYvWpIHpoqecii+PsO5ZMdWLsbXqX3ixEQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VvQVrFrAFlSpC1bFBUaLV5XybH6U47YjrjYj9X2w7SFaURn/OQKynWsCPG5JqlgJIF3JBSzcDM/iqSVpt3dqj4gGWPHHu2rj0/h2D9QudfY5mPLU6foqnVqPQiP08ZoVWmeNrBCk5mXRyLDPHiU6U0bIP+ZYwRyO0YZB3ioUaZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Fs927xIh; arc=none smtp.client-ip=209.85.214.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Fs927xIh"
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2dd753a52bbso43610235ad.0
        for <linux-scsi@vger.kernel.org>; Sun, 20 Sep 2026 10:10:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789924242; x=1790529042; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=m/K1OkPa5NYvWpIHpoqecii+PsO5ZMdWLsbXqX3ixEQ=;
        b=Fs927xIh17QospCUPJcbnL8Z6UqO6gmgq9M8qaSNDCKlLZrFivkHaw+bp8c/vjbNgk
         0MAQlV/RNu1icuSaUJhNw3xk9B0c3vQO1XKj1VCzGyafkzDS0mfbO3HG8D+BAOqb/V2Q
         ngMb+Mi5DpWFeISToyhxYXxUlCSE7wtWxWEoGKWOSXm8qtnbTvkf2SxyKy8Cog/uk55q
         EpWL5SO6ynEJ76ye+OwQWjTxLYrvk5hewbjU5FFUYm96mrdWKnD6B3HpeS5xDNOrg1Sd
         mz24TVQyCOPUMwtzs8M24NkkIFCozUJ0b0aTbdfVQAmz1eZSZQuow9Kc+t347uko1ouU
         Dnqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789924242; x=1790529042;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=m/K1OkPa5NYvWpIHpoqecii+PsO5ZMdWLsbXqX3ixEQ=;
        b=Gq/ZQA5ix8nAqo96jOuMIuwnKu+cGxPKd8VyuTAVpvgGYptTHMyCJSYIm8u27PbvL1
         M66Le7Y3NtDoWcDeen0pbWEilCbM7KGNgUBJZ+t6PEtSqfSLvHNOPQcdejFqThBEa0Dd
         +kR28bokLubyLFoSW6eYbxl9EhOv4l9c57/H9bFTKWNlvlPbKL9zpc/XEj7d7rmhQeSE
         XN1O1naxzBMVGWV1CvPMkcaJkgjnMrb+KS6510wL5e8UYVDJrPthnDgMAYTX2O1Jzk7+
         pHnMAW4xQWI72FPu4TK3uQRAn5m1f/B2otrVkIC+ov2vVi12iLSMf29HZ5g8mkV5qCXj
         GfuA==
X-Forwarded-Encrypted: i=1; AKwUvBwaXnjr0OCkxc1Hy/QX0nlyD2BcPN2dWi/U4g1BuUyQzhVUVupnOMCoLoJbdskfwJ7X/5NK37tHS7aU@vger.kernel.org
X-Gm-Message-State: AFuF++kBKe1xJ8z1NhX2t8mRLl3s5lP10Vte9jsDem6pL1dNr5qWDP4b
	XKiw+1n5DN46is1OknhHMNZaInYVSsZGWqlZkqHuh6kqt7UH2WkDbwC0mRUsdETyxBHwP7cTC6/
	GkDAZkBqpAygLqGwQgbh6vg==
X-Received: from plar12.prod.google.com ([2002:a17:902:c7cc:b0:2dd:5ae:3a51])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2f4c:b0:2dd:c170:2d4d with SMTP id d9443c01a7336-2ddc17034demr76642115ad.24.1789924242402;
 Sun, 20 Sep 2026 10:10:42 -0700 (PDT)
Date: Mon, 21 Sep 2026 01:10:40 +0800
In-Reply-To: <20260911024319.1346706-1-stanleyjhu@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260911024319.1346706-1-stanleyjhu@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260920171040.4052486-1-stanleyjhu@google.com>
Subject: Re: [PATCH 0/2] scsi: ufs: core: Handle devices declining optional
 Query IDNs
From: Stanley Jhu <stanleyjhu@google.com>
To: "Martin K . Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Stanley Jhu <stanleyjhu@google.com>, Xilin Wu <sophon@radxa.com>, 
	Bart Van Assche <bvanassche@acm.org>, Avri Altman <avri.altman@sandisk.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 11 Sep 2026 10:18:47 +0800, Stanley Jhu wrote:
> Compile tested on arm64 (defconfig + SCSI_UFSHCD).

Quick update for the thread: Xilin Wu tested this series on hardware
with a Kioxia THGJFJT2T85BAT0A UFS 4.0 part (with the device quirk
dropped) and confirmed in [1] that it resolves the 0xFD Query response
errors on boot and resume.

[1] https://lore.kernel.org/linux-scsi/B6ED6CADE807138B+422dda6a-301a-4bd1-befd-b932ea9f46e0@radxa.com/
