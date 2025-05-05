Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BA462701B5
	for <linux-scsi@vger.kernel.org>; Mon,  5 May 2025 19:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746472995; cv=none; b=jz6WZYlSsQZfHnpo18bnsMX9Z+PIKGGwg/39t8S02MDILj6WwD2fAk+d/KFVi9kyqCHMS9tKvA01gngDfggErJyBMdaBmAawH/08/BfZzgXizXV+LDyM/wEP4ervu6GgYKqVeY1oGEC1XgrUwLWcB1MVMVX28flo0b9Y+Ovvtc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746472995; c=relaxed/simple;
	bh=ENSwrslkI8QKccIUjGOSW7JPQFj0MtcxngdcS/b7F70=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=C+ZZWSgLrv4uNwXxm7mXCj14atiI+aU2eI5ZBsHfETm4gjl3PXMGPsJFD6Q83c2o4HTrM2rx3wnq2ymNy9Nnp5KW8S2qpopEKVLr6NglC4dX/rKOeJJ9bLIgY9kCJQR0s8zJSLU4RmyvEQiW+rTo4wN6w9FD3pGT6XWtnb/RqbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KzU7a7o/; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KzU7a7o/"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3d938fcb70cso17106515ab.0
        for <linux-scsi@vger.kernel.org>; Mon, 05 May 2025 12:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1746472992; x=1747077792; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZMVeIpMgFF4mocy+t3rzmtkLWK0EgWsZb4AtQGZnRAs=;
        b=KzU7a7o/03NOU83+KXDRr4VoaKCThhQSEhWpcfsB7BOO+72SsMmlp/k2fW3HG7h9q7
         /NePk6i84NyiHnYHIjqsxWXZexMHD+r7oiLb8a6eElueMmWS9Uxt8tRB7wjYzbVK6DAt
         VxnZNa7MuHcswUyv3Mko6USTaFAh4/SUVniSguPryCGnAyzMgrNgLIJsLHrjXidqjeUj
         KE+tFdJHX/hELKBMw1JWT7u4NKGmMoas2agkcC9koVmMNxEvM4tU/TOcTLwmE+cLbR+k
         8dKIqWuGwhfNFgltPDo4O8LM0y8pbBslX3urLbQPpRJAimwzD96UaEAoMOzOlnyiuiYX
         o4xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746472992; x=1747077792;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZMVeIpMgFF4mocy+t3rzmtkLWK0EgWsZb4AtQGZnRAs=;
        b=See3yQXNFDPxKsi4FP3nWhYNtwP432RxXk7J3FrDN8iiDp8bilfc38K6DgM84KAY7L
         fjUQye6Szz3psA2u7qWNUNsPGA0IY3Z2oOPxJkA2W4Vric594KYJnO4xlUl39DkTBQwm
         3swrSZdUr9gG3S2vT4XFhrKylthbtmboSCnOSBGVVNY8WB0r/b0bWk15TXA3JfcchaKw
         VXcGgHkDuhl1R0I3t8Q5afoionAtQg0mZKOqSXPLBKvUhTVJpB85PnbJ+LDkuvDPNJbT
         9p44pWSNpexuBw4CTuHzbP1F48eFWesiNe+YnFNGXbc+hPOfAscVE4kK6Y7mD2EQK7V0
         KCTg==
X-Forwarded-Encrypted: i=1; AJvYcCUSFU2VoRUxvLJy1cKmPx0yDd1kLa3sbqWjQzOD+jzTqv8UL933prPx14pUKe3YAsJepAodBt25m/sa@vger.kernel.org
X-Gm-Message-State: AOJu0YyZCpSY/1YL4CN82rrZWBzOyyKVnn7Gg8ptWtApnENs57FY0wzs
	j7mYpRRMtT42yoV9ywqhtoJ41/u4ATM6dpdsydVTpKaLKezH+6tRlhIxUBayON8=
X-Gm-Gg: ASbGncv4IDfrUxBlpt5JPUtcALe4wOmyQu51FT2pMllkLWJ37d3LeVUOqmAi403BRKA
	o/TKhkciOwSwz6+SmmnHG3Wo2DbB+k3FFizxYSUDo8Hqj6JOJ2Iv+gEBA0YaUkBtiQYc5T6hP1q
	V7n7NRhrQHgOR02PVACKUUOaaptQ91FbzOsOHlcGEAnjezt7+fUWsS7ZlMvzZMbvxgmFRLbJKv3
	1/SGUuMSJuIzbWcCpDV0cJ2yAgGdiHuAIvSUokyl5NXwqvb0S57dtniTAMCNvokaWyATwJBX9Kk
	GqW7vcAzCunlMG49AlD57oN+i0+YebeV
X-Google-Smtp-Source: AGHT+IE4U0Nel01JtHK/rX8QBl2qPC8iA3WLhlaneMKSKU+x8aeNWP3CpSNUZacnFBxkOoaqFfb6GQ==
X-Received: by 2002:a05:6e02:378a:b0:3d3:dfb6:2203 with SMTP id e9e14a558f8ab-3da5b34518cmr82097595ab.19.1746472991964;
        Mon, 05 May 2025 12:23:11 -0700 (PDT)
Received: from [127.0.0.1] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d975f6d771sm21077235ab.63.2025.05.05.12.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 May 2025 12:23:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, 
 "Juergen E. Fischer" <fischer@norbit.de>, 
 Alan Stern <stern@rowland.harvard.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-block@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, 
 usb-storage@lists.one-eyed-alien.net, linux-mm@kvack.org
In-Reply-To: <20250505081138.3435992-1-hch@lst.de>
References: <20250505081138.3435992-1-hch@lst.de>
Subject: Re: remove block layer bounce buffering v2
Message-Id: <174647299114.1416870.3005554851862973144.b4-ty@kernel.dk>
Date: Mon, 05 May 2025 13:23:11 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3-dev-7b9b9


On Mon, 05 May 2025 10:11:19 +0200, Christoph Hellwig wrote:
> the block layer bounce buffering from the early days of highmem keeps
> being a wart in the block layer despite usage by only four drivers,
> all through the SCSI layer.  One of them is an old PIO-only ISA
> card, two are parallel port adapters, and the fourth is the usb-storage
> driver.
> 
> This series makes the first three depend on !HIGHMEM and for the fourth
> rejects the probe only when used on highmem system and the HCD is one
> of the few annoying one that does not support DMA.
> 
> [...]

Applied, thanks!

[1/7] scsi: make aha152x depend on !HIGHMEM
      commit: 7b32cb540bff6d6c8a1659babf930e9f66283c2c
[2/7] scsi: make imm depend on !HIGHMEM
      commit: bf69bd3fc26a107611e76b342027bb60b2411d4e
[3/7] scsi: make ppa depend on !HIGHMEM
      commit: 27a0918d4b701d4825e191448e44b9f14dc0a3b3
[4/7] usb-storage: reject probe of device one non-DMA HCDs when using highmem
      commit: 48610ec22f0cf7ee5b5658b2b3bab27a8f2ef78b
[5/7] scsi: remove the no_highmem flag in the host
      commit: a9437f6a1d8d0b3787fe6ff03d9aab4d3fe9b940
[6/7] block: remove bounce buffering support
      commit: eeadd68e2a5f6bfe0bf1038ec49e3a8d99eb5fe8
[7/7] mm: remove NR_BOUNCE zone stat
      commit: 194df9f66db8d6f74f03c78c2ad47b74a5a8b886

Best regards,
-- 
Jens Axboe



