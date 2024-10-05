Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10B5139578
	for <linux-scsi@vger.kernel.org>; Sat,  5 Oct 2024 08:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728116322; cv=none; b=DkEL5uuVYN/kKb9UQrZLxXc2p+1aqkXIYT/r6keSmzD7VzrdP1V3ESlMH+zN/hbvKJo0+sIbW89n8PZbYVNNTX/9l6O0dhBaoY0NaJuMn5441HUiDA/QCeT1oLdMUKUKBWdq/RZCTMheRAmjDP2hdJTVQTBqqZ4obmKVZJqVD+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728116322; c=relaxed/simple;
	bh=ERneIrgLPRtWwRr7jfiUOeI59b33GahU8R7kfdUHHaU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AiUnp3LeG5nt/J4iVcoaL4t9KF+mHHJylre3LezezMW/cCngEvxJs24kkjgsBNenL2kKAU2eSdmqhw+9l7KeV1D3qQ1gllJjbjdXtUeoiFRIUTSsmUO96Brj8P73PXcVMabqoNK2Kcrw8Gu10gtNSahBZzoQOzP7WYdouWGkzbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZUetfGHl; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZUetfGHl"
Message-ID: <21e1b842-7662-46cb-9da7-fe37a3b3119b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728116318;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NMmkCzSXIAM+PLZxbf+a1AidtWBAPGqD1VWOkXNMcPo=;
	b=ZUetfGHlSxiTqLvxg1v3AM+K64bVN20czslKjjbF5TywuBJdYVWyEu54jBenAtlpBhHE+F
	AKa18sJR8W0TwofNKhn89ulvAHbmynuArQ+cJgPHcLIlug7bjNHXXq5xQWfGNqYWCa7fxq
	zonkQB3gbpcaKde/TTazAA8GwkMpP3Y=
Date: Sat, 5 Oct 2024 16:18:06 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: blktests failures with v6.12-rc1 kernel
To: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "nbd@other.debian.org" <nbd@other.debian.org>,
 "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
References: <xpe6bea7rakpyoyfvspvin2dsozjmjtjktpph7rep3h25tv7fb@ooz4cu5z6bq6>
 <e6e6f77b-f5c6-4b1e-8ab2-b492755857f0@acm.org>
 <dvpmtffxeydtpid3gigfmmc2jtp2dws6tx4bc27hqo4dp2adhv@x4oqoa2qzl2l>
 <5cff6598-21f3-4e85-9a06-f3a28380585b@linux.dev>
 <9fe72efb-46b8-4a72-b29c-c60a8c64f88c@acm.org>
 <b60fa0ab-591b-41e8-9fca-399b6a25b6d9@linux.dev>
 <c5c3c7d7-2db9-44fe-a316-b0b5bab30f1e@kernel.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <c5c3c7d7-2db9-44fe-a316-b0b5bab30f1e@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT


在 2024/10/5 9:41, Jens Axboe 写道:
> On 10/4/24 7:26 PM, Zhu Yanjun wrote:
>> ? 2024/10/5 0:31, Bart Van Assche ??:
>>> On 10/4/24 5:40 AM, Zhu Yanjun wrote:
>>>> So I add a jiffies (u64) value into the name.
>>> I don't think that embedding the value of the jiffies counter in the kmem cache names is sufficient to make cache names unique. That sounds like a fragile approach to me.
>> Sorry. I can not get you. Why jiffies counter is not sufficient to
>> make cache names unique? And why is it a fragile approach?
> 1 jiffy is an eternity, what happens if someone calls
> kmem_cache_create() twice in that window?

Got it. Thanks a lot.

Zhu Yanjun

>
>> I read your latest commit. In your commit, the ida is used to make
>> cache names unique. It is a good approach if it can fix this problem.
> That seems over-engineered. Seems to me that either these things should
> share a slab cache (why do they need one each, if they are the same
> sized object?!). And if they really do need one, surely something ala:
>
> static atomic_long_t slab_index;
>
> sprintf(slab_name, "foo-%ld", atomic_inc_return(&slab_index));
>
> would be all you need.
>
-- 
Best Regards,
Yanjun.Zhu

