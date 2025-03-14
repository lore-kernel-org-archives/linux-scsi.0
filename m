Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28F42E337E;
	Fri, 14 Mar 2025 01:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741916959; cv=none; b=hMU3mvLVueiDsSiEoH7/5MLHxVsB1eC5HQ33qyamAoemN42905VjKMQ/rXQGz1qou0HozAXd+YXXaz4LBWOQa4RV/eMvbZY7BZZOxQrpz1CstAV8Lanz4zNv6jhvd+lxw5/Y4QpPlTjjWT37I4I0IuxpMnElpig08P2hiRg+OWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741916959; c=relaxed/simple;
	bh=ipJVnD5vLJyeWbgVJCp7BU1Bwa7IwU6dr5l/KZTVHXM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HmVdcKaDbr+BGYNKBWqWLpdW9FMfB5eWKH5VVGU03HJZ78nKX7VZ20fMJdX9qRf02gLaXLd7dYIRnO30sPUxG7+15BIRyqUXueSFgoFgEkGqQ6Jv8fln9DilOPTxoVtc5XRBYpgtvtyN9P4mgxpayiy54kEMnGDjrNVCx0Bw7eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EiEGok+B; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EiEGok+B"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZDS304KTRzlxY2F;
	Fri, 14 Mar 2025 01:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741916955; x=1744508956; bh=OVD8dlXS9CG6wKFU6suQFKKu
	NzYa+NwFmWOkeL/cq5k=; b=EiEGok+BAEvGGqMRHtxD/U62vIcu6LCZvU81VaX9
	bUgZFrk//gu+IZ1rfI9KArIiGRBA0PmB6lAHts6tgNIKnPnOyQj1yG+N0B3BXuha
	0M8zlAqrQusolc9ashGjt6x4BVeZrCGTpfyJuGlfy1ke4KIDwmz6cplNljFk28Zh
	libYpO+GlvKr7mhfHxBVpRRCGx7NZYkTQBRyC1dsjfpj/eyP45CaKhB8xH08Lgwu
	9h8yc3AAxOWdaScfLGYUChvPNhpKYR9YAIU5Kyt6zH+zyj003W1zE25dzGgC7PrL
	qe0EX6bOyOl2/DSNn6Lt1klS/CspRz5pZEwvpZvweOEFmQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FKM7eojvVRNV; Fri, 14 Mar 2025 01:49:15 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZDS2p69Z7zlxY1l;
	Fri, 14 Mar 2025 01:49:05 +0000 (UTC)
Message-ID: <58ddc052-039b-4b9f-b0b2-102f16da5d47@acm.org>
Date: Thu, 13 Mar 2025 18:49:04 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 01/19] scsi: scsi_error: Define framework for
 LUN/target based error handle
To: JiangJianJun <jiangjianjun3@huawei.com>, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: hare@suse.de, linux-kernel@vger.kernel.org, lixiaokeng@huawei.com,
 hewenliang4@huawei.com, yangkunlin7@huawei.com
References: <20250314012927.150860-1-jiangjianjun3@huawei.com>
 <20250314012927.150860-2-jiangjianjun3@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250314012927.150860-2-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/25 6:29 PM, JiangJianJun wrote:
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 815e7d63f3e2..f89de23a6807 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -291,11 +291,48 @@ static void scsi_eh_inc_host_failed(struct rcu_head *head)
>   	spin_unlock_irqrestore(shost->host_lock, flags);
>   }
>   

Please move the new-style error handling functions into a new file. 
scsi_error.c is already way too big. Mixing host-based and device-based
error handling in a single file is confusing. Please don't do this.

> +#define SCSI_EH_NO_HANDLER 1

This should be a new enumeration type instead of a define.

>   /**
>    * scsi_eh_scmd_add - add scsi cmd to error handling.
>    * @scmd:	scmd to run eh on.
>    */
> -void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
> +static void __scsi_eh_scmd_add(struct scsi_cmnd *scmd)

Please choose a better name for this function than __scsi_eh_scmd_add().

> +void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
> +{
> +	struct scsi_device *sdev = scmd->device;
> +	struct scsi_target *starget = scsi_target(sdev);
> +	struct Scsi_Host *shost = sdev->host;
> +
> +	if (unlikely(scsi_host_in_recovery(shost)))
> +		__scsi_eh_scmd_add(scmd);
> +
> +	if (unlikely(scsi_target_in_recovery(starget)))
> +		if (__scsi_eh_scmd_add_starget(scmd))
> +			__scsi_eh_scmd_add(scmd);
> +
> +	if (__scsi_eh_scmd_add_sdev(scmd))
> +		if (__scsi_eh_scmd_add_starget(scmd))
> +			__scsi_eh_scmd_add(scmd);
> +}

Please rename the function __scsi_eh_scmd_add() to make it clear that it 
is used for the host-based error handling strategey.

> +static inline int scsi_device_in_recovery(struct scsi_device *sdev)
> +{
> +	struct scsi_device_eh *eh = sdev->eh;
> +
> +	if (eh && eh->is_busy)
> +		return eh->is_busy(sdev);
> +	return 0;
> +}

Can the return type of this function be changed into 'bool'? Can the
three statements in the function body be combined into the following
statement?

	return eh && eh->is_busy && eh->is_busy(sdev);

> +static inline int scsi_target_in_recovery(struct scsi_target *starget)
> +{
> +	struct scsi_target_eh *eh = starget->eh;
> +
> +	if (eh && eh->is_busy)
> +		return eh->is_busy(starget);
> +	return 0;
> +}

Same questions here.

> +struct scsi_device_eh {
> +	/*
> +	 * add scsi command to error handler so it would be handuled by
> +	 * driver's error handle strategy
> +	 */
> +	void (*add_cmnd)(struct scsi_cmnd *scmd);
> +
> +	/*
> +	 * to judge if the device is busy handling errors, called before
> +	 * dispatch scsi cmnd
> +	 *
> +	 * return 0 if it's ready to accepy scsi cmnd
> +	 * return 0 if it's in error handle, command's would not be dispatched
> +	 */
> +	int (*is_busy)(struct scsi_device *sdev);
> +
> +	/*
> +	 * wakeup device's error handle
> +	 *
> +	 * usually the error handler strategy would not run at once when
> +	 * error command is added. This function would be called when any
> +	 * scsi cmnd is finished or when scsi cmnd is added.
> +	 */
> +	int (*wakeup)(struct scsi_device *sdev);
> +
> +	/*
> +	 * data entity for device specific error handler
> +	 */
> +	unsigned long driver_data[];
> +};

Adding unsigned long driver_data[] at the end of a structure is the old
way for extending a structure. Please don't do this. Instead, leave out
the driver_data[] array, embed the scsi_device_eh in a larger data
structure where necessary and use container_of() to convert
scsi_device_eh pointers into a pointer to the containing structure.

Thanks,

Bart.
