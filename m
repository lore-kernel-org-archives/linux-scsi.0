Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F6F13C3D5
	for <linux-scsi@vger.kernel.org>; Wed, 28 Aug 2024 17:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724865571; cv=none; b=QOC5YM60bJeAOiUspAGUJN5W569tYHwntB2Ui90BatOgYhLBEFx3QfDH/PrH3KIET2uCkdmbxS7LVQ2Ll49tETYJpC3XTEYrYG1YvRCQtiFxuxAfbsEaRkLQfcmn45xx+kpXIeedNUCAeBxp3tMr5NREkAi9z5WDIZKUqqRn/pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724865571; c=relaxed/simple;
	bh=xgnIoqyS1Ye4wdwvrmYIU0tDifwNF6Xqfov3kHGnyuA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t6aYCnvaqm3WvL4E+gDJKBtf+XTgVH6aVA8OuaqrO5vWesDOvH/avkGkYIsi1h8wJxK1dVJeJ9TisevI0EJAPdi7HIWoT/a8fjmHBRjpxMAbNieTfqZ/Sqd0yqyrGb3R6bjkFGg1RJDfJ2Oim7ZGI8quDHMqUC48VsaphBrcLa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=y3OyMnZA; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="y3OyMnZA"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WvB3h2K3Hz6ClY9H;
	Wed, 28 Aug 2024 17:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724865564; x=1727457565; bh=RNupwKxBLeuzlD8EEk3y/684
	EY2j7yYHSWYhDjaSGWg=; b=y3OyMnZAqrZGUxr/NbK75hobyD65DmorMV9/T5xf
	MjazivIs4Y15X3goXs9PrsBQe9TiLvVevx/FDOBWIe0CWvximH+OeDziSoxhtRN1
	gR02/mNZ+CCS86kGOWfnWj7q0PCAhCLZrVrkSqCLnzKzGGoQEfKL42iP85s7rATZ
	ZtwOBA/AfmcT2cJ+uvUuT3VviScgkcxMyBVoleqaGOqtEpKEB5aMOH17qZNWGt0Z
	uAJAOhK9p2A2refzT0Oswd+FWstu+s1SNHOdTXvifg2ioOj2YWgjzjwxXtyqrB0r
	OjRI76UK3+6M3oJTvU9Q1HBeXl/kUCseEdwA2tnihaCNOw==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Flwm7fwSfPaC; Wed, 28 Aug 2024 17:19:24 +0000 (UTC)
Received: from [172.16.58.82] (modemcable170.180-37-24.static.videotron.ca [24.37.180.170])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WvB3Z4BKyz6ClY9F;
	Wed, 28 Aug 2024 17:19:22 +0000 (UTC)
Message-ID: <a7f1194f-d3a6-45e3-a986-a7e972799a3f@acm.org>
Date: Wed, 28 Aug 2024 13:19:20 -0400
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/9] ufs: core: Move the ufshcd_device_init(hba, true)
 call
To: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>,
 Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>
References: <20240822213645.1125016-1-bvanassche@acm.org>
 <20240822213645.1125016-7-bvanassche@acm.org>
 <20240825053320.mewedbbpxkljamds@thinkpad>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240825053320.mewedbbpxkljamds@thinkpad>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/24 1:33 AM, Manivannan Sadhasivam wrote:
> On Thu, Aug 22, 2024 at 02:36:07PM -0700, Bart Van Assche wrote:
>> Move the ufshcd_device_init(hba, true) call from ufshcd_async_scan()
>> into ufshcd_init(). This patch prepares for moving both scsi_add_host()
>> calls into ufshcd_add_scsi_host(). Calling ufshcd_device_init() from
>> ufshcd_init() without holding hba->host_sem is safe because
>> hba->host_sem serializes core code with sysfs callback code and because
>> the ufshcd_device_init() is moved before the scsi_add_host() call.
> 
> I think this last sentence is not complete.

It is complete but your feedback means to me that it is hard to
understand. I will reword it.

>> @@ -10632,6 +10629,11 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
>>   	 */
>>   	ufshcd_set_ufs_dev_active(hba);
>>   
>> +	/* Initialize hba, detect and initialize UFS device */
>> +	err = ufshcd_device_init(hba, /*init_dev_params=*/true);
> 
> I think this inline comment is not really needed. It is rather decreasing code
> readability.

I will remove it.

Thanks,

Bart.

