Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A79317083A;
	Wed,  5 Feb 2025 18:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738778467; cv=none; b=LhBT72nS5jxFkiXJdh4tdfUhFsCXFBpyVowiM2Lk+D7Dh41HJ9kXyBiJQMukvKyAxmT9+GgINu03K2HRyjdCD5eHvCKuJo+5Slb+o4U3EEe3BLWsBV5Sgt7Tf4JM64MhXrqiJbPF9/AwJPpKPb6tpW16qnxDI3q/mO9dlTVqEqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738778467; c=relaxed/simple;
	bh=pHvDOJ4bgYgV/rRcDVUP7oHXA/s7jDkkadCumurMcsA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TVK1YGJB1i3xGmX431DwPZrXQdN1ND2OJRAmUmJpW59FC0E28Aido095cjWDq4zgybMnOZZOBzrHlPgpIgY8AeA2CBNxxkSzkbFGnXt5Z20LOLirbtRxFyy01F+FhcTIFvidUkIyE8lmnWqkXAhw9ZLoLAvmuqDlIv4VZ6w9mGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CVVIB9vI; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CVVIB9vI"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Yp7MH1QLJzlgTwT;
	Wed,  5 Feb 2025 18:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1738778457; x=1741370458; bh=VoBaSJJofKqvbnPzJdpfhaXD
	X7PHwqyjhO95WSo4/MA=; b=CVVIB9vIahXbWke2/ZMRcoVJqoUVXh+UhQ5wcuZ8
	ucb6TJSeKFXdZ1z2S4nUplJLrYVN8ukHXcrOb/MV01siL2QyIe5oGS06a3pph8vx
	AmUz8sciu44lYY2eivfogAxFT+3IIayPbQL63aXeoVyVIx0Sooktuw1qDDUuNhMU
	1i94gWPvwJn/d8N4SkxbvZgAbX0isEhPzqxZMBHDmpUiI5JPktTY+Mz1EyL/uL0J
	vLhdzOSdYVbjBkjNsvix8kC8x0S8XtbvEOsky01Ozrbov+fdQZb7vXki5iyLOZcM
	gERLZRRu/j7zvTewtx9KnDD5AcYKi86j/g7UKosi8IWlnQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 7zw3PCjv0K0N; Wed,  5 Feb 2025 18:00:57 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Yp7MC6T9VzlgTwJ;
	Wed,  5 Feb 2025 18:00:55 +0000 (UTC)
Message-ID: <9ebbd6d9-149f-43cb-b188-bd3a6125654f@acm.org>
Date: Wed, 5 Feb 2025 10:00:54 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: critical health condition
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250204143124.1252912-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250204143124.1252912-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/25 6:31 AM, Avri Altman wrote:
> +static ssize_t critical_health_show(struct device *dev,
> +				    struct device_attribute *attr, char *buf)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +
> +	return sysfs_emit(buf, "%d\n", hba->dev_info.critical_health);
> +}

Hi Avri,

My understanding is that the UFS 4.1 standard supports reporting a
critical health event repeatedly while this patch does not allow users
to figure out whether a critical event has been reported once or
repeatedly. Has it been considered to report the number of times a
critical health event has been reported by a UFS device instead of only
one bit of information?

Thanks,

Bart.
