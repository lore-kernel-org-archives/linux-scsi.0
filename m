Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8564F1D86F6
	for <linux-scsi@vger.kernel.org>; Tue, 17 Dec 2024 23:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734478506; cv=none; b=i8uc9tsbosWaVFF/JXslQ8lbC00vlUxI4Sl7pAa83tlTgIpbDY/9ekAjBNCkaTv0VJdkFPrILlZjAgBHCMcGmUS3R0NIYRRUcbiwTeYlb/BGgFm7xG6DH3CLrcRb/t2GPY70W5R3ZepBz7asyqH5Ih2n8JP2b6pc06XP9GrYb+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734478506; c=relaxed/simple;
	bh=xH27H6aUlVTkYiXC9FNwbXl/+oCgSc09aaQS2hG+VSc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=adcwlFh6m8s1fihqxchWHhwhyZc8GMUQLs4BFs/a7RW5xNFIUY02xQah69hVQsx+g6ha6kg78GaPRqq1Y7OylHXoadBaEqgSBMrJ28mzb/YU3BgPvdwfqGCYn+JP/KlTzCyQiwuEgXBEnecMj5TkVLRygZJImPigC8qNSZesWPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W3Un2KRk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W3Un2KRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093DCC4CED3;
	Tue, 17 Dec 2024 23:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734478506;
	bh=xH27H6aUlVTkYiXC9FNwbXl/+oCgSc09aaQS2hG+VSc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=W3Un2KRkDi+NZC0yc60tP0+9P9y1YLrMllekPcy/yYUX7p1NsbDxwYIkGtejPjCqe
	 wugreWaq7X5MbO5tgL7xzL07Y5UrqDAfKwrH9djslJZf7G+5UBgjRguZ2aW8TJ1h3A
	 TDws6bAPzf9Zw0pqOO036887E1mVBuNac0+S7r2lzyG7sVovug5GiPxt2xXBoOY/aY
	 rNXK2h1qQDvcTYHrid5yd36v0cXKMY6Nt3xbkhTp+LKJI2T2uDTqpyC5RLTL4r4idA
	 KXP6CQOJ0KTUmKegxA8wUeiU31lpW8vbMcKFAw/7FhyBRY0o4FjecMbMX5ggcN2vu8
	 ZXpDvOTBkEN0A==
Message-ID: <bf927563-5281-476e-a2fd-8b42ecba5530@kernel.org>
Date: Tue, 17 Dec 2024 15:35:05 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: block/032 triggers lockdep complaint with v6.13-rc3
To: Bart Van Assche <bvanassche@acm.org>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <e78b6e21-7b7b-40b1-8a2f-bbcfb4e794f3@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <e78b6e21-7b7b-40b1-8a2f-bbcfb4e794f3@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2024/12/17 14:30, Bart Van Assche wrote:
> Hi,
> 
> If I run test block/032, a lockdep complaint appears. Has anyone else 
> noticed this?

This looks like the same problem Ming found:

https://lore.kernel.org/linux-block/20241216080206.2850773-1-ming.lei@redhat.com/

-- 
Damien Le Moal
Western Digital Research
