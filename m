Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BD23D66
	for <linux-scsi@vger.kernel.org>; Fri, 31 Jan 2025 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738336427; cv=none; b=SgJgFSbql7qy1y1spGNSWx7q3Uu8F6L8dzq2OXbv1YXlJ8aYmA3yL1xf8eKk3/1JiWXLtrjM+w46H7FVMM5bS0UFwUJiv4L1GG8YHyQvniPgqcklsd6PXvPH24/vs4BmNc8Pzib4SChvAWTvgs/OwbbiG4w7gLROgaeIi9KJWHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738336427; c=relaxed/simple;
	bh=4gQp82pyQdSv9h4bIaao3v5flWvB/YqaorWgObY4Jfg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=ZuWi8IpWl1bIbDK3w33TQ3iSmJ6bkkc6aR6vVRe8A8gGjEG1m6Zm0hIdvLRJX18TCaI8bfPFifDuu36HyA3OPIMKt9EQeyAIwZteADWnhVPvXb+pBBY0HQy+/yR7BQgT/Voa1tj63lAYJeUpN0ReMzyteZuFMTAzMK4y7TxOGb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=l94an1pd; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="l94an1pd"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-844e12f702dso54970739f.3
        for <linux-scsi@vger.kernel.org>; Fri, 31 Jan 2025 07:13:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738336425; x=1738941225; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U+9HC8EV1wWIoNgKbafn8wjlhkFnTml5y5fJi9ZNauA=;
        b=l94an1pdXrSSUOv+7SXgzHI6LXFtjM6M83K9U55R2DEDk59PYNHWQNPLz5Wk0Ib1V5
         /PzkLns1Q//b9IcukSm11w3f6wZDBXUTjQ1CKOCrIkEUJxxYc3ZQHCnx7+mrlA8p7VzJ
         erA0MuoiHMczPPZD61c7njpIp7f+MSiNMGcMdb0jpLpYxSrpndebzt4JUdh/NVAd9FnI
         ViLcv4t90Hi2DSSyziyLI0hLAD5OqF/pKIeutNqmmJfD3ZHlXeJTy0dSKmcD+7Y5IM+R
         6lKVyTwKgZuB01HbL7rsTJ0ERFQZ0VUCHec/HEBMgL7mbHXJWqYbogp1tyviN3YX3zEE
         fntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738336425; x=1738941225;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U+9HC8EV1wWIoNgKbafn8wjlhkFnTml5y5fJi9ZNauA=;
        b=YQ3ZWN7cIw7c2rjAGtKG++c5QVNWU6cOugsqvULjewtuzLAtQljWYT3wSVihKvK8nK
         u1nYPnV8AojWqyWZkDvCxzTUIvILD5n7A8BQtok/E3jv1rYznBvvhr4YinB+joITOo4b
         OArbv7B+aCOlQmQQQJU+kcWZQMkmDRf9hF0LH/POHQzCXx8hDddSHgYvfrpvswJNiNxt
         umpmfCG9eP7jsFBW8xx23NReivD8mJ6ghdPB4qxiuZeRLWDgjIa+ouO9M4nScKZnkan7
         Y0VsKyJE/XscqmWL6EmglUIz4NkFkxmqng7YqEM1pO9+tIlfWJe17uZUhW0HM/0mKdml
         QQwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVzwcjspfI/2XFhVlE4Ui6g+Xo17/UaTwnavHVkAYq/x6z6o1Gmwd6+nbtG8W3xuUepPQJKYAb+4zuQ@vger.kernel.org
X-Gm-Message-State: AOJu0YztY+ds32nggIH0Gf3rQlZ1I2aItp16xsaakL8NPkc1mCwXrBUH
	A4vWnRhkWnOcZG0uZpb/YgE1bRnwwXwJM20XGVvWXZiNVCPYJ+LGvK8n+IVheX8=
X-Gm-Gg: ASbGncvVATVGp9nZooIf0qPDNN7XY8CLsjRVlKFLImf4M8gppTc49GDzIPPHLgYzFLU
	T2HF+pZ6TGArkDuM4tkGDfOPFsrgd5SOsyf8zI7eFw9qVXzm36TNYL9Oi/wezxBXLoN//M9Xb2D
	3DCd0LVIqP7L9aYrBJYjPh6EQo2J8WbMHIqIB/t9/U6aHrYV9lp9fDm9pUKoLDrG64ss5rsl2PR
	3ASNu+CTeW1OK/B1vcLi8Y9gRYwAY8Y9bebWKmanM+r+m3kzK56e1/r/tkHkIoF1u313KaRPZL8
	jhzQhQ==
X-Google-Smtp-Source: AGHT+IHdBYkV/Lcjpt9Dx2u2hBI2V53NbB2KTd/PWwFq4iCV5vqkwpfG1ZQm3S6I8vweH0IHJRW4Uw==
X-Received: by 2002:a05:6602:6406:b0:843:ea9a:acc4 with SMTP id ca18e2360f4ac-85427e24fa1mr1154985639f.8.1738336424835;
        Fri, 31 Jan 2025 07:13:44 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec746c920dsm856099173.125.2025.01.31.07.13.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 07:13:44 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, 
 nbd@other.debian.org, ceph-devel@vger.kernel.org, 
 virtualization@lists.linux.dev, linux-mtd@lists.infradead.org, 
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
In-Reply-To: <20250131120352.1315351-2-hch@lst.de>
References: <20250131120352.1315351-1-hch@lst.de>
 <20250131120352.1315351-2-hch@lst.de>
Subject: Re: [PATCH] block: force noio scope in blk_mq_freeze_queue
Message-Id: <173833642386.354079.3672902422068183900.b4-ty@kernel.dk>
Date: Fri, 31 Jan 2025 08:13:43 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-14bd6


On Fri, 31 Jan 2025 13:03:47 +0100, Christoph Hellwig wrote:
> When block drivers or the core block code perform allocations with a
> frozen queue, this could try to recurse into the block device to
> reclaim memory and deadlock.  Thus all allocations done by a process
> that froze a queue need to be done without __GFP_IO and __GFP_FS.
> Instead of tying to track all of them down, force a noio scope as
> part of freezing the queue.
> 
> [...]

Applied, thanks!

[1/1] block: force noio scope in blk_mq_freeze_queue
      commit: 1e1a9cecfab3f22ebef0a976f849c87be8d03c1c

Best regards,
-- 
Jens Axboe



