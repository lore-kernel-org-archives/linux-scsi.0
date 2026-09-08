Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F9570808;
	Tue,  8 Sep 2026 00:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788827109; cv=none; b=UtKYuVFV5d76EmWM/ETvSARMbTmRumUFGBpRxEktDBb1GqVu7Ub9VsqyGLeopkb6rLWQHnc+wzxfMsQT1YJOE8aneapZiBpeOsDyo/jaNTQYfI3m4ldyCHDpmWOGned92ZFJ+EAO0UueQo2ee5bIcYN8K/pPyDutOzVSjWRVwA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788827109; c=relaxed/simple;
	bh=lZH+Q7CTiDG/DsbdOqVsQvKyc/UJY6KxwDWrbiIp5lo=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uk8aDiXKddWdnI0MSaWkeZkfKdy4CzNSy4KVDBqYgTkSdWurFsCWQuDrxCubMOcNbB0N4EUyQg+mnsNUius+TgESNsaUabKNRXfxmCngCqwfBFzeF7K0z1BlnX5/n8CT7QeDnoU3GHE32/hdQOjpNj22xpREd0P+dG9tnxT06hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hwEvBz+p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hwEvBz+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA2DB1F00A3A;
	Tue,  8 Sep 2026 00:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788827108;
	bh=ok+vHul/Dy0ksibMeZbclMYrsjflqttaJaACv/Vdb1g=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=hwEvBz+p8QwXumaOV9vLNFq0w28cmrT5M3X4L1pEoDq2C9QYqCW+5Kwob3m6/qpDt
	 hslekFo0+WdRzkpPd1IOa3ekrTB+RT85kUn1UX3gk7LGM6IJzbJHy4zfAlQQx/SOqp
	 P73ac5Hsg5DXqHT+5GkhYU4Avaxqe865MTt5Dc7sOtlm31zp8NFlhNjuCZcTHfx3cO
	 0m6m4rxuPdAtJHQ5m7zJa5eLoIGd3D2ghr8UGbUNxTDUuULIKwOuBCC6Y4zUkmZQvY
	 ZRhKKjaVinxo3ElG827Lrc2dEibeg9PJlJd0weyPqNvoIMUIK3IMjKLSKl/w9F0TnV
	 kh5CZTfmNWjeA==
Message-ID: <3c91259c-dd65-48ad-b537-7e99f20f6ef7@kernel.org>
Date: Tue, 8 Sep 2026 09:24:55 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 38/40] s390: scsi: use 16-bits defined sense codes
To: Hannes Reinecke <hare@suse.de>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260903034201.112211-1-dlemoal@kernel.org>
 <20260903034201.112211-39-dlemoal@kernel.org>
 <7c093d2e-3f16-4e58-9f43-24db27bc2c28@suse.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <7c093d2e-3f16-4e58-9f43-24db27bc2c28@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 9/7/26 22:20, Hannes Reinecke wrote:
> On 9/3/26 5:41 AM, Damien Le Moal wrote:
>> Use the 16-bits sense codes and replace all hard-coded additional sense
>> codes and additional sense code qualifiers with the enum values defined
>> in include/scsi/scsi_sense.h. This helps with code clarity as the sense
>> codes being processed are easier to test and self-documented.
>>
>> No functional change intended.
>>
>> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
>> ---
>>   drivers/s390/scsi/zfcp_scsi.c | 3 ++-
>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>
> Reviewed-by: Hannes Reinecke <hare@kernel.org>

Hannes,

Thanks a lot for the review. But I posted a v5 of the series yesterday... There
are a few minor tweaks in v3, v4 and v5 compared to v2, mostly to address
sashiko review comments. If that is OK with you, I will carry your review tags
to v6 (need one more correction), unless you want to review that version.

-- 
Damien Le Moal
Western Digital Research
