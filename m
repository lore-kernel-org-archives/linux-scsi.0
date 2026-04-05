Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56C693368AA
	for <linux-scsi@vger.kernel.org>; Sun,  5 Apr 2026 11:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775388564; cv=pass; b=gfPk89lqgHcKfSgkWgLAs2mOePuFUAlj+Jmw7jGHHy3gr/3x6eKKKlOFxuUa1CvNGRMOsJ5UC9gcKdJJOnwiUpqTXEn7s8jJSxPwwcyuGWor4fHcLw3pS38FMqKFymIrIsICw8tpw2rhP2EbUwty0LryOnZC61FFChgM4yF/Vig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775388564; c=relaxed/simple;
	bh=DShwsFfuiYCMrn3K4etN1h9yvssJ5Zz+2dg4zhc0vIY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NRP0Lh4Osx6Z6bsV02PNIRtQ7gdvEtOilXvt3uMQTc2XCi5N0zupkAR4BtKvxCqQ1Tqf3LaP8W/uheKgc8jY5leCY2esn4ZcfoIU+mgLesyNiDceJQbZf3bAPb8vlQDapqOscRP7l4PP+8I5xmpn7kTU0p+7j6neKTuBznajN6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JRwA5s6U; arc=pass smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JRwA5s6U"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b980b35534eso674999666b.1
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2026 04:29:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775388562; cv=none;
        d=google.com; s=arc-20240605;
        b=VpFEXIrnnLLh8vO2ExUOWHGHkCQY/WNonhuxFKb4kxzFt1xYD7U9mMLZpW3BBn+YG2
         w3fE7ayEEYu6Tc6HG74GvacEq73/rSr2ZbHk849NvAJhUIZ/FoQgvU45JkAIpd3vtccq
         TI/07pHWC6aXjeI8OKQ8EbO8um9OrWnWjY9oJw9YGLdw5IPZcaYFRtITmB43UEYm6ZwZ
         z8sc+sCOdkvtW/icKL1knXE7vZ1f28kl8cJ3yi9ffK9FW6LGNldUZojaEw44TxXaIMFO
         ansPthos6TylFk60DNnV5fvIqfw9RnOaaEx/gFM6Lm1Mt1otnBqr/Vmx6nMuf3hHSC2D
         WDwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DShwsFfuiYCMrn3K4etN1h9yvssJ5Zz+2dg4zhc0vIY=;
        fh=+X2KFBnQbdUANWeK6hgz7Z9F8wdcc3cV5seuzEnPdkk=;
        b=IYDHzN90m9irqwwY16w5F4j0l9YlTNbuJSBFTINlEP718h5dckQG/eKPMWgNEMKw26
         DK9SVL18DfwM4AyZstWnMAH2Lyt5wLpCZJyhR0a5eNptWFotZ0S3ZlmNXcUJ022GvBwK
         CCE6VeetkRiV5AacYRFxPxnR03wYU4Hfh3fgx9foaGQ7J1wxu2M0RA3YybCBdC9blsY6
         zxB5HigFdR06V3jR/6t8zK9OzrYH1CjVvUfln4iwOn9+ty/1uuTTvYLA3tblROtL45Io
         dddjQLMuufjlUCdk+tHJetz+AyMIqUv6SDxsFCJXmVYE8lqWIda8ZhqZSDIg/zWov368
         cnJA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775388562; x=1775993362; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DShwsFfuiYCMrn3K4etN1h9yvssJ5Zz+2dg4zhc0vIY=;
        b=JRwA5s6Ulbe0lLrICQqrynQmDhtzK61AF5XFyUCmO6fy/fO1YsALAQe9WI+BMKVe3j
         RsUkW72bGHd42EfGq+3Sbg8RWfHn6QYDc9nD5axgVL8VuZM1Rf9ubELQUbqMfuh3l4GK
         AOHbwJHX4oLILy6EySOwINOllVqC4nJdt1JdxAWlHJBaQMAuDoZc7I7LPpVLhkyg0qzW
         cCSe8hLKbtmHjg4l6ylW+RN7yiEzJSpWDssteT7WzIicA3m5Blv7oigqfqeATzWh1cJK
         QgRQGxkbUh/ujn4QA4tBhI3nLBEVABlq8J2TiSwDguWL8TXFEpOm6YH5Im0f3oKSuu2n
         c2gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775388562; x=1775993362;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DShwsFfuiYCMrn3K4etN1h9yvssJ5Zz+2dg4zhc0vIY=;
        b=hdw/K/49S0ngJHadEwDRtmLG5mSMqh5RuyO9rE4XL727wZbA1TrFLrYqOMYXXpDAi8
         roNexwkfCc9jJPVJlZYJFH6SCyIQ/XulCxRhcnzUnGlIq97MfXGdG/HYYRSIaZzSruOp
         HS6JRUk7tcPkmhWQnKjVnG9eelPv2SHh7XE3O+QwDd7V9W22srYKgGuERpSrfQPOpWNR
         tWzAgJkT5H67n5dyH7QsLiITmi9rPrFbOh31XmmSN7dmbC2y2rxVhF0TQWhD7xmOb9JF
         kcPMd0iRwxTnu+KDIOxLu4RZZyhsVzfMppMTEBWRTQ6rQWluNwNjuzlVuFC6pt1DKZtK
         4PAA==
