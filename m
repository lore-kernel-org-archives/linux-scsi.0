Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5853F2820A4
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 14:22:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763043729; cv=none; b=l4ZYaUx+eUfzGhk03LvDmSX8hYBLjwDTtB05ZfWmwtN1K2Iyd5C9o6DReZTsYSZTu8x7b+odbVnfwFwJeK+sevVHNhXpZRc4y+VL3YpQUwofHGpRe2usiXdcLKx04HOTKG1Kmr2hvOU9iI3ibG7WyTajdq23ystMzQ4miH5GJj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763043729; c=relaxed/simple;
	bh=SRPyIxONN4iYKqdhLwIvZsfImSINh5R41RazzeL161E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dc6VCJLy2LEdfkfbbpxDhPtVUxlqw3NFDA+/M3WQzG9CONXvYYrZF8CUTdxgef1TXZgKdWUs8Cz/4dbrHbXb0W1pH0kZ1yWCobIPwSb2CqHJurSKiUdeNElIdcysEvDRpLcedEu157/KQkLLj820/addX4VZmOZtrFjeys0A+rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AQg3waQB; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AQg3waQB"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-93e9b5bafa5so33137339f.3
        for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 06:22:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1763043725; x=1763648525; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=71QUiUVvszi5smeka3Rm9hrZ66uQklMOtur10e8Yq5A=;
        b=AQg3waQBLs1mDXuu8rFSAzYhFV+l3qxbYk4QyA1JN23LwdQTOJgVYP0axL5jCRP1HQ
         p+rSoQtHKPrCa8JS2F7217WI7IAUT3rL3dVgPdDld/ns3BHW25aOmbQ9ynhLqlLbWQiz
         7xxXcpr65X4URJgCvPshAgwIkCQ0PutEToWS9BCPFAIZQGiKRuQBJJC9H9JmcnTk/uGC
         9ucAK2v15LkcwGWmG9PKmbqDdF6C0abTeFeHtfkMmoKo9PQnnmDNiJT9ceX2WNBYErSx
         Gmu65y5VETQpfNlOeEmwSabumTOz2thN77CVYMXxKwC+kb0RSq+PIsSGjxI49Nw3ieGg
         i7bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763043725; x=1763648525;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=71QUiUVvszi5smeka3Rm9hrZ66uQklMOtur10e8Yq5A=;
        b=aG49Y8RpTGNCVoLPVuBRGqqSqhBsyIorp/uYRAWrkiKfTTUN92A/38FosiH1iZnjLV
         s2uL2unZ1wW1K4tRITvz2JQ2XOvYlR1129NqWMPUxJ9Ks9tEgE/jCga4/sSrH7dW9UJH
         O4U7YK9+cJDuaKMVRFfLLR/2iaFF8wgwOOPbdlkjwnt9653vWoo1Bx7MiJSXwyCoeXYO
         +O6d0N65tMn/KezBifR6oC1OOSWcTVHH0XLvFaOOLnZlz1aocVKwtdPom6vcqexzM2JR
         wExGrO8b/T1hYzHNB9/ZxNKpKgoPXDw8xLgvfPaIUJI4x0eQu3oGlBWVlZEGNlFoUeVe
         JNow==
X-Gm-Message-State: AOJu0YwWy9SuH7nE0EzvFuAec6u7oC1ajyJFw+6z+i4yq8kZH8BJCnUh
	ahMzlw364qDvBlMNbAMi606Fxcz9NIMJuCBifDIeKZgID8zQ/ck3Bg2n6S9gzl3IWok=
X-Gm-Gg: ASbGncuTNfZ7cF9PQFwFO5Lk3ErMjvBS4UNH8wUvhJJWXSY/+qJ0juAC7SNFVANufEB
	r1JVBK4xbhHs/PIftC6IErBQmS4/6tXubwJIcsez5v0xjedmybBnRooatqAJm8mqR5oWddu3zB6
	V1mux3pQB0TpR59ln5X2FDw8C4nl+XHS8zHpWpaCSUi2ycfuB+Nj3agIdHNbDBCWth2hlof5xXH
	rnhuF8af69zwIkK4izxbgCUoieE4rpsrAS6o/cbFyp2/Rq1w/v2JUKZemZCNWHcW9MrmOGcJ5cy
	o5I+vyK3GemWGgmYTWFgfIcs/OprpQ32lyDUw4N9MViKVxpZgGvL9S3Ru0vAXzTA3rZkbsIxdwV
	mOFnd/hUudDSph8vrVZu0wQRk9KrOFJZsHCnoDgzEHNzk1X9lBunbW9CXJ+Ns1Ojcnk63+gorqQ
	==
X-Google-Smtp-Source: AGHT+IHuKMRKcENHxBgpAEXEf1GFTGz/cL+4p3x7bUWBgR+loibP81c3hZCRmFcC+2FqcHg4MV7cAg==
X-Received: by 2002:a05:6602:3609:b0:93e:8b7c:4a25 with SMTP id ca18e2360f4ac-948c46d85camr843857139f.18.1763043725163;
        Thu, 13 Nov 2025 06:22:05 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7bd2700d8sm755013173.22.2025.11.13.06.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Nov 2025 06:22:04 -0800 (PST)
Message-ID: <bfa525c9-5d86-4384-8e80-85efea15c5ff@kernel.dk>
Date: Thu, 13 Nov 2025 07:22:03 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] blk-zoned: Document disk_zone_wplug_schedule_bio_work()
 locking
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Chaitanya Kulkarni <kch@nvidia.com>,
 Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20251112182421.3047074-1-bvanassche@acm.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251112182421.3047074-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/12/25 11:24 AM, Bart Van Assche wrote:
> Document that all callers hold this lock because the code in
> disk_zone_wplug_schedule_bio_work() depends on this.

This is already included in your previous series?

-- 
Jens Axboe

