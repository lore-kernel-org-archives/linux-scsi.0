Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20F493EFFDD;
	Fri, 10 Jul 2026 08:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783672209; cv=none; b=MYMd9/Qj+oEp5UE5KUVBPSc7j9Evyr1VxphMKqmOmnUXG/kMkrdIlmv3g8EVY7E7lA/G9GncADDuhTKEQ2yYgjxr0qKAUl0Gfx3CQPmuz/lNzHW3oZYxrYC+uFnNUjczBuGLe+HwcphFb9thhMWqS+VcjCGfKCQ+OKB8nHeNurE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783672209; c=relaxed/simple;
	bh=n5u/F/1g8wyEoOTcJEyVWT9sCDLhe1RTYk2O/Axj6/U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O0dkcwMu8SQyXagIovxn6P6/a4R/JOP8alDhLYZrkR2MvdhCW5rm/GuzT/X88lCUZ41drGPGAf6kD5DPcF4VPXit/wkFAN1UHQLbyYWKwEhmouSwymcOe5jPFoZNQ4XRzfanhBGfV/GWOCxCYbh6AgYumTQ4hI/EtpV3dngPBII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mYL/uiIL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mYL/uiIL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D3E51F000E9;
	Fri, 10 Jul 2026 08:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783672207;
	bh=gXBkTFIZDM7kIV7bw7HC2drnyXkAdZgTIlef0jlR5kw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mYL/uiILkbbbzhg9nKiPfyv0IZ8OTin8LyNUrp4OYbLkqXa6VQQL98dg157JLNDb2
	 jlAxx9T4Oi2FKH5L8hygvhE2CoFJxrfe3JJzPYXj7IJ13d2U7JfDC/+l+xtNUYP1Kn
	 8WNAMMxsWuAZ2pPnhF2VwYUxTwLeZPtepmOhOwowybAcpLecjDj5LgHLAA7CfM8QT/
	 s1VhlDzuuYkjtmz9GXQrLDycpW2qnAMyhrMOseCJFZlZ+KFf8adnQrHRclnRleSk8/
	 1T/nOEjj4r1m2xZFui6KEMpdQ4pVYlEFg+rBCLEwaO2s+9w5cR70zQC6DugdvPEjeN
	 o4yC6kePI+oOA==
Message-ID: <43c999f5-84bd-45f1-8194-cc80a535ef0a@kernel.org>
Date: Fri, 10 Jul 2026 17:29:56 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] ata: libata-scsi: terminate deferred commands on
 time out
To: Niklas Cassel <cassel@kernel.org>
Cc: sashiko-reviews@lists.linux.dev, linux-ide@vger.kernel.org,
 linux-scsi@vger.kernel.org
References: <20260710000646.1202200-1-dlemoal@kernel.org>
 <20260710000646.1202200-2-dlemoal@kernel.org>
 <20260710002431.3148D1F000E9@smtp.kernel.org>
 <724b4a01-e396-4cc0-be2a-9860f42d803f@kernel.org> <alCoB5FOGJTljbjU@fedora>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <alCoB5FOGJTljbjU@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/10/26 17:06, Niklas Cassel wrote:
> On Fri, Jul 10, 2026 at 04:25:38PM +0900, Damien Le Moal wrote:
>>> [Severity: High]
>>> Does this function need to set ATA_PFLAG_EH_PENDING?
>>>
>>> Because this flag is not set, ata_port_eh_scheduled() will evaluate to
>>> false. This allows the block layer to immediately retry the requeued
>>> commands, which __ata_scsi_queuecmd() will accept and re-defer, keeping
>>> the host busy.
>>
>> No it will not because this is called with SCSI EH already waiting to run, so
>> newly incoming commands are not passed down by the scsi layer.
> 
> Could you please point to specific functions + lines in the code?
> 
> AFAICT, I don't see how SCSI EH is waiting to run when
> scsi_eh_scmd_add() has not yet been called.

The wait is at the beginning of the EH task:

int scsi_error_handler(void *data)
{
...
              if ((shost->host_failed == 0 && shost->host_eh_scheduled == 0) ||
                  shost->host_failed != scsi_host_busy(shost)) {
                        SCSI_LOG_ERROR_RECOVERY(1,
                                shost_printk(KERN_INFO, shost,
                                             "scsi_eh_%d: sleeping\n",
                                             shost->host_no));
                        schedule();
                        continue;
                }

and... looking at the code from there, indeed, scsi_timeout() calls eventually
scsi_eh_scmd_add() which increases host_failed. So looks like Sashiko has a
point here, and we could see the requeued deferred QCs immediately re-issued,
which would keep scsi_host_busy() incremented.

Grrr... Need to dig further.
> 
> Note that all the places that currently call ata_scsi_requeue_deferred_qc()
> are called when ATA_PFLAG_EH_PENDING | ATA_PFLAG_EH_IN_PROGRESS
> (ata_port_eh_scheduled() evaluates to true).
> 
> We could add an WARN_ON(!ata_port_eh_scheduled) in ata_scsi_requeue_deferred_qc()
> and we would never see the warning.

You will see the WARN for a timeout because in that case, we enter EH from an
expired block layer timeout calling scsi_timeout(), not from an error IRQ
signaled by the ATA controller. So we do not have ATA_PFLAG_EH_PENDING set.

> With the new function ata_scsi_port_eh_timed_out(), AFAICT, it can call
> ata_scsi_requeue_deferred_qc() before ata_port_eh_scheduled() evaluates to true.

Yes.

> See e.g. the commit message for:
> e20e81a24a4d ("ata: libata-core: do not issue non-internal commands once EH is pending")
> of why I think __ata_scsi_queuecmd() will accept new commands.

Yes, it seems that nothing blocks new commands until scsi_eh_scmd_add() as that
is the function setting the host state to recovery.

So back to the drawing board. A simple requeue will not cut it.

-- 
Damien Le Moal
Western Digital Research
