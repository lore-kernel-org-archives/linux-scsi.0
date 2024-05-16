Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF321474C6;
	Thu, 16 May 2024 14:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715869039; cv=none; b=HOSMsu0qlosBnwTOSPlyOB4OWgRs8mhdHKFS2wpzuag/luB+FaNQyZ4nXExLk7DwiJ/S3Hek+xkjIdMnZWJ7NuvE/2EFoTNA/oN+AoKTxGXR73pt9a49Yl3l3+myaXXqCo4CEmE8Ruuf85guqYPJ65VK612rKPX2sIuQY4T+J3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715869039; c=relaxed/simple;
	bh=vuGen6pBZFDSpFlQAM7glOJYA6AoeXmKysq5Rr1LfXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=amJSH1EmuzX5L8lG5Jh12+woO51Wk24k7ks1J0GYSPS6NSABHibNvAeGVfjKQAWCKm/FoDwHZCqCyFpUhDeuk8fBujHqOyThxn6ECUpvo4N6mTTOqdPehQh3LRENuYYlkIl8sxLXXEpRbv4q2ObaZ/X70dALbmE5oQob4xYlwQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=C57+4asW; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="C57+4asW"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4VgBxT0RNCzlgMVL;
	Thu, 16 May 2024 14:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1715869035; x=1718461036; bh=DIahbDSpuDRG5+a9rEtREKP7
	+qLiKp27MuyfzJgoL7U=; b=C57+4asWP6YaRdtoCSPHv+Y1Z6isoVJoi5/I0U0w
	FU6VPJZsQfgpGhI6+7UsvC6Zb6tVec+5C+I6Dy+1wW2fa8MjBarKX4gRW7nOa7RK
	kPXfadsHjzry1JI/u1f2hGiLDWhsCSPUvVT4vHqrAblOsazFxXNqgTSN5H29UTjm
	NsnsfuMlWDc4b8+6KY+B3wQtJGfK5yZiQqmWvzon8NuZDE8y1+K2+jO76H0jp3kD
	EdgthzIxjC3y4xs3yyQljXKrX+FhZm/J21KzVGWMLwmRggVTlyZHc35FmTlR19vE
	QMy6MzL9i9CMdf/h1iP7LLAH05l2BIJvVjbBDsLvV+pnTA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ZAlx0itUAQNB; Thu, 16 May 2024 14:17:15 +0000 (UTC)
Received: from [172.20.0.79] (unknown [8.9.45.205])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4VgBxQ2N5nzlgT1K;
	Thu, 16 May 2024 14:17:14 +0000 (UTC)
Message-ID: <054739a5-f38c-4756-b248-94dfb6bad916@acm.org>
Date: Thu, 16 May 2024 08:17:13 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] scsi: ufs: sysfs: Make max_number_of_rtt
 read-write
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bean Huo <beanhuo@micron.com>, Peter Wang <peter.wang@mediatek.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240516055124.24490-1-avri.altman@wdc.com>
 <20240516055124.24490-4-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240516055124.24490-4-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/24 23:51, Avri Altman wrote:
> +static ssize_t max_number_of_rtt_store(struct device *dev,
> +				     struct device_attribute *attr,
> +				     const char *buf, size_t count)
> +{
> +	struct ufs_hba *hba = dev_get_drvdata(dev);
> +	unsigned int rtt;
> +	int ret;
> +
> +	if (kstrtouint(buf, 0, &rtt))
> +		return -EINVAL;
> +
> +	down(&hba->host_sem);
> +	if (!ufshcd_is_user_access_allowed(hba)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	ufshcd_rpm_get_sync(hba);
> +	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_WRITE_ATTR,
> +		QUERY_ATTR_IDN_MAX_NUM_OF_RTT, 0, 0, &rtt);
> +	ufshcd_rpm_put_sync(hba);
> +
> +out:
> +	up(&hba->host_sem);
> +	return ret < 0 ? ret : count;
> +}

Since modifying RTT is only allowed while no commands are in progress,
shouldn't max_number_of_rtt_store() freeze and unfreeze all request
queues of all logical units?

Thanks,

Bart.

