Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 145AA20ED;
	Wed, 10 Jun 2026 00:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781050346; cv=none; b=Gu8ZrxU8g6gl20nfNX/peS/hxkU4EvGD8SjHP+lKBrmIRT29qCOxLIThns9BABchKlIgbyqXE4SJZaCTWI8uNaQMsxuQcPg6Yk417pO04psx/5bG7YYFHOEx6+JcpdKjwlX+6B7tSQ++lyTf9LHI3fkU4L8xrAkHr3Z11akbzGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781050346; c=relaxed/simple;
	bh=nUAWGPannloqxsFPiE+8Hz2I7zLcDjiAJao4e/vobD0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GQwrGYtbz2AjOBhzUvF2Jkqg3zRYvNJK9IxRLteksweS2tJLJpsBy/c6TzrlEvR5DMb4KygYi+2UgvvISafmcqwXdn7C6sBAVOrUFvjYe5JYeKMo+ufZrBryxtMb/WrLfMof3seeNwXO2T0BS0NjjNxQMNuNnA9LOGid7okrtz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aW7NNo+e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aW7NNo+e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D941F00893;
	Wed, 10 Jun 2026 00:12:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781050344;
	bh=uAtYpqDNK5brSycLgQonyxM4I0BkARS3Uny+BYBoDaE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aW7NNo+e2EhKUuO3Q+5T8gO2wrP4aIrC1f6sQSgTqqAoBQeoY3pTdc8AsFYSOwRf7
	 kFW/mXfZfNB12lgKOh7fjBMuThHTLNfBB+TPKglOn4SyoT99PpXZg3wHOisEWybfYq
	 bB19Gw0Pj/5Ijg2M0OajNt31tzaMXh56/YMZX1zpbJzmq0e06GZyuYNxqz8Sk11Le1
	 mhxl+eLkxUWHHitQgSW4BBGBw/6Y37ySlVEIcruchEQFHdKDOyeLjH5R72tbriFNT5
	 Mf/u/KsF3UtLHnjFNhr8o/T3/H14rxxLSBho/RM0BE45YtJ7S5dZa2MN33mMZDMYlA
	 B5aoSv0Oeq73Q==
Message-ID: <5effba66-0d42-4d42-9833-f2c0be6874ad@kernel.org>
Date: Wed, 10 Jun 2026 08:12:05 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 RESEND 1/2] scsi: mpt3sas: add IO Unit Page 7 config
 accessor
To: Louis Sautier <sautier.louis@gmail.com>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 Ranjan Kumar <ranjan.kumar@broadcom.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Guenter Roeck <linux@roeck-us.net>, MPT-FusionLinux.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, linux-hwmon@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260609164423.2829699-1-sautier.louis@gmail.com>
 <20260609164423.2829699-2-sautier.louis@gmail.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260609164423.2829699-2-sautier.louis@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/06/10 0:44, Louis Sautier wrote:
> Add mpt3sas_config_get_iounit_pg7(), mirroring the existing iounit
> page accessors. Used by the hwmon driver added in the following patch
> to read the IOC and board temperatures.
> 
> Assisted-by: Claude:claude-opus-4-7
> Signed-off-by: Louis Sautier <sautier.louis@gmail.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.h   |  2 ++
>  drivers/scsi/mpt3sas/mpt3sas_config.c | 36 +++++++++++++++++++++++++++
>  2 files changed, 38 insertions(+)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
> index d4597d058705..c655742d0dde 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.h
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
> @@ -1904,6 +1904,8 @@ int mpt3sas_config_get_iounit_pg3(struct MPT3SAS_ADAPTER *ioc,
>  	Mpi2ConfigReply_t *mpi_reply, Mpi2IOUnitPage3_t *config_page, u16 sz);
>  int mpt3sas_config_set_iounit_pg1(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
>  	*mpi_reply, Mpi2IOUnitPage1_t *config_page);
> +int mpt3sas_config_get_iounit_pg7(struct MPT3SAS_ADAPTER *ioc,
> +	Mpi2ConfigReply_t *mpi_reply, Mpi2IOUnitPage7_t *config_page);
>  int mpt3sas_config_get_iounit_pg8(struct MPT3SAS_ADAPTER *ioc, Mpi2ConfigReply_t
>  	*mpi_reply, Mpi2IOUnitPage8_t *config_page);
>  int mpt3sas_config_get_sas_iounit_pg1(struct MPT3SAS_ADAPTER *ioc,
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_config.c b/drivers/scsi/mpt3sas/mpt3sas_config.c
> index 45ac853e1289..ef07825046bc 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_config.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_config.c
> @@ -991,6 +991,42 @@ mpt3sas_config_get_iounit_pg3(struct MPT3SAS_ADAPTER *ioc,
>  	return r;
>  }
>  
> +/**
> + * mpt3sas_config_get_iounit_pg7 - obtain iounit page 7
> + * @ioc: per adapter object
> + * @mpi_reply: reply mf payload returned from firmware
> + * @config_page: contents of the config page
> + * Context: sleep.
> + *
> + * Return: 0 for success, non-zero for failure.
> + */
> +int
> +mpt3sas_config_get_iounit_pg7(struct MPT3SAS_ADAPTER *ioc,

Please do not break the line after "int"

> +	Mpi2ConfigReply_t *mpi_reply, Mpi2IOUnitPage7_t *config_page)
> +{
> +	Mpi2ConfigRequest_t mpi_request;
> +	int r;
> +
> +	memset(&mpi_request, 0, sizeof(Mpi2ConfigRequest_t));
> +	mpi_request.Function = MPI2_FUNCTION_CONFIG;
> +	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_HEADER;
> +	mpi_request.Header.PageType = MPI2_CONFIG_PAGETYPE_IO_UNIT;
> +	mpi_request.Header.PageNumber = 7;
> +	mpi_request.Header.PageVersion = MPI2_IOUNITPAGE7_PAGEVERSION;
> +	ioc->build_zero_len_sge_mpi(ioc, &mpi_request.PageBufferSGE);
> +	r = _config_request(ioc, &mpi_request, mpi_reply,
> +	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);

	r = _config_request(ioc, &mpi_request, mpi_reply,
			    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, NULL, 0);

is a lot nicer to read.

> +	if (r)
> +		goto out;
> +
> +	mpi_request.Action = MPI2_CONFIG_ACTION_PAGE_READ_CURRENT;
> +	r = _config_request(ioc, &mpi_request, mpi_reply,
> +	    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT, config_page,
> +	    sizeof(*config_page));

Same here, please align the arguments.

	r = _config_request(ioc, &mpi_request, mpi_reply,
			    MPT3_CONFIG_PAGE_DEFAULT_TIMEOUT,
			    config_page, sizeof(*config_page));

With that, looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
