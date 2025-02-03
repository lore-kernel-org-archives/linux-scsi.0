Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28CF9209F5E
	for <linux-scsi@vger.kernel.org>; Mon,  3 Feb 2025 15:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738595529; cv=none; b=UvCHL3spbsPk0/qn2fW/iuxd8Of40mdeyP0HRUKcBTzWQwPgG2WXoxyC5WuA4t0F5UaQCOGgGjBA3vFp8YObO1eiSNfLPZhC/bqCK8dEDLN7SykZsHSqv/x+ao7Hgtxg82X7SxECE0fRk+AgDqNozfa2Y/XBbfhyhZi7CbDsg0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738595529; c=relaxed/simple;
	bh=J4WPyu2dCpa1wg3kBbT+yTxtUfiD3S5ZdeCx/ev+Q+4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uaxCbTOmQnitfpk1MyeLhDQE3kUkyDiLLHGLQfRVpjxvCF4HCM/DX7O6tnEq337bHexgIQJuDNbW8GnzaIMXx2wYh4lmq2REctymjh7zyHk121yLq8jCowCo8uOKGWlBL45LLyzrkvC73ChX8nFljEwWVn1QtutSbGDZgo3u8S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=NkiN9Xns; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="NkiN9Xns"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3cffbcd520aso13869085ab.0
        for <linux-scsi@vger.kernel.org>; Mon, 03 Feb 2025 07:12:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1738595526; x=1739200326; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QRfpPZzgAZa6Zak9GDas5XD80wl2C6NIA/57szE4cSk=;
        b=NkiN9XnsNIc9MJ9+BQBMhqCoS4s4xFw7uobCWNFiNpbWh3HQBJG8zie61VQBnwy9f1
         xtB3skXdXs6TlGnbW441ecnT+L3SoGcBa6ziPKji25fhhj/7Vmbnd2X2hyA0yGlydm7h
         GnJpR285Ab4PoaqwEcy61WQc0YWmIFWBeJVUkJtxP0QtjUK0Rwqjdktp3vBzilq9CU05
         xqNpPMNt7k7pR69S3qmCvqbS7aiaftA/pRJ9QEWU3PpdTBmNzz7kyrExM8RLzm2Xa4UV
         a9rX7wbysZIu4dlZnE8fW9cMdxQCO2k96efKhkR2cvcse6u79Omc8qPp2bhUj/I60Jru
         9RtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738595526; x=1739200326;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QRfpPZzgAZa6Zak9GDas5XD80wl2C6NIA/57szE4cSk=;
        b=Pb/3yOvdSx1meiGU4KrhFuS8bhhhF07/3S41QDxruiAd0nYoNQIvK0vZVQRT0Do9Z1
         ocwCq4LhPw60hhiA3HwnosHr3Od7upV/6/BJU73FZQic/3xnZyrna7jjerdROaqwX2Ml
         j7fQJKYMHuaEfhM9ILjPWb57K2YjvW/c5sToCN0+OozJWp41DuuoIh68G9q/BZDpIR5C
         OdCarFl/QPuwWcWHtYX3cakXLEXRLHn0uv08u74liDuGin4xcVegll43ABSbyBOwK4F1
         Szl1XjmKiOGrWFVFlXrZHLLygk5Qp+TLnq9kczM/ZwwIzBqqJT7cI9OMmIirZNCo9JOx
         VghQ==
X-Forwarded-Encrypted: i=1; AJvYcCVIrjB75/yDMJyWWwB50Q2WMju54H/IG1zYZKYOtRocKz4hApAwcVDEDbJIlwBurvBm/+kfKnnFvDS0@vger.kernel.org
X-Gm-Message-State: AOJu0Yzu3415MnGiOIZEI0ShIpoowjbBamaFfylh3QJTH0pjCsewvpoS
	D/2Yfs4xHd6b9p99a7S+0lfORtdmrcJiOhKTmzYeQfm4V4b2X1yZK9tCBiYvfKbJFlwNyoOlWb+
	jl5s=
X-Gm-Gg: ASbGncvrb2FOLO1gw3RMfi7kniq+V87gdt/TTJhvajnZuoBi70TiufypOVK1PKOb1Lv
	cwoDIG8PjWrhig6d91OtmhWNxy4zKjVLS9AKdgEvY4nnJFAgOOch7Dm5i0G1BTkzn/ntDewMvpU
	qbXo0hgvxkJilNzvRd7l4/KXn2/Z4zyJ8zK0mO1gq6r3HqFp9N24V+53CEBwHF/UnaNKDA+I0iz
	x8Ysnvc1dgdY2op1TYl+gZVUSXQQWm/vKbsoQ6TAgX7nBILPKRTZFhRyNYQc1pOJzcgq0bPQwdl
	k5yyLZwamAs=
X-Google-Smtp-Source: AGHT+IExPksUoM3E6ty6LrIuS+bUTXtJbAwi3WKcho/2VPhbuSKK1HIuLb1aeN5jPmbZBIOOLKzxHw==
X-Received: by 2002:a05:6e02:2688:b0:3cf:b2ca:39b7 with SMTP id e9e14a558f8ab-3d008e71836mr145248235ab.3.1738595526174;
        Mon, 03 Feb 2025 07:12:06 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d01c433734sm16125455ab.14.2025.02.03.07.12.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2025 07:12:05 -0800 (PST)
Message-ID: <262032e2-a248-40aa-b5bd-deccc6c405ca@kernel.dk>
Date: Mon, 3 Feb 2025 08:12:04 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: force noio scope in blk_mq_freeze_queue
To: Guenter Roeck <linux@roeck-us.net>, Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org,
 nbd@other.debian.org, ceph-devel@vger.kernel.org,
 virtualization@lists.linux.dev, linux-mtd@lists.infradead.org,
 linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
References: <20250131120352.1315351-1-hch@lst.de>
 <20250131120352.1315351-2-hch@lst.de>
 <2273ad20-ed56-429c-a6ef-ffdb3196782b@roeck-us.net>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2273ad20-ed56-429c-a6ef-ffdb3196782b@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/3/25 8:09 AM, Guenter Roeck wrote:
> On Fri, Jan 31, 2025 at 01:03:47PM +0100, Christoph Hellwig wrote:
>> When block drivers or the core block code perform allocations with a
>> frozen queue, this could try to recurse into the block device to
>> reclaim memory and deadlock.  Thus all allocations done by a process
>> that froze a queue need to be done without __GFP_IO and __GFP_FS.
>> Instead of tying to track all of them down, force a noio scope as
>> part of freezing the queue.
>>
>> Note that nvme is a bit of a mess here due to the non-owner freezes,
>> and they will be addressed separately.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> All sparc64 builds fail with this patch in the tree.

Yep, Stephen reported the same yesterday. The patch is queued up,
will most likely just send it out separately.

-- 
Jens Axboe

