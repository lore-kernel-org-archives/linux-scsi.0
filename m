Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7865140801E;
	Tue, 21 Jul 2026 07:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784619802; cv=none; b=uixg+AJdEbq+xENEEbiNOUNuUkSAr7P8bfRGhPW3PF9r+WKJH+QRl5wwpjnAF+cb1LHO8e3k9fNOBeVDylEN6nbWIZkRlCOf1twbTOSXNf8vlO1dHMevYlCMBxK2M1qdsm/hKKGYLrZUosP49Xp9KM0hrior1e1KSkgY14qDemI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784619802; c=relaxed/simple;
	bh=ir+4WfbiAzotiJ1Wjs3iSJw0sPivkg57hAu2GpqjZZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g5v7Q1P20Xh5Q7ZAtpqQqXSzjFRFWss2CIq5rsUe9HUnshS2AjjKNAh8HIfMiDbMVtVuO4y7xmyS5gp3wkfOa+MZrf0qHd++lOAh0v6PM2fWsU0cX36NkkR86I5H5L/I/wJp4TELMeNrK108JiMkB+N6gEgIRzkRAgU7DU+pajw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JR0x25fq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JR0x25fq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C7A61F000E9;
	Tue, 21 Jul 2026 07:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784619800;
	bh=h3tOXkeBPviC75Xzqug+FxcB9x6aF4pEU5Z+9yTVlIw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JR0x25fqiXNTl0ZypZVjnoNkYtUeKuZMLUb/uQ2J1yzupBijUCFgmANQDLgTTdYWL
	 CPpFIZakriC5r2qRE78MQ6w9d2qP0Hpxf0jprw1aR0QmiPibsAUMKDQFJ4JVqAtKTs
	 wcnaM3c8YlHZRymCCArM2XjZaAYjA4xJBgpy3xCfhdTr23vR6cj1uJsbuSZ/8Mo//U
	 Pe402ohhGtZKS1XGvfELfXzzOo3ItvWv04SCdnCbZmYq1xghR+Sg+pS5U1ZOpGbf+Q
	 /KK0FIHbLSnMKqx9IyeQRcDrojL43QFYyPIgbEKSLaKdZpFtELSkPPoINsXSyyikaO
	 OxHUi8TTNUQWg==
Message-ID: <64eb7729-6f7f-4a05-a471-2406c5e3ccfb@kernel.org>
Date: Tue, 21 Jul 2026 16:43:17 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/2] ata: libata-scsi: terminate deferred commands on
 time out
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org, cassel@kernel.org, linux-ide@vger.kernel.org
References: <20260721064027.2081195-1-dlemoal@kernel.org>
 <20260721064027.2081195-2-dlemoal@kernel.org>
 <20260721070030.8AC0F1F000E9@smtp.kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260721070030.8AC0F1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/21/26 16:00, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Missing call to ata_scsi_schedule_deferred_qc() in atapi_qc_complete() leads to starvation and timeouts of deferred commands.
> --
> 
> --- Patch [1]: [PATCH v7 1/2] ata: libata-scsi: terminate deferred commands on time out ---
> commit 3b26adffba8da435c70bdca03b617603f9f9ae76
> Author: Damien Le Moal <dlemoal@kernel.org>
> 
> ata: libata-scsi: terminate deferred commands on time out
> 
> This commit avoids unnecessary SCSI EH task wake-ups by scheduling
> a retry of all waiting deferred QCs using the new ata_scsi_eh_timed_out
> operation. It also updates ata_scsi_requeue_deferred_qc to terminate
> timed-out deferred commands directly and schedule libata EH to prevent
> the block layer from re-issuing them immediately.
> 
>> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
>> index 5868526301a2b..c2f2f711fd987 100644
>> --- a/drivers/ata/libata-scsi.c
>> +++ b/drivers/ata/libata-scsi.c
> 
> [ ... ]
> 
>> @@ -2936,7 +3014,15 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
>>  		if (qc->cdb[0] == ALLOW_MEDIUM_REMOVAL && qc->dev->sdev)
>>  			qc->dev->sdev->locked = 0;
>>  
>> -		ata_scsi_qc_done(qc, true, SAM_STAT_CHECK_CONDITION);
>> +		if (cmd->result)
>> +			ata_scsi_qc_done(qc, false, 0);
>> +		else
>> +			ata_scsi_qc_done(qc, true, SAM_STAT_CHECK_CONDITION);
>> +		return;
>> +	}
>> +
>> +	if (cmd->result) {
>> +		ata_scsi_qc_done(qc, false, 0);
>>  		return;
>>  	}
>>  
> 
> [Severity: High]
> This isn't a bug introduced by this patch, but should atapi_qc_complete()
> be calling ata_scsi_schedule_deferred_qc(link) before returning?
> 
> Unlike ata_scsi_qc_complete() which kicks deferred commands,
> atapi_qc_complete() misses this call on all of its exit paths, including
> the ones modified here. If an ATAPI command is executing on a shared PATA
> link and a concurrent command is issued to the other device, it gets
> deferred by ata_std_qc_defer(). When the ATAPI command finishes, it
> appears the deferred command will be trapped in link->deferred_qc and
> never issued, eventually failing with DID_TIME_OUT and causing device hangs.
> 
> Could this function be missing a call to ata_scsi_schedule_deferred_qc()
> to prevent starvation?

Yes. Will send another patch for that.

-- 
Damien Le Moal
Western Digital Research
