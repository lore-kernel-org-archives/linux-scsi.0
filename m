Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE84414D29B
	for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2024 12:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718368426; cv=none; b=td99SmFbkCYFwbaadpEXAy1KCKlcPKDALM0qQIRoyt7hl3iF2TxUZv1h4z6pekBlwQjtmeq6a3nRKtK/b9ldLnp3+eD/e21Y64Q33PJt3YtgNEX6hqpdZM5Guxy2lco9Sz8q0QFn3FhulGR1bIkCLz1rK69AdYe7697HFjrKsrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718368426; c=relaxed/simple;
	bh=ViOeFSLpzBTfbhkwvbIOhDLgIujUpX169FCRqiXsZHw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=goxGfTokzx522qhLAl6uH5u0TiSzDIgs1osJl1KGgQdfHGaFlai6w310PGGWyCP8Bj7WAzqZowi4AnWybqrCJ4K7HVoVa0de5g9huuSurQJf9Mg7crVK4pPKBrwc/3FtZEB7bVnPlGQc1qnl8+P4G9TsnWdGSXMVXwDyAdhSq/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LuV9Yhz1; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LuV9Yhz1"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-1f715fd5e60so1948635ad.2
        for <linux-scsi@vger.kernel.org>; Fri, 14 Jun 2024 05:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718368424; x=1718973224; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IQUOxKnD6CsmHDQ8zwTblKdKo9rITBkMiMcIVKNHWq0=;
        b=LuV9Yhz17Xocu9NAHd9mQYpjvIl00VlVdGe7bRqWYO80L7X9/cHFM4n3N+EbTbLGaU
         cOOh+b0dIwTDYwTQ3u8NpufJ5hrX031r4f7Le4p+T5I5LS0N5chAfXGpWC3WJrygda3B
         13x+3F9MNOrx153LZj9GWVI8nLwXQTV/wQBgQGaDdOPP1O7xXPj3YOxYN2AAfVTB15bo
         mdMNQyztKNqum/GqOIyJYh0vOND9T1Yt7qyGml6YnhqnszSaaEO9eWrnzxmOxS+VW+Qc
         t7enjwOUGTU/cToDlqMxAKZOlcHiB1nMcSPXgtWED2i6NvjqRb+zM2sZGxNXioN0OpWx
         w+RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718368424; x=1718973224;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IQUOxKnD6CsmHDQ8zwTblKdKo9rITBkMiMcIVKNHWq0=;
        b=ZMkwyDI0TK55ydi44hFKgmgmGLYbU93Y9ONqRzwZjD0gCfkwr8I8wojfSGTIHR2xrX
         dB7FFX0dFO1cbuqGYUdH1KNeFt2X3xeM7OLv/fgsZBVpmqLljohN+fCY/rkRYx7KiQ78
         iZHvuSHL58xuNSPgYMF6QMoyz1kxOhLMLTOD30mMoYkAb0LLGews5mdkawhCxYSzH8fs
         zxRY7x1U3cIp0WPL9onA8vbj694OpZC7oI/VvFv8iUrgpGQltR6rwtTnC8WBI9rAt7kk
         wIiav+nGeTyjZZUVuxkjK+H2XSbFAKSF5IJVogLjWYH7wyJNJHuZOsk101LOoMckeKBp
         gzsA==
X-Forwarded-Encrypted: i=1; AJvYcCU6EVVMRzt1OLbvzuuiSvcuigkWcHUNmJFV+ynVVR0HQHmNn+w0zH0c/I4mcPntcNCA6Dyq5YHOff+0mOpDKSsY2qDITEWOfym5ug==
X-Gm-Message-State: AOJu0Yz1Q2QWs66HK8NHOGEz4plreQdLMtpekFp0Iv3pjphPICjPrQIa
	MHhsrczrPEhwkcg4vjvt2UFDB4DLRCAIJxnG7xW0MGSVwYLLCtdj1Tn1e69lA+g=
X-Google-Smtp-Source: AGHT+IFgr4iSfGSF5IPV3zZl5qFPlqcnaulUtE1TfAC51U6Q4NBcINjOTwVkZv2IxHULMCAp2GZWSA==
X-Received: by 2002:a17:902:eccc:b0:1f7:1a37:d0b5 with SMTP id d9443c01a7336-1f862c30f6amr26779945ad.4.1718368424251;
        Fri, 14 Jun 2024 05:33:44 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855e55c3bsm31084685ad.57.2024.06.14.05.33.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 05:33:43 -0700 (PDT)
Message-ID: <f134f09a-69df-4860-90a9-ec9ad97507b2@kernel.dk>
Date: Fri, 14 Jun 2024 06:33:41 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: move integrity settings to queue_limits v3
To: Christoph Hellwig <hch@lst.de>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Keith Busch <kbusch@kernel.org>,
 Sagi Grimberg <sagi@grimberg.me>, Chaitanya Kulkarni <kch@nvidia.com>,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20240613084839.1044015-1-hch@lst.de>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240613084839.1044015-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/13/24 2:48 AM, Christoph Hellwig wrote:
> Hi Jens, hi Martin,
> 
> this series converts the blk-integrity settings to sit in the queue
> limits and be updated through the atomic queue limits API.
> 
> I've mostly tested this with nvme, scsi is only covered by simple
> scsi_debug based tests.
> 
> For MD I found an pre-existing error handling bug when combining PI
> capable devices with not PI capable devices.  The fix was posted here
> (and is included in the git branch below):
> 
>    https://lore.kernel.org/linux-raid/20240604172607.3185916-1-hch@lst.de/
> 
> For dm-integrity my testing showed that even the baseline fails to create
> the luks-based dm-crypto with dm-integrity backing for the authentication
> data.  As the failure is non-fatal I've not addressed it here.
> 
> Note that the support for native metadata in dm-crypt by Mikulas will
> need a rebase on top of this, but as it already requires another
> block layer patch and the changes in this series will simplify it a bit
> I hope that is ok.
> 
> The series is based on top of my previously sent "convert the SCSI ULDs
> to the atomic queue limits API v2" API.

I was going to queue this up, but:

drivers/scsi/sd.c: In function ‘sd_revalidate_disk’:
drivers/scsi/sd.c:3658:45: error: ‘lim’ undeclared (first use in this function)
 3658 |                 sd_config_protection(sdkp, &lim);
      |                                             ^~~
drivers/scsi/sd.c:3658:45: note: each undeclared identifier is reported only once for each function it appears in

-- 
Jens Axboe

