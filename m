Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9833F9A1B;
	Thu,  9 Jul 2026 09:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783588452; cv=none; b=N/u8xMhrKH3nwI+wIaFC6IskswpEb8RO1ncxG5LaQDBTxz6QWBVN12hUZE5TdjwR3wM1Lt1mt7bIflTevngepWgywH1tFoqrAGhKeK+LKHCp5eR+3J9oMzHxFSDdF8fvcvaO5TPjmgvcS7VdWXKZT8zGGkpKdSX+Ertblg7joHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783588452; c=relaxed/simple;
	bh=Qrjsa6kNlgtqbcszSbWTM/A2+j5SwnmvBesi2KThD6M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hFeTdUBl49vcIa7gdCoDm2X0YWiGhcsTTgc0tkM36xz6pzFVm2OFuV6F1EUBu/bT5IzlA/PeuYJRHgqd/oL9cLrbNOX3nuxA5OZ4g+Z9KIXAaSTFZMgMFdyhh3k6d+rIOB8abIFlBtSyuvh+T4QZGQVKrGcszJzJ0s3M1kqBxM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WTybV0xP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WTybV0xP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3279B1F000E9;
	Thu,  9 Jul 2026 09:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783588450;
	bh=oacrnyBrpn2K0Y0NRU9kj42nB0krZasHrT3apgcYHzQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WTybV0xPYemqWJLocPgwRv1n2vVlWP64G4ERSiMpVBxCvISv8trKSvfeXj4UeqjH2
	 eEl2QR5wHoURSrIq6GQZRCZZ3WT+hakTpPRj9ZTa9BO4C/Ge+1ggD4md58CC5xAQA9
	 dAxXkagHW/OMVtpHyVnEhwsYZDzjD8UtJNSRQsq5fg0mKD4TMk86pfvxMr/9bnKZQG
	 y7nwFfDzl/INI/KMtTu2rE+Pwb1aeFF6N3xCx/U9NKtVpLsNXNeKOUYYEmD6BUiqsr
	 t1sea7mq4pZ/t5bIacLwpeeq096EP9aOShJC85Gh/uaryDUwzDFF+le2YHRCRXlb7v
	 fOiwg9do66Keg==
Message-ID: <dcc4f558-7b6e-4193-a943-036255fc202f@kernel.org>
Date: Thu, 9 Jul 2026 18:14:08 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] ata: libata-scsi: terminate deferred commands on
 time out
To: sashiko-reviews@lists.linux.dev
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org
References: <20260709083934.1116862-1-dlemoal@kernel.org>
 <20260709083934.1116862-2-dlemoal@kernel.org>
 <20260709090006.F317F1F00A3A@smtp.kernel.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260709090006.F317F1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/9/26 18:00, sashiko-bot@kernel.org wrote:
> [Severity: High]
> Does calling ata_scsi_qc_done() here prematurely complete the timed-out
> deferred command and free the libata qc?

Yes it does. But unless it is the deferred QC that suffered the timeout, the
scsi command will be requeued and retried.

> When a deferred command times out, ata_scsi_eh_timed_out() calls this function
> which sets the host byte to DID_TIME_OUT and calls ata_scsi_qc_done().
> ata_scsi_qc_done() then frees the qc and invokes the qc->scsidone callback.
> 
> Later, when the SCSI completion softirq routes the DID_TIME_OUT command to the
> EH queue and the EH thread runs ata_scsi_cmd_error_handler():
> 
> drivers/ata/libata-eh.c:ata_scsi_cmd_error_handler() {
>     ...
>     set_host_byte(scmd, DID_OK);
>     ata_qc_for_each_raw(ap, qc, i) {
>         if (qc->scsicmd != scmd)
>             continue;
>         if ((qc->flags & ATA_QCFLAG_ACTIVE) ||
>             qc == qc->dev->link->deferred_qc)
>             break;
>     }
>     ...
> }
> 
> Because the qc was already freed, the ATA_QCFLAG_ACTIVE flag is cleared
> and deferred_qc is NULL. The loop will fail to find the active command.
> 
> It seems this causes the handler to fall into the 'raced completion' branch:
> 
> drivers/ata/libata-eh.c:ata_scsi_cmd_error_handler() {
>     ...
>     } else {
>         /* Normal completion occurred after
>          * SCSI timeout but before this point.
>          * Successfully complete it.
>          */
>         scmd->retries = scmd->allowed;
>         scsi_eh_finish_cmd(scmd, &ap->eh_done_q);
>     }
>     ...
> }

And after this, scsi_eh_flush_done_q() will retry the command.
Tested and I do not see failure of the deferred QC :)


-- 
Damien Le Moal
Western Digital Research
