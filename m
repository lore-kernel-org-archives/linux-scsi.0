Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB523368AA
	for <linux-scsi@vger.kernel.org>; Sun,  5 Apr 2026 11:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775388509; cv=pass; b=m/tBcDnwlLz+O1JnWI9SLJoBXX2dTDQZ5UwaAFEjHX5NbXSTKkecQ0uPKbCluxUum4ulJtFmKThXgXj1zmZztWlu72EBQ2UIuNcd8i6L+nukWMx1YGIBHH1fsZp1Fq3rDC/urU9cnjwJ8k2sZ42r6Z2Rt7k3OYD5OpfkzNjnbg0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775388509; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K8mzJ7sOzpKw1MQazVsN1jU2q7/wkNfTvB+lD/D5l9spTVwbernZ+BSju5iO+5ckamWR0dn+39qtFmqYeCxqTrcSDwAfdDBS60o/Kw48NeN1VWARKWQZkGTNLZNdZSVXO5yxz0VBXYeWsV76404XGNa0UHgZT8AONZLiZLklLik=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eiWX6n8/; arc=pass smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eiWX6n8/"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-66ee0241bc4so289091a12.2
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2026 04:28:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775388507; cv=none;
        d=google.com; s=arc-20240605;
        b=CaUR4ZecepyE3xdrGLVxvKG1bj/HnY1vaXXZ4ZUJQY4jK4iBC3uQjqkLvi/68NXwWQ
         cmbjVsBAEjzah4EBlSbql7Vkm3nnQUE5V1kG7JUhrWKwxdiOvNpWvpvP9tFYsD68nXLY
         vRfj3Va+gr9l5CQGTpjPU6726jOMeGA2SiiGJDA4K/6Suu5Kw2Iz12wlTKivvXyJPTJC
         +myiWX6MIw9jOsn1rOULwcFJv8CfShEHbt9n29vcGe5WEz2zSA33bAb74E8aLhy2lFAo
         0WaaUJpCRBCp4SU7/BLxZFr8x+pfPsEAfILGTcKP44qA+MPOmjvS3+OQze2xuu2JPlbD
         HAIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        fh=QpoT/Gj24VW4T+19bKUTLkzqRv2/tMk6BO+AoULMAq4=;
        b=VMx2hkRh0vCYTyLOkx8mw6Y4Anegucqa8N+57zO6s7zLEaglP768yZ4dIc31uAcTK4
         cX4Fg/68YNolZFn3uApv1P2E6W/G/jGqBDO/RwY/tk1npla18uFdELH743hfWS2GqFzV
         dIF8B9RI5wvA9G+8BklOlP9qU7ikinrUYU/RghZdrnEfMkKZV3/tITaxsXaYqv7ToqdZ
         Pc+c7rYsULw74t5I/Bfdr9oh5tcYPujjfLO3D+u+8LxXXhSX4RpkEz0lsseFQrUhr7cv
         4zTP6oWZy0xkGdXsKDzgNMRbeX9GV0WItUFlU2yLRHlbEveo4uOYjHGcfZ2lvnsZNUoN
         uQcw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775388507; x=1775993307; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=eiWX6n8/dvQP2epzag+YOiOJKImwBf0ETOFRZpxjC1rfx2fIJn7MwIyhhxwEbXmV0P
         9OhNwTVtZ3EAiOuT0enMlxKRW1mnF++pITBf6ykD4l7mDgmVZ48drY31swGtS02HskNh
         Elt1Zlqr2ohEkg4Ekrdt0gu+YaYNTZC8lf5ZnAydk1huj7gEQ4xfT6rbejcP4gd2gVTC
         JpW6WxBgEd+F2j5017dD+4LTHGLR6qU+PTdO30NGJQ/+70vONaJea+d40KxMPhuObiOl
         Pd6rL10zgz6GHhHRlnMXmJlOCf6mghUDiTX50gl3H43rFuqbRdxiZl8TNQj2cb1ZTW1b
         S77w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775388507; x=1775993307;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
        b=Yr84jyo27Nic1KRDGTkRw3sHcpYWTKdnmXhMwvtJyYRNzTaqpHSoWmNsOYtIXa7pe6
         703TXrP1ncyfAW/z4q5WSjm7XnnSapiFeZN/6BLH8y7PBS0K0wzzxFql4YPUQoAG7H+f
         lhO8MLfNTNXssUF5E+RKiQQZUctjvFjfNG9Kxw5xTRVk3wC+J3GdrDKErAHQdQHRAwmv
         jUYxPYPWVJshqkFL+RE1IeksimifZc2mVVhlHnW8GZbXU3pS6twb5c3putr5sVWyRIOT
         CpdNRYKP+yvyB6K3gt+W4HKAca2Rh795IoasqvJW/gWUfFTb1HXuUymxEUyk8UkNz67F
         V78w==
X-Forwarded-Encrypted: i=1; AJvYcCWGD/BdY1Bi3BACESwHvGoJXOQVC25FZ45Rf/1+Iuh32XNIq5Nj2lbvAf+RLyc7RcGSnB3DOmrU9rbm@vger.kernel.org
X-Gm-Message-State: AOJu0YwCjPJtYqnfPG6O1cn2Jf7U77MRPkEivF2LQq2dxx39aKkSWFFs
	wgUk8rJzsO2pTUPokqBY1Di/MHCdIiUl+ETHtcW38nCpJjk9u/ZLB49lE7xKO9l3NG2AJcXMc3R
	o4EMYXcuDCGOSRl39El9E72Np101zsA==
X-Gm-Gg: AeBDiet+j4Rd5ImV8bK8dUpEmQ5lvfKIrJmBZJW2jJF4+apO5wxmQ4KVrVKjbxiDiBh
	JEp26CxHl7oCuEXz8zNbdm0EBwCtu0aG4sckh4mO6+vlWOdNUH272idzJTcE/+SCy/H5mSkq3Ti
	6J8FdRpOjAur/BvaF2fDFOcGXwlp0fuGmLSiaOvwklg5SJWZLFowhN6desJ3tYaN7K530Vjb/cq
	SQ+4Ng+l0MAu78dVXR8a32emof+ekdkdLleLVaYt9e446lNJtc2DLeB5i6kfku51icC8drmOkHC
	iJ0XA3rfS0qwyz62C8lo9kA4E+taghI8upwIu1a4HG2HQkkCZcsxRf3SjLolvRRGIioiFA==
X-Received: by 2002:a05:6402:510d:b0:66d:eb3c:e33a with SMTP id
 4fb4d7f45d1cf-66e3f3cd75amr4391626a12.1.1775388506893; Sun, 05 Apr 2026
 04:28:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403194109.2255933-1-csander@purestorage.com> <20260403194109.2255933-3-csander@purestorage.com>
In-Reply-To: <20260403194109.2255933-3-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Sun, 5 Apr 2026 16:57:47 +0530
X-Gm-Features: AQROBzB7BsO7HtCIFo-YLrsx_ROEx0YM6hJF0_8-6yyuGMvlIZYevxnPKzknkJw
Message-ID: <CACzX3AsJbxpYdVPiSeY8bjZVVWDfMuzGSH_dsTqzBvGGbkvx8g@mail.gmail.com>
Subject: Re: [PATCH 2/6] block: use integrity interval instead of sector as seed
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
