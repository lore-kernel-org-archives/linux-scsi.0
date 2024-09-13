Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8911486AE3
	for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 18:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726252677; cv=none; b=NIPLH28W95I5iSGQ8/9epi6X5y7I1EMWbP1DgTl7x4npEGVUrUmpUkZYzYZwDV3TFMTx8Y9lhdXl7VoN2lBLDk3EVZyaXaZ5H7Wq3IL8gl5/oDQyQPTOlYMV7WU5RWWLuAO/2XAiKW0a0IoIcclMt2whkot8yaHU61SACI/PePA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726252677; c=relaxed/simple;
	bh=soXX02shZgK3i0/+SD0c6UGvkvxfq+2YjBhGP8GM4f0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=k87DlICFjlLYRB6fsebIdGzTlVw8zUkCNX0VY8vCXLCEbfutEvrTYYAurJNbXOctu/1+hRFllPulTXVojvCCgFjuFhVMUatoAn5X5bwPOuiEz6HINHTBh1hYRfiFjHvdTWZcmQLjmi5tDCytdBhtHyeVNIYDlB39qRcoHs4Wc6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AHvMJ1DJ; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AHvMJ1DJ"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2d877dab61fso969996a91.3
        for <linux-scsi@vger.kernel.org>; Fri, 13 Sep 2024 11:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726252675; x=1726857475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mrB+Hmxb4QK/8HwYBDkHB2XlWD05YJZL1QKZ9ghv1bE=;
        b=AHvMJ1DJb8F0hF6D7GxB/R7SDWnT1dLZxPY2X1IWTbWexDi7wnDxEmt89bCL+c0dfh
         fYmlptIlmeAL68PvMvFF3WAhDRl+lScFUqJKs1uOPf15BE6VCyk+BpH93HlAfv+w8j8Q
         j4o7UqeDxGjX4+TtToJJdPwiwjxqSo0KJ3N7N8LL0Uf8YneVKEQ7KLQ0NJ8qdCRbpsTy
         BGSKzBVyDhGyiQtumqp1XxOexX4Qk1KNFirotSohuAmyBFVQAYWjRS1j1mXcCEYrwQMx
         DbmiwkwTM66K3gTzpF73EkPevuo/JsqJ6wGHhni7wgUxGlhh3KF8059S+7jvhXUYE5CS
         bxag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726252675; x=1726857475;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mrB+Hmxb4QK/8HwYBDkHB2XlWD05YJZL1QKZ9ghv1bE=;
        b=GakK/csZxUA767QVSuawSZhTYk+A8DeK1GexMwnY/YOhLm+33/FdDIFm2jTmyEQe73
         Tzugd7eScJW8nk1a/BbZyU151mtrFHCAg4cEzwKv6peM1S1JsvmhHfIz8fDs22TPELwt
         Ao7fBv0xYPzI7Q8fccbSwhUoKS/5cIAhghWX2pTKMzbAHTvVvvFQ47ZgCHTPlwkl/Gav
         vpPraTemAr7Ty7GPOg7tVXqtGChhbBUNx/Xo1fd6AabMzJCH2UYdjR6f1B7YEeC7SD+9
         jxdlWKoqV4GQB20gRc2pGL39XkcIZiRg5/qHPMkfEWtF88JTs1GxCnPcjMNP3SY+cWfT
         uy1A==
X-Forwarded-Encrypted: i=1; AJvYcCVtsY/JAaHcgc3SnX5kjCZ5FWt8IcFid2OmtI3n+qCDBRKaHOboIn7YQhc0GBYggqnFsan7eSTd4BZn@vger.kernel.org
X-Gm-Message-State: AOJu0YyDpD6uGF6+I1w5XZLPX2tPnwE5ycSsWdeuKBAafxMomeVGl0hV
	CAuXPGkfmCqFwINBNQw+sJrP2LdS2NGyw8RWq9ryV2CKNrpEQB6J+WS5wT21Qtc=
X-Google-Smtp-Source: AGHT+IGe+5/MHKnKQqg9KZuy2B2Mce1EGZNmzHsE22Siu2vIa7Q6z+h4KwKtvGrKJiIR8wXMxfcUiQ==
X-Received: by 2002:a17:90a:fd81:b0:2d8:ad96:6ef4 with SMTP id 98e67ed59e1d1-2dbb9ee0f71mr5231548a91.28.1726252674647;
        Fri, 13 Sep 2024 11:37:54 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2dbb9caafb9sm2144057a91.24.2024.09.13.11.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Sep 2024 11:37:54 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: hch@lst.de, martin.petersen@oracle.com, linux-block@vger.kernel.org, 
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, 
 Keith Busch <kbusch@meta.com>
Cc: sagi@grimberg.me, Keith Busch <kbusch@kernel.org>
In-Reply-To: <20240913182854.2445457-1-kbusch@meta.com>
References: <20240913182854.2445457-1-kbusch@meta.com>
Subject: Re: [PATCHv5 0/9] block integrity merging and counting
Message-Id: <172625267354.693477.10856158382526407856.b4-ty@kernel.dk>
Date: Fri, 13 Sep 2024 12:37:53 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.1


On Fri, 13 Sep 2024 11:28:45 -0700, Keith Busch wrote:
> Some fixes and cleanups to counting integrity segments when metadata is
> used. This addresses merging issues when integrity data is present.
> 
> Changes from v3:
> 
>   Dropped the trivial nr_integerity_segments helper
> 
> [...]

Applied, thanks!

[1/9] blk-mq: unconditional nr_integrity_segments
      commit: 2b018086143d638de8d67ae5be6e8c1afb413193
[2/9] blk-mq: set the nr_integrity_segments from bio
      commit: 9c297eced59817f461be33e4c241820c5be4bcc1
[3/9] blk-integrity: properly account for segments
      commit: d148d7503456556859c7e4d354115215d8fb5016
[4/9] blk-integrity: consider entire bio list for merging
      commit: 0d7cb52fe417dde4bc9e8d01fadd8c0ec69612cd
[5/9] block: provide a request helper for user integrity segments
      commit: d2c5b1faccd5ef6352456f817e941945d3b3fe62
[6/9] scsi: use request to get integrity segments
      commit: 27c3785e94f003c664d9d867fbd62d1494546876
[7/9] nvme-rdma: use request to get integrity segments
      commit: f4330766bc0d14b5eb9459e616060d697e7b128e
[8/9] block: unexport blk_rq_count_integrity_sg
      commit: db5197b554fcb8fde0182af65e8e94bec414e342
[9/9] blk-integrity: improved sg segment mapping
      commit: b712a8c0be4d50cbeffe24b9af96921f28b6f939

Best regards,
-- 
Jens Axboe



