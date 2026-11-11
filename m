Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794415664;
	b=nQUfNEmg2uwZv6j8H+7bkHfM6SVf6HAq7EGYj9lASP0gV/8IFVfjCMtHtlcf0+2uy3XI
	 L7VHQprBTGyZ48HR8Ia5tPiOmy++OfkRbV38r+ZA2jIDkSdW7fQimxaNjNpeKWbjUKTPi
	 wFHKgskCvUyeJl6JN5FPK13iYvcvCEC5ZjCjpejWK/RrR6ANljy+bEC8JQWQQkwf3C05u
	 vWVXFAmTTNDXwNT/04CzWyXjm2PMNOK2owevlJKoday0OpH7Q1BpTVnc9D++HKqZVpiMB
	 1HpijQhiH6115MhJ0skadMC1XS59ZGtNf46EKS4fmsS8OIb8UBBvzw33+C8ETbT/lUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794415664;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=JEN1we3zUbJ34wQgamBpttlVbDethKWGuPURScqYgfU=;
	b=ghfr3btmS/aod6BMQT1CAcWou+sy+krPrMSkP+BstDxXwnmVe56W2qSpwgFgyCA40ew0
	 WofPe4n+BQSVr1Xny/9b8YHaQZ4w/phPr4Pw4mniqOKoq0O2kpVm+OO8+wE4N2j/BDpZI
	 i6zgqj5uTIUO8/mtQMgnJiAHsCnixvXD8REATBWUoEiIFplR8AXiyCS1P2QYi63mVQcBr
	 yXlKlFv4M2Hz2onzu9BGCwAeNv2CxuCJXtyf236tiNIpDP74RQ+MESLJU+1u2MVNiT8HP
	 sc0z9l7ooIDI5zunTiYTXsKEJkCJEjBMEviZttCzQkpFgC5miFC+2kHnDjTN35Uc2lQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Arhv0r+C;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7337E606A335
	for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 16:47:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7337E606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Arhv0r+C
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so239025e9.1
        for <linux-scsi@vger.kernel.org>; Wed, 11 Nov 2026 08:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794415663; x=1795020463; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JEN1we3zUbJ34wQgamBpttlVbDethKWGuPURScqYgfU=;
        b=Arhv0r+CzJ6kd+TulLavcwx/mGrglYS422JYKTdbpa5un1a18rj23MyxqxLhddkmnB
         gNcaXJ2IrojyJbxM+OgBPEAeEpsNpzWgOGqEgdEdfbdQsuKembFEQ+6KhZaeIYR30gze
         IooSZe2fNj/7K3ZNeH8x15dEsu+UQLaI/m1IWuoX86P9po90K2PyeQK2TvubNwe2um3L
         oa28twmLTolBcK1wc4TjQY120ADR9pALZ4st9GAliG4qO1r6wi1yEW2L29tlSgZjmr2h
         E0qSshK5f4Tgf9M06nnSpMmyfbMbMx74mcpO6fx0yDufhfISeijTTqV/EjmW0IdaeTyH
         ahNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794415663; x=1795020463;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JEN1we3zUbJ34wQgamBpttlVbDethKWGuPURScqYgfU=;
        b=ua9i0J92l4tkEZEY6dyBegmrH0TYI3OV1wkX0Kk54+Akudb0Q8a5kK3l+LjPc0lffi
         Z7rzVIBfbEQ555n5a6xH5yqkS1yh4cJhczgaEb9gK+6SHtHH6K9PqaNyN4oo3fxFZFSi
         mTrKlREPk3sH9bTslbkB7pOG2mLmgNvu0/chSZuOql7cknhNWGl3asGPGZw0+CHuzlHE
         GUjfMaIqr9Q6qxkwltLbsLXrCZhBKQvdbINzEguN8/Qa/rYZ0Rem3Ncq7UqMyGwFBk3x
         vO1NmefW3R/89wTOgl2RdHNuc3e72LB47AUprtebOnSY78sYldFO5oJc6v0lYuinXq2s
         UbvQ==
X-Forwarded-Encrypted: i=1; AL+hErHtyXfLC3/Fxdxkq3gc4c/HQuzp+SrvMJve3pGtNS8hCOb/nYBeCf7oa+81gGFk4E59Wnyz/ayMm0Gd@vger.kernel.org
X-Gm-Message-State: APuU4Z8Mnjh29vFiILsZ5eGYGaORrSUWoyP8v/fO51GUnB+OYKdsv2Pj
	286Q9I4Ar0pUf4aNCxSjNDJT5wVWzuoDWmSUrAZM0fmqbIUxiVEojWdeozmDg6hnDA==
X-Gm-Gg: AYBFou0fCZShES2v7RmNZHY99+wV9N59UmGE7TEqX4RlAYm2ZGvNY3C6cY6MVRSJvJe
	jiaMiII+6tBFv9MkNvusqanEqj7faX1OtkDKqPZ2zkLEkChXgTCHWK0kp0twDjhg53EWVEk/F/j
	W6UdxQ6sRGj/qi73XuONp/LmfRT6Yez9vU7dlolHUV+WseUZWgoff1F+gmr41GhPj7so0ATIz0P
	7itu8+zjbqvJJ9ZnKB6/B2aylzh7YSLt7FXbvLXQuex2bOSpJ8xAko9NdnXDOuxsZvBpUD5OBRQ
	CeW6HjkNm7a7HSqzxyG/bGNQCPc1Dp3snN8PYx+1vOKQrRvX9csEORoD1DikIx/wuujv/GBIMOw
	1a4g6LN8X6N3mkIOsw+EP9+zWogPFwMc/wC7NrW9+UV12J9cvWB/WQFs0iPq5H1mUR3yawSc0VC
	yJNjSpTCvu4w2RLdO9zFr8UNy+RvYYOOT22uzO+yoZxrWOrILG1Z+6AkVwl2FpkFkuapg9rKZKv
	ClQxytCxl3dVOLuNAdZFul5vOzvvlzVsNhKUlzghzUg0dIhDXhE4oKU8SGoMo5+uG5PCrU1Doru
	XLpbCTEpc3wrrBfBKrH2D4dxMdus09g5ZV1GCvbCQQqvwDcM3qeNsFoTVW8RVSzO3w==
