Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04C228689
	for <linux-scsi@vger.kernel.org>; Mon, 22 Jul 2024 22:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721686950; cv=none; b=NpwCt2P0HBOMXLQkZE5YLjxH55v7PnhFp/lQyoeJulJVdtTVF7cmfe8iN7e6MNpSWbmYvtHVfK20TB1Yu2GPDS2T66sWsx+vveBhFLU2VYac7PUy1gSjH1FDE/yfTUwBpK3m0z9PzuxoXTN1ukAP+vQarm+eHI7MMLuaeL2wTTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721686950; c=relaxed/simple;
	bh=NBa7JVKjwoFi4L04QvHkRHOK1hCkVZoIydEAQJ8zEFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rEcs/SYQTCaiZ2PYpOdKiZsPmLUgk3wbiinu4tUC5p7i5gcvXJSXwdQvCm6m54GA0fE1+nBUfbr2/4BiuQQAhSeMAHjrFru19uvPRz44YpNPSI7tLsptjru28p4e0Dqxkv3ZCkQG91NWOgnYirpYyIj2PIwdhIs1X44vZ9qo+hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=s0JtGKL6; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="s0JtGKL6"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-812796ac793so20136439f.3
        for <linux-scsi@vger.kernel.org>; Mon, 22 Jul 2024 15:22:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1721686948; x=1722291748; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MnRlInGC8vN1+rV19INQEkwGpgPNaUbausotg6BATNY=;
        b=s0JtGKL6IA1nZBi0d+vZIFFOtEBw68ylf5xA2XaGhvBce/WB0Gd7lEpMvHBBjQXVyh
         YUNzdv+wjdD4eUXbN1JH/ZeDUJMfIotZbQmIPLtAX801dPPJW9Nyc1u+h7QpttvH40oh
         wjH5us74GSsXlFzp4rGAgGTNjOljXoausBIwlGYwebVjBrVFza/GRQvNiBk+ZFl4Wpne
         U3Gmh+zqTJ89eMML6VlImvrsjA4E2V3OKfoY2gZKW5rx4GmHXbPfE+GQJFmUk3cx85TI
         97EHefIFxJ74EX41/aXfXe1Uja+GWsulpKOfZo68VEEZWuy4wxcmzDy1QhAyWfSux38o
         bd2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721686948; x=1722291748;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MnRlInGC8vN1+rV19INQEkwGpgPNaUbausotg6BATNY=;
        b=WBVxblyNRuvAwi9Q67WmDQYKuOa1rSh/3H6pY7rvnMRcaapu/RDxWP1/t2q6z8VI0e
         wL4yw7m56qAbgStBLDLdB76KNLgzEdcLwBb3WcpVHp6PY2sAEQSyIkFXO0K/HBBMu95T
         UzOWZYP9TxbUww8TMplNz2XcmqFZp3XuEGk7lQICWkaFMUITTON6u6XejiXmSHIiueGh
         nsd6Jq7rbD9RtOiDliwmPDSrYSW5aRZgGn+KfgIpvno6Noo/HdDnIeyi874nkHc3de3A
         Qlxx9Jm+letR+zSq0EwDT1UUcmr27pb38cQf5C8GexdjuuttOw3wVxIJhlfp/lRijae4
         xZbg==
X-Forwarded-Encrypted: i=1; AJvYcCWQ3KbrRPPS9Kjyrd7AdHiNnHRdBrLs66U/uB4OibkSAIVVGvphzpj+U6fn7ADTmAyFrFVT6uj9uO51Q2MfCDobwTYg6Jmg0TxK7Q==
X-Gm-Message-State: AOJu0Yzb2vOYk5liG1/P3jU0i43tYTjVjqjhrpeKDlkMVS1YAyeudDtR
	iMGd51yow2kuq1T9FRq9HcGmuiPRBqCoGPjiEJiYNMJFJayY5o2rsSQV9VnduCzxPONE50RsbjJ
	tALU=
X-Google-Smtp-Source: AGHT+IGErpgwGnbRUj/d1zgp5yaU/AfHzH/lzmXBBD0hSLIdu6yCr2Kv+i26Aj/Fex49lV/gUXpopQ==
X-Received: by 2002:a05:6e02:1d9b:b0:38e:cde9:cc86 with SMTP id e9e14a558f8ab-398e725c529mr48241285ab.4.1721686947826;
        Mon, 22 Jul 2024 15:22:27 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70d35de3274sm981370b3a.83.2024.07.22.15.22.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jul 2024 15:22:27 -0700 (PDT)
Message-ID: <c1b47037-4754-459f-9e8f-ae4debd3fcf2@kernel.dk>
Date: Mon, 22 Jul 2024 16:22:25 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/2] scsi discard fix
To: Li Feng <fengli@smartx.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 open list <linux-kernel@vger.kernel.org>,
 "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, Damien Le Moal <dlemoal@kernel.org>
References: <20240718080751.313102-1-fengli@smartx.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240718080751.313102-1-fengli@smartx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/18/24 2:07 AM, Li Feng wrote:
> Hi Jens,
> 
> These two patches have been reviewed but have not been merged into
> linux-next. Can they be merged into 6.11?

They can, but is there some dependency that means they should go
through the block tree? Would seem more logical that Martin picked
them up.

-- 
Jens Axboe


