Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 819E0450E2;
	Fri,  1 Nov 2024 16:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730478709; cv=none; b=icFd3RJbOUfqqQ2VitaFilhmkIq2Fbv2s3tmWTAVrhimkSj0g5r5PD6yi+7sI5rJDFtyO96ltAhUKcS8Tx3HxWMLX5k6JnCtgIa76VuSc9jC5DKD4HKY63UdE0mORHg30E7n+AUCziuzocdxoFwSu4la2S52c04KeM4U2UXoh7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730478709; c=relaxed/simple;
	bh=UkKa/Lw6Dl+rJepRqjmt1WrXexCCnMQQr4Ofx7jv2X4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DpoDGsrBSfxGv/Bnmozen+tKYVI9pFBpxCOCCAUl5Xq8D3VUX+rKJ4qv69JWDy9FSkODkg0XBN4ghFci8MLhOL0aLMiJfLN2hiHN1WnReMRC3PGeZ+Kj4hHHG7Vakf+0WPLspt1jz/0hoCVOI+KNXOqE9ec8M0pVKf9JEbngcJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=iV8mLnq8; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="iV8mLnq8"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xg5wd5TGYzlgMVl;
	Fri,  1 Nov 2024 16:31:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730478697; x=1733070698; bh=OOcYODchsQjbT7r4ghzvVlXf
	dRY1Q6XH7O4JcVoylK8=; b=iV8mLnq8ex6bYkiI+T8ZWGwJrRvCZQopcC6lqhX0
	Mhe79pA1ZByuBVpPIpZqFjjIkkgv1p/ucDD75xfFU+9RzSfhIQa9PY3xXAD5Psqw
	qgDxsBnNMda0zqDF5f6+lSeQZrLm7MbniKVJdkTPRNjRPA6EcWN8WLaC29Wj29Re
	vomt4zdF1ns2F/4vh75Ibn175g/i4E26ki7uQQM0yXj3PrJy7EhVSrO/BL+6VNRJ
	alr+0ui/qVnZk+Oyjsc0cQufYev2l6Q4799CUnCphVQh7W73P/vxsd/HfEgjc+xs
	+D09iaF8b3LfJTAZzg3nM08XTxx/XFHqKp5Su9W6Ll9bNA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id VkQ7rsJnJtQE; Fri,  1 Nov 2024 16:31:37 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xg5wM2k6JzlgMVb;
	Fri,  1 Nov 2024 16:31:30 +0000 (UTC)
Message-ID: <116df065-ab9a-46e2-90eb-9ae5f5f01b70@acm.org>
Date: Fri, 1 Nov 2024 09:31:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Start the RTC update work later
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>,
 Bean Huo <beanhuo@micron.com>, stable@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Maramaina Naresh <quic_mnaresh@quicinc.com>, Mike Bi <mikebi@micron.com>,
 =?UTF-8?Q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>,
 Luca Porzio <lporzio@micron.com>
References: <20241031212632.2799127-1-bvanassche@acm.org>
 <20241101075309.wvfv2fcjeuimcihj@thinkpad>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241101075309.wvfv2fcjeuimcihj@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/24 12:53 AM, Manivannan Sadhasivam wrote:
> On Thu, Oct 31, 2024 at 02:26:24PM -0700, Bart Van Assche wrote:
>> The RTC update work involves runtime resuming the UFS controller. Hence,
>> only start the RTC update work after runtime power management in the UFS
>> driver has been fully initialized. This patch fixes the following kernel
>> crash:
>>
>> Internal error: Oops: 0000000096000006 [#1] PREEMPT SMP
>> Workqueue: events ufshcd_rtc_work
>> Call trace:
>>   _raw_spin_lock_irqsave+0x34/0x8c (P)
>>   pm_runtime_get_if_active+0x24/0x9c (L)
>>   pm_runtime_get_if_active+0x24/0x9c
>>   ufshcd_rtc_work+0x138/0x1b4
>>   process_one_work+0x148/0x288
>>   worker_thread+0x2cc/0x3d4
>>   kthread+0x110/0x114
>>   ret_from_fork+0x10/0x20
>>
>> Reported-by: Neil Armstrong <neil.armstrong@linaro.org>
>> Closes: https://lore.kernel.org/linux-scsi/0c0bc528-fdc2-4106-bc99-f23ae377f6f5@linaro.org/
>> Fixes: 6bf999e0eb41 ("scsi: ufs: core: Add UFS RTC support")
>> Cc: Bean Huo <beanhuo@micron.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 
> Bart, Thanks for the fix! While looking into this patch, I also found the
> weirdness of the ufshcd_rpm_*() helpers in ufshcd-priv.h. Their naming doesn't
> seem to indicate whether those helpers are for WLUN or for HBA. Also, I don't
> see the benefit of these helpers since they just wrap generic pm_runtime*
> calls. Then there are other open coding instances in the ufshcd.c. Like
> 
> pm_runtime_suspended(&hba->ufs_device_wlun->sdev_gendev)
> pm_runtime_set_active(&hba->ufs_device_wlun->sdev_gendev)
> 
> Moreover, we do check for the presence of hba->ufs_device_wlun before calling
> ufshcd_rpm_get_sync() in ufshcd_remove(). This could be one other way to fix
> this null ptr dereference even though I wouldn't recommend doing so as calling
> rtc_work early is pointless.
> 
> So I think we should remove these helpers to avoid having these discrepancies.
> WDYT?

Hi Manivannan,

In the context of the Linux kernel, in general, one-line helper
functions are considered questionable. In this case I prefer to keep the
helper functions since these encapsulate an implementation detail,
namely that the WLUN sdev_gendev member is used to control runtime power
management of the UFS host controller.

Checking whether or not the hba->ufs_device_wlun pointer is NULL from
the ufshcd_rtc_work() function would be racy since that pointer is 
modified from another thread. So I prefer the patch at the start of this
thread instead of adding a hba->ufs_device_wlun pointer check.

Thanks,

Bart.
