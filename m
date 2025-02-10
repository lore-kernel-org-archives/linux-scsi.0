Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA50325B668;
	Mon, 10 Feb 2025 18:30:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739212243; cv=none; b=VpGchlwxDG8eQCLxLGg2qya8kSBsbNqPeya8JOCjRi8/jGdgOKFJEaxjmFAEX2y+pIkS7boMSPn8zHSMzTMwLFu+FfOev0d4pVbk0MSzo8jK0MWQmtPDB+f4X0N8ahof85f39RBA3NQE47u4lsonJV4e8K5Wwa3D8dN7SaKBP/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739212243; c=relaxed/simple;
	bh=NpUbqGXrMouY2GQCefFrHJh2xQhsDigKdnZDZh70UiQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LfAsVI/8q47CRGMFvAh+0qxrxMyfDF+JBmqmp5tde/y0/MMpbV+pC+z2Pehy6DBy4udElvtjdS/XdaJONPaqO4QTAyhsUN3xdMEi3z1L810nqTpUs9AYvSI4dbvUuZFNAX4eagU3OgB4+HC5brLR6WH3YcF78x0t7M3PAZhBk/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Rj/CP3px; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Rj/CP3px"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YsCn70DPQzlgTxL;
	Mon, 10 Feb 2025 18:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1739212232; x=1741804233; bh=rvjXTLcQM3fw49GIJv8Wb69W
	nr2JbJyCdGw5e7OGk9g=; b=Rj/CP3pxeFjJyhOywyYi0inr0oyXYvb1xlmTUyDZ
	o5ZjJ6UgzpiaFTE952nBVcB9IH0LSHlOmUdppFyUAVnZH0BTOIfDnR6mvQh5WzOK
	6TxfiUKnUrpZSjIFlzYVL0twZLlGKBpPdJIc4uGIh5xzqmTDameZQaQnRzUuQjj6
	ClibSEwY6zXy/Y3qGE6KkAFihrm9FbkiOboLt/XSUIoXCFNL5sYFnVrAk3eh7uOe
	T6jLGrv/+XcF6YxfINOarbyHMbxm5bzGL5zoqTld2VrctDZLp+aTrx1m0NeofDcu
	X6C39ImuQkD1dyv+miL0yVH8S03iaLEwX9z1y+OjVrGntQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pbDLEYCiXs9e; Mon, 10 Feb 2025 18:30:32 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YsCn412T9zlgTwM;
	Mon, 10 Feb 2025 18:30:31 +0000 (UTC)
Message-ID: <01d47263-50a1-4626-ad34-446996ac970e@acm.org>
Date: Mon, 10 Feb 2025 10:30:31 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: ufs: critical health condition
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250210135814.50783-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250210135814.50783-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/10/25 5:58 AM, Avri Altman wrote:
> To handle this new `sysfs` entry, either `udev` rules or some other
> polling code can be configured to monitor changes in the
> `critical_health` attribute.

Hmm ... I'm not aware of any support in udevd to poll on sysfs
attributes? I think that calling select(), poll() or epoll() is required
to wait for a sysfs_notify() call.

> +Description:	Report the number of times a critical health event has been
> +		reported by a UFS device. further insight into the specific

further -> Further?

> +static ssize_t critical_health_show(struct device *dev,
> +				    struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	return sysfs_emit(buf, "%d\n", hba->critical_health);
> +}

Now that the data type of hba->critical_health has been changed from
boolean into integer, should its name perhaps be changed into
hba->critical_health_count?

> @@ -1130,6 +1131,9 @@ struct ufs_hba {
>   	struct delayed_work ufs_rtc_update_work;
>   	struct pm_qos_request pm_qos_req;
>   	bool pm_qos_enabled;
> +
> +	/* HEALTH_CRITICAL exception reported */
> +	int critical_health;
>   };

Please leave out the inline comment since @critical_health already
has a kernel-doc comment.

Thanks,

Bart.
