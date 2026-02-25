Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E162628850E;
	Wed, 25 Feb 2026 18:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772045348; cv=none; b=hxxAzIyF3mPSz7gpb/zr2Vtq/nKvm4qbhw6Vt/fp+4dOvPLKdeaYbldH5epW/fKxTfUN2V4RlDefxQMg49PLJ0SlOCzcsbBMK3Tu6Ro/toyqHjwhEEjM0ICMXCgZxZLU6mzM1DGgGWfpNPy/JlGIGC5cgn4tMnDUE2WBmqBQgvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772045348; c=relaxed/simple;
	bh=K1wjUdZbkFmAAOtLJ8izoO/deoPn42lRMa4XtEbvLh0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XCCdtERI5evkA/j1DlUImpFOTFC0dQAV5RCYA3oL9MefU11bo2qDHydQXmz5g0AQ25UoUmpmo3Td73sFjYdysNb1jT1TTgUb9LsLxSIbVTjwKoX1Nqw8+ISvWnyS6RlEbpjgyhgHJ5riDBhBLA3IXW/4d6DnjFRmTn+RIJvskII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wXcefYjR; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wXcefYjR"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fLkC03MTlzlh1Vp;
	Wed, 25 Feb 2026 18:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772045337; x=1774637338; bh=vehE1cjB5CBnsLvBUQ9luftD
	uZi0TzsBdhiHq3qm9Ts=; b=wXcefYjRz0V/wsptF3pqZ33smIsL0xpD6VLTbxPI
	B4wDyoAFpu5Tu+6RPwxvFK+0T2a6a2AC0qji5RMAEyhmm+5mwkAqcUti8HYMPETu
	GJRlyTxbwVd1jV6iBf4Dz/Ny2Bh73QCpoD804WKA2nozsYqYInbLcg/eRg0UlnIP
	xNmqaUttC0V/NOyK49CVjY+IL+fo8JzTK9dRlScXPWDvwJOeLQBUQztwppsCQN2h
	fLHMvq1iq/kbr1+zcot/LF0fRfa+fizxaqex6sPoMShpSA54x+Aziyp7dTEXlDMD
	kzxR5yWYUioj7aTaOZgnPForJ0DC99GxvLOoyK0bARzSGQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rYXZ-kiW4931; Wed, 25 Feb 2026 18:48:57 +0000 (UTC)
Received: from [172.20.2.156] (unknown [4.28.11.157])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fLkBt10C3zlh1Vm;
	Wed, 25 Feb 2026 18:48:53 +0000 (UTC)
Message-ID: <72cd1fba-0f7d-41d3-b933-88eb8fe861fe@acm.org>
Date: Wed, 25 Feb 2026 10:48:51 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] scsi: ufs: core: Add support to notify userspace
 of UniPro QoS events
To: Can Guo <can.guo@oss.qualcomm.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Huan Tang <tanghuan@vivo.com>, Peter Wang <peter.wang@mediatek.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, Liu Song
 <liu.song13@zte.com.cn>, Ram Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
 Daniel Lee <chullee@google.com>, Bean Huo <huobean@gmail.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260225022942.345564-1-can.guo@oss.qualcomm.com>
 <20260225022942.345564-2-can.guo@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260225022942.345564-2-can.guo@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 2/24/26 6:29 PM, Can Guo wrote:
> +What:		/sys/bus/platform/drivers/ufshcd/*/dme_qos_notification
> +What:		/sys/bus/platform/devices/*.ufs/dme_qos_notification
> +Date:		February 2026
> +Contact:	Can Guo <can.guo@oss.qualcomm.com>
> +Description:
> +		This attribute shows and clears the DME	Quality of Service
> +		notification from UFSHCI UECDME.
> +
> +		The attribute is read/write.

The above text is incomplete. It should explain that
dme_qos_notification is a bitfield, what the meaning of the bits in this
bitfield are, when this bitfield is updated, that the only value that
can be written into this bitfield is 0 and also what the effect of
writing 0 into this bitfield is.

> diff --git a/drivers/ufs/core/ufshcd-priv.h b/drivers/ufs/core/ufshcd-priv.h
> index 7d6d19361af9..14e8cb145f43 100644
> --- a/drivers/ufs/core/ufshcd-priv.h
> +++ b/drivers/ufs/core/ufshcd-priv.h
> @@ -446,4 +446,10 @@ static inline void ufs_rpmb_remove(struct ufs_hba *hba)
>   }
>   #endif
>   
> +static inline void sysfs_notify_dirent_safe(struct kernfs_node *sd)
> +{
> +	if (sd)
> +		sysfs_notify_dirent(sd);
> +}

This function is very short and is not used outside
drivers/ufs/core/ufshcd.c. Is it really needed to introduce this 
function? If this function is preserved, please consider moving it into
drivers/ufs/core/ufshcd.c.

 > @@ -11044,6 +11051,8 @@ int ufshcd_init(struct ufs_hba *hba, void 
__iomem *mmio_base, unsigned int irq)
 >   		goto out_disable;
 >
 >   	ufs_sysfs_add_nodes(hba->dev);
 > +	hba->dme_qos_sysfs_handle = sysfs_get_dirent(hba->dev->kobj.sd,
 > +						     "dme_qos_notification");
 >   	async_schedule(ufshcd_async_scan, hba);
 >
 >   	device_enable_async_suspend(dev);

Where is the sysfs_put() call that corresponds to the above 
sysfs_get_dirent() call?

> + * @dme_qos_notification: UFS host controller DME QoS notification

Please explain also here that this is a bitfield and where the meaning
of the bits in this bitfield are defined.

Thanks,

Bart.
