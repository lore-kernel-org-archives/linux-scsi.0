Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD57456E1F
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 16:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790267895; cv=none; b=BLVrdWLlBZD3HULxFTm0DJ1ot7JZ4KqdAXpnjZkmjsaBsA9jeHz+iBtCApt9NF07WbzYPKfcU4HWjRTajKlvQf99Ow/AxG4R/OYNJPo1OvTdCGBnGcttDUbN+eXibAkAkluw2aoFADexFf84tG0RMrniqewxpzhMFJPwRYvHTao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790267895; c=relaxed/simple;
	bh=Y6dfgoDu9ENyHz35342iESy0PYqePxl/sIn9jSurkUk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JG6ZzNHm5zW1jgrquJE3ip6+u6Fl87Pcms7URa7RnRqDmby87opdW+fnXW5hzmzT3DUQO+XeEdRGFmB5CID5EZFk4OQfqlpqVw7Fn3nvNnWLJyhOhsgp/0cKWdWxNRPdpBqOL40gQ+JB9SQ42+vuu6x7+tgw5rg3onkwSPczeys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=DELaQ6H+; arc=none smtp.client-ip=74.125.230.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="DELaQ6H+"
Received: by mail-qk2-f12.google.com with SMTP id d75a77b69052e-52fb76543e1so245151cf.0
        for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 09:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790267891; x=1790872691; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LuPrvXBzY5FQ+f/5fzbveR9yF272P1V2+jsIcGJNdC0=;
        b=DELaQ6H+GoqYKhSPbbw83I2UghjOPLUKt/HJzwYXOl5vd4By1b/ewKsZIbd9ahXhZb
         TJDLBT2drAnq8j1D4gtZjKdZE54vfhHIW07z7SMjyhNrpJZ88lIXL27llafwJKgt7Hvw
         zeqWn52o1fsiwmzoo4rrDQZv3h3IiFJnFO2iuBnkUsGA3ktjvtFHA3Jr6K2ZEcGMg8M1
         1di2ZTIAJ2yTB2V6zmlctv6zG6tcG5IvMF9RkWmI06r7tX+skZxDuVThBB0MSr3NZe3S
         B2+XxiOTA95Xk/3/+mlBZ2rpvQSIcAx9lD43yFxhcrOBvTesr5mE416XkZK5Fw1vsdLx
         5Q7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790267891; x=1790872691;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LuPrvXBzY5FQ+f/5fzbveR9yF272P1V2+jsIcGJNdC0=;
        b=lUsixElZKJB4RD1RlAKJ84JTR3axpIfEJnyFgip2JWuoXGwX6ZpIAbmy+qCOjLPaHl
         pGnJRmlYjzc/VwpudzkRTQ484IUYFVAmx0vmqS44XMYZszH5C7ryJypXIDUOUvA0wiph
         h46F8QJcX8ii+PnZQz8utJvAF/jhGur/GCO/tyqenzLJ5FyHErksc++x6Ri0+LUtrA8i
         z3I0obgy6tP2TESjPjXRjIUi4SpUg4Lw0kBoK9r0xfK1Jvoji+aspBvcZWhXhLCjwXFo
         YjzSc/gxlkkkfAw3Xs8Wgdqh86mXFcrilLzMJKxsKB3bMjc5IiqFMa5VArvKVqr+3gIq
         NLZQ==
X-Forwarded-Encrypted: i=1; AKwUvByCgCxH0ugBqG2SUD9xiMZBdqvPc8OpixkTrM+BVFvoh/UYinfgvoYW68jbCZsflO4HAxo17OZBHGCL@vger.kernel.org
X-Gm-Message-State: AFuF++mOAygCbF6LlEwPVYMcwg8ugIssl95bO5TwCRFEWBWur2j6UMSR
	hjoQa7RHqFF6Z9g6Ws2vZOCuBCBYT/eJ9xCf4tDNmtq+mn9aSndFcMU/leYO00hTcf8=
X-Gm-Gg: AYBFou1M6SWeiIoKITv7hZwpDcwgFBvN7DVrQ08T0OgRut87wrSVz1b9jMIO6rB3bIh
	pjTVlDBtuO3n3KJ+N/H8hHhHRjm6dovm7i8VZzqYHhkjCNkl8eJcPVcz4oKxjSICX/ZFDowy5DO
	Qn/0BFmgp4HSKUAVUtqliYb91bJIIcbKdkW1/4m7qbBurP7B0cU+9ygsgJiFXCJtbvE+9+3Gr1U
	b1gfSSTXutjZi3B1dnYaQ6wbeoJmrV8Yq2sZQhSMfiFjytHjBrSPYRIYsG4I+rt2vnu3FOD5c4y
	ILcCTqfFIGyF3xZcvThCeR8Bz9Y95m4KBjzck6zByL7dQm2gvbJE23jFE924e1L9ju4XclsN42v
	Dh57drt5DPL6mqX8U6bhzrJB7GuB+QLuRUy9OSrf2OW/wmwbc6NAIvol9nCWSTgM1ZLyNHqzena
	FZNeSUyrqVVVTRpfUKYDLKK05jhg391AQKe6gsa1MBWD7oDYcoHPYCcgETusYcHv1hD8qWqlXTw
	bYeVUfW1ng+rHmmlvq/nc7DWVeW9boPmMpzWroYwxflCaCrq/kbJqo=
X-Received: by 2002:ac8:5743:0:b0:530:d860:ffba with SMTP id d75a77b69052e-532fe9f05bamr29797891cf.6.1790267890993;
        Thu, 24 Sep 2026 09:38:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532eb32f6aasm45064551cf.16.2026.09.24.09.38.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 09:38:10 -0700 (PDT)
Date: Thu, 24 Sep 2026 12:38:08 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-rdma@vger.kernel.org, selinux@vger.kernel.org, linux-sound@vger.kernel.org, 
	bpf@vger.kernel.org, linux-scsi@vger.kernel.org, linux-fbdev@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linux-trace-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, linuxppc-dev@lists.ozlabs.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
	linux-s390@vger.kernel.org, sparclinux@vger.kernel.org, fuse-devel@lists.linux.dev
Subject: Re: [PATCH v3 03/40] mm/vma: introduce and use
 vma_[flags_]can_merge()
Message-ID: <arVRqJZkql6sGunt@gourry-fedora-PF4VCD3F>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-3-4583d8a23bca@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-3-4583d8a23bca@kernel.org>

On Thu, Sep 17, 2026 at 05:22:12PM +0100, Lorenzo Stoakes (ARM) wrote:
> Replace the open-coded VMA_SPECIAL_FLAGS check in the VMA merge logic with
> two new functions vma_flags_can_merge() and vma_can_merge() and update the
> merge logic to use the former.
> 
> This abstracts the check and expresses it in terms of the desired behaviour
> rather than an arbitrary and confusing VMA flag.
> 
> This also lays the groundwork for making further improvements in VMA flag
> usage.
> 
> Also update the userland VMA tests to reflect the change.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

