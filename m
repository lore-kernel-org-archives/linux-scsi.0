Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B288158540
	for <linux-scsi@vger.kernel.org>; Mon, 19 Aug 2024 23:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724109322; cv=none; b=KnzcbkZWO9sodTmTVWsP8DlQH3ofJU4/xAyebTTjDYsNsjIBEwdeCu9L0HBh0WLP0GkpOB2eBR/nxxwKhbzcat0T4veSHlfgrNTSFgm0oNWN9trJiRBzJTwSaI7V4jDJIrT0I1o7bWt0UzViftTc7guzUVtNeifaFzLZda1Bx0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724109322; c=relaxed/simple;
	bh=vmhVR2PgEqexpBNeakpqNcnmtE9AOxNMBloSw8kz6e8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oRr4Sd7MrsbWuUsNqd8OAXSIBR6rplcFBX6rsBz72QqTQbKqlJFfiaHat9XKb6gb8g1S9m6tWFeOYqTt+q6i/zlyiLaUyMQuInvwVdNGvp5SKq3vtOHMWNcPzMssI/yCw2QLWDW3Mmj298jTVsoDp+xvz74a/APivJ1qOBvkM2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SEe1k1Wf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SEe1k1Wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB14C32782;
	Mon, 19 Aug 2024 23:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724109321;
	bh=vmhVR2PgEqexpBNeakpqNcnmtE9AOxNMBloSw8kz6e8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SEe1k1WfvgsXm9B+3U+i/KOPXhdIc+g3t+/uAYGLFBAlVGUbbTIvY3oUL3kgEQLLh
	 qXD6FLS0f9rQjEzPYVrp0qId0zUhVX/ydmsO5LyBcdlYmLWvD5M//ybeSS7Xkwojkc
	 ndb6jXmV+rILmk6Rh2wGL80wrQyHeDu0V0CNb+EG6QDmglOWYpas2BweBRXv8Dz0nv
	 N1LPqjaxQGaVXwirYK9zZf8uFmyRXRr6CbBoBiBoExFrwSrWunVZkUCa1dzYSKxfBn
	 /XgqPlNzMpbmZyS/vADgZu7TQR1wwoieagQfg5A7EVEC/MaI/T8qxwJqtShdJB8DXe
	 9o8A4bZFv0zBQ==
Message-ID: <4220a817-592f-4bba-ab80-64993968f605@kernel.org>
Date: Tue, 20 Aug 2024 08:15:19 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/18] scsi: Expand all create*_workqueue() invocations
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
References: <20240816215605.36240-1-bvanassche@acm.org>
 <20240816215605.36240-2-bvanassche@acm.org>
 <686d0650-f5c9-4c86-9900-ba980baecb00@kernel.org>
 <bd0ad5fc-bf76-423a-b734-bc306b2edc45@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <bd0ad5fc-bf76-423a-b734-bc306b2edc45@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/20/24 02:17, Bart Van Assche wrote:
> On 8/18/24 4:25 PM, Damien Le Moal wrote:
>> On 8/17/24 06:55, Bart Van Assche wrote:
>>> diff --git a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>>> index 1078c20c5ef6..f49783b89d04 100644
>>> --- a/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>>> +++ b/drivers/scsi/bnx2fc/bnx2fc_fcoe.c
>>> @@ -2363,8 +2363,8 @@ static int _bnx2fc_create(struct net_device *netdev,
>>>   	interface->vlan_id = vlan_id;
>>>   	interface->tm_timeout = BNX2FC_TM_TIMEOUT;
>>>   
>>> -	interface->timer_work_queue =
>>> -			create_singlethread_workqueue("bnx2fc_timer_wq");
>>> +	interface->timer_work_queue = alloc_ordered_workqueue(
>>> +		"%s", WQ_MEM_RECLAIM, "bnx2fc_timer_wq");
>>
>> Very odd line split. And there are a few more like this one. Maybe your patch
>> needs some manual tuning after running the script ?
>>
>> The patch overall looks good to me, but it would be nice to have consistency in
>> the line splitting. Personnally, I prefer the pattern such as:
>>
>> -	kmpath_rdacd = create_singlethread_workqueue("kmpath_rdacd");
>> +	kmpath_rdacd =
>> +		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, "kmpath_rdacd");
>>
>> instead of:
>>
>> -	lio_wq = create_singlethread_workqueue("efct_lio_worker");
>> +	lio_wq = alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
>> +					 "efct_lio_worker");
>>
>> Though I guess that is a matter of taste :)
> 
> (reduced cc-list)
> 
> If I run "git clang-format HEAD^" on this patch, no code is changed. 
> Does this perhaps mean that the .clang-format style file in the kernel
> tree needs further tuning? The most recent change in that file other
> than adding for-each macro names is from two years ago (see also commit 
> 781121a7f6d1 ("clang-format: Fix space after for_each macros")). Or does
> this perhaps mean that there is broad agreement about the coding style
> parameters in the .clang-format file?

As I said, most likely a matter of taste :)
The pattern:

	lio_wq = alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM,
					 "efct_lio_worker");

follows the regular kernel coding style.
I only meant to say that I find the pattern:

	lio_wq =
		alloc_ordered_workqueue("%s", WQ_MEM_RECLAIM, "efct_lio_worker");

more pleasing visually. But the line may be too long anyway...

> 
> Thanks,
> 
> Bart.
> 
> 

-- 
Damien Le Moal
Western Digital Research

