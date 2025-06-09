Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1532D4C8E
	for <linux-scsi@vger.kernel.org>; Mon,  9 Jun 2025 07:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749453480; cv=none; b=LNQo8RRfKKiX7WgKdZ78CKfdHYz6s+iLvM3nlEfsyHSlly12YJSJKutLwLPnQvcmEusPR2LA/HfMlxpbv6ruJ9VA7qyUlU9hILQexEeT5pDmIIZSFroULSnZvx8rhp4FnqyhhT2rSgGNkbRSafKdLT1hYXMi3al0Q/I0mvoY1AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749453480; c=relaxed/simple;
	bh=a1SDk8IZj36dqy4cRm8fQlN5eZCxDPTzypSufqNRE68=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M6UzOp6jta8S3OGRDIHhmGazgx4YIq/pxXSnDF5hoqjYReKSkWh9JAvt9pHp6CNguno3jk5PtnWRjtM9t++20WXkZFYjH0gAsLOvfw3wcKrTuoKIn0TMxhoguVAyTM0/MBUy4KWA69SyM979m9X7j2Mi4mDUjBpetxTEs/+NZxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ntlYQmOB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ntlYQmOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B33BC4CEEB;
	Mon,  9 Jun 2025 07:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749453479;
	bh=a1SDk8IZj36dqy4cRm8fQlN5eZCxDPTzypSufqNRE68=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ntlYQmOBqVXb/qUHfvfG7BnGPMJUJ5J41x8/piq66lRDVSawKJMoryZtx41ALsT84
	 vrBytcxjM+42n330Qfk51Xws4wrUM/xtvqIE/L1r50XJsQ4U9MEpsd6Bm/1+7qH3U7
	 2RbM6DGp0GjtrnzLKFVKeO3jyYmjSMb0TZ+bTOwTTnOwclkXaGumlgul5lPBTsvpFG
	 D/PDso8lipyJdMZxHjk0qT3bbcNAio5gp6VKuo2BJwm5+sQ2cBFtWshjaJcel/uamU
	 uuzwfeLSKGZA8CuokkTA+WsD64IsXou3jGZkt7bnfP/LtFYeEMPlwL1vA0U86QyIox
	 sIQE8F0Ppf+3w==
Message-ID: <a177a03c-5545-4211-a401-da15722c2e65@kernel.org>
Date: Mon, 9 Jun 2025 16:17:57 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Improve ATA NCQ command error in mpt3sas and mpi3mr
To: Yafang Shao <laoar.shao@gmail.com>, Christoph Hellwig <hch@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 mpi3mr-linuxdrv.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
References: <20250606052747.742998-1-dlemoal@kernel.org>
 <aEZ2C93sEiFRzGEE@infradead.org>
 <CALOAHbDmSjaBjG7-yTm4FOxwY-mhR0ea610ZyTb-TPzLZOu2Lw@mail.gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <CALOAHbDmSjaBjG7-yTm4FOxwY-mhR0ea610ZyTb-TPzLZOu2Lw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 6/9/25 16:09, Yafang Shao wrote:
> On Mon, Jun 9, 2025 at 1:50 PM Christoph Hellwig <hch@infradead.org> wrote:
>>
>> Adding Yafang Shao <laoar.shao@gmail.com>, who has a test case, which
>> I think promted this.

Note that cdl-tools test suite has many test cases that do not pass without the
mpi3mr patch. CDL makes it easy to trigger the issue.

> 
> Thank you for the information and for addressing this so quickly!
> 
>>
>> Yafang, can you check if this makes the writeback errors you're seeing
>> go away?
> 
> I’m happy to test the fix and will share the results as soon as I have them.

Thanks. And my apologies for forgetting to CC you on these patches.


-- 
Damien Le Moal
Western Digital Research
