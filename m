Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27CB2F1FD1
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755808266; cv=none; b=HhNMP2xr46jDLj0v5xTXSmrQdQufucI+mSViiQHSq186tx47dltYEOqtcl+XD+lELExrN6MTvfLiA2a4L7JYqkLFtLlCesGhWUvo6hOTT9RsuGE/oCpCTMkj6Ys5idBb1BlCURe7AyvPpKcOqH6mP+fR0LOHEDYw5NhqF4X+BcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755808266; c=relaxed/simple;
	bh=oA3XFTq+X9InxrtY53OI1FqTpqPTKR+1uoMqvtlA0+o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aSoOrTE5GcpH4UriDnQ7CVybA9UVTIlwRbAY0s77V7Tfdgfs+JMtDDSnAfXRJoOe5eQK/8jDFlc61+lqiaEfmW/lMEz0RB4C9jemHlHt4XOxF8y7WFjZ2snn1Sq4wx34rmjLCdi2fQr1ISO1D/w2OkW90HZBt2ZSshnIpqM4Hys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EY8csOnO; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EY8csOnO"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-70a9f5d4b38so12498536d6.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1755808263; x=1756413063; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6aeG3+zXNcZH2d1Z1/su6zkQOg7Uc4j3Xw+oqie+iPw=;
        b=EY8csOnOJZ2EnCopcxBAnfIMiiXYuAaL0tw+brDbCbu2ztLLVAGquuUTh2a+CMK1wT
         Bt4VZF9RPpK5Tka/mh4RoTEkrPFIAEfVK8tU1gnb5iFReQ22twmAYr7oXjBp7YoiDTa7
         DLrSYVSJAPPusy3BY0Hz/t+hQDBTusc1bSSKM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755808263; x=1756413063;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6aeG3+zXNcZH2d1Z1/su6zkQOg7Uc4j3Xw+oqie+iPw=;
        b=oPDkEluv3IlE6uHq1/KiPgBjW8hSTuNrUvkFRsFGQtgB+vdjjvgWtdgW/DmqGAqm5E
         +GTntv0Bo+erhCGaIT3SJXk0b0k4mV54T8CXCTet+FII529X4eu/bgFjsoPHRh1AzrdJ
         LzZSqjsI6wOQDMXSDwZUWSh0d7/5ZDDMBZWxF54vVadhaGNQ3/SATMVnNXvSDekzrs3k
         fAw0avFFqYqq5o24ET57MongsfN7yTpIWw1c6qe0e7XrixthPJO0/suHHR99wBmza/qr
         fLxDbIaA8ROPD5mX4xAS6z6vJdvA484jczFQnsh/0UMU63jC+sRorg3C/T+OM6NcUjz0
         xPYQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjcjwvbO5j7R9NfTtYcET4ASXCub1BxfaQROtxjPp8XFyzq+O2GRjyX98Oc1XxHz7YrMB1bXTCrnn2@vger.kernel.org
X-Gm-Message-State: AOJu0YxPuMv2qrW+5Lyda916sHUy27UcEch26oowiSsuiUzlKdD5f9rM
	CI4clSOVPMiZYmn7xOJ8T3f38T9ADSkhGnxCTU2PPCFAGf3k+4AUiTjrn9Iz8LrG8OpT/1phYpg
	HNFNE0Aw=
X-Gm-Gg: ASbGnctQhlRO+dl6Bos4jmhR2oKe9Q/a5FstF/33RDGpK6IKyfLjBx5nO75bPB+DZKm
	72xFX4GxokiCV4j6GXBSPmiDICg0Saaix+TKZSalL66r+ZGnXJ0EBzwV+o+L14FdcETgcAEUm4n
	jcQFi3wAHQe4aq7dLlbMuQFuocblRExReDnhzm5xeftUtb8aXeP/y8EHe2JJnc96kia9Qm5stEV
	kSa15+m+cRUbustgNbc9ng7YOpG++z+LPEqzbmKko/4a6NzyRI5S2XdsEzFsqilJ03wwlRwiwnS
	Xa1Devtp+dzLLYUENg758PR+9bnrqLbdLbEOacSNu7HddJX88CejupBX1wrmN9Hhti/V+Dp8oxG
	4SvDyI3ECz/gjCDRbE7X6z7zxWDq+P7eEacnICn8Yyy45p8wZnvg/mcK5OdrRytGfjBZhzu3uiN
	zCks35gJuz8pI=
