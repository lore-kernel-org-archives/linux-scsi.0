Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7D81C84A2;
	Mon, 21 Sep 2026 15:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790004617; cv=none; b=BZxVOmiY/2lpOlX0Z/HQ8HgckJJ9BqIgkZAo11uX7pPGslXfd/9PXLcOfyhpNhq+0ZaT2OXdWJRJzVqXj8Dqo/xrv3lFzdI5QBQcw5iTiuaHihJnzwa78S+osJQWLOmacFphqsu608M8US9SsNQ+IR1drtBZkD/s1WQWam2k2TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790004617; c=relaxed/simple;
	bh=Stt+5wPEyNaEa1MffM6CWybQVjA/ZZweqoM+mx/FheA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=XKmEQZRYiEBRVgrF4LULD+oueKZnw/NtZnt8Ocks66hbki2FZcRlKQEJvX8NM3KBPVTnWIkuGYhKDEQpMbhNwi3NsBG+Egn62h92Hdw4q48Dr4uX2tI2Q6/YJxSapf7ygNUqVP39ZRPM1Q1FO356mzM+5+2tp8WJVePwZ92CgJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NyGnFcSG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NyGnFcSG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5B11F000FF;
	Mon, 21 Sep 2026 15:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790004616;
	bh=wy/zmOHiT9Y0SfSM6t4I4E3vT0zzCbSu/SlDYSnptk4=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=NyGnFcSGkho9ec938s1Y/DesdzlPcQPhX6vd9K6LOQmM1CxpyxjOvZDGl0Rc+Ku0T
	 onHjzC+mmDeE3meZrFqgGsXZTRUEnBZKGdbImkEKP4zKM5nDy4R3Fgmvgc7Hx7sOel
	 H+3LX+mJ0UlnSmkmnYKxN5rJf4jHFzE5upito3jRat8yWEqLXtBx+3lhuTAKS6Xnqs
	 hWUeQsZRyqsyDc99Kn8VJMwQI1S1J/y/uBMkgUZIP8z59X4DsO2mp+87WQAi8FSUsw
	 g8WtaqRMkd9Zrk4tZbo2Ykh3PRrKhfEsAvXRh2kEgkqLj/6SF0Y3i0W7UQvYWMswY0
	 8s3EZXgENjzmA==
Message-ID: <b9bc4c58-c34c-43b0-85bc-45aa0d251f41@kernel.org>
Date: Mon, 21 Sep 2026 17:30:09 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: libfc: fix directory server rport memory leak
From: Krzysztof Kozlowski <krzk@kernel.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Hannes Reinecke <hare@suse.de>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Joe Eykholt <jeykholt@cisco.com>,
 Robert Love <robert.w.love@intel.com>,
 James Bottomley <James.Bottomley@suse.de>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20260919173405.3718408-1-lgs201920130244@gmail.com>
 <arFKHueZaSQAOSbc@quoll>
Content-Language: en-US
Autocrypt: addr=krzk@kernel.org; keydata=
 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
In-Reply-To: <arFKHueZaSQAOSbc@quoll>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/09/2026 17:15, krzk@kernel.org wrote:
> 
> On Sun, 20 Sep 2026 01:34:05 +0800, Guangshuo Li wrote:
>> fc_rport_recv_plogi_req() creates an rport before allocating the frame
>> used for the PLOGI LS_ACC response.
>>
>> fc_rport_create() does not add FC_FID_DIR_SERV rports to the discovery
>> rport list. If fc_frame_alloc() fails while handling a PLOGI from the
>> directory server, the function returns without starting the rport state
>> machine or dropping the initial rport reference.
>>
>> Since the directory server rport is not present in the discovery list,
>> there is no later teardown path that can find the object and release
>> that reference. The allocated fc_rport_priv is therefore leaked.
>>
>> Record when the failed frame allocation leaves an unlisted directory
>> server rport behind and drop its initial reference after releasing the
>> rport mutex. Keep the existing lifetime unchanged for ordinary rports,
>> which remain owned by the discovery list.
>>
>> The issue was identified by a static analysis tool I developed and
>> confirmed by manual review.
>>
>> Fixes: 3ac6f98f4113 ("[SCSI] libfc: correctly handle incoming PLOGI request.")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
>> ---
>>  drivers/scsi/libfc/fc_rport.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
> 
> 
> You sent multiple independent patches, to multiple independent
> subsystems. The amount of these patches clearly suggest this was
> AI generated and most likely not tested.
> 
> More importantly, you sent all this work without properly organizing
> relevant patches into patchsets. This makes reviewing difficult
> and might cause multiple reviewers to address the same issue.
> Replying to the entire set is impossible and requires handling each
> patch independently, instead of applying or discarding the set.
> Maintainers also won't see the bigger picture of your work. Quite
> worrying.
> 
> This is on the verge of hostile patch: bomb us with so many
> contributions, we won't be able to handle them in efficient manner,
> like responding ONCE to ask you to slow down.  Considering all this
> is untested and LLM generated, I have even more doubts whether this
> should be considered for review.
> 
> Please read kernel documentation BEFORE posting more work. It will
> explain you how to identify subsystems, how to organize your work per
> subsystem, how to document usage of LLM and how what you should not
> do if this was posted in a good faith.
> 

Apologies for spamming here. Fighting fire with fire :). No, just mutt
mistake on my side.

Best regards,
Krzysztof
