Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3CA1A9FBA;
	Fri, 10 Jul 2026 00:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783641652; cv=none; b=AU+K6SN5XfEhw8MzsS39LkM36wRGeHaSvSk/K56klswCe/7Peg6SXSSwOBPZiAwUspwghpaL2yIiLcabKUbOE4OiaKjthPZCSJA+Eq37PCfbQoKS2ROC0fb2hkRxP6laiDYfBhqGKVsGuTvVjynlXUqk4DFNtMvyD/Vw7lk+qVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783641652; c=relaxed/simple;
	bh=E/qHtxbxH1+9Hsqr/vPcZIknI0y/gGruw+lvoE5ZBXA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=moq/+zHEhV/mZrpaLJ/7T+QEDPRtN0d+oW1lfMQCfOzEPYp7HT5pLubYgbtvaV9RX9k1DsJ2EJ6IYSjPsg6DCBMTbveEmJvP+NQEuXhG1PoB4hiqXbetxlLUTkgO3n0eR0DBlkdTPjHWBDw+J5qDuTwZW3mplWqfWVgPbPTRNq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ndSsxuac; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ndSsxuac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F3D51F000E9;
	Fri, 10 Jul 2026 00:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783641650;
	bh=BHFrEJN3EyPSPC3rL5AxNrBEWcneqD1zIU6SKTYWKfo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ndSsxuacz3k3YviEHMB5ta7TZ63ap1GWkX9yeagz+jUSytUCJEvGyoNyYo5tI6v8u
	 X5BBJrPEep23Ynx5+ha16qjLRO9dCgODTeW2V0BxoYpw6MeGZwJ9SmHSevGYIFWHmc
	 dINkujz19oxWyHMdzrtsJ+klTzrvexd4GfHsf639rA7MMR+8gslz61mSgIPfg5bzT2
	 9JhE8WYZkUyh7etB0JOsi6Cde09Q5xl8XEZF3AQMScfMqAeOZnlkI2IbLqWAb9h1FA
	 dkFIQzOe0TbhahneQ+P4CVN0aujQKNkkUoWIoxQJ+wm6zIagGfZPFoJay8gEzD6khM
	 r/bWnjrxYKYlw==
Message-ID: <5cab2d52-5100-4dd8-aff7-f0927777041d@kernel.org>
Date: Fri, 10 Jul 2026 09:00:38 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] ata: libata-scsi: terminate deferred commands on
 time out
To: Niklas Cassel <cassel@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
References: <20260709083934.1116862-1-dlemoal@kernel.org>
 <20260709083934.1116862-2-dlemoal@kernel.org>
 <20260709090006.F317F1F00A3A@smtp.kernel.org>
 <dcc4f558-7b6e-4193-a943-036255fc202f@kernel.org> <ak_gsY5YvMBC-0M_@fedora>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <ak_gsY5YvMBC-0M_@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/10/26 02:56, Niklas Cassel wrote:
> On Thu, Jul 09, 2026 at 06:14:08PM +0900, Damien Le Moal wrote:
>> On 7/9/26 18:00, sashiko-bot@kernel.org wrote:
>>> [Severity: High]
>>> Does calling ata_scsi_qc_done() here prematurely complete the timed-out
>>> deferred command and free the libata qc?
>>
>> Yes it does. But unless it is the deferred QC that suffered the timeout, the
>> scsi command will be requeued and retried.
> 
> I think Sashiko has a good point.
> 
> 
> After this patch:
> 
> We will have some deferred QC handling in ata_scsi_eh_timed_out(scmd):
> 
> -Sets link->deferred_qc = NULL;
> 
> -Cancels the workqueue.
> 
> ata_scsi_eh_timed_out() will do the following:
> If scmd (the QC that timed out) was the deferred QC:
> -Sets DID_REQUEUE on the deferred QC.
> Else:
> -Sets DID_TIMEOUT on the deferred QC.
> 
> -Calls ata_scsi_qc_done(), which frees the deferred QC and calls scsi_done()
> 
> -scsi_done() will call scsi_done_internal(cmd, false);
>  scsi_done_internal(cmd, false) will set SCMD_STATE_COMPLETE,
>  but will defer the actual completion (scsi_complete() to softirq context.
> -ata_scsi_eh_timed_out() will return SCSI_EH_NOT_HANDLED to scsi_timeout(),
>  which will break; and will then evaluate if SCMD_STATE_COMPLETE is set,
>  if it is, it will do nothing.
>  (If it is not set it will add the scmd to the list of failed scmds.)
> 
> In case scmd == the deferred QC, since scsi_done_internal() will set
> SCMD_STATE_COMPLETE, before deferring the completion to softirq context,
> the code in scsi_timeout() will not add the scmd to the error list using
> scsi_eh_scmd_add(), instead it will return BLK_EH_DONE;
> 
> Thus, Sashikos comment can not happen in realtity, because if the deferred
> QC timed out, it will never be added to the list of scmds which
> ata_scsi_cmd_error_handler() will loop over.
> 
> I think it would be cleaner if we:
> 
> 1) Modify ata_scsi_eh_timed_out():
> if scmd == the deferred QC, set DID_TIMEOUT, but return SCSI_EH_DONE.
> This way it is more obvious that no further EH will be done. (Instead of
> relying on SCMD_STATE_COMPLETE already have been set, even though the
> completion was deferred to softirq context.)

Yes, you are right. For a timedout command, we always get +1 to the scsi host
failed counter, so we do not need to do anything special to decrement the busy
counter for a deferred QC when it times out.

As for the change, since ata_scsi_cmd_error_handler() already correctly handles
timed-out deferred QCs, when we have scmd == the deferred QC, we should just
not do anything at all in ata_scsi_requeue_deferred_qc().
ata_scsi_cmd_error_handler() will take care of it.

Sending a v2 with that change.

-- 
Damien Le Moal
Western Digital Research
