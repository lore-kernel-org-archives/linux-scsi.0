Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072E2195B3B
	for <linux-scsi@vger.kernel.org>; Thu,  6 Jun 2024 12:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717676089; cv=none; b=j2vWE5mAPEXahFnc144YFC3yvfUX55JxVqDUbJuIHfP0zkreRhTjMm1f8z8jCLrUM5mifyCFGzau95Tm/1JCxAZb1v7wwYh2hJmYcRzXteAzdk/2NPwyIEqJBbOBcMDadG02SnrbhWPGDE93Mx9OCG/1Y/d8HemXCqWIXukMgVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717676089; c=relaxed/simple;
	bh=GpeAxXQQy0gEWdIDs9kfc2iv6JE3gl9LVaxdBtJKyNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eVPZ0MNcCVOQU8sZKvKRswx7KNyQ8YX5GQXxqidjqx5zpQOmtTui4wvTske4aXAzsNh4vnSfTIqdFqFXs1Evvdtwj7PhfeGBu5pO9LsAuzgK2vCO1UT7lpdqpNYwzWzQkMaONshlKvAQAUUpvSQW4UV9PM8YUAM5TIwkfJW2KRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GjxCk3KE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GjxCk3KE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9924EC4AF08;
	Thu,  6 Jun 2024 12:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717676088;
	bh=GpeAxXQQy0gEWdIDs9kfc2iv6JE3gl9LVaxdBtJKyNM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GjxCk3KEoQH/ZV9nCMiVuUGPZfSijim+qnCZ1msSMNcgVIx6OnT9gTdzyacKF5A73
	 HwG4hLjLCxYdZpV4E5eiTf9HbPVvQzcufnRBJM45H8vPwVmb0d32/ZqTwKEBbrKZ9E
	 NXd/gb3EtQAvQR+43ZXdOFr9B1DtJnQg5Mi19T2YPFG6CHD46pzOlz7Xv1FNAy9AHK
	 uSfkePwJfz3N8pSEeoTtHOU3np3VWyvCTf5qHDg0lSgSMEz9GIej7FtCFLF+JtGyLP
	 Y/J74h89P7xqYwc01a7UoZL1lg7Fg1+TcTrsIH5eQJQ4h1zJVEMGYVLqQc8wZZIzXh
	 pCTXXAxM6igJw==
Message-ID: <a61c0dc6-40f3-4e01-9657-eadbf3a50c99@kernel.org>
Date: Thu, 6 Jun 2024 21:14:46 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: mpi3mr: Fix SATA NCQ priority support
To: Christoph Hellwig <hch@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
References: <20240606054749.55708-1-dlemoal@kernel.org>
 <ZmGB6I1OQ5TZOHAn@infradead.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <ZmGB6I1OQ5TZOHAn@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/6/24 18:31, Christoph Hellwig wrote:
> On Thu, Jun 06, 2024 at 02:47:49PM +0900, Damien Le Moal wrote:
>> The function mpi3mr_qcmd() of the mpi3mr driver is able to indicate to
>> the HBA if a read or write command directed at a SATA device should be
>> executed using NCQ high priority, if the request uses the RT priority
>> class and the user has enabled NCQ priority through sysfs.
>>
>> However, unlike the mpt3sas driver, the mpi3mr driver does not define
>> the sas_ncq_prio_supported and sas_ncq_prio_enable sysfs attributes, so
>> the ncq_prio_enable field of struct mpi3mr_sdev_priv_data is never
>> actually set and NCQ Priority cannot ever be used.
>>
>> Fix this by defining these missing atributes to allow a user to check if
>> a device supports NCQ priority and to enable/disable the use of NCQ
>> priority. To do this, lift the function scsih_ncq_prio_supp() out of the
>> mpt3sas driver and make it the generic scsi device function
>> scsi_ncq_prio_supported(). Nothing in that function is hardware
>> specific, so this function can be used for both the mpt3sas driver and
>> the mpi3mr driver.
> 
> Shouldn't this move into the SAS transport class instead then?
> 
>> +/**
>> + * scsi_ncq_prio_supported - Check for NCQ command priority support
>> + * @sdev: SCSI device
>> + *
>> + * Check if a (SATA) device supports NCQ priority. For non-SATA devices,
>> + * this always return false.
>> + */
>> +bool scsi_ncq_prio_supported(struct scsi_device *sdev)
>> +{
>> +	struct scsi_vpd *vpd;
>> +	bool ncq_prio_supported = false;
>> +
>> +	rcu_read_lock();
>> +	vpd = rcu_dereference(sdev->vpd_pg89);
>> +	if (vpd && vpd->len >= 214)
>> +		ncq_prio_supported = (vpd->data[213] >> 4) & 1;
>> +	rcu_read_unlock();
>> +
>> +	return ncq_prio_supported;
>> +}
>> +EXPORT_SYMBOL_GPL(scsi_ncq_prio_supported);
> 
> This also feels kinda out of place in the core SCSI code and more in
> scope for the SAS transport class, even if the other code can't
> move there for whatever reason.

"also" ? your previous point was not about this function ?

But I think I get it. I will move this to scsi_transport_sas.c and rename it to
sas_ata_ncq_prio_supported().

-- 
Damien Le Moal
Western Digital Research

