Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BDB28FC
	for <linux-scsi@vger.kernel.org>; Wed,  3 Apr 2024 01:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712106086; cv=none; b=uz8rouaJ0m4rnve2brsZw6AzB9QkudoP3E3VuhLT/+cYGxGgMvtCRgNIYThnx8z1kmYByGu635CV5hEW9ca28Wf7eH6W+ziOFbgfC5ATXWTN690Z+vszxkFTVU5IgP96T8hQ/CIOVIo1skzT+hHS/hFatxUL5u0A1yCr24j7ltY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712106086; c=relaxed/simple;
	bh=oxq1cMg7RGrZHNssKE2eJeggwHOvoX2G+56i2ws/Nig=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dSfDiXUv0iokKrw2CmRSrn8aBpMu6PiMGvGN8KP1zKudEQq/FXNFsEs5R13rrlZv4yy10kwK/Ax5mB8pmotP2bVJPpYsMlf35FKNp0nXU8fm376LmO+5QhF0EVyp7alfqq1VTFaZeyWrx7weEmjXMe/sMRDxlNHb/p91VEmJFzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hma+xKEO; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hma+xKEO"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1e0e89faf47so18936295ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 02 Apr 2024 18:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712106083; x=1712710883; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bVq/F6jwmyuusQdHnZ4WViSQjual7NBb8Hrq3g+KgzU=;
        b=hma+xKEOHQ7wisUQhekp6hKSSc7O8Uq92uHHR6cIcPYw3nQB5HYRGvUD2T0vV2Lf48
         skFcVfNfAJAFVTtzVR5KZrIf1pR2SBt1tnxwnio0AgBm6lBVANJdVucI+GOkWNPeyzf+
         UkrHzR650I4alt4qQkH43C+a4Pu36mcHnN+n51vDUcT/1dBvvpe6bG120RmLTlIkwkyj
         WdcyXBgi/mvBu61/Yjwvb5kbzBoJFGe8mlJZOUc/kZU/YJyNGLdu/+8z7gbQwCFHbkk4
         8Z54rj18R2CqvXJtskrnU1fhFY3e9Eb0kcdmmT47obG5V8f5S0SnY3hDRb+itcJ/DHhZ
         DzzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712106083; x=1712710883;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bVq/F6jwmyuusQdHnZ4WViSQjual7NBb8Hrq3g+KgzU=;
        b=mFIKb64QfdcDEcSZSK9r5aJz3jX9KQrBJxZFR8aKHlebLReuFyQtrtN5YYotb50ia6
         sN9VVpuyY9RN3HH8LFSVSkQorwe8xPUd0D0ya/E3VjQTE2kkmTkV6VCjNeBDXvLfxcDc
         mV6q1mMpDGdxB/gbjdhpod9LPo6rEsd5c2F7m+mnwAgZ4Mlh1hgcrnLHrKczzn/SReqy
         WNkZnfCL2XN0GBCFZIp/RUyXfpdwVf/FGADfQGSmjDKTleUxL5Ymz8RzgQ68hsux1eFB
         UbqpjXGcbk0R6DibCPKu9BHuMc3JBw4KF9KprR7OeguAk+pud9zx0oSjbhza7w6GrWBm
         IurA==
X-Forwarded-Encrypted: i=1; AJvYcCUnLhABq51YZYu4jhgvUiCjv0ZriVk/QYXobhPhIp94u/OpAvAI3f0E9VsAYwrrFkouOG0JyOTIDUoAN907TxuFvmOhSLrNq6HgCw==
X-Gm-Message-State: AOJu0Yxb9LG8OEq+ga9mU2iXogRLNwkGp3wZmJovRTQb+ul0UNGy7MKn
	Zntq/lL5aRwFKm945YYQnhG9ge3zYcs8iLPqMDxAw8Nxg1KlZDLrAEoRlTSi97I=
X-Google-Smtp-Source: AGHT+IGJhXKwl0JdEUOdgu34QyQrsf18ALIOaqHxaO+yI+l2ba4JnRblQLZM3qjRUlxHmlFK3QYxCA==
X-Received: by 2002:a17:902:b18c:b0:1e0:c887:f93f with SMTP id s12-20020a170902b18c00b001e0c887f93fmr15507773plr.1.1712106083237;
        Tue, 02 Apr 2024 18:01:23 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id k5-20020a170902694500b001e038619e34sm11769300plt.221.2024.04.02.18.01.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Apr 2024 18:01:22 -0700 (PDT)
Message-ID: <a68d7e70-d82f-4a09-8b9c-db5e902a3663@kernel.dk>
Date: Tue, 2 Apr 2024 19:01:21 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/28] block: Introduce zone write plugging
Content-Language: en-US
To: Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 dm-devel@lists.linux.dev, Mike Snitzer <snitzer@redhat.com>,
 linux-nvme@lists.infradead.org, Keith Busch <kbusch@kernel.org>
References: <20240402123907.512027-1-dlemoal@kernel.org>
 <20240402123907.512027-8-dlemoal@kernel.org> <20240402161213.GB3527@lst.de>
 <e923b1cf-9683-4029-8a39-c66aa8fb2647@kernel.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e923b1cf-9683-4029-8a39-c66aa8fb2647@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/2/24 5:38 PM, Damien Le Moal wrote:
> On 4/3/24 01:12, Christoph Hellwig wrote:
>>> +static inline struct blk_zone_wplug *
>>> +disk_lookup_zone_wplug(struct gendisk *disk, sector_t sector)
>>> +{
>>> +	unsigned int zno = disk_zone_no(disk, sector);
>>> +	unsigned int idx = hash_32(zno, disk->zone_wplugs_hash_bits);
>>> +	struct blk_zone_wplug *zwplug;
>>> +
>>> +	rcu_read_lock();
>>> +	hlist_for_each_entry_rcu(zwplug, &disk->zone_wplugs_hash[idx], node) {
>>> +		if (zwplug->zone_no == zno)
>>> +			goto unlock;
>>> +	}
>>> +	zwplug = NULL;
>>> +
>>> +unlock:
>>> +	rcu_read_unlock();
>>> +	return zwplug;
>>> +}
>>
>> Did we lose an atomic_inc_unless_zero here?  This now just does a lookup
>> under RCU, but nothing to prevent the zwplug from beeing freed?
> 
> Nope. When disk_lookup_zone_wplug() is called directly, it is always
> for handling requests/bios which are holding a reference on the plug
> and because there are requests/BIOs in-flight, the plug is marked as
> busy (BLK_ZONE_WPLUG_PLUGGED or BLK_ZONE_WPLUG_ERROR are set). In such
> state, the plug is always hashed given that
> disk_should_remove_zone_wplug() retturns false for busy plugs. So
> there is no reference increase here. The atomic_inc_not_zero() is in
> disk_get_zone_wplug() which calls disk_lookup_zone_wplug() +
> atomic_inc_not_zero() within an rcu_read_lock()/rcu_read_unlock()
> section.

But doing a lookup under rcu, dropping it, and then returning the unit
without an increment is just a horrible pattern. Regardless of whether
it's safe or not. And as most callers do the atomic_inc anyway, some of
then outside rcu lock, this looks horrible buggy.

Please just unify it all and have it follow the idiomatic rcu lookup
pattern, which is:

rcu_read_lock();
item = lookup();
if (atomic_inc_not_zero(item->ref)) {
	rcu_read_unlock();
	return item;
}

rcu_read_unlock();
return NULL;

as that is well understood, and your code most certainly does not look
safe nor sane in that regard.

And probably kill that atomic_inc() helper you have as well while at it.

-- 
Jens Axboe

