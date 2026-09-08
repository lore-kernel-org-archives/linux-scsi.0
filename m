Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D073B2AA;
	Tue,  8 Sep 2026 00:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788826961; cv=none; b=BioDdwqb+DUJYSz5ulL/EBfzvQ7SIw6/tVtpdXOaGEC8fzvRMACRTcOekrVRY3ibgV8UN8vRzBpnl+ORxju0Y1hN8yTzDIS9IU5eev1/r/2J8ZHNINh0D6ivtgEBu5azrGSeMcrc6GqQxXgNBJpWOZtR/1gQg1zfwuWvRvCCMq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788826961; c=relaxed/simple;
	bh=8heCkrRS8LpnKJ0IYc3Rb2LuOI7NmMdLwmJqwzefxFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=MdHl3thi6xENKIeqOg61tb76LDsDsdAxb8II8aG7F2+uyvE7FemsUbm5O4a7d8JlMoPU5bZj5OSiHCaoVmrolamlfYvY2ZUa9mA/20Im1oXurPmQzVjSJAJoiZaPCkdM+EVvoH4/VuzFpTqiPWuR9r/YpG+0CKVwKI66qPAJAFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oYevvtD/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oYevvtD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0ECD1F00A3A;
	Tue,  8 Sep 2026 00:22:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788826960;
	bh=RvG8QobpVOpIY2AUDMH1CnAiz0t3hCS6J97jB2a+l1U=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=oYevvtD/2ZhSH7iI+JM7rf5ngGXrjPkRqIBWSo3zufIn370pZAIP+COzpPcqywRvA
	 DIXZE3SWhVfgtgJAwgdYy8RXZf8j6psUeVYKFVHqWxv+8qnbmID4fvZ3veeCBIv0WZ
	 oGUayJ0ITA9b572zKrYFV9Zk2UlZCbWpNpSn5zis/enYPQ9VWSBLXJiTDsLQlOgC7d
	 E8Q6E0nCsOX8gQ+wnKO6CU7o9otsMLBu2Vji6E4aXqzjFMWizfdklg1c3PZCwVpP7i
	 G7DdIwywp/3pMGP8bGnd+EEEvcAuxZo5i6nLSOJs97EBCtmUh/XVOVrBvRpRhHPHit
	 6g6tDDXyicarQ==
Message-ID: <2d926172-4ae8-458b-a7c3-e870e36e043d@kernel.org>
Date: Tue, 8 Sep 2026 09:22:27 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/40] scsi: prepare for using 16-bits defined sense
 codes
To: Hannes Reinecke <hare@suse.de>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-6-dlemoal@kernel.org>
 <cb08459f-ac72-4f37-b241-b4cc047f4890@suse.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <cb08459f-ac72-4f37-b241-b4cc047f4890@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/7/26 21:16, Hannes Reinecke wrote:
>> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
>> index e321471e8ca2..11910142ac50 100644
>> --- a/include/scsi/scsi_device.h
>> +++ b/include/scsi/scsi_device.h
>> @@ -518,6 +518,7 @@ extern void scsi_sanitize_inquiry_string(unsigned char
>> *s, int len);
>>    * to match any sense key, ASC, and ASCQ value.
>>    */
>>   #define SCMD_FAILURE_SENSE_KEY_ANY    0xff
>> +#define SCMD_FAILURE_SENSE_CODE_ANY    0xffff
>>   #define SCMD_FAILURE_ASC_ANY        0xff
>>   #define SCMD_FAILURE_ASCQ_ANY        0xff
>>   /* Always retry a matching failure. */
>> @@ -526,8 +527,18 @@ extern void scsi_sanitize_inquiry_string(unsigned char
>> *s, int len);
>>   struct scsi_failure {
>>       int result;
>>       u8 sense_key;
>> -    u8 asc;
>> -    u8 ascq;
>> +    union {
>> +        struct {
>> +#if defined(__BIG_ENDIAN)
>> +            u8 asc;
>> +            u8 ascq;
>> +#elif defined(__LITTLE_ENDIAN)
>> +            u8 ascq;
>> +            u8 asc;
>> +#endif
>> +        };
>> +        u16 sense_code;
>> +    };
>>       /*
>>        * Number of times scsi_execute_cmd will retry the failure. It does
>>        * not count for the total_allowed.
> 
> Why do we have two definitions for the sense code header? Can't we combine it
> with the definitions in scsi_common.h ?

This is *not* the sense header. This is the struct used to filter errors for
internal SCSI commands issued with scsi_execute_cmd(). And since that function
is devlared in scsi_device.h, this struct declaration is here too.

> 
>> @@ -537,6 +548,16 @@ struct scsi_failure {
>>       s8 retries;
>>   };
>>   +static inline u8 scsi_failure_asc(const struct scsi_failure *failure)
>> +{
>> +    return scsi_sense_code_asc(failure->sense_code);
>> +}
>> +
>> +static inline u8 scsi_failure_ascq(const struct scsi_failure *failure)
>> +{
>> +    return scsi_sense_code_ascq(failure->sense_code);
>> +}
>> +
>>   struct scsi_failures {
>>       /*
>>        * If a scsi_failure does not have a retry limit setup this limit will
> 
> Cheers,
> 
> Hannes


-- 
Damien Le Moal
Western Digital Research
