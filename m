Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94496221277
	for <linux-scsi@vger.kernel.org>; Sun,  5 Apr 2026 11:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775388619; cv=pass; b=FxCq/5nFY0jRq4Byq0Yt0aZC0zB+E9D1xa7EHWtS8YHNpyfkNkq70klcXx/Suglh3CWZlaJk4v5egLxxEqY4xPT3uqYCZcDLn48bZDqnlJGPqaus0rmW8bi0cyVnpzFJYaI72uhSLkDA3QcbBpyhN8yrX1CvjhVAZsvz4cG+Lws=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775388619; c=relaxed/simple;
	bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PW82h56BM3lI3yn4r25tWaZYpP7htImnuMPI6+xpMqdDEEt18H6/tGnVnH4CvAIfCpQ1yV1Nv1wRfSrikbq0cw2Fsx4/2RqkS4oHsAc3wRXKxKtx87HVdfyciXkUbOzW8V1kK6IFgfpylQLNdk8+km2FWggp1r33sQolRLOS06w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a+629FMc; arc=pass smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a+629FMc"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-66ee02e2c55so295178a12.2
        for <linux-scsi@vger.kernel.org>; Sun, 05 Apr 2026 04:30:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775388617; cv=none;
        d=google.com; s=arc-20240605;
        b=A2SbZDhKBwPCfcI7siQm1ZrWryqcQjRl2dlixUmRkHuAwY3d7aEAsV2++O7Bzh3cfK
         hPP9TBMx9WCGMowPfefk4cq2Vvt3eM3Gv5PWaS3aaG7m5+7j2VjOQJV2sStnigAwncpn
         kZhMujp46eKAyDyDnPVabaTbr/7XYtsyK1BNOt3FVifzJUhnB4QMevrNMtsdGAs9mJE8
         FaDixilzQk3eAei8XcmalQE7fi9Q36zgvxozb9VYEiwVjuddcwU3jZAf74zd1+JKkCHT
         HZFcRuNKUaG5BAGBTYlOypCnPFX0rLLFfWZ+hIEEeIZQJ7UDZI5CxAWQbM4JuojM/DdV
         +I5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
        fh=TqWiX0598OPyKKI2WdbBVNbgek+/VSaVOxAARQ8nJ28=;
        b=E6CphiSID3kHkBI5lKl0IZF5KHtEkfnz/lvZ7PoPxbD3tjuCyxp982Mw8p8mA47Lx4
         dCK0G6LWgWcM15F+2jfz0XjE32M5GhKm5eHTMZlls4w9+frP8JdTYH+Oe4rKiU+QXABP
         nsJsRup3Yc75kg+xhLgjQSe+4IkJjMZ5mpPOU4u6IN5n+EuEyzo/0/z0FWg28IVeqDGA
         8xtzkyybLHAHXC1A0GzzisYOhoFYoOS1NB0fjQeceT0udQVmTrjZ9KLwFWhFB69FNI9P
         uw2Uo5kF3bNlHe9RpLcQNnDbREkDZrGrh9o0V6Jvlgj/uJaRTSSOUVQeZUOv+fkt2PKi
         rlPg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1775388617; x=1775993417; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
        b=a+629FMchi6KQ7gsXOapCt+K5NIEeVvHgtNI+Pf6DhtT28irjcfAi57toEJQqFY583
         1Z7vPU4+BzTeWrBQkWe5iXd+pkATi565F9dOZfVnsThA3n7zg1ZaspPgVw2Yb8M32Arq
         oKeRw+T+cjgivu7GZRlmMMzBB3jqCLPrvg0Lw2X6ojyf5kVw6lkkS2G4aWNZpVrAw3t9
         H3KLWrs1S2syd9aw+AwTTdBl1JEZph3O3UsL4C/azc1Jn9JZNO0RfZEfsesM/fEqQcYx
         4+xHEE8OWH9XFRFZoJKbFaMDGD9r4QkOeoeW2ZIjbDeqsfeOiMDALE7OrDJakbHGiiKy
         CoHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775388617; x=1775993417;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DvF0YtJZCPbcobMdQgE3+ZNHa9Fjrq28Jh3rCZ4Bn5k=;
        b=Vyxd5H/V74c0JIpGZY8jcxnej37jgtZwm45Rc4Y4Qi9NXhcNIefXFw8OE436XmofvJ
         pDYo+YqqdvgUQBJk/O4itzKjaadqNj2KI4wSZYkY/IeK+Ddglp/NZfw/E56mU+ji4mXz
         RaKKfjpMs+GOxUS7T0jGpjtrAR+kd5McVqSP7I8QfEwBbCV+6Vz9B+uyWgisYmAU3rNM
         nAEODWAmX+w4MLiEHDRn/KmLbWYAKxdmLRjwTC3RLYPD7X4SZbviq+Avge4eC9YhzqMQ
         wvbA4XQ7kRUcih/jrblvA7gY2dkBBK5LXx8PDpJ90w4dICtBtYM+w/aP5xEc8683NSlm
         mNzQ==
X-Forwarded-Encrypted: i=1; AJvYcCUO7iW+jQQyTlwNYfaWDt68N64uoInhDi3srWut7yFxSOmvl3mDmU+t9BMKzTZJ4RpBcOL4b3wzeF/I@vger.kernel.org
X-Gm-Message-State: AOJu0YwFzBPmnpvmeg2LBfxOkm0M9C0XuRD6yeFhRTMVtlOqSeJJCu/O
	m7zN7EtedoyTVXC+6JYJs4788BhbYxnqUSy9GD5zLUPNea0d5xdXEtMvs3G52Me27B1Tka+hIO2
	0xV8l9Y65dMdJokT/NobUIPjSUogt6w==
X-Gm-Gg: AeBDieuH6RrU0cexyg3AJq4qaXcKNOHtFV3VD2yL7pMxnUXXwbiJIDebwqd0b4JolLi
	micewdxAr4u5rz4LVSsnj8YOIo+kmZ9MWtfynobDxvl9WfmTd37zpFt7ADtUA4XmbzC60kmDnm7
	V4GfHNpKqd4TQ4fIMPop297CqKzPl7VZBio0hvQ7UbInrrjrjYQIEWEANbPYsv8Q+ZDt6P936Kp
	2u90vidiVQ8V3vlhssAy+tUkMyLgocoANUkFs+D3ejVtA5fAJq1rNwWxeOWHeVk7d6OxjOHByJp
	KqW02x9U7s0WAF8lmlsNkQXIYYa7gqBoW3fQepvl6zsBYspi3Ex5sPgmPoBe0/bJAfbsOQ==
X-Received: by 2002:a05:6402:324c:b0:66e:df62:8826 with SMTP id
 4fb4d7f45d1cf-66edf6288a7mr338829a12.8.1775388616842; Sun, 05 Apr 2026
 04:30:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260403194109.2255933-1-csander@purestorage.com> <20260403194109.2255933-7-csander@purestorage.com>
In-Reply-To: <20260403194109.2255933-7-csander@purestorage.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Sun, 5 Apr 2026 16:59:38 +0530
X-Gm-Features: AQROBzA2rcbT0pZ0-7PJWuNuCAXgpXg-lAQtO03rLOJpR9_lw8vMvBFgqpf-qwE
Message-ID: <CACzX3AsN9osGEHdaZu-qKpKhR+JGTxaSvx3PhqWt4N9HSbj63w@mail.gmail.com>
Subject: Re: [PATCH 6/6] target: use bio_integrity_intervals() helper
To: Caleb Sander Mateos <csander@purestorage.com>, Anuj Gupta <anuj20.g@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Looks ok to me.
Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