X-Forwarded-Encrypted: i=1; AJvYcCVKpyklJGXlkf3UiyISAUrSvNoTMaRRnFVZgzrV9y6mttPATv55+36KF9AJalLY2iyu5LyJsOSaOP4c@vger.kernel.org
X-Gm-Message-State: AOJu0YwEuyaNbguAE8fucj2rJ7HvCWITJgEy1VvOkZibHHR1KSCJ0T0f
	4416YNiqeosfZ1FtxbiZTbn0bzbfPs0hpP05UX9wVqJptKYEicyLkIlwD+VAAdO9ZpCIluwbLaq
	H9+M3V0WEKssUv1a1nNiKlJeanK4kAQ==
X-Gm-Gg: AeBDietNCVhqailCD6RLrF8LDKUzQSwwqvIowX78K2vIW7iM+f6ZmAKrwOKDCqbBllH
	PBYNJxNpI/3O64cVSBzMnEgczrjmFm5PewpFRlVq/twJy8oe5/pjfd++YA9yCBnXjCeX3lhGzhL
	9R+xVOJvJOb4i6oBWPDWVpcSOYEODG5SAnlZKQVLfobr18TcjHK9RQ1EndRyBhGjiY30TNKom2D
	MLaT5J/H/mcLT3j/epuF2zCy83s8hBCLToHxHsAjSWepMWUZ2kPMaQVc0NwYh9xsTiSOb6+rn21
	rU1zD3DOK1kZqSjFVCoUBPZPgOGVtJEZEf+HtYOYwJUDFs8qENg3xytPx41R3qoAYMLHYg==
X-Received: by 2002:a17:907:96a0:b0:b97:b149:4e72 with SMTP id
 a640c23a62f3a-b9c4713a360mr613633166b.28.1775388561627; Sun, 05 Apr 2026
 04:29:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403194109.2255933-1-csander@purestorage.com> <20260403194109.2255933-4-csander@purestorage.com>
In-Reply-To: <20260403194109.2255933-4-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Sun, 5 Apr 2026 16:58:43 +0530
X-Gm-Features: AQROBzBzw9s6pxMkbcgpTMX5W8n4QANeXDJvCU5tpcGpnilon7LOxG0WvSR_FnA
Message-ID: <CACzX3At16V+ZLqoWh4UNEJ6p60x94x66HxzTtPUuJ+KWxs4AXQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] bio-integrity-fs: pass data iter to bio_integrity_verify()
To: Caleb Sander Mateos <csander@purestorage.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	Anuj Gupta <anuj20.g@samsung.com>
Content-Type: text/plain; charset="UTF-8"

> bio_integrity_verify() expects the passed struct bvec_iter to be an
> iterator over bio data, not integrity. So construct a separate data
> bvec_iter without the bio_integrity_bytes() conversion and pass it to
> bio_integrity_verify() instead of bip_iter.

Good catch!
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
