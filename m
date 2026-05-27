Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C13538237B
	for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 16:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779898011; cv=none; b=AjvDaeoEol1JGga3Qj6CHP1wrQhI4LicmY6GsEIRkUd+NZEAFQKfUKBFAt7Zl/At38VuntzOdUvS/NDPz2heMR3fs+X70TMxi1r/QeSPA3LVGYuDHQfKA4JpZ0F/Buj1r9GdNXjnHA2/guRzjfnKur515z0/HCEHZ32g0oNJtec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779898011; c=relaxed/simple;
	bh=fwkxSqx7ty2JQSbgYGjXCJheNp4aXVJfNCMAJtiBUtE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XnoWxVLdMLicCBhbiCyyJQ+hJ0Ie3EmBDwD7cFmhB6D4Q2xOLzouvxRgOlyOFIz5eSLGWTettd/26wOU5Z5SKy9NsmL5FmSvAeuVtn2VIbzQk/CqhbOa18Z8GDxFhGjn9C8jv0syLTAKhv1erujTz8spaAXVvsG94OutI2r8/hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=O1aMiL1o; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="O1aMiL1o"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7de4be15125so11373871a34.0
        for <linux-scsi@vger.kernel.org>; Wed, 27 May 2026 09:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779898008; x=1780502808; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DDewevQlsNX9Nf5an4WdPkqFyUO5oYIAKU8piRx5pII=;
        b=O1aMiL1oIFen2XoIfw6SCJALa8Ot1OyXMqMDB/oU7qEd7xqcpJcmD2Obpa7Xhf18Wb
         Tv/hwDlI7f60fJZz3LA5WSK4ha8sHBqy0Kfvy69FTonSDHkqHImBe3jY7r5kUGVV69g6
         DhgWZzngjuvHdU+DNARaOlOBOOyKC+yJ6iCMDZXnpaxkUD82iSBKl0+T6BjDJfWzZiQg
         6B27azfpAuiutURWisO1EMMtvonRee30OHl5YFyTxvXi+wBdj4rE79r/FP+yG15cxFY8
         kseLG06/4whit0X1Jj2asavVTSHHe2CqrCILfrcIu8BMz8zsF0kxznceQwGoyP4Yuqbv
         9JUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779898008; x=1780502808;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DDewevQlsNX9Nf5an4WdPkqFyUO5oYIAKU8piRx5pII=;
        b=I9xAqvB0f35ncZpJxPEItiqYUZN1FgDEQEmHntLPZCKxQVcqWRsQ/mw+Dv+XtJa5VB
         rqnlJMbbXi22r7v1sSZOhvVYQEHvVyc56mZ4Eqyc33P3PflfYOcJT0JWoK2sSQ/Z+sbq
         rsBIazM00LEqBj3ksj4bH5C6BcdorSz9SN74kVkkdeTRIYsk6lGhNMZRx9GKXyo3X1z1
         ws+SfLNZJ4I2YbzoWApRYPv5+SJqepfOoSU54OljiiU6ZfolT7FqvCfrvgDgvfZ/hW+I
         hkZu1xWe+4yDQxykgT/yR6rlfCFBTOPN1WWb0guur1wQ1CbgSEc14xA8H6Ixa3xtqIVC
         Ro/A==
X-Gm-Message-State: AOJu0YzsOsJBG19/La+cxodFVWu3X89x3aDn1rLMxF187BKxE5SLDcNM
	R4qx+Afpa2M0BI4qy1bUA/T/bMLUyU7McWgU+Ku2Y3lClVAxofZsJ1lfB9ixkK7eBnc=
X-Gm-Gg: Acq92OFIpoI/ZVdbtdVH62E4/mxHcv44kjW2AJOlilbuCckS+STKI+Q8H6UALHLSC9g
	3FQkh82UUb/Rmlh7nLj365IaiWzmWRS+39g+EranUA7rfJOWoYX4Uw+SZZbnKmCK9TbNrSzP3sV
	PZiCsiJ2qVjq5dlo1CriA8g+KtOeNEv2liK9nsc95uvFqbiJb4uj9WiS53aPDwd/JfBAytJeyH9
	xs80c6MZSYnG0aQDD87+854l1UZ4/C9NYBZBFBwfemguk0yS9BtV3CTz/C45Ng6LHmCfLn3n+6k
	FT3inBBW8RU2S6k8UKtUsykvYkUEfSgM4dRIvSzUlTVVidpJ7c4fJ7QjKh5tY4U7U4mK08bIl5/
	CzE1P+G6lPiarrEGy1F4VAJwySbILlxMw4FNn0lZW9yy/iYXxr/50ANknao987HVwziIwOlKo6Z
	XaF6po1M0oMAI0wi5TE3XZKpvtpkdNBeYFOX06/Jdvvva0cpECtcRyb0NmB0Qm33DNwSfc2JbzS
	zmNyqNn8lv0KaKwY6o=
X-Received: by 2002:a05:6830:6682:b0:7dc:dd58:50a1 with SMTP id 46e09a7af769-7e5fee5ef73mr15600883a34.15.1779898007969;
        Wed, 27 May 2026 09:06:47 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e606459bf7sm11606383a34.1.2026.05.27.09.06.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2026 09:06:45 -0700 (PDT)
Message-ID: <ee931505-64a2-411d-8607-3db8912b70c4@kernel.dk>
Date: Wed, 27 May 2026 10:06:44 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: bsg: copy uring_cmd payload to prevent double-fetch
 from shared SQE
To: Rahul Chandelkar <rc@rexion.ai>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260527105931.3950913-1-rc@rexion.ai>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260527105931.3950913-1-rc@rexion.ai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/27/26 4:59 AM, Rahul Chandelkar wrote:
> scsi_bsg_uring_cmd() and scsi_bsg_map_user_buffer() read bsg_uring_cmd
> fields directly from the shared mmap'd io_uring submission ring via
> io_uring_sqe128_cmd().  On the inline execution path, io_uring has not
> yet copied the SQE to kernel memory, so a concurrent userspace thread
> can modify fields between reads.
> 
> cmd->request_len is read for the bounds check, for the cmd_len
> assignment, and for the copy_from_user length.  A racing thread can
> change request_len between the bounds check (passes with <= 32) and
> copy_from_user (uses the enlarged value), overflowing the 32-byte
> scmd->cmnd[] buffer into subsequent struct scsi_cmnd fields.
> 
> scsi_bsg_map_user_buffer() independently re-derives its cmd pointer
> from the same shared SQE, re-reading dout_xfer_len, din_xfer_len,
> dout_xferp, and din_xferp, enabling direction confusion and buffer
> length races.
> 
> Copy struct bsg_uring_cmd to a stack-local variable before use in both
> functions.  The pointer variable 'cmd' is redirected to the local copy
> so the rest of each function is unchanged.
> 
> Tested with KASAN on QEMU (virtio-scsi, 2 vCPUs).  Without this fix,
> a two-thread race produces:
> 
>   BUG: KASAN: wild-memory-access in scsi_queue_rq+0x4a3/0x58a0
>   Write of size 96 at addr dead000000001000 by task poc/67
>   Call Trace:
>    kasan_report+0xce/0x100
>    __asan_memset+0x23/0x50
>    scsi_queue_rq+0x4a3/0x58a0
>    scsi_bsg_uring_cmd+0x942/0x1570
>    io_uring_cmd+0x2f6/0x950
>    io_issue_sqe+0xe5/0x22d0

I don't think this is the right way to fix it, ->sqe should've been
stable upfront if this ends up happening. Can you share your poc with
me? Your trace has been trimmed down way too much to be useful.

-- 
Jens Axboe
