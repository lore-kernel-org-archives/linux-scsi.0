Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C66D1E0E1F;
	Mon, 28 Jul 2025 15:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753717677; cv=none; b=Hhs3z+UAd84VBQiQQCSR+B1PR+nq6b6u+6Wq5X0dE9i8uyp8LAEY5Z9yfwTbve8WiPzpyWZSxnKhQJ0Rk5N/zDpcWZQoFtyhhSrX8XL4WWec6q/HWO+Z731BSPMffNRPbUQp0h19x7NJIWlLY48XgvD1VNSXzG/Br7xCTka87iQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753717677; c=relaxed/simple;
	bh=r73bhfTc0ML5kdqwwez8W13WlP2Z6Nku7Makb+XHKXQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R50XVuTr6H2EQg/G4c1ob5u5QAkY57xpIfx4SfRYElNoPFX9qMQv1QypLql7+pa9BiSfapyVp55XedUbqMIIwMYBqs9uJ8KA/A9jJF6rZpt5Re3l+qaTd7PUAF9KOn+Vike6zpU8rxiQxdJX+3xDLdFhDPl7kBK69R4juKhFD9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pwQWluFu; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pwQWluFu"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4brNCl3ZHszlgqVr;
	Mon, 28 Jul 2025 15:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753717665; x=1756309666; bh=Bx/IeMx6TM9NMAMm+fjcLqD2
	6UbM95ezcPAHt/qbh/A=; b=pwQWluFu7EUZ4u8ZAB3OBOLwnlUizo5FJ7wUo/sY
	7+rHoDKuzSs7FnBa2atDMxNVrTAr7KNUIboX1MBro6To5v9g3is4eNP9QZO9vyve
	PlL60xUs1Ciqf5wAh3DYI6ofGwXn/JXSBQmsrZdgK+MmVhwfRZp8wqS1ykJFCuvt
	A4dYhDcBYCqJqnpHm3AxWaGCbpOG4vbcQLPSYPwxcm4QWQowywEOKpNieMFGdUfL
	AHFGo+S1zPQAGFWTaAnpYbXJYzLeFbPrx2Glnv4kL5uiJPdmMatpPtL4uXWkWrqz
	7LUSNwfvsAmuDzPgqMnbY8d+j95PKCFmGLkmfcN6JJEKYA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9XCt7SpqjYD8; Mon, 28 Jul 2025 15:47:45 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4brNCc3c3dzlgqVF;
	Mon, 28 Jul 2025 15:47:39 +0000 (UTC)
Message-ID: <325a7f60-955c-4e3d-bd16-e5377462fa33@acm.org>
Date: Mon, 28 Jul 2025 08:47:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: sd: fix sd shutdown to issue START STOP UNIT
 command appropriately
To: Salomon Dushimirimana <salomondush@google.com>
Cc: James.Bottomley@hansenpartnership.com, dlemoal@kernel.org,
 ipylypiv@google.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com, vishakhavc@google.com
References: <20250724212137.105270-1-salomondush@google.com>
 <20250724214520.112927-1-salomondush@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250724214520.112927-1-salomondush@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/24/25 2:45 PM, Salomon Dushimirimana wrote:
> Commit aa3998dbeb3a ("ata: libata-scsi: Disable scsi device
> manage_system_start_stop") enabled libata EH to manage device power mode
> trasitions for system suspend/resume and removed the flag from
> ata_scsi_dev_config. However, since the sd_shutdown() function still
> relies on the manage_system_start_stop flag, a spin-down command is not
> issued to the disk with command "echo 1 > /sys/block/sdb/device/delete"
> 
> sd_shutdown() can be called for both system/runtime start stop
> operations, so utilize the manage_run_time_start_stop flag set in the
> ata_scsi_dev_config and issue a spin-down command during disk removal
> when the system is running. This is in addition to when the system is
> powering off and manage_shutdown flag is set. The
> manage_system_start_stop flag will still be used for drivers that still
> set the flag.
> 
> Fixes: aa3998dbeb3a ("ata: libata-scsi: Disable scsi device manage_system_start_stop")
> Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
> ---
> Changes in v3:
> - Removed unnecessary tag
> 
>   drivers/scsi/sd.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index eeaa6af294b81..282000c761f8e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -4173,7 +4173,9 @@ static void sd_shutdown(struct device *dev)
>   	if ((system_state != SYSTEM_RESTART &&
>   	     sdkp->device->manage_system_start_stop) ||
>   	    (system_state == SYSTEM_POWER_OFF &&
> -	     sdkp->device->manage_shutdown)) {
> +	     sdkp->device->manage_shutdown) ||
> +	    (system_state == SYSTEM_RUNNING &&
> +	     sdkp->device->manage_runtime_start_stop)) {
>   		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>   		sd_start_stop_device(sdkp, 0);
>   	}

Runtime power management is not related at all to deleting a LUN through
sysfs. This patch makes it impossible to understand the sd_shutdown()
implementation without studying the ATA subsystem and its history.
Additionally, this patch makes the documentation of
.manage_runtime_start_stop incorrect.

There are only two drivers that set .manage_runtime_start_stop: libata
and the unmaintained sbp2 driver. Has it been considered to test
sdkp->device->is_ata instead of sdkp->device->manage_runtime_start_stop?

Thanks,

Bart.
