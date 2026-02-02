Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C92E56A;
	Mon,  2 Feb 2026 01:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769996821; cv=none; b=ivEIdowocqh2MaargU5WVInQrzreAsoNX9T3b+snICSAAae2IxAC5yFkqrcrRGw5q8qLqFgwbcSs7tslqBJgTddOdUHJAZ7slX100TKFMAc965/Aqz73+rKjgfd/dM2C+sezhtTERsTjQlfqZieiLnAn6jGNOoBXC+06V/kPb2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769996821; c=relaxed/simple;
	bh=0/3pjykQsnTR/y7MV3u3BDMrzVNSc7rmtHUVn0Qtg1s=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=BSX54APByNBh3q6FUrcLNsY2YSxIPa7UfQiFzj9lP2ltMnctTigbu0/iWgBYtwHHgr2+qXKI25kI1RWqbwGXNM4El9lW1zJO2Jc9aCFDXj0yblW515w91koUJoD8Usa7dthGwby4G/G5/jF89ywlw1br34UzdQdF8Ly16pP7jjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ohx65ajZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ohx65ajZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DEFFC4CEF7;
	Mon,  2 Feb 2026 01:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769996820;
	bh=0/3pjykQsnTR/y7MV3u3BDMrzVNSc7rmtHUVn0Qtg1s=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=Ohx65ajZCiPR/9HpFPxUYwBSYiDnYA7BqcQ6PIYIJwul+l2YzC3H2PIsvDx8auaY2
	 vrg/5fve4z1mQItOcAR0Cd6jLap0ffTPzEKtBZwQHHEY+oyNNuk1pJz2hZXED+6/1D
	 ponSlkvjbdlky7KODhL7sfspBTjbeetx5W/99URYka380rG11Qtv3Zu4MiCyyJHRfq
	 +IwPpF+iTeZ3X8fmznTnM7rykODIHPLQ2WIXWYnyhJfO4wvD2KDEn+ncx6pqNK9KZf
	 pLsUVtbAM+eRj/USJipEzeCNMV67crwtSf/CDapnNw5iZHrfiBIrfQ4P2jpxpJ/AXC
	 mhgkdC5XkubvA==
Message-ID: <5f15b257-23b4-43a2-926b-9c9a9becff6e@kernel.org>
Date: Mon, 2 Feb 2026 10:46:58 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Damien Le Moal <dlemoal@kernel.org>
Subject: Re: [PATCH] scsi: libsas: Fix dev_list race conditions with proper
 locking
To: Chaohai Chen <wdhh6@aliyun.com>, Jason Yan <yanaijie@huawei.com>
Cc: john.g.garry@oracle.com, James.Bottomley@hansenpartnership.com,
 martin.petersen@oracle.com, johannes.thumshirn@wdc.com, mingo@kernel.org,
 cassel@kernel.org, tglx@kernel.org, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260129093859.1418749-1-wdhh6@aliyun.com>
 <e59ff23b-81d3-41b7-ac25-ab886a3379bf@huawei.com>
 <aX3dpqtLmgNVaQEg@LAPTOP-RK2E6KJ3.localdomain>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <aX3dpqtLmgNVaQEg@LAPTOP-RK2E6KJ3.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 1/31/26 19:47, Chaohai Chen wrote:
> On Fri, Jan 30, 2026 at 04:27:11PM +0800, Jason Yan wrote:
>> Hi,
>>
>> 在 2026/1/29 17:38, Chaohai Chen 写道:
>>> Multiple functions in libsas were accessing port->dev_list without
>>> proper locking, leading to potential race conditions that could cause:
>>> - Use-after-free when devices are removed during list traversal
>>> - List corruption from concurrent modifications
>>> - System crashes from accessing freed memory
>>
>> libsas events are processed in orderd workqueue. Do you have a crash log?
> No crash log. I noticed the missing locks while watching the code. But
> there are tow queues, event_q and disco_q which may cause conflicts.
> And I think the dev_ist_lock is designed to prevent conflicts.

I am not so sure this is true in general. E.g. when sas_suspend_devices() is
called form a disco_q work context, events are disabled, so there cannot be
changes to a port dev_list.

If you have no crash log, please provide a more detailed analysis of the
potential problems. Given that no one has reported an issue in this area (that I
know of), if there is a problem, it is definitely not obvious and thus requires
detailed explanation to be understood.

-- 
Damien Le Moal
Western Digital Research
