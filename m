Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC18B221DB1
	for <linux-scsi@vger.kernel.org>; Thu, 19 Dec 2024 10:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734602946; cv=none; b=KPPrjY71EFQ6GJMQXEU9gc+g5yYGrhGJ+pwWagJvPtqpflYCNgKAz5akSxF67RdxLE+xzZQREwXX9NvsZT1Ts1ILUM0BnT5OZLaA52LzGrpb8r5+uEKm/gJc68M41o0Ote3WbTRQmbyCgnsZEyKHdUyxJZi2j9no87AxsySydms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734602946; c=relaxed/simple;
	bh=2gDH687Y+RbAzf35eofEUfdXtMWrVfNMD6crZe1I8Z8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qj3uELIQ4aoSMt1wAF7BDIRsAK0rn0WEXJ0YppsIxkh3xjr+sJGJYTZJnJMNFFOW3XBxoPvB2/NGquHfeJoMmVwY3ssYRJepc1ms9veJUALjoUuS5JaeDBpSfFoDqgqb0FYzGaTSkzd3Nkj5ebg8T0i1uCOcCKc6TC5xZ3z9Hhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iG4CxSdH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iG4CxSdH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1734602943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T98mqp2bW2iDbPQ1pjYih/rvPbjnw2C5T7MaMia1oug=;
	b=iG4CxSdHDBX+qVGi6ftJSmJLnghH0Kx0YLCv95YnNgo2nfAKvLFNPrSieVtxN3vpwzso71
	BNB+AU/nWhFOiw/Mju+EuYf15PKyLdAkFM9JUR7wHQd/qmhRyst2nwuqhvvw36LnmGXT3s
	JCoRrq2LPRTX7nIzcKD+B3L6M0ahfUg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-638-bTukT6WTPXWZLxOyHE7j7Q-1; Thu, 19 Dec 2024 05:09:01 -0500
X-MC-Unique: bTukT6WTPXWZLxOyHE7j7Q-1
X-Mimecast-MFC-AGG-ID: bTukT6WTPXWZLxOyHE7j7Q
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-436225d4389so8527025e9.1
        for <linux-scsi@vger.kernel.org>; Thu, 19 Dec 2024 02:09:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734602940; x=1735207740;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T98mqp2bW2iDbPQ1pjYih/rvPbjnw2C5T7MaMia1oug=;
        b=Zk5D4VmPCySfNpEzftrumysk3nxa+6AG7AFFLsiHTyvERWRS+AFDNjwCj7HwplIIJX
         ivnqCqJAvxff57lvHUH0bgcuyFzznPH3hvOqIHeR+ORb8Ke9qr8+f/kgBaiw0YSfybsv
         wPh9FgXpRgm4O5DeBN1p7ZyqPYj9zmIhgDq/0sg68pXYwguMwmvBsrVy+hSZ8QqceY99
         d/7qaWHeq6uo1ay7ojh+t7GlO2i50MOD2Bgr/yKF6U/sHqWywdm2cfNKR0URERJcaVtb
         CEVqgltyXLwTcQfqVTmindC9zfhTyBXwCwhXFXKxqLQyOrHl3fi5s8Gg5Zsws5WTS0id
         eQrw==
X-Forwarded-Encrypted: i=1; AJvYcCUmh4ENguX3Olo1kELc6676acPFNrAHP5H6u0d2fzFgApZB+1q7lyuGt0X2yCa/Zms7ctygKKE0oQBx@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0CbZlAGmLq0tqevlz3sPsV54QytAh7fLRyBD37vBT5XbIA83p
	3BOjO3MPkkb6K9foKH5u2Fg9tdhXq17i26IkrKALypE4ZAR2V0prCYrnPVOpk9hSmvU8xUdwbp5
	kn1dRPeoimK5w31w5orp7bRu8FSYQOLvlmBQNaeDG7PzZZzS1uQ9cb7dnCC0=
X-Gm-Gg: ASbGncvZUpDdnAQ1WjofF1e0F57uAOdn80GvnyUpgxU4DfqSN50j9C2tYSpoGEGupGM
	/9JXLSJHKEJxv3W2a2VLuO+aoOGNAiX4gwPhijL1tJORhNSa9zMH1Iu92OhqCfQWWYAFII6vfNG
	9kjK5COZpAOGp6gOr08+JtIPtwO3gTFphoGjffn+YUUCBH4l9psNh6Kym76qtcX2IBn0rU05pvI
	7gUj7agrwuzPjoru7cPtQJfV3GrgtqtHhaSp8mn0DNkRwGeG2JHP42o+pH9pFF/2A7yPgxA/uvq
	0FLr5LRKsQ==
X-Received: by 2002:a05:600c:6b6d:b0:436:51ff:25de with SMTP id 5b1f17b1804b1-4365c77510bmr22352085e9.7.1734602940180;
        Thu, 19 Dec 2024 02:09:00 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGirXoXRQE0r5vB0TfkeqRe7MfB/RkGpoRNVbjNqtlwjyADuUYTSVPC9u5W6B0bBw1vsjY5kg==
X-Received: by 2002:a05:600c:6b6d:b0:436:51ff:25de with SMTP id 5b1f17b1804b1-4365c77510bmr22351795e9.7.1734602939835;
        Thu, 19 Dec 2024 02:08:59 -0800 (PST)
Received: from [192.168.88.24] (146-241-54-197.dyn.eolo.it. [146.241.54.197])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c89e2d2sm1189392f8f.71.2024.12.19.02.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Dec 2024 02:08:59 -0800 (PST)
Message-ID: <badf281c-cccd-41be-9cd7-bf6637c981f0@redhat.com>
Date: Thu, 19 Dec 2024 11:08:57 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] net: core: Convert inet_addr_is_any() to
 sockaddr_storage
To: Kees Cook <kees@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: Simon Horman <horms@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
 Chaitanya Kulkarni <kch@nvidia.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Mike Christie
 <michael.christie@oracle.com>, Max Gurtovoy <mgurtovoy@nvidia.com>,
 Maurizio Lombardi <mlombard@redhat.com>,
 Dmitry Bogdanov <d.bogdanov@yadro.com>,
 Mingzhe Zou <mingzhe.zou@easystack.cn>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 "Dr. David Alan Gilbert" <linux@treblig.org>,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, netdev@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
References: <20241217203447.it.588-kees@kernel.org>
Content-Language: en-US
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <20241217203447.it.588-kees@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/17/24 21:34, Kees Cook wrote:
> All the callers of inet_addr_is_any() have a sockaddr_storage-backed
> sockaddr. Avoid casts and switch prototype to the actual object being
> used.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Simon Horman <horms@kernel.org>
> Signed-off-by: Kees Cook <kees@kernel.org>

It looks like the target tree is the networking one. If so, could you
please re-submit including 'net-next' into the subj, so this goes trough
our CI?

Thanks!

Paolo