X-Received: by 2002:a05:600c:3f07:b0:4a2:18c4:61a5 with SMTP id 5b1f17b1804b1-4bb4e27994emr1100895e9.6.1794415662004;
        Wed, 11 Nov 2026 08:47:42 -0800 (PST)
Received: from google.com (0.182.34.34.bc.googleusercontent.com. [34.34.182.0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-498365cd06fsm11724877f8f.40.2026.11.11.08.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2026 08:47:41 -0800 (PST)
Date: Wed, 11 Nov 2026 16:47:38 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Tao Cui <cui.tao@linux.dev>
Cc: akpm@linux-foundation.org, dgilbert@interlog.com, mkp@kernel.org,
	loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com,
	vivek.kasireddy@intel.com, mst@redhat.com, jasowangio@gmail.com,
	eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com,
	rostedt@goodmis.org, mhiramat@kernel.org, jgg@ziepe.ca,
	kevin.tian@intel.com, axboe@kernel.dk, linux-mm@kvack.org,
	James.Bottomley@hansenpartnership.com, sumit.semwal@linaro.org,
	christian.koenig@amd.com, phasta@kernel.org, joro@8bytes.org,
	will@kernel.org, linux-scsi@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org, kvm@vger.kernel.org,
	virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org,
	iommu@lists.linux.dev, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, bobbyeshleman@meta.com,
	mathieu.desnoyers@efficios.com, robin.murphy@arm.com,
	mason@kernel.org, aesteve@redhat.com, tjmercier@google.com,
	harry@kernel.org, vbabka@suse.cz, cuitao@kylinos.cn
Subject: Re: [PATCH 4/7] tracing: account ring buffer pages and trace_array
 metadata to memcg
Message-ID: <avScKhR22kFOQ1z4@google.com>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-5-cui.tao@linux.dev>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106131829.3228926-5-cui.tao@linux.dev>

On Fri, Nov 06, 2026 at 09:18:26PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> Creating an instance immediately allocates two full sets of per-cpu
> ring buffers, array buffer plus snapshot, about 1.375MB per cpu per set
> on the default config, plus the trace_array and its name.  None of it
> is charged: neither trace.c nor ring_buffer.c passes __GFP_ACCOUNT,
> while user_events in the same directory accounts everything it
> allocates.
> 
> Instance creation is currently gated by tracefs file permissions
> alone, so a
> rootful container with the host tracefs bound in can create instances
> until the host runs out of memory.  Charge the ring buffer pages and
> the trace_array metadata to the creating cgroup.
> 
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  kernel/trace/ring_buffer.c | 8 +++++++-
>  kernel/trace/trace.c       | 6 +++---
>  2 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
> index 1fd28a72e6ee..676c059c112c 100644
> --- a/kernel/trace/ring_buffer.c
> +++ b/kernel/trace/ring_buffer.c
> @@ -441,7 +441,13 @@ static struct buffer_data_page *alloc_cpu_data(int cpu, int order)
>  	 * gracefully without invoking oom-killer and the system is not
>  	 * destabilized.
>  	 */
> -	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO;
> +	/*
> +	 * The subbuffers are charged to the memcg of whoever caused the
> +	 * allocation: the creator of a trace instance, or root at boot for
> +	 * the global trace.
> +	 */
> +	mflags = GFP_KERNEL | __GFP_RETRY_MAYFAIL | __GFP_COMP | __GFP_ZERO |
> +		  __GFP_ACCOUNT;
>  
>  	page = alloc_pages_node(cpu_to_node(cpu), mflags, order);
>  	if (!page)

Hum, by default tracefs is root only. 

And even if made accessible to other users: 

  1. The life span of a trace instance is not tied to the caller.
  2. The ring buffer is shared by multiple users.

Overall I am not convinced charging the creator makes much sense.

Eventually a few allocations for iterators could be GFP_ACCOUNT.

-- 
Vincent

> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index e8c4efa8107b..04b60b9cc4f5 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -8693,11 +8693,11 @@ trace_array_create_systems(const char *name, const char *systems,
>  	int ret;
>  
>  	ret = -ENOMEM;
> -	tr = kzalloc_obj(*tr);
> +	tr = kzalloc_obj(*tr, GFP_KERNEL_ACCOUNT);
>  	if (!tr)
>  		return ERR_PTR(ret);
>  
> -	tr->name = kstrdup(name, GFP_KERNEL);
> +	tr->name = kstrdup(name, GFP_KERNEL_ACCOUNT);
>  	if (!tr->name)
>  		goto out_free_tr;
>  
> @@ -8708,7 +8708,7 @@ trace_array_create_systems(const char *name, const char *systems,
>  		goto out_free_tr;
>  
>  	if (systems) {
> -		tr->system_names = kstrdup_const(systems, GFP_KERNEL);
> +		tr->system_names = kstrdup_const(systems, GFP_KERNEL_ACCOUNT);
>  		if (!tr->system_names)
>  			goto out_free_tr;
>  	}
> -- 
> 2.43.0
> 
