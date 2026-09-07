Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F961231A23
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 03:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788753556; cv=none; b=DgMAWDHpmt16mNckIfcNUkhigLlvoswA+drs+Uey/DBwrY+GUA176PV15cTCfWWFM6ekLU4cFSFwIeqw8JN2oYYx+BGAYQxh8GsrygXmXtshzdq89W4b3t1sbO3h3/QYLH2ggFe0/7AU7iDqjdPvlhqBeRuRdIic+UIkQRTawmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788753556; c=relaxed/simple;
	bh=QYn6zzZQJ6CR5e51b/bx/JCTm/2zGVFVVOQGLn3WI98=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=IG6s/qk1NGz4ILaR+LK0IPEwBzAvCilI3U/3DT4SqZv5S4e5cjSVkozcrgrl9ujmWrwYxhQmSysibBuMM10qijXUd7f8hLqw719He1z71TN+avbhXYWqMvkDLt0YpB7Shwp1QFvpYLCfcdEzGredwaQxsRSYNu4ADQNs0Cknkic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RKBSZ0zF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RKBSZ0zF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684D91F00A3A;
	Mon,  7 Sep 2026 03:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788753554;
	bh=NjQmowA277SLdzkMD8bZNyr6HfTSO1ROQ4ByobmmI78=;
	h=Date:Subject:From:To:References:In-Reply-To;
	b=RKBSZ0zFI3ulrB8GADUeYkiTFpbPXb9AG+1732YQfRZsLzEQ5tThpYDKNTD1fQvd8
	 pasoBTqgRmxYK2KyXXPvSAoc9XSghz/Wr7A1cNNUXy+Q76Hw0WmisTEVjAYMr0dlp6
	 xb0gzYWqH4Km4R7uV5sWL7mjEyBF6Hxjap0jwbjqy8Iu86xqwux3dz2e6xw87uSdsU
	 ++uBnSCrHCagOfQwxTyRj0GiZPqCz876Vl0FT9v4zFDIvA4jtQe0czaIUMAp0en528
	 dHK/NsTqJBZlcyIRfA3dBgzFtWDKv2WT4HGGbIZ3hGYvEHSAB5+KLHxQ9mrKpHd3a9
	 OPHygDFKbM86w==
Message-ID: <d4a7f2c8-9811-4a5f-a3d9-df26456c4bd6@kernel.org>
Date: Mon, 7 Sep 2026 12:59:12 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/40] scsi: define all additional sense codes and
 their qualifiers
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-2-dlemoal@kernel.org>
 <20260907031437.87FC41F00A3A@smtp.kernel.org>
 <531b5431-dc8d-4708-a67d-0bfcac96e1ea@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <531b5431-dc8d-4708-a67d-0bfcac96e1ea@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/7/26 12:51, Damien Le Moal wrote:
> On 9/7/26 12:14, sashiko-bot@kernel.org wrote:
>> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
>> - [Low] The newly introduced `scsi_sense_code` enum injects hundreds of generic, un-prefixed identifiers into the global namespace.
>> --
>>
>> commit 483fa6eeda05c51714847f3283212cc3d768cf57
>> Author: Damien Le Moal <dlemoal@kernel.org>
>>
>> scsi: define all additional sense codes and their qualifiers
>>
>> Introduce include/scsi/scsi_sense.h to define all existing additional
>> sense codes and their combinations with additional sense code qualifiers.
>> The sense key macro definitions in include/scsi/scsi_proto.h are also
>> moved into this new file, and scsi_sense.h is included in scsi_proto.h.
>>
>>> diff --git a/include/scsi/scsi_sense.h b/include/scsi/scsi_sense.h
>>> new file mode 100644
>>> index 0000000000000..e668ac1c2302c
>>> --- /dev/null
>>> +++ b/include/scsi/scsi_sense.h
>> [ ... ]
>>> +enum scsi_sense_code {
>>> +	ASC(NO_ADDITIONAL_SENSE_INFORMATION,			0x00),
>>> +	FILEMARK_DETECTED					= 0x0001,
>> [ ... ]
>>> +	ASC(WARNING,						0x0B),
>>
>> [Severity: Low]
>> Does defining scsi_sense_code this way inject generic, un-prefixed
>> identifiers like WARNING and WRITE_ERROR into the global namespace?
>>
>> Could this cause symbol collisions since scsi_sense.h is widely included
>> through scsi_proto.h?
> 
> Martin, James,
> 
> This is a valid concern which I had when writing scsi_sense.h. But so far,
> building with allyesconfig/allmodconfig did not great any issue. But I can

s/great/create

> change these names if you think it is better to avoid issues going forward.
> 


-- 
Damien Le Moal
Western Digital Research
