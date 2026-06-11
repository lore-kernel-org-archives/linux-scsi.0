Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2609B3537CD;
	Thu, 11 Jun 2026 23:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781220858; cv=none; b=A5d6N+LfhhLFfNxrCgiG3l8zJ1SLXTpwVNlKisQ4HkTc8y1pMk3W6mhcwfGr20MQawsi7cw1WwHvoLnVd41mQYAJTZ2ONLFrqfwGzDQsak7JzsLDaq2y2+MJSTCR12hhc7bnWWuVX36Q0udQgGqzfT7fHQ9au3/EqaioF4rso6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781220858; c=relaxed/simple;
	bh=K9EjqlJm5wZmDxJ9dqndu5PvBOsEi4TUXqgUnMU00oo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AynOgOVnY9xHx3yB+SJHJXZQrT66GPsuE4EnYQ4ja+urNzy18JQKG6LDSQeXUh1hC3CL1n1vObO/42EMxVD+ncDiG/D9WW7+v2JtPJY/Oz0XR6yX55uFqnk+QvqKXiEi3Relgf6QyO9BWQS/sqyZ0MsPklRH3BrUVMAcuE2jJeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jE7VweGc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jE7VweGc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BCBD1F000E9;
	Thu, 11 Jun 2026 23:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781220857;
	bh=9Bap6l9i4ZQz5pn/Hk42rWgxj93JiOlztKrjDzdgYHo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jE7VweGcc2A1ga6JUZEIkSRB9X6pyTI0EcO6Y0xVl01ZwP6Fk7aBHatOQO5Wa4vmn
	 hP1DaUNvo/RzTTJZHsBbNcO+/60Gr4JbJSF634L1sOaJP5wioZ7ewXUCbOPO9rtorc
	 td5I4ZGgvyOoHbQ7rxory7liLgDYGHYGOV4iW0DCeLJc+tAUOog+OQaxIUDkt4sCnC
	 K2RLqlTvdXVFYFTp+O8zLh3WtitNwdpCvOGOrHE1cw8WeMEGG/OlMvKHelical6fSW
	 vSWnmwozfbYViUG+8vZzA3oTG62ZanVdx4SoH+A9s/mdlg7XQGD8ApP2sUfx0gzEc5
	 mWxatn4h34KEg==
Message-ID: <fdea1a8b-d631-43d8-bcf0-1c79e635782c@kernel.org>
Date: Fri, 12 Jun 2026 08:34:13 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 RESEND 2/2] scsi: mpt3sas: add hwmon support
To: Louis Sautier <sautier.louis@gmail.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Guenter Roeck <linux@roeck-us.net>, MPT-FusionLinux.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260609164423.2829699-1-sautier.louis@gmail.com>
 <20260609164423.2829699-3-sautier.louis@gmail.com>
 <93542109-2101-4d62-aae4-bbf058029663@kernel.org>
 <airk3Os03wPV0rvW@localhost>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <airk3Os03wPV0rvW@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/12/26 01:39, Louis Sautier wrote:
> On Wed, 10 Jun 2026 08:22:22 +0800, Damien Le Moal wrote:
>>> +config SCSI_MPT3SAS_HWMON
>>> +	bool "LSI MPT Fusion SAS hwmon support"
>>> +	depends on SCSI_MPT3SAS && HWMON
>>> +	depends on !(SCSI_MPT3SAS=y && HWMON=m)
>>> +	help
>>> +	Say Y here to expose the IOC and board temperature sensors of
>>> +	LSI / Broadcom SAS HBAs (such as the 9300, 9400, and 9500 series)
>>> +	through hwmon.
>>
>> Why do you need this ?
> 
> I was following the logic used by NVME_HWMON to prevent issues with
> SCSI_MPT3SAS=y and HWMON=m.

Ah, yes, indeed. I did not thought of this case.

> 
>>> +	struct mpt3sas_hwmon *hwmon;
>>
>> This should be conditionally defined with "#ifdef CONFIG_HWMON". Then you can
>> simply drop the config entry you added.
> 
> If I dropped SCSI_MPT3SAS_HWMON, I would use
> "#if IS_REACHABLE(CONFIG_HWMON)" to match what i915_hwmon.h and
> xe_hwmon.h do and properly handle the SCSI_MPT3SAS=y and HWMON=m case.
> What do you think?

That seems appropriate. If there is a clean way to avoid adding the new config
option, we should use that method.


-- 
Damien Le Moal
Western Digital Research
