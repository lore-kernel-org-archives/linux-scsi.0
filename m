Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE0032938D;
	Thu, 11 Jun 2026 23:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781220743; cv=none; b=SSRZUBhe30CfVnxo8YYCMsk8LqFSBdF48xzR6sSX774cFSx0saZ73ckl1AvlmddgfQI23U8FNyu/YeaS0O+BJK4wBD0V9ACruyR3Fvjf+WpL3yES9yMhVwIHOLqac38L9X7LfDkS+k/7srwvrSnK5ESWnXy+UuVE9f7+yGdDFOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781220743; c=relaxed/simple;
	bh=h+KBinhNiXy2ebHi7hoVnnRYtG1vDCeiSp9x7aGY+as=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i6mzOB4sgKvTyQbk2yA1sfx3nKodFXNCb4D0SE2Tb+C5yTjtV9qSUm7cMN567UvDI+37aVVerT24Ghi3wtljZXhL7M0bc9800zzmX850XoLRRTyP/ntGTUIelpkiMIrJr32JKLtwIAKjb3JroQliSD2fFzuNIDg+purArjwTJIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hk9q+YiF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hk9q+YiF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7D71F000E9;
	Thu, 11 Jun 2026 23:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781220741;
	bh=Cwe5AFKFgyX3A2tnZLz300MxtXADjcDySyH4Nf0UHNA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hk9q+YiFl9Mj5Si0qJD9jsIV+7j5D16drEP6Oba4uNQxjUj+JALutYf3E5ITKDn8c
	 5zrww6ciifnFBq8jh8P+lzWpgbmNVWpM4DnGTIxzlo4yHGuV8qCjJzTs98tWERlpWn
	 F03wCsd6E8D+xkFmHewbWwcpwwn51jRfgjeQoNBAd2Ra0oLBDuTIwGHi/02qk7mSj3
	 wafQy6Ts6LEdVKuCz52FPNiHHO6ZIU7CXfhQhHnoXyWuMnqtIJiXqmxmnMQXu3TBJi
	 00CZXFfTxmF3fdMgDzhBt4AEMFEl+CCXZ+MCmJMlsQ5u1TnZjkMk7t5RFFXpzooeCA
	 24at1Ijyo4QVQ==
Message-ID: <8171d9e5-e347-403a-bc3c-79a89a8e45d3@kernel.org>
Date: Fri, 12 Jun 2026 08:32:17 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 RESEND 1/2] scsi: mpt3sas: add IO Unit Page 7 config
 accessor
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
 <20260609164423.2829699-2-sautier.louis@gmail.com>
 <5effba66-0d42-4d42-9833-f2c0be6874ad@kernel.org>
 <airkbg8-kDC0Gyv9@localhost>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <airkbg8-kDC0Gyv9@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/12/26 01:38, Louis Sautier wrote:
> On Wed, 10 Jun 2026 08:12:05 +0800, Damien Le Moal wrote:
>>> +int
>>> +mpt3sas_config_get_iounit_pg7(struct MPT3SAS_ADAPTER *ioc,
>>
>> Please do not break the line after "int"
> 
> Hi and thanks for the review.
> 
> Sure, I can change this. Can you confirm we want to diverge from the
> convention used by neighbouring functions such as
> mpt3sas_config_get_iounit_pg8?

My comment is based on the standard kernel coding style, which we should follow.

> 
>>> +	Mpi2ConfigReply_t *mpi_reply, Mpi2IOUnitPage7_t *config_page)
>>> +{
>>> +	Mpi2ConfigRequest_t mpi_request;
>>> +	int r;
>>> +
>>> +	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
>>> +	mpi_request.Function = MPI2_FUNCTION_CONFIG;
>>> +	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
>>> +	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_IO_UNIT;
>>> +	mpi_request.Header.PageNumber = 7;
>>> +	mpi_request.Header.PageVersion = MPI2_IOUNITPAGE7_PAGEVERSION;
>>> +	ioc->build_zero_len_sge_mpi(ioc, &mpi_request.PageBufferSGE);
>>> +	r = _config_request(ioc, &mpi_request, mpi_reply,
>>> +	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
>>
>> 	r = _config_request(ioc, &mpi_request, mpi_reply,
>> 			    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);
>>
>> is a lot nicer to read.
> 
> Do I also align the signature like so in both the source file and the
> header?

I think so, as in my opinion, that makes for a nicer reading.

> 
> int mpt3sas_config_get_iounit_pg7(struct MPT3SAS_ADAPTER *ioc,
> 				  Mpi2ConfigReply_t *mpi_reply,
> 				  Mpi2IOUnitPage7_t *config_page)


-- 
Damien Le Moal
Western Digital Research
