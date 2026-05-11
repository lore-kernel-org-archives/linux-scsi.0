Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA35F2C11E6;
	Mon, 11 May 2026 21:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778536455; cv=none; b=c5HzpyTd05ijEVWRp77+c0jjLn3ErTzJc+hPhRmY/2gYU+pCBjVYGK5G4ssdFbLz8tXrjWovMbxhj3Zb9oBzBUkf4cdPFPxVOLyWivjf9FOWc8sQpncklh9ffitrZ5yZmm5jOz/WqQnTqrC9MTwGzP11qXNL4rOlFKpxOmnRBJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778536455; c=relaxed/simple;
	bh=RomqOVCJ74bU+jz8D6wGQX7OqLfegoqSF+qw3sa8MCk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XZIDkpzLa7SYsD4X+vU4MOxBYp8GfpKwnFxDPOvN1Qp5N9mNmiwDLtfXxSH7XUR6ciVle0zzNLDOAjfdxHj+k0R8/GBzZe++gSeZJ1fbzTaadrde9LfCfqOUZCB7MnIgqgMiGYcuidKLyg0Ry3BXuXo13d/QEUJu604ljQWmrJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Us4oqDCG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Us4oqDCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB72CC2BCB0;
	Mon, 11 May 2026 21:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778536455;
	bh=RomqOVCJ74bU+jz8D6wGQX7OqLfegoqSF+qw3sa8MCk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Us4oqDCGnv65A5+Y7h5uCsUqyxPpZSgNVDTcHgk4KiVvJ8T/1H4NeZZR3Hn7INP1O
	 bSkUM4sPXjLamRNTYLrMUHUI6LH09zegpOT6z92a+mM/1PJOxyL7k/PQ9qrerWwHJo
	 I46d0tXzHeEozot3Mbwy0eG6gMXhE9IQlxQBgnHMLB3zmJVHS0Zhmuk/rKIUFL50o6
	 Q1sMZFAAQHpIrZI7rVHszB0izhJSl12+0kcPzIJbvReDaxu2Tk66FwRbXx4wc+FmSW
	 Zqv/sv8raTJJvtlgB5Mqirccae4f53qzzMk35U5wCl1mvzCIN6gMcbUuZyy7EPrd0L
	 ZkXldJTNemaDQ==
Message-ID: <1436af33-87d8-4070-ae67-a6a290fc0240@kernel.org>
Date: Tue, 12 May 2026 06:54:11 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 7/7] scsi: scsi_devinfo: extend BLIST_NO_LUN_1F to
 MATSHITA and NEC PD-1 variants
To: Hannes Reinecke <hare@suse.de>, Phil Pemberton <philpem@philpem.me.uk>,
 linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Niklas Cassel <cassel@kernel.org>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260426190920.2051289-1-philpem@philpem.me.uk>
 <20260426190920.2051289-8-philpem@philpem.me.uk>
 <c1db6016-9b7d-454b-a4a8-c8f61391c5ae@suse.de>
 <566ea0c5-3d8b-4ce4-8d42-e97ecabe5f9d@philpem.me.uk>
 <ea4de81e-4c9b-48d0-bc6d-72f23c7fc831@suse.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <ea4de81e-4c9b-48d0-bc6d-72f23c7fc831@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/8/26 15:02, Hannes Reinecke wrote:
>> Only that these are optional to the feature work and untested as I don't 
>> have hardware. I believe these drives use the same PD-1 mechanism and 
>> firmware so should behave the same, but I can't prove it.
>>
>> The intent was to allow the 1-6 set to be merged (as these are tested) 
>> without 7/7 (which is not) to minimise the risk of regressions.
>>
> So drop it, then.
> We can always add it later once someone shows up who actually has the 
> hardware.

I agreee, let's drop this one and patch only once it can be confirmed that the
change is needed.

-- 
Damien Le Moal
Western Digital Research
