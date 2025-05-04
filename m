Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A96EAC7
	for <linux-scsi@vger.kernel.org>; Sun,  4 May 2025 03:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746328145; cv=none; b=IEELGoZ0DqElkBsKyZBGZOmxUxVzCPY4a95epYmfN+D5Q6C5nnv/9ByJxxYuH3GK6dEMS3Yy/Yh8hNg3q5gJhcUzAYLlSiRvN+ydKs57Ft6n50guwQ18BEq1rQ1eHYdYDoXmw28o0toD4YWsfk+zB6GwZU+z9gmYa9OMGaCjblM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746328145; c=relaxed/simple;
	bh=VqZwxFHeRZ8mC3oPm2jz9cNUojz4gngYFqMc7bou8DE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PM7CRqIF+YZ7iTANa/AI0bpbe8w2uQzQmK/sB3ojtUMWTdClqU5Lt7JWegkovBgY3yc1LJDpwxself2FGo6GyULxqfwfaERxxyKDGDCEPHFc1VkW95mgIcqyOqTbipaWQETHT17tBU1rcm6o8e0+DPvWRVQVtQSKLzp5UZ7TaGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EEuRJgLi; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EEuRJgLi"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZqqPV4RFpzlgqxh;
	Sun,  4 May 2025 03:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1746328141; x=1748920142; bh=aw0oTbQ5+iBPDzABtjRK1/KH
	xK8OdHXCpBToiRt7zW0=; b=EEuRJgLiPMUxE9uvcUi+XFn7cBTfv8DOsWRwNHXJ
	XkiC1J1V3ZAO76vsOTA+gb6xBCZwYhYmgr8ooG58eKK/LMJp89W+4Ff5pQvBlhmZ
	/kuAbBumRSYzPG1CR/PB6mUoCfAR1mI8j17SVZzfmpG3Hbg4AV+Qr908k5nz7thr
	Nz0fd0aqKtUciMf9k/BaY5IVENgJOkU8M/fgthGaz7v4a+kHKKrta/l9HraIHzB2
	pVduwfGdURGdkbdJBCm+t7SPtWI9jvgwJ8fR6wejITfR7VSkXxAd+Cf3TpTA5I77
	7Qf7NnCPECd/zfleznVAO7O2i7B4B9EYtqLK3k0nokT89A==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id oOi6tSlH6EGb; Sun,  4 May 2025 03:09:01 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZqqPR2ZFHzlgqxn;
	Sun,  4 May 2025 03:08:57 +0000 (UTC)
Message-ID: <1ead49d3-b541-41fa-8bc3-225d5fff3252@acm.org>
Date: Sat, 3 May 2025 20:08:56 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: remove the stream_status member from
 scsi_stream_status_header
To: Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org
References: <20250501181623.2942698-1-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250501181623.2942698-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/1/25 11:16 AM, Christoph Hellwig wrote:
> diff --git a/include/scsi/scsi_proto.h b/include/scsi/scsi_proto.h
> index aeca37816506..bc8f2b2226be 100644
> --- a/include/scsi/scsi_proto.h
> +++ b/include/scsi/scsi_proto.h
> @@ -349,7 +349,6 @@ struct scsi_stream_status_header {
>   	__be32 len;	/* length in bytes of stream_status[] array. */
>   	u16 reserved;
>   	__be16 number_of_open_streams;
> -	DECLARE_FLEX_ARRAY(struct scsi_stream_status, stream_status);
>   };

An additional note: the following comment needs to be updated since
the member it refers to is removed:

/* length in bytes of stream_status[] array. */

Bart.
