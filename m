Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B693093C1;
	Thu, 17 Sep 2026 03:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789614869; cv=none; b=ouBUwHP/ogSHII4qFAwF8TXXrvjAmPJCMePP2GvN3wgjkWMi5Za7YpOyYwIwo+QSc3LMDejAqr1ewFCdBBJSiJa+ylEtqUPa4k8neMD8b1Hh/ucwUqMmOUpoh5SbF7alWt8Kyg39HjGOVEZGauWdyMOK2wvvl7Q6dmOFjsHlenY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789614869; c=relaxed/simple;
	bh=VEdmEHU4HRcFLiSrkc2qsVN8mU3sz6fIJalnefhVTs8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aJgOqa4TpOYYHQz4+/CxinFmuYNGqv1lsOKHQYaqdmIjL+PXKuwvCXLd/K7RJJR9CdZQ0tCbzQHyxbRx+fGkqgVXZPHdbxXMF4cHpM1JKclFh+HO7M/SfTbHZcW96ReViqmM/CR2OgDTBOS8Fjf7gIjSAmku4aD1nrkThpgOLWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dd7KyGlP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dd7KyGlP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36041F000FF;
	Thu, 17 Sep 2026 03:14:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789614868;
	bh=cIZz2g8Pz+PxuDxpdtRY73qiC4kxknpNb+WL0xDIPYU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Dd7KyGlPaqCchTDzmDg4Fv2fL8zWmddUEFrPpesp5b3684t0Oox1e7rZ4iT9K/c31
	 zAy7sx94VHWO1a3XTYo7xGRVLIWb2mwHN4lTHCwWN94nz8V2/m0Vn7PlsodrHnPYgx
	 M13jk+udCl9YWbLL5Jt/5l6OdX+ddNtlHp+NJEuOl+6NvWKqIhYqb7LkWP12um39g7
	 gjWdZl+LxlUTwD1jQHEONoTO95OulZKSffNqtd5dBmmJkmchzx9LYSZuf2XY1f55vI
	 /rFsvFX0L4NW3j75R2eDu51SXcEUoNo1jhQUQfpdSawwrXXGac4hVEkUY2ZivU4rSc
	 pJxVqqjCusEKg==
Message-ID: <f3ab4b89-627d-4711-84b0-85b887256ccf@kernel.org>
Date: Thu, 17 Sep 2026 10:14:24 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/37] scsi: st: use 16-bits defined sense codes
To: Laurence Oberman <loberman@redhat.com>, sashiko-reviews@lists.linux.dev
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org
References: <20260831020451.585944-1-dlemoal@kernel.org>
 <20260831020451.585944-13-dlemoal@kernel.org>
 <20260831021927.90FD21F00A3D@smtp.kernel.org>
 <2ff511fa29b801ab74ce9ee60e1257c47918c1db.camel@redhat.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <2ff511fa29b801ab74ce9ee60e1257c47918c1db.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 2026/09/16 22:29, Laurence Oberman wrote:
> On Mon, 2026-08-31 at 02:19 +0000, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential
>> issue(s) to consider:
>> - [Medium] Incorrectly assigning ASC value to ASCQ in SCSI
>> tracepoint.
>> --
>>
>> commit c1f7c0aa9501c3562bd45de8a85431d940fa338b
>> Author: Damien Le Moal <dlemoal@kernel.org>
>> Subject: scsi: st: use 16-bits defined sense codes
>>
>> This commit refactors the SCSI tape driver to use the 16-bit
>> sense_code
>> field of struct scsi_sense_hdr. It replaces hard-coded additional
>> sense
>> codes and qualifiers with enum values defined in
>> include/scsi/scsi_sense.h
>> to improve code clarity.
>>
>> While reviewing this patch series, I noticed an issue introduced in
>> the
>> related change to include/trace/events/scsi.h:
>>
>>> diff --git a/include/trace/events/scsi.h
>>> b/include/trace/events/scsi.h
>>> --- a/include/trace/events/scsi.h
>>> +++ b/include/trace/events/scsi.h
>>> @@ -303,8 +303,8 @@
>>> DECLARE_EVENT_CLASS(scsi_cmd_done_timeout_template,
>>>  		if (cmd->sense_buffer && SCSI_SENSE_VALID(cmd) &&
>>>  		    scsi_command_normalize_sense(cmd, &sshdr)) {
>>>  			__entry->sense_key = sshdr.sense_key;
>>> -			__entry->asc = sshdr.asc;
>>> -			__entry->ascq = sshdr.ascq;
>>> +			__entry->asc = scsi_sense_asc(&sshdr);
>>> +			__entry->ascq = scsi_sense_asc(&sshdr); <-
>>> --- here
>>                                         ^^^^^^^^^^^^^^
>>
>> [Severity: Medium]
>> Is there a typo in this assignment?
>>
>> In the scsi_cmd_done_timeout_template tracepoint, __entry->ascq is
>> being
>> assigned scsi_sense_asc(&sshdr) instead of the ASCQ value. This
>> appears to
>> log the Additional Sense Code for both the asc and ascq fields, which
>> will
>> result in lost diagnostic data when userspace tools analyze SCSI
>> errors via
>> tracepoints.
>>
>> Should this use scsi_sense_ascq(&sshdr) for the ascq field instead?
> 
> Hello Damien
> This seems to be real issue here that sashiko found
> 
> We assign the same for __entry->ascq  as we do for __entry->asc i.e.
> scsi_sense_asc(&sshdr)
> 
> We need to have it as
> 
> +			__entry->asc = scsi_sense_asc(&sshdr);
> +			__entry->ascq = scsi_sense_ascq(&sshdr); <--
> 
> Otherwise we will miss the ASCQ

Yes. That was fixed in later versions. The series that Martin queued up has this
fix :)



-- 
Damien Le Moal
Western Digital Research
