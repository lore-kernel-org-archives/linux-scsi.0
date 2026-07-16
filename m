Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F7B39DBCF;
	Thu, 16 Jul 2026 07:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784186207; cv=none; b=d9jPHRTnyRT+ZslZ9PkXHrpSBJL6LFYcTdnU+UrDf4AIuQLk5TqXDBSzHn/5p0XszydQ+M2yqEAAnocFPD6VVCScK0D6326Rom4mvKWT8WRZDAWkyzbkaC9P1LCSX7ObskWdGOQr/0ljWwB0kdoVMJwmCwSC/1lOHNngVf7pNEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784186207; c=relaxed/simple;
	bh=qlzWM26usHdRpTkJtcrDzllnThZCEQt/L/D2LcjJM0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y0XGRfPIMU857fktshD0vo6HSogTHxse0i2WLE3HolAg3nW9GZimlgmRALq1h1gABlpR765YrLtKI2YSsRVuw3UxTjMSVySnXpkzKbmZpSjLhKMvvp8GMM0Wj01ap2JR95PtzVlxLnDLDuXvAYZMmfPBTjeA1aEaeEIfurZfTBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8IHL2kk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8IHL2kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A35D91F000E9;
	Thu, 16 Jul 2026 07:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784186205;
	bh=VAaYd0xFaj79Ri+1GDZG/6rMCoqUh3VINqqH2E2xRyM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W8IHL2kk96VNrYrFQ/b8TLBYyZOJEYu64cRHqsHcc4Z3cIIjhaH9I1DPQwXIQ9xkf
	 3Zlil7/o5OKRQUlG6nXtcZ1kh7ZRUX+HLtal7lhfcqDRJ0Ys2fKEnSSA6lStiX1yYR
	 Y5yOO1RCXJp/iKSw/24R1qkYt57LmPrlTMWb64h8ReOPvtMDmEzzQIxAQlI3oBss2t
	 jQn86wysx50g+Fn7OIEhNuhARYlqenVf0yYplJRYrFxuH2mKO2EZYa+urd0ZgNIDcG
	 u1fx9VCMFQD2IiVKP4xUA2RcvW4NVF7anQTy7CJk98o1/ICkKSQvFcl1sk4ki/dOnj
	 8FTyF3AV6LfSQ==
Message-ID: <593bac89-9e1f-459f-8e08-2cb9a2dad528@kernel.org>
Date: Thu, 16 Jul 2026 16:16:43 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/2] scsi: libsas: terminate deferred commands on time
 out
To: John Garry <john.g.garry@oracle.com>, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-scsi@vger.kernel.org,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Igor Pylypiv <ipylypiv@google.com>, Jason Yan <yanaijie@huawei.com>
References: <20260715085824.854200-1-dlemoal@kernel.org>
 <20260715085824.854200-3-dlemoal@kernel.org>
 <b2300bba-73dc-4555-ad99-4e440b918a91@oracle.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <b2300bba-73dc-4555-ad99-4e440b918a91@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/16/26 02:37, John Garry wrote:
>> +/*
>> + * Handle deferred QCs in case of a command timeout.
>> + * See ata_scsi_eh_timed_out() for details.
>> + */
>> +enum scsi_timeout_action sas_eh_timed_out(struct scsi_cmnd *cmd)
>> +{
>> +	struct domain_device *dev = NULL;
>> +
>> +	if (cmd)
> 
> Can cmd ever be NULL? AFAICS, the only caller is scsi_timeout() and cmd 
> can never be NULL there.
> 
>> +		dev = cmd_to_domain_dev(cmd);
>> +	if (dev && dev_is_sata(dev))
> 
> furthermore, I don't think that dev can ever be NULL (even from 
> cmd_to_domain_dev())

Good point. Will simplify this.

-- 
Damien Le Moal
Western Digital Research
