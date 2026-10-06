Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0B93E3141
	for <linux-scsi@vger.kernel.org>; Tue,  6 Oct 2026 08:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791275758; cv=none; b=APjMGu5eEu29nlFj4JW0xvFRic1uGqRJBEgQokbqBkKqHxeg9jQew/DJKeYey7KlkQZG2KCPLSot6KZNO48br30JK269WpbCGld2WvfJK1EaWbpy78e9hGerVgbQx4LDRekqRt7eGp4wf07MmESgTpiA2epRhp6FtkMOKVLrZtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791275758; c=relaxed/simple;
	bh=jCGxsWDhCeD7oFUcGBe4JD4pOKhnWG5kWSE0uGdSQXg=;
	h=MIME-Version:In-Reply-To:References:Message-ID:Date:Subject:From:
	 To:Cc:Content-Type; b=FSK179DjGCcjzn+CnowMoeA94w0NpRHteWtmLL4XlYgONZSAHPHUTD4YtFJjwdluQTNZw4bbsCGrG37mEMNSvdngqYPps2rcxACikGhEAujoIN9+FEkOwsOuvofCDzp6Qh/uACdmmA4g02LFiCiGGmaQ4nLsNpbdz8mJpFeSzLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D2G6Ha2V; arc=none smtp.client-ip=209.85.210.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--stanleyjhu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D2G6Ha2V"
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-886129276ccso1900861b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 06 Oct 2026 01:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791275756; x=1791880556; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=jCGxsWDhCeD7oFUcGBe4JD4pOKhnWG5kWSE0uGdSQXg=;
        b=D2G6Ha2VCF6fCE2sjMqRFg9ZjBa5F9ifBxtW2Xt1P5v6DYKQeZFe01VqUaaTaTplV5
         CKUxvsEB/kfX6oYQ8fwMg8lmCiXFz9WSOCxkKFNQ7scBu51CmQk2D+Lyj537KamjFMn9
         uVIbGG21/rGTioLD7qXytqe6r3LZkt2aGQDXHPBapb6KrDiqqTpipo+8aAUIL9nqucX8
         Mee0wHOo6q9eRmF7SZTLh9GjbTVLGk4DyoFoCaPohMeRbWoXrp1nYdhqsW0eUVbpYAc1
         3eAUeN/J9BnoExEV69x+OgDSAOflkdm6cBdl+gDd9OB0CW4SnNMBfJoqTN7eN51HjGen
         ktfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791275756; x=1791880556;
        h=content-type:cc:to:from:subject:date:message-id:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jCGxsWDhCeD7oFUcGBe4JD4pOKhnWG5kWSE0uGdSQXg=;
        b=Wd5zZgF/foaJqkeIfP0gLWBxJJQZlQC35Nq/pQ+Sl8ykjrLZHtVUf1Ece8sGLZOrq9
         Fv2RLOmgM/tuRzRVT4IBaD1IhjJv0WKfP6lIvPzrrpzxrsibc7XsjStT4Khrrz4Y/gUQ
         Gdks2bBkMllyLZo7Xf7eRKiPOjdt6p+TemJu8/QUbLSanuCSS3v+rEJjUhykEPQZChNb
         q3yx4QnV2ux9oLSD5W2mkv/GUrBIv4orcFMnnssrTn4rfocoPauDrvBbaA3GToKXtx8V
         ReM217wE55ouIb1yfIWbGQ4xrR0cM5d/f9xQPOYA8vv2G/jdJmtmd6nMWiY+s3/VDGBE
         AwZQ==
X-Forwarded-Encrypted: i=1; AKwUvBzkOX+1k7/G7k0bUJHZu9rKlusbAQp1LG9dT3IqWOJr5HGW5nQYBi5xTrU9gMsOkxj+VQKRsBr5SSHR@vger.kernel.org
X-Gm-Message-State: AFuF++kei5+PG58VSm2fI83nHCkoRQTMiRGAj4fQOwfcWwOwOlmYfaHH
	xs5AVFdBrM/p5kGcZ/K1PZlqI9u2+Cmop9IR0iIzAc1TuzWRxZXjGA7utqxIDgCwbQFogdgk7Xn
	i2Bn1AmIGqvXKUUBMpndxKg==
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: from pfbgj14.prod.google.com ([2002:a05:6a00:840e:b0:886:fe91:dda4])
 (user=stanleyjhu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:2990:b0:88b:7278:ebed with SMTP id d2e1a72fcca58-890ddb0d82bmr609566b3a.20.1791275755834;
 Tue, 06 Oct 2026 01:35:55 -0700 (PDT)
In-Reply-To: <20261006082907.3405554-1-beanhuo@iokpp.de>
References: <20261006082907.3405554-1-beanhuo@iokpp.de>
Message-ID: <18dbe3cf2d3e54ce.3137322e31362e3131332e313435.357c9.0000sendgmr@google.com>
Date: Tue, 06 Oct 2026 08:35:55 +0000
Subject: Re: [PATCH] scsi: MAINTAINERS: Add Bean Huo and Stanley Jhu as UFS reviewers
From: Stanley Jhu <stanleyjhu@google.com>
To: Bean Huo <beanhuo@iokpp.de>
Cc: "Martin K. Petersen" <mkp@kernel.org>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	Alim Akhtar <alim.akhtar@samsung.com>, Bart Van Assche <bvanassche@acm.org>, 
	Bean Huo <beanhuo@micron.com>, linux-scsi@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes

On Tue, Oct 06, 2026 at 10:29:07AM +0200, Bean Huo wrote:
> Add both as reviewers (R:) for the UFS subsystem.

Acked-by: Stanley Jhu <stanleyjhu@google.com>
