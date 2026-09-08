Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2596B8635D
	for <linux-scsi@vger.kernel.org>; Tue,  8 Sep 2026 00:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788827423; cv=none; b=XsCQz3ARtigvx5te+f4XT/C/WLtRfvEwDa5TkbcklP7/wbIBWg9v7wIWPkC+xo8kgrEFhAhasisVHSmlxEGu/32BBuC9TT8IWEXQaG/dxmVrZzR5oFrO8B3UW93zcdkIBgAt9+mqv9W/IR96JsHvBvunQNI2w0BUAy/WNPndqD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788827423; c=relaxed/simple;
	bh=sPwhH+CTRjaEzq0eiIcEY00aXu+55+i214qF4zXiTEw=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=OHq73AKpLzwB4CH1NedEix1iinArKZe4MzIjPzgcUnkODOE1BoFmebMJddmkMiyJpF44YL4i4AUeyxkC6TWvAt7ncAX90i9oeghMQLwZQH7JWVlCkbF+xOdQRbohKFIq3mQAT2txCyLNV1xZhktWUAoEVs4k3ILnu6FMOWreSho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NA+PK0PT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NA+PK0PT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F2F41F00A3A;
	Tue,  8 Sep 2026 00:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788827421;
	bh=hyYcVg7m56KQW7YHOSZDAfq+snLGHS/X2ZVp5sJnxgo=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=NA+PK0PTtzcHnF467rUtAL+zPKKDTJk5YuS7zlqzPhJDfELKAmvdf2WVcZ2MBWjX6
	 22ZXCnSJ8nvuU35Mfcb5PwcLYbNGIJCWao8oviCt15MsTk55Zy+vyGo+lkDxNFa9I3
	 cGz9Ocj8WgAtc8PLnCJKj3G+9wWmoH6YvlmnwCXVTkTRFBUgIqYgDg3KUP2P5KvStS
	 iWe44ABjfnOZVGBNdK0/M+80KzGMtRWDF5SsuBZ0Z0EOMF204Xo/8WeCWIxEx1QSBL
	 i3O9lr0SEXScblwzsuqC7E+0Obgz69KFnBhmPrYXaW40cisTOGca1oaX8euf1uSdCU
	 guVEJSpLU5JRQ==
Message-ID: <835e4db9-5be7-4118-94ee-afc412e82a2e@kernel.org>
Date: Tue, 8 Sep 2026 09:30:13 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/40] scsi: define all additional sense codes and
 their qualifiers
To: Bart Van Assche <bart.vanassche@gmail.com>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-2-dlemoal@kernel.org>
 <20260907031437.87FC41F00A3A@smtp.kernel.org>
 <531b5431-dc8d-4708-a67d-0bfcac96e1ea@kernel.org>
 <b7d26272-f53c-4355-a5ca-b6d9fb321599@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <b7d26272-f53c-4355-a5ca-b6d9fb321599@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/8/26 04:59, Bart Van Assche wrote:
> On 9/6/26 8:51 PM, Damien Le Moal wrote:
>> On 9/7/26 12:14, sashiko-bot@kernel.org wrote:
>>> Thank you for your contribution! Sashiko AI review found 1 potential
>>> issue(s) to consider:
>>> - [Low] The newly introduced `scsi_sense_code` enum injects hundreds of
>>> generic, un-prefixed identifiers into the global namespace.
>>> -- 
>>>
>>> commit 483fa6eeda05c51714847f3283212cc3d768cf57
>>> Author: Damien Le Moal <dlemoal@kernel.org>
>>>
>>> scsi: define all additional sense codes and their qualifiers
>>>
>>> Introduce include/scsi/scsi_sense.h to define all existing additional
>>> sense codes and their combinations with additional sense code qualifiers.
>>> The sense key macro definitions in include/scsi/scsi_proto.h are also
>>> moved into this new file, and scsi_sense.h is included in scsi_proto.h.
>>>
>>>> diff --git a/include/scsi/scsi_sense.h b/include/scsi/scsi_sense.h
>>>> new file mode 100644
>>>> index 0000000000000..e668ac1c2302c
>>>> --- /dev/null
>>>> +++ b/include/scsi/scsi_sense.h
>>> [ ... ]
>>>> +enum scsi_sense_code {
>>>> +    ASC(NO_ADDITIONAL_SENSE_INFORMATION,            0x00),
>>>> +    FILEMARK_DETECTED                    = 0x0001,
>>> [ ... ]
>>>> +    ASC(WARNING,                        0x0B),
>>>
>>> [Severity: Low]
>>> Does defining scsi_sense_code this way inject generic, un-prefixed
>>> identifiers like WARNING and WRITE_ERROR into the global namespace?
>>>
>>> Could this cause symbol collisions since scsi_sense.h is widely included
>>> through scsi_proto.h?
>>
>> Martin, James,
>>
>> This is a valid concern which I had when writing scsi_sense.h. But so far,
>> building with allyesconfig/allmodconfig did not great any issue. But I can
>> change these names if you think it is better to avoid issues going forward.
> 
> Hi Damien,
> 
> My opinion is that introducing a new un-prefixed global identifier with
> a name like WARNING is completely unacceptable because it clashes with
> an existing global identifier. Please fix.

Sure, easy to do. But I have not seen any compilation errors. So their is
currently no clash, but indeed, this is at the mercy of any change in included
files. So better safe here and I will rename. Not sure what a good prefix is
though... Maybe SCSI_WARNING ? Or SCSI_SENSE_WARNING ? Any better suggestion?


-- 
Damien Le Moal
Western Digital Research
