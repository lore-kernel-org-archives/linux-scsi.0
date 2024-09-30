Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1581B193428
	for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2024 15:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727710850; cv=none; b=VtNUeBb8/VPtNB+1I1laH66C9zBZJBWT2tDWa+nM+0gBZFoGf5NGC4gQNTYc4QuDnjN49tYP4McTQ3vdZNlH2Q8707R2Y8sY52gkGIn7AdEV+U5zxLDMwHsUR+x5vj76gtDzn2gdfX+HU6KxYgn2KUjahHda3IJWwDhA6M/Y1xA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727710850; c=relaxed/simple;
	bh=fDFumAK9igYZ+CxTHR9gCbxjlAoTzynxL/GKvBjAzsU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KklpC32fPRN6HJevCw2ieAO1v8nDtJHlp+WGYWqfoh+ue+7Y8KTSx1/7zVuzqMdU3YYH1laHCTaiuz5NZc1qdoKvGJetPkr+B/rBEYzLAaO1Pi2Lnm6xYdYTgBH4/aYMNUKBzdESWY/7L0ejKHlfEBj11f4QdXHNkFafcOp4uZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=networkplumber.org; spf=pass smtp.mailfrom=networkplumber.org; dkim=pass (2048-bit key) header.d=networkplumber-org.20230601.gappssmtp.com header.i=@networkplumber-org.20230601.gappssmtp.com header.b=csafDKve; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=networkplumber.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=networkplumber.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=networkplumber-org.20230601.gappssmtp.com header.i=@networkplumber-org.20230601.gappssmtp.com header.b="csafDKve"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-20b9b35c7c3so7361675ad.3
        for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2024 08:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20230601.gappssmtp.com; s=20230601; t=1727710848; x=1728315648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gk4IT+ziW7GSilMgu7AJgpoE41t4jq/Ls2rSzqW+beE=;
        b=csafDKvefF/P8ZewMQZITH2n/3TirhLRyV+fyujN8sG/8QTfABFbl7uLHCVd3xJp8o
         i45ZC5vAhS3FncRjCQg9sznJVAa/MzMr+8+NRoWXbcd3zT6QOVULcrStd3Rl3Rakgnsb
         lbNgj9YssLf7SKWOxuz2exxKwC/990ZbmOz7KpSNQDosnOPDfjtqUuWKcJYsZg2LTTH8
         2a9MHrQfG8BLSbJ0nm83tK11XHl2SLd4vXbn/KTk5e7XmrRwT9aAPk+0f2JqFSk7n6P6
         WpmPzQdRktvTnOG8m+pn3jDkfSE3OlgQgBJhnuzuJEwjNcTj9E0Hgmm9AnfaxRJVU1Kl
         7zYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727710848; x=1728315648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Gk4IT+ziW7GSilMgu7AJgpoE41t4jq/Ls2rSzqW+beE=;
        b=I29wgnr1iaTkEFEvMt1Ctkd6fMDRSoFX7spdkIvBfQA2vHw9PUy8UG0aBmrWUSLdaH
         0h6tserp0F96wj9/gPO45xR3CSqzt4nt7ukr/nmj777/EpPck7gNzQrI8asTTdEjeX5Y
         RL3q+eu5uGVmAAYXODbAC/SPkiXiiJcURrgtVMC3SX7ugegbuaXwWaov16taiXbM5lwN
         t4BTZwxyDdtJkrDkAIMUK0qqD95dQvWvrkQrbX3IGjB3um4bcB6FO8y39HyUH9BbyBKC
         dU8J2mZUpPR6wzAjwbXE8h5SX4jLywqf8YVH5cUWYdZWsHkevN+NbbrGesEGlEAwD01+
         qCIg==
X-Forwarded-Encrypted: i=1; AJvYcCW2PPeHYvJali5Fa7XXwc2rOYg5Z1jF6MgeE1Psf7QsuM0B2SRS3JFpch2m5RqznSewO/nC+uvOH96h@vger.kernel.org
X-Gm-Message-State: AOJu0Yx3VDAT5KMEuU3DGw4P3P/K/NEIn9isYMIAD9kwdAsaHnMplf7N
	Ii6rF/0MhfCiIe7vozIEhlTP2HIwl2fRSDCfWGrc7krtzZYucKAlt/lZazmtMec=
X-Google-Smtp-Source: AGHT+IEBTYKGJiVF/hvLtnqHSF6GUD7YmyDMyv0oyolLcyv9IFVLXr8V4Z3pE6cLuKRIJT4zroumAw==
X-Received: by 2002:a17:902:f54f:b0:20b:5c94:da02 with SMTP id d9443c01a7336-20b5c94de48mr112201815ad.33.1727710848215;
        Mon, 30 Sep 2024 08:40:48 -0700 (PDT)
Received: from hermes.local (204-195-96-226.wavecable.com. [204.195.96.226])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20b37e6c997sm55788515ad.307.2024.09.30.08.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 08:40:47 -0700 (PDT)
Date: Mon, 30 Sep 2024 08:40:45 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-media@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-fscrypt@vger.kernel.org, linux-scsi@vger.kernel.org,
 bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
 kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, Jamal Hadi Salim
 <jhs@mojatatu.com>, Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko
 <jiri@resnulli.us>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>
Subject: Re: [PATCH v3 17/19] netem: Include <linux/prandom.h> in
 sch_netem.c
Message-ID: <20240930084045.7c0e913e@hermes.local>
In-Reply-To: <20240930123702.803617-18-ubizjak@gmail.com>
References: <20240930123702.803617-1-ubizjak@gmail.com>
	<20240930123702.803617-18-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 30 Sep 2024 14:33:28 +0200
Uros Bizjak <ubizjak@gmail.com> wrote:

> Include <linux/prandom.h> header to allow the removal of legacy
> inclusion of <linux/prandom.h> from <linux/random.h>.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Stephen Hemminger <stephen@networkplumber.org>
> Cc: Jamal Hadi Salim <jhs@mojatatu.com>
> Cc: Cong Wang <xiyou.wangcong@gmail.com>
> Cc: Jiri Pirko <jiri@resnulli.us>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>

Makes sense

Acked-by: Stephen Hemminger <stephen@networkplumber.org>
