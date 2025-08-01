Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703824207F
	for <linux-scsi@vger.kernel.org>; Fri,  1 Aug 2025 01:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754011733; cv=none; b=kf7hO6JFRE5PVDnKkc4/6u/+80qlLwYq3+eGicFBlefQ+VoD3eO1nRRtutyqj9rSsAzB0UxLe84r81Lh987ZSAgOLkmf54E+MZaReScYMdW9pqbo8+vhyIvApcUlj8DVd02luPzgjIuuN3xxUqzipOvFXtRvrPIqSmolxX5XhNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754011733; c=relaxed/simple;
	bh=poeYCw2mdcsNQYn12cgcXoGgIf1RDzaaCq+qqucTmes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lRE3b6NqBngoXuMgy58TxTHLsFkrDRTfSc8wZ7xKDcb+YFyeHmy4j1eg73vEwL/5zNzoz/ZJYRK0aP3zZ0DXZq7SL8NUsJiOpdK0NVen8yHJwaHkBl7kzZhNupH8elj0Vx3lhRe81IKK/m+FToPujZfd/K4wNdO/I6Axl9DWtNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JxT6qDsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JxT6qDsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CE7C4CEEF;
	Fri,  1 Aug 2025 01:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754011732;
	bh=poeYCw2mdcsNQYn12cgcXoGgIf1RDzaaCq+qqucTmes=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JxT6qDsYyOS6/7JOzuT7TSzMW8p34jfDb3ysjMir4rOX8LsuBZ0d28qfBi120EYnM
	 WdTn6PaaC598LBewoSE734gBVfabV69Ueh7ZwtMmNpg4Sa7iLjgZ3SGzGW6EDuZY5r
	 2/U9Act8G7PIMFUlroYkyuIhgU6j/pVZt//TpOEm4UwAJh2V+eFRt0whVwYuBU24rT
	 Zn0qHX1+Jj1pjVvmkYAC9LwgO6FXR0zt+qBDwoWHEr7c6Z/CbVF+mF/GWhKcxwYFyc
	 ym6G/nI2lzkRkXCP06Jh925C/abBSaRy20QvETYPhY5DJvrB+GwgDiv7WDJfMCYxyS
	 BQtF8rq0c9FNg==
Message-ID: <058aa1ec-3243-4063-90d0-278c870accca@kernel.org>
Date: Fri, 1 Aug 2025 10:28:50 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mpt3sas: Set DMA_BIDIRECTIONAL for additional SCSI
 commands
To: Ranjan Kumar <ranjan.kumar@broadcom.com>, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com, Christoph Hellwig <hch@lst.de>
References: <20250721110546.100355-1-ranjan.kumar@broadcom.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250721110546.100355-1-ranjan.kumar@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/21/25 20:05, Ranjan Kumar wrote:
> Extend DMA direction override to handle additional SCSI commands
> (SECURITY_PROTOCOL_IN, SERVICE_ACTION_IN_16 with RELEASE) that
> require bidirectional DMA mapping, in addition to ZBC REPORT_ZONES.
> This avoids issues on platforms that perform strict DMA checks.
> 
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index bd3efa5b46c7..8aec475fc7a4 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -2686,8 +2686,22 @@ static inline int _base_scsi_dma_map(struct scsi_cmnd *cmd)
>  	 * (e.g. AMD hosts). Avoid such issue by making the report zones buffer
>  	 * mapping bi-directional.
>  	 */
> -	if (cmd->cmnd[0] == ZBC_IN && cmd->cmnd[1] == ZI_REPORT_ZONES)
> -		cmd->sc_data_direction = DMA_BIDIRECTIONAL;
> +
> +		switch (cmd->cmnd[0]) {
> +		case SECURITY_PROTOCOL_IN:
> +			cmd->sc_data_direction = DMA_BIDIRECTIONAL;
> +			break;
> +		case ZBC_IN:
> +			if  (cmd->cmnd[1] == ZI_REPORT_ZONES)
> +				cmd->sc_data_direction = DMA_BIDIRECTIONAL;
> +			break;
> +		case SERVICE_ACTION_IN_16:
> +			if (cmd->cmnd[1] == 0x17)
> +				cmd->sc_data_direction = DMA_BIDIRECTIONAL;
> +			break;
> +		default:
> +			break;
> +	}

Very broken indentation. And the comment above this hunk would need to be
updated too.

This really has to stop. The need for modifying a data buffer content when
translating between SCSI and ATA is nothing new. HBA hardware designs that
cannot handle that internally are simply broken and should be fixed. Or better:
make your HBA use libsas and rely on libata-scsi SAT.

The commands above are not "performance" commands as they are generally not
issued in the hot path under heavy read/write workload. So even if they are a
little slower because of the HBA double buffering, that's fine. Relying on
unauthorized accesses to host memory to replace the HBA internal buffering is
probably not faster at all anyway.

I was already very sad/disapointed to stumble on the report zones issue. Adding
more commands to this is really not desired at all. Where does it stop ? After
all, you are not doing anything like this for translating ATA log pages to
mode/vpd pages, right ? So the HBA *is* capable of double buffering, no ?

Your commit message says nothing of the use case that this fixes. Is there an
actual problem in the field without this modification ? Without a better
justification, I am not in favor of this and would prefer the fixes to go into
the HBA firmware.


-- 
Damien Le Moal
Western Digital Research
