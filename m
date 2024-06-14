Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 129EC16C437
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2024 16:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718381766; cv=none; b=qLDaIAN4YQtM70egnJA5tW1rsAUF00gv15HpMpoNQmeOZlwpbZRJpMbvOLt5LMxGSuYOGTMAPv0rhz87wARS6YfpRxuEGyhz3J/wQ6w2jf9rrfRdkmZmZBgvDUVlQGOG7sCbBTq98zEJZiC6/r7tIWWvKGLRK4I5gN72DgThRSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718381766; c=relaxed/simple;
	bh=Aad19hIjxSUfEbYh1/pSP2sHGv1iCwO+UAJvrB+cZ08=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BiUXIXLIrjLYBvF/mcgFp+bzTHGCAweMkb9BJsvfQczwM+zmLk6qmpopYliqR3i4Igs3Az2ZHQrYM0WYJkcQTe0lelhHc9eCedZw7u8WvVSm2AAKKSlru7AVqETKcE4bT9Hq2DI+9PgY5QOHYRSybCf6CB8NpMQt0yS+dxAyajI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gqQ2NMhY; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gqQ2NMhY"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7041a382663so73089b3a.2
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2024 09:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718381764; x=1718986564; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BDixbra1HnV5DPgXv78teb+z8r3TOra1wJTUjH08YD4=;
        b=gqQ2NMhYISubpA/O2zIDXj7REGCxPKs4R/Rde+ilKBlHNlj2PmjMPcpzq+17MEyRVe
         IXc9gw+SrQ5Qxq6CbfSwf+KWf7KgvKBM9EpAAPrq4HhVhOyv98il/gX65LCRG2iL8H+D
         vW05aaiimr1Pv6Cwo0NLKS2M/Uesj4UcctnZp5IigCyN95IAhb1VuyWt5RL41KpiG42d
         vM/wwiYb2D+x0FuhVUhDmFLo90AxEkzwLxUSmEEs9nCgxq7tUQyoHSp/eg5x3NJK8g49
         zk6+FGx/M/t+QDE1+M8/tj/qiVAtDYBXE7bcKVpSj8Jm24Z0f0UIFEFOChdO1Z2mgoDc
         WPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718381764; x=1718986564;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BDixbra1HnV5DPgXv78teb+z8r3TOra1wJTUjH08YD4=;
        b=Dg1ve2w+31WUWa3stjT81coEYQC4++vPulIWXECg2yemBTtZqhboKAlxxwfyZHjDxd
         DspWRjeX7aB87PwwdBhQpMsoR4IzgH92ktv1lPNPAtaPAR3zIQZmc2yF2lXNx8a9Um7c
         Mtz6rc+lbZXb6hpfLmUdKdy6iE9px8wwoLd34kZrpqcYnD02M7ngAWJfUk1uM0AuATvu
         4fE6mB7tXOURWLja/SSFsS3+JzmNv5noc+2oFq7lDnfp90kZ7paKCyNiOw1jatSzy98b
         8NdJK80g4eCFTuoEJ5/Y+2zfd3enGMXq53E3CyX17axXqeNekuyyZL89YWOdZgqY8l2l
         P7Nw==
X-Forwarded-Encrypted: i=1; AJvYcCXBOPJPkGWb2eyK5DHYebicp/46Pt5U4qeRqXRiY/6Lk5FEktIoTWUSpZBqbmZxs7U6h8MoPJjlWgtdAUtGbHg2p6jpEYYUIf0vkQ==
X-Gm-Message-State: AOJu0YwIYaqFjwuMUXzSRXiThGwddpO50uPYe6f0NeLgqTfrYM56Du7I
	jF7ToZpbBCXSj2yaBJBSsgs0ap2/7K+gxUdjcX/MMIRyBkROla9OEusyc1KrdBM=
X-Google-Smtp-Source: AGHT+IHcxyIgaaVTPfM4bd/lwoK3Ws05v5eakEhv+baleiJUj4MZMdoqwGuHfLvaj6ML51yAKT62Sg==
X-Received: by 2002:a05:6a21:6d98:b0:1b4:e10c:62bd with SMTP id adf61e73a8af0-1bae7ed3e48mr3699835637.2.1718381764289;
        Fri, 14 Jun 2024 09:16:04 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705ccb8d98bsm3224419b3a.191.2024.06.14.09.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 09:16:03 -0700 (PDT)
Message-ID: <6c5d4295-098c-4dc2-8ad2-f747a205f689@kernel.dk>
Date: Fri, 14 Jun 2024 10:16:01 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: move integrity settings to queue_limits v3
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240613084839.1044015-1-hch@lst.de>
 <f134f09a-69df-4860-90a9-ec9ad97507b2@kernel.dk>
 <20240614160322.GA16649@lst.de>
 <af0144b5-315e-4af0-a1df-ec422f55e5be@kernel.dk>
 <20240614160708.GA17171@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240614160708.GA17171@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/14/24 10:07 AM, Christoph Hellwig wrote:
> On Fri, Jun 14, 2024 at 10:04:28AM -0600, Jens Axboe wrote:
>>> That sounds like you didn't apply the above mentioned
>>> "convert the SCSI ULDs to the atomic queue limits API v2" series before?
>>
>> That might indeed explain it... Surprising it applied without.
> 
> Also as mentioned a couple weeks ago and again earlier this week,
> can we please have a shared branch for the SCSI tree to pull in for
> the limits conversions (including the flags series I need to resend
> next week) so that Martin can pull it in?

For some reason, lore is missing 12-14 of that series, which makes applying
it a bit more difficult... But I can setup a for-6.11/block-limits branch
off 6.10-rc3 and apply both series, then both scsi and block can pull that
in.

-- 
Jens Axboe


