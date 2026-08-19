Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D198A2C0F93
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 12:48:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=124.126.103.232
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787143691; cv=none; b=ABhJKgD74twCWAAukW58fUOaNwCFHmvQX2u8bAqGsxvH+Rsx0UW6FoNLiRRjJjeLCeZbGXmIDD27Nr0xAX+y2yzLtHRjOdf1/GspYahjeM/2pVJ5m2915kI2qkmPVChpLPglf1hDr4mwvrzFGqohQ9tYiXQyczYHN8U0xAZpcwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787143691; c=relaxed/simple;
	bh=jUBdztM/NpAtAZTykY5xWHyNHJpT3EcCFU0mUlzQQtU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bh0cD0xaUL0KA5nsFDuQUjWhznK3t5T/CK2rI6oCn86K+5WkMHwH6gE4ReUn1IFqsyB8RK20iLtFNUTXBi5qcxAWmZrL7wF3D7lf090eTEvVJyvE+khUMtNhPgx5SqzH79zBwndYJeZh6hyQRd1OhsvPpsibwNKBGVAlN/fuYPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=kylinos.cn; arc=none smtp.client-ip=124.126.103.232
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kylinos.cn
X-UUID: 34a62c489bcc11f19a56ed5b684f684d-20260819
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:63ede66e-828d-497b-87f1-2dd3b308418f,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:468def0a2de014c5dacec2dcf4c104bd,BulkI
	D:nil,BulkQuantity:0,SF:80|81|82|83|102|865|898,TC:nil,Content:0|15|52,EDM
	:-3,IP:nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
	,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 34a62c489bcc11f19a56ed5b684f684d-20260819
X-User: lilinmao@kylinos.cn
Received: from [10.0.2.15] [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <lilinmao@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_128_GCM_SHA256 128/128)
	with ESMTP id 1955562046; Wed, 19 Aug 2026 20:47:58 +0800
Message-ID: <cb241fc1-4a4f-45c3-8e96-30d01ad491b6@kylinos.cn>
Date: Wed, 19 Aug 2026 20:47:54 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: fnic: free the NVMe port template from the
 delete callback
To: sashiko-reviews@lists.linux.dev
Cc: linux-scsi@vger.kernel.org
References: <20260819114242.3598034-1-lilinmao@kylinos.cn>
 <20260819114242.3598034-3-lilinmao@kylinos.cn>
 <20260819115211.D46EB1F00A3A@smtp.kernel.org>
From: Linmao Li <lilinmao@kylinos.cn>
In-Reply-To: <20260819115211.D46EB1F00A3A@smtp.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/8/19 19:52, sashiko-bot@kernel.org 写道:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
>
> New issues:
> - [Critical] Relocating `kfree(iport->nv_tmpl)` to the asynchronous `nvfnic_local_port_delete()` callback introduces a severe arbitrary free and memory corruption vulnerability if the unregister process times out.
The bot is right.  Please drop this patch; 1/2 is independent and still
stands on its own.

If the wait times out, fnic_remove() continues and eventually frees fnic,
which also frees the embedded iport still referenced by lport->private.
A later ->localport_delete() callback would therefore read nv_tmpl from
freed memory before passing it to kfree().

The underlying problem is that the bounded wait allows fnic to be freed
while the NVMe/FC transport still holds pointers into it.  I will revisit
that teardown separately.

Sorry for the noise on 2/2.


Thanks,
Linmao

>
> Pre-existing issues:
> - [Critical] The driver's bounded timeout design for NVMe FC unregistration leaves the `fnic` structure vulnerable to a Use-After-Free when deferred callbacks execute.
> --
>
> --- Patch [2]: [PATCH 2/2] scsi: fnic: free the NVMe port template from the delete callback ---
> commit 99ed8cf7442e7f3171f98e582e611d65cec9862a
> Author: Linmao Li <lilinmao@kylinos.cn>
>
> scsi: fnic: free the NVMe port template from the delete callback
>
> This commit attempts to fix a dangling pointer issue by moving the
> freeing of the NVMe port template to the deferred local port delete callback,
> tying its lifetime to the transport's use instead of a bounded timeout.
>
>> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
>> index 00d9d5d439a38..a8b7b7d40b9ab 100644
>> --- a/drivers/scsi/fnic/fnic_nvme.c
>> +++ b/drivers/scsi/fnic/fnic_nvme.c
>> @@ -1243,7 +1243,6 @@ void nvfnic_nvme_unload(struct fnic *fnic)
>>   				WARN_ON(1);
>>   			}
>>   			iport->flags &= ~FNIC_LPORT_NVME_REGISTERED;
>> -			kfree(iport->nv_tmpl);
>>   		}
>>   	}
> [ ... ]
>
>> @@ -1669,6 +1668,9 @@ void nvfnic_local_port_delete(struct nvme_fc_local_port *lport)
>>   	FNIC_NVME_DBG(KERN_INFO, fnic, "lport delete 0x%x\n",
>>   		      iport->fcid);
>>   
>> +	kfree(iport->nv_tmpl);
> [Severity: Critical]
> Does moving this kfree() here introduce an arbitrary free if the unregister
> process times out?
>
> If the bounded timeout in nvfnic_nvme_unload() expires:
>
> nvfnic_nvme_unload()
>      time_remain = wait_for_completion_timeout(fnic->nvme_lport_unreg_done,
>                                                msecs_to_jiffies(time_wait));
>
> The driver can abandon the wait and eventually free the fnic structure, which
> embeds the iport. When the transport later invokes this deferred callback,
> the iport pointer will point to freed memory.
>
> Could this cause the kernel to execute an arbitrary free by passing a
> corrupted iport->nv_tmpl pointer to kfree()?
>
>> +	iport->nv_tmpl = NULL;
>> +
>>   	spin_lock_irqsave(&fnic->fnic_lock, flags);
> [Severity: Critical]
> This is a pre-existing issue, but does the bounded timeout design for NVMe FC
> unregistration leave the fnic structure vulnerable to a use-after-free?
>
> Similar to the issue above, if the wait_for_completion_timeout() in
> nvfnic_nvme_unload() expires and the driver frees the fnic structure, this
> callback will attempt to acquire fnic->fnic_lock on freed memory.
>
> Since the transport can asynchronously invoke the localport_delete callback
> long after the driver has given up waiting, is it safe to dereference the fnic
> pointer here?
>
>>   	if (fnic->nvme_lport_unreg_done)
>>   		complete(fnic->nvme_lport_unreg_done);
