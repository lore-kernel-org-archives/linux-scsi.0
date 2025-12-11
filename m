Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6337267729;
	Thu, 11 Dec 2025 23:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=80.241.56.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765497222; cv=none; b=lt725TrKHAjXOKwh5C3snZApdL+MTGXHsWLe7LQpweSHI4gqQ/jgMfMWhd24USoTg5CrQQtS56f5MxkBE8bDVYalxrz4gCSeck/3Oqd8L7ggUb59/yUZPH5URUKdjk15N7HIjz5YAVSz/d0jpss3QPO552EqoP1WSJDX1XDhO/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765497222; c=relaxed/simple;
	bh=hOdfs+WEfqci97B3SH/qnpDChq0ECuUBByFcaSbF3t0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HpTZwgdrYrI38Yur06H3Y2fObrO88CKU7Wvj4lmd20zySZ1KBKEYhKxfPU0D6oxjHn2yP1ZeT9pxQJ/8QjYUOVNhseaJMioGzl/CBv+PRdboFcrxYmVASdH8zZ4mACa9edpTl4wNDkLllTsKlrPGwfX70flvwXHNrCttw8Hl/MQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com; spf=pass smtp.mailfrom=pankajraghav.com; dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b=kyncJVek; arc=none smtp.client-ip=80.241.56.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pankajraghav.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pankajraghav.com header.i=@pankajraghav.com header.b="kyncJVek"
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4dS8YX5kXcz9tCQ;
	Fri, 12 Dec 2025 00:53:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1765497216;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uXed7TuLkDi/ADOnoI/WKx542ut9oPDV/eIIhHsFN24=;
	b=kyncJVek5sDxnTuC7zyaJgpMbFLUQY1eXiy1h6PYgfR8ne80886LoY+UiyIQ7Kugftc1h6
	9ls7cI5hWYAcLHIrMQWkBik4g9tQ12PbhbhjIvlots5kqR8UNj7WOv+ix/EVGIWKiVeHDk
	hhg7q+c9iDUD0jb68OUVWkaDs4zdJZyPRtQKrrbiFAJVnhh0R7VWUKIPhRtThmQW0XCiLj
	nTvN2FxXS8O9u8eTCWeqjCM26fmKddAcneJdie143WtDtyO8ScUhIcwfujAlm95G7kqq6C
	zCr5Ptn9HjjcHIkZ5MJk8sRacTG3uI4DrV1woOA/NKPwQ5o9geH2RNC9sGy7fw==
Authentication-Results: outgoing_mbo_mout;
	dkim=none;
	spf=pass (outgoing_mbo_mout: domain of kernel@pankajraghav.com designates 2001:67c:2050:b231:465::202 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
Message-ID: <934c62d1-c800-4b31-9774-1e9dfe661877@pankajraghav.com>
Date: Fri, 12 Dec 2025 05:23:24 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] scsi: sd: fix write_same(16/10) to enable sector size
 > PAGE_SIZE
To: Damien Le Moal <dlemoal@kernel.org>, sw.prabhu6@gmail.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org,
 stable@vger.kernel.org, Swarna Prabhu <s.prabhu@samsung.com>,
 Pankaj Raghav <p.raghav@samsung.com>
References: <20251210014136.2549405-1-sw.prabhu6@gmail.com>
 <20251210014136.2549405-3-sw.prabhu6@gmail.com>
 <0b3458ab-e419-4ec2-9cba-eb9fd2cd8de9@kernel.org>
Content-Language: en-US
From: Pankaj Raghav <kernel@pankajraghav.com>
In-Reply-To: <0b3458ab-e419-4ec2-9cba-eb9fd2cd8de9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4dS8YX5kXcz9tCQ


On 12/10/25 07:22, Damien Le Moal wrote:
> On 2025/12/09 17:41, sw.prabhu6@gmail.com wrote:
>> From: Swarna Prabhu <sw.prabhu6@gmail.com>
>>
>> The WRITE SAME(16) and WRITE SAME(10) scsi commands uses
>> a page from a dedicated mempool('sd_page_pool') for its
>> payload. This pool was initialized to allocate single
>> pages, which was sufficient as long as the device sector
>> size did not exceed the PAGE_SIZE.
>>
>> Given that block layer now supports block size upto
>> 64K ie beyond PAGE_SIZE, adapt sd_set_special_bvec()
>> to accommodate that.
>>
>> With the above fix, enable sector sizes > PAGE_SIZE in
>> scsi sd driver.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
>> Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
>> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
>> ---
>> Note: We are allocating pages of order aligned to 
>> BLK_MAX_BLOCK_SIZE for the mempool page allocator
>> 'sd_page_pool' all the time. This is because we only
>> know that a bigger sector size device is attached at
>> sd_probe and it might be too late to reallocate mempool
>> with order >0.
> 
> That is a lot heavier on the memory for the vast majority of devices which are
> 512B or 4K block size... It may be better to have the special "large block"
> mempool attached to the scsi disk struct and keep the default single page
> mempool for all other regular devices.
> 

We had the same feeling as well and we mentioned it in the 1st RFC.

But when will you initialize the mempool for the large block devices? I don't think it
makes sense to unconditionally initialize it in init_sd.
Do we do it during the sd_probe() when we first encounter a large block device? That way
we may not waste any memory if no large block devices are attached.

--
Pankaj

