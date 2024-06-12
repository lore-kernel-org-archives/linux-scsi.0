Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A953714F132
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2024 08:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718179285; cv=none; b=HnaAojihFTm18iXIll+elGJnaAVo9YqHJxR3Ze1M5WNOQco6afCJDelJ4jbvHJsdbnx09jZ6j27Gq+2NJAtIPGudWmYWUEEz80sCDzcAp1Qm85mJB362Yzq66QR9wP6KcxBScW6OkFNs5lysA8SkGSdt+RvwhtKyQGmMJ5XDR4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718179285; c=relaxed/simple;
	bh=2cExcM3FQdKVHy7cL3IiNx2Bk/UFeUgrDgrQcqyJhl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oHQk7bpP6ts8iPbVra6eNmsUW0pHVhPPTo9SBylAtsIqC7GZngcoEA4AcZeo7BuMKwXb6szCUZKxxTw2z2NyyieoxK2/3Ihnd4mnOsixAwPXXitOuMQtEIOy+F5FucoFtD+mtwBipyvlEwQJ9IYtQGJ5TQV3WMfKwr19u+yYKeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=wGSiQ07I; arc=none smtp.client-ip=209.85.128.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="wGSiQ07I"
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-62fa71027b1so5142707b3.3
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2024 01:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1718179283; x=1718784083; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1PGf6HlJc1ANQenmlixWu1Sno9FA8D3ndcnX4NZVy9I=;
        b=wGSiQ07IIsz3I5o3sJPfsRh6+YQ4aS+dl8faDVi6tCb8oJsgDTIAJhb3nIcw252bU0
         nDpxqZOv3GJrkXMrxGioYAsvh4Pq/cnolHHO/TtN2xI0rAGtwEWsQRY4QkfU7k3Bm65M
         hGrDJE6dultwgkDJcvbr8RkJ/+8f2Omv1w+bg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718179283; x=1718784083;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1PGf6HlJc1ANQenmlixWu1Sno9FA8D3ndcnX4NZVy9I=;
        b=tMgttiiVOJ07lNSQtHaqhm0Aihr0Ihp9ptSzi12YS1GhBeQBXNLanTEMtfcZ+ZmPph
         /n6hBkZQtZm0shmMxDtAi31YaWPHeFEx97S7TMoih4KgqG+MYVXmedKawGiU5+GEKNLu
         W8gm62WbGu67Kjup0QuaeJGzaQvWHgheTrjhRup+GJDRy0ezbdmOW3wslGwfSrntIyUu
         SO3BaAq4bXMR7z3jHLI3bL6qJ//1gG5yGeVe/hnDQUNEVJHa5DepyiCOX7hlCxV7OhVF
         1Bf4pEyd34+iFs08fFOfeRQccntLYSNPtElLuU8LPixWA9RGw4UkgDdjQ7mMloa3u3K0
         jn5g==
X-Forwarded-Encrypted: i=1; AJvYcCV/tvspu2/yHeDDpuRDjG1D59b85v1ks7pB1KJmWgXXCYh9uhbrMdUr+T3sBHGLD5k7rqNP+TPVmlslXcmI+a+uMJKYaU2hcw6x7A==
X-Gm-Message-State: AOJu0YwVA/hMoMlw0Nd8aNQ4Hu3dNSRjYSfFGDFSlh8krpmicVT2CcmK
	7gwjhXOChJxP5kCEkrlncs8Y73NkTmzR5mCcPp95ElW2KeWRd9ZN3widgjH9cH4=
X-Google-Smtp-Source: AGHT+IEk5bObzz8qCZsqdRqFNOU7a/dh67daOPgnEKJGJzh0sP06pKqPApTvT03CHGJxr8rf1zPYww==
X-Received: by 2002:a81:b647:0:b0:61b:e62e:73f1 with SMTP id 00721157ae682-62fb8a58273mr12605907b3.3.1718179282688;
        Wed, 12 Jun 2024 01:01:22 -0700 (PDT)
Received: from localhost ([46.222.2.38])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6b093aff889sm6894416d6.101.2024.06.12.01.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 01:01:22 -0700 (PDT)
Date: Wed, 12 Jun 2024 10:01:18 +0200
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Weinberger <richard@nod.at>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Christoph =?utf-8?Q?B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
	drbd-dev@lists.linbit.com, nbd@other.debian.org,
	linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 10/26] xen-blkfront: don't disable cache flushes when
 they fail
Message-ID: <ZmlVziizbaboaBSn@macbook>
References: <20240611051929.513387-1-hch@lst.de>
 <20240611051929.513387-11-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240611051929.513387-11-hch@lst.de>

On Tue, Jun 11, 2024 at 07:19:10AM +0200, Christoph Hellwig wrote:
> blkfront always had a robust negotiation protocol for detecting a write
> cache.  Stop simply disabling cache flushes when they fail as that is
> a grave error.

It's my understanding the current code attempts to cover up for the
lack of guarantees the feature itself provides:

 * feature-barrier
 *      Values:         0/1 (boolean)
 *      Default Value:  0
 *
 *      A value of "1" indicates that the backend can process requests
 *      containing the BLKIF_OP_WRITE_BARRIER request opcode.  Requests
 *      of this type may still be returned at any time with the
 *      BLKIF_RSP_EOPNOTSUPP result code.
 *
 * feature-flush-cache
 *      Values:         0/1 (boolean)
 *      Default Value:  0
 *
 *      A value of "1" indicates that the backend can process requests
 *      containing the BLKIF_OP_FLUSH_DISKCACHE request opcode.  Requests
 *      of this type may still be returned at any time with the
 *      BLKIF_RSP_EOPNOTSUPP result code.

So even when the feature is exposed, the backend might return
EOPNOTSUPP for the flush/barrier operations.

Such failure is tied on whether the underlying blkback storage
supports REQ_OP_WRITE with REQ_PREFLUSH operation.  blkback will
expose "feature-barrier" and/or "feature-flush-cache" without knowing
whether the underlying backend supports those operations, hence the
weird fallback in blkfront.

I'm unsure whether lack of REQ_PREFLUSH support is not something that
we should worry about, it seems like it was when the code was
introduced, but that's > 10y ago.

Overall blkback should ensure that REQ_PREFLUSH is supported before
exposing "feature-barrier" or "feature-flush-cache", as then the
exposed features would really match what the underlying backend
supports (rather than the commands blkback knows about).

Thanks, Roger.