X-Google-Smtp-Source: AGHT+IGTO0vvjqCTxAcP3aDU0iGrcFjybpZUCZtmF26qocyK+4hK57UvxCBTz86G0azUYHzMtjqtZg==
X-Received: by 2002:a05:6214:411c:b0:70d:968b:bfa0 with SMTP id 6a1803df08f44-70d972519b1mr8911436d6.20.1755808263329;
        Thu, 21 Aug 2025 13:31:03 -0700 (PDT)
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com. [209.85.222.181])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70ba902f26asm110946116d6.15.2025.08.21.13.31.03
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:31:03 -0700 (PDT)
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7e8706a6863so172257285a.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:31:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXUEtyV1CTFoRPuQ8QR51BF/ebVnUBeNae4wH8tBqeUIMvceXePH/Hpx+4b0l8qW7uZZx2wabRP0/ge@vger.kernel.org
X-Received: by 2002:a05:6122:1ad2:b0:53c:896e:2870 with SMTP id
 71dfb90a1353d-53c8a40b923mr212315e0c.12.1755807884664; Thu, 21 Aug 2025
 13:24:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821200701.1329277-1-david@redhat.com> <20250821200701.1329277-32-david@redhat.com>
In-Reply-To: <20250821200701.1329277-32-david@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Aug 2025 16:24:23 -0400
X-Gmail-Original-Message-ID: <CAHk-=wjGzyGPgqKDNXM6_2Puf7OJ+DQAXMg5NgtSASN8De1roQ@mail.gmail.com>
X-Gm-Features: Ac12FXxaZhwn04a0gbwY6rjh9UGLxnRlGOG0Jy0WjRbVAG0UxLDqNy0Wydj0GQk
Message-ID: <CAHk-=wjGzyGPgqKDNXM6_2Puf7OJ+DQAXMg5NgtSASN8De1roQ@mail.gmail.com>
Subject: Re: [PATCH RFC 31/35] crypto: remove nth_page() usage within SG entry
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Alexander Potapenko <glider@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Brendan Jackman <jackmanb@google.com>, 
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, 
	dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	iommu@lists.linux.dev, io-uring@vger.kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com, kvm@vger.kernel.org, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-arm-kernel@axis.com, 
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org, 
	linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-scsi@vger.kernel.org, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Marco Elver <elver@google.com>, Marek Szyprowski <m.szyprowski@samsung.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>, 
	Robin Murphy <robin.murphy@arm.com>, Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>, 
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>, wireguard@lists.zx2c4.com, 
	x86@kernel.org, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 21 Aug 2025 at 16:08, David Hildenbrand <david@redhat.com> wrote:
>
> -       page = nth_page(page, offset >> PAGE_SHIFT);
> +       page += offset / PAGE_SIZE;

Please keep the " >> PAGE_SHIFT" form.

Is "offset" unsigned? Yes it is, But I had to look at the source code
to make sure, because it wasn't locally obvious from the patch. And
I'd rather we keep a pattern that is "safe", in that it doesn't
generate strange code if the value might be a 's64' (eg loff_t) on
32-bit architectures.

Because doing a 64-bit shift on x86-32 is like three cycles. Doing a
64-bit signed division by a simple constant is something like ten
strange instructions even if the end result is only 32-bit.

And again - not the case *here*, but just a general "let's keep to one
pattern", and the shift pattern is simply the better choice.

             Linus
