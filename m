Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8526140A956
	for <linux-scsi@vger.kernel.org>; Mon,  7 Sep 2026 19:59:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788811190; cv=none; b=lj9nZomZESP85woCpJHCMGxEeP9MeL0dBi5rf5raKW1Z1ETOBAU6Qe2RwxJCd2hF6V5QIypyr2l3cOitQ03KEdRWUwf23DyV9yyDVJdhQpyjRhXk41W7M78cqQNSbqn5ZzUTjBLQg8CT1DEhvH8Q32/wo40uAkfc3KxNmBS+MVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788811190; c=relaxed/simple;
	bh=NPC7mfuNQa4wKK2W4biw2Myu6oR1c1auolmQ5ieBido=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Cnig+2W8bIK/dnaN062pzzAPQluMHC7Njo0oOCU0zdhSznSBtJwjVLroYN25m+Rh34SXBoBbqu4EJGk1Sc7YkPgA8EdiexDRJvd0vd5kriDGJQXJGqk+yQherwhbYlQbDav5RTtKOeFP6KBZxVr3mTBu0ZVTrJbNfhg8tdytEOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WrTEYZTG; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WrTEYZTG"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-382ef647e20so3882366a91.1
        for <linux-scsi@vger.kernel.org>; Mon, 07 Sep 2026 12:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788811189; x=1789415989; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Lx10W/zE4CURTtdkCdixVkF8iJt7dYMZHifzbBJBauc=;
        b=WrTEYZTG3whhX07avoCBG/+Lyl27MCWSlLSnDs0OcTgYZxjjJ11LRwdvibTO16rqid
         ZQ0UJIE7ma/OtI5A54YBl+H5bLo0oeRYFLDo1XQjJtuUVrjurza3ZhOFv2ujTlTcbuNO
         vcAfoZlGkKV2COeEsp6HSc5G64JW7ZH1/1C9VY1f1qb9B2R1F79rmAjIx48fBo/S5nqE
         hC0qt6DE3v9qKlDr98bJQSqMXof+rZKTyX4eRI0ZLfxSaTxH0kTw7zeyPLQzc8x73+Wv
         D+h9Ohw1JVv8ljooLYKTiS0EP58c91scwJJNPSrECAi0SUWYxvENNiKTkoVJCwqksKLb
         T8bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788811189; x=1789415989;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lx10W/zE4CURTtdkCdixVkF8iJt7dYMZHifzbBJBauc=;
        b=K5kHlp+YVe2Nxe5STQGtWrAnFQxGDsMdcm8G+eq8Oqtr2CevnkY5if6hWqcGI2qqQz
         XXN2yuEQtwlQ6fFuTmpnAjq/NLABLU3yGP4+UWiAst6IQwdSlvD892rrOWNqjXU3cenK
         YgiMjsVuvYGi9Z17OwCns0qNKLxC3ie/CUGuFYDNDcHWUadaehyHClz3+xnz/BJ9VJ9u
         HeUPvjYanG98/sdVxklldQfhHUxVrTWKDCTj8dtlLP7FEWlFKhCJQ7Foro+K71mBHNXr
         9KVgUDDoqXTOo79ZUjPx2WFSnAgUFHK0csNY5NGMU4t0pnFMrCVOe8Fo00wV3JGj1HPN
         K4mw==
X-Forwarded-Encrypted: i=1; AKwUvBxpqp1v80yuPO3WNeL5Z64DbpMVm95b8xu4jTkOPJRDUntiowY0DrZe9fV4Jucs4YauAefo3jpB1aLQ@vger.kernel.org
X-Gm-Message-State: AFuF++n/KIjUA/EWAcJKMJgmtVnfsjb8f4xaCN0ylHPdFEqzvSPCTlWg
	OEKk3QFcJdaNW35rszD99gqFu0XnpbvLZ3yrNC+IOCQMxJAbBS8szsNZ
X-Gm-Gg: AYBFou1D6M+GgtImguCaY8jzgLILTvOOINvh3EybiPyE1aF3Z0+a1ZIM3h6UUrU+c70
	GjEs7jayWUWgfUl0OzTk49AZhx6jyHx/hk3+1eB7yB30c4lbImA9qGWm3Z5G8X99WOKNVCGrBLR
	VX4x8GKPeA/hopWPHILkn+nfzCiyxn5qMmLwXPE6p0T1VigmyC3ifEv5llYpSSuCf6Bh0lOEHyJ
	3TfqLNWLtd+o5W0hMSNStPaWU4TU2mJukl/+6AUzJ8Ihqkf/Vcv9fBxFSlooDPtou5jU3YcTQjr
	MziS9qHYsHFsyRCgprxWElzQKNdgyTE/sZsC5BcZ2xtns1c4Z7BrxCFNSxvAFLKqjnuL4pQcaHM
	Qa3Ix/Uv9daa5cLXDZ6ybrLJ/D4rRiLKUmplSWuZRfBSM9pjhT3FjLScQ8mfjzxhHivU+41Fn08
	ZtF+nbY0hAhHtz+/WRlg4XnSICHPb03HT33lTkNjaZHdTwSnS5wmC42lgraOzKq8P5wLxC89XkL
	jaHLaS+2yQ8pmjFH+g6B+L2nKzr7uYARZwxkKzOHl4k2uoEw3P7uPrDEZr1TFSwZSCt1UAKOgal
	qmxnZDVR+fK+
X-Received: by 2002:a17:90a:e7d2:b0:381:1c96:829b with SMTP id 98e67ed59e1d1-39b260d296cmr34499832a91.3.1788811188796;
        Mon, 07 Sep 2026 12:59:48 -0700 (PDT)
Received: from [192.168.51.14] (c-24-6-239-25.hsd1.ca.comcast.net. [24.6.239.25])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3339befe870sm33511217eec.30.2026.09.07.12.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2026 12:59:48 -0700 (PDT)
Message-ID: <b7d26272-f53c-4355-a5ca-b6d9fb321599@gmail.com>
Date: Mon, 7 Sep 2026 12:59:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/40] scsi: define all additional sense codes and
 their qualifiers
To: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 James Bottomley <James.Bottomley@hansenpartnership.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-2-dlemoal@kernel.org>
 <20260907031437.87FC41F00A3A@smtp.kernel.org>
 <531b5431-dc8d-4708-a67d-0bfcac96e1ea@kernel.org>
Content-Language: en-US
From: Bart Van Assche <bart.vanassche@gmail.com>
In-Reply-To: <531b5431-dc8d-4708-a67d-0bfcac96e1ea@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/6/26 8:51 PM, Damien Le Moal wrote:
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
> change these names if you think it is better to avoid issues going forward.

Hi Damien,

My opinion is that introducing a new un-prefixed global identifier with
a name like WARNING is completely unacceptable because it clashes with
an existing global identifier. Please fix.

Thanks,

Bart.
