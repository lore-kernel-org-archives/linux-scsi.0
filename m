Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13CE534A329
	for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 20:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755808608; cv=none; b=ns18g+GqEmYWeRvNSCQy4zJ8bhCLmtq8xJ54Vr64Cvxp8Q79sxJ+MDCnly6a+WsJ8zjcBcg8q5122DGPXpfUhwmeb1dtQY0xeOuzg/y7CsdMdxtW82KR+4guE6NCfaTNsNXhJcxkQaQ5bCGQ83iuS5/TD6EOujdDEiZWiISddLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755808608; c=relaxed/simple;
	bh=yojduCRvPCmYgwaX7kfWJ1p+To4BJmiAMcPa2zQubFw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lzEi+LDcIr2tpWwEhsFLnhVize9mUb0eyGWlYsy2XZ3J9oHQWRW4vNKml8pH1oNXAgWiOv8D5gu4DRYLDqX+J0YG6cp00DfXtgBYpQ/8owZGxkgQrarUrB23/OlfEh+4iiYBVDeDIeGDuLsGe18VVbchmVcSrJaFHDnCIWoqGoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FV234+mU; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FV234+mU"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e933af9f8b5so1158485276.0
        for <linux-scsi@vger.kernel.org>; Thu, 21 Aug 2025 13:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1755808604; x=1756413404; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=083PuN2wICwWm8iwB5WBlP6qyKXLyqdZEBdZ0ztp8l8=;
        b=FV234+mU7pRMURRjma/HCXOh7oRBz2o8mZ4HY80Nw18ph+1Eb98oLCMJUBmPlL/wYk
         wbYnIjf40zeiyigCAOvdnmVZW/bVhKI/R6VE8hLE1yX0t518kJFFvAM8OXr9IG/1iZiY
         bM5bWY1XzkQ4ggk041+jvfFIOSBug5NgOCliY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755808604; x=1756413404;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=083PuN2wICwWm8iwB5WBlP6qyKXLyqdZEBdZ0ztp8l8=;
        b=eT4WTVKyaFlwXQjcS39VcRgQGNk6/BKtaiF9QLQRyjzrfYrx+hQY5gbikPmxDufaHV
         M1QwlNlLtCA7+lWJMzfaDrf5r50ssi7bcHCFGbfQnANey8KVsN4C9ooe0T/oyXMgu5nt
         KmzZQYOatb0s8xW2WEG46dGSUtfvj/jUCq/1jtgikrp8RBW2DEs0+9Mup5xowuoDFKKQ
         bqKFaRqKxSzypC979Fni+SK3sLNDB5Fcnvd7tkXoSd6b1s79Ixi2V2LbUfvdPUWzLsVg
         fpMq2+gV8s6kWghcUu+vCVFr7+KOU00dU0+6wxdJl/CiBrq31sWotLa6xeUz6iH0/c2T
         gTFA==
X-Forwarded-Encrypted: i=1; AJvYcCXHpM4Qg0fFzvz6Qdb558E6Dk7T1Ovw7gtmQ2x2Xb1o2O0QHblUdGEOeuX+AaEeqGGEDwv0kEvjU0Dj@vger.kernel.org
X-Gm-Message-State: AOJu0Yzl0poWs0zYGFVqno0vqTNqmy0ln62iWEfXq4JSnHdikVDvUEnN
	onkic4vj3dbbZUa9ZlYhQmYm7fJ2oG8DSjGKLzJb4L306qUDmXF7Ix8Ipwt5d7bk2A1s9/fgsWy
	u/XJ36a2lvVIsrxXwkJR/EMQedRe4wg6OMZTjWv3/Ug==
X-Gm-Gg: ASbGncsfC1LKBJnxia9XC6LDo2eHdXVFneoZp0qpN6QqLrRNstAbCHzePXaKNzlYu3P
	oM+xlhPtiyql837g2/96i/SlBB5C5lKoZoynlt7h0I8+FigJ2OZM544lnSnyLjVMcAtwEmo2FBN
	S+fnvd3yDkrOj/2r6rV/pq0aXcOXrwTNwVC0bzKB8mOCbEHqAamAhWdR8EHbxLwXJSfMYyrJj+6
	cXLHQsiyc1c27EIUZB6Uy6t8Rg=
X-Google-Smtp-Source: AGHT+IHnF0lVhm+1Tun1UWlMLnnSk/jF/jUOt69DP22IOjEUNxjHdHqCJTIRGjm6XM6hiUq/Axp7jnIGuYc/D1Y8ZZI=
X-Received: by 2002:a05:6902:4381:b0:e94:dea:b80b with SMTP id
 3f1490d57ef6-e951c365621mr715984276.40.1755808604080; Thu, 21 Aug 2025
 13:36:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821200701.1329277-1-david@redhat.com> <20250821200701.1329277-32-david@redhat.com>
 <CAHk-=wjGzyGPgqKDNXM6_2Puf7OJ+DQAXMg5NgtSASN8De1roQ@mail.gmail.com> <2926d7d9-b44e-40c0-b05d-8c42e99c511d@redhat.com>
In-Reply-To: <2926d7d9-b44e-40c0-b05d-8c42e99c511d@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 21 Aug 2025 16:36:32 -0400
X-Gm-Features: Ac12FXz8i_O0Dca-zCdGNOyRYVeCyfB9Z0ucQ3KoLazk0PNM2PIB2a_qe1sXKks
Message-ID: <CAADWXX81Y3ny6WvDN8EeYvBPa2qy10PKhWfZpj=VBcqczL6npg@mail.gmail.com>
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

Oh, an your reply was an invalid email and ended up in my spam-box:

  From: David Hildenbrand <david@redhat.com>

but you apparently didn't use the redhat mail system, so the DKIM signing fails

       dmarc=fail (p=QUARANTINE sp=QUARANTINE dis=QUARANTINE)
header.from=redhat.com

and it gets marked as spam.

I think you may have gone through smtp.kernel.org, but then you need
to use your kernel.org email address to get the DKIM right.

          Linus
