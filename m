Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5258E4121D
	for <linux-scsi@vger.kernel.org>; Mon,  8 Jan 2024 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XstsQf/e"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7baf436cdf7so19519639f.0
        for <linux-scsi@vger.kernel.org>; Mon, 08 Jan 2024 07:26:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1704727607; x=1705332407; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jKBszmdO+GFMl2fHINscvTxwqYrGI6Zn86c3J1Yhu2w=;
        b=XstsQf/e/AK3K3YYQ7/RdeeOce/DDT0IzrckK+djVFhSSVZ7Phzkq31wIYjUU688R0
         sGHPuP0fOi4pGW39wjJVnhKpRZhThLXl5F1N59UL0rCGexSKVPWe5HZQx2Np6Pji4IOa
         JcmJbq0E//OGAgBq1gd4KxF7OiHxbHfffADooPJ2iebHd6C0VAyjtElEwwbBYwrL+eca
         m2KHhDLC7/ZN8sMkoqfASnZUDPSkyipZdlUj4SOdRJUy5s3gMqKoPLCiELFmGI8S7ibO
         8taAT0BbLwQW+XLLxaXifRwED3IxDrG/nkj+uuiN+Kb7O4g9KoxFFXZqGpoJ+c5ZDy0s
         hfSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704727607; x=1705332407;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jKBszmdO+GFMl2fHINscvTxwqYrGI6Zn86c3J1Yhu2w=;
        b=Ef5ofFGtf1wDiId9OR3ahoGS9zg9A67HvCzXONHHYlkev3Rl5IisoaEja4NISJWKdk
         vGUZ6T40Q3w0UXpsRZm/g28Yl/jYeGiwhtroKxYnCUO64Wizlwz8HQvM5jvFkGM3rbTU
         r/xxgzFFq1e4XHXfUJdUj2msWHrwLOc/jswO/y9KPo4ljP7D2NfqOlN+qGzI1oyDeWL8
         EFXvmCyEINHASnyye0KVnSggaBk0IRhqLxJQPST//7wePj57g52bo/H3jQkm1dFUQZwg
         tIeYfHP4zZz/9iUN01TXIio4qfJZPlQHUiMkHFq9PjvvZH33Kf8gxMw1lqAFn+9WpjQS
         k29g==
X-Gm-Message-State: AOJu0YztuCqLmqSx1qoM/NkBfks5DfrZADWTcbVp2rNRoazuTxBugUpJ
	vPta+SkO7rGWTk1Vj9azFaExzU6N/7zLow==
X-Google-Smtp-Source: AGHT+IGdW9CJgcvJ2Uthw69BnC49HL+xr8afbYNDsiCuyMlQghag6fjOJBvE4n2UC5gZBoA6TG5KjQ==
X-Received: by 2002:a05:6602:4f42:b0:7bc:2c5:4f6a with SMTP id gm2-20020a0566024f4200b007bc02c54f6amr5641129iob.1.1704727606891;
        Mon, 08 Jan 2024 07:26:46 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id bp15-20020a056638440f00b0046d6b3edd2asm9666jab.132.2024.01.08.07.26.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jan 2024 07:26:46 -0800 (PST)
Message-ID: <1a4f6e1e-9981-4e2d-bacf-3e387addfa47@kernel.dk>
Date: Mon, 8 Jan 2024 08:26:45 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: remove another host aware model leftover
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Damien Le Moal <damien.lemoal@wdc.com>, linux-block@vger.kernel.org,
 linux-scsi@vger.kernel.org
References: <20231228075141.362560-1-hch@lst.de>
 <20240108082452.GA4517@lst.de>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20240108082452.GA4517@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/8/24 1:24 AM, Christoph Hellwig wrote:
> Jens, Martin,
> 
> can you take a look at this?  It would be great to finish the zone
> aware removal fully with this for 6.8.  Thanks!

Looks fine to me and I can queue it up. I'll do so preemptively, Martin
let me know if you have concerns and I can drop it from top-of-tree.

-- 
Jens Axboe

