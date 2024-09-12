Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6765684;
	Thu, 12 Sep 2024 01:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726104730; cv=none; b=eOzJpxT3UQDuPZ9GcgXgN3RwhbUAv4N3KTWEJVhDISUBKPiOsBFOVihbVL4VXlKpXXaN0F/vyQsKUdQxe/sBZz1NDj9ydqOtBf1/ZCDflvwifYzjUzSHiwdIJjBHhFOMe4wjQ+qSoIzz65VbjJ7Wgu/alnge4zqNAHb+PAnsRMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726104730; c=relaxed/simple;
	bh=02RKLivhx3YcJ+Yytua9aGRaixYRj/aHQu3H0kMrXYg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QGpKbWY9prJQq3PVxf+Osg85+cgW8nwwkq/E8IheKb9hGMkCGCtBNsVNoR+6amOuiheeaOpkZsRA3tqxM3x7wyjcL87IckCKcykBfvdMesMph7Y10yxydcQmGnRhtUrPQJfipJT6GO1uF4oEqUSONF4nUPCnH6zblqktA3MyamY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eOQtrzZC; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eOQtrzZC"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4X40Kh3VJqz6ClY94;
	Thu, 12 Sep 2024 01:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1726104726; x=1728696727; bh=A4IFHD2bgumyn15Psby8zd33
	93rJ5zZZP0BtK+yAFl4=; b=eOQtrzZCgZgE+gEp4Q3jhwMPGDGPOHghNseQml/g
	VowTdiCt2iVJQY+SVdIYFUBZMjlg7pxpNHpc1kzmb+lvJzmk4P8ndFYq9DLFUsUB
	aRcOv7z2OfZVRpNWnqUWHX/NweH/0drATHyfUX0i10oMwEOXoVAZbmZhOJi3UPP9
	PZhFU8n5LLoL8WKVQBxVRJkEYr/6aE4nbqATXjtaFtxe6ZCTEqIcrT7UBwlv7DAy
	+WrBas9LUckQk9q6He54+IasnJb/jFM6+U98pJnursbBtWHj8Qb2w1MQgEpqBezH
	6Ah0xvfdikXvyrtAWeRcIltYMUQ6/9d+fvfjW+Uxzss66w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id DfU3nvbYkfes; Thu, 12 Sep 2024 01:32:06 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4X40Kd3bQSz6ClY93;
	Thu, 12 Sep 2024 01:32:05 +0000 (UTC)
Message-ID: <e19fc109-9711-4a3d-9aaf-4a7159946a2b@acm.org>
Date: Wed, 11 Sep 2024 18:32:03 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Zero utp_upiu_req at the beginning of each
 command
To: Avri Altman <avri.altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240911053951.4032533-1-avri.altman@wdc.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240911053951.4032533-1-avri.altman@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/10/24 10:39 PM, Avri Altman wrote:
> +static void zero_utp_upiu(struct utp_upiu_req *req)
> +{
> +	memset(&req->utp_upiu, 0, sizeof(req->utp_upiu));
> +}

Introducing a function that only calls memset() seems like overkill to
me. Please call memset() directly.

> diff --git a/include/uapi/scsi/scsi_bsg_ufs.h b/include/uapi/scsi/scsi_bsg_ufs.h
> index 8c29e498ef98..b0d60d54d6c9 100644
> --- a/include/uapi/scsi/scsi_bsg_ufs.h
> +++ b/include/uapi/scsi/scsi_bsg_ufs.h
> @@ -162,11 +162,13 @@ struct utp_upiu_cmd {
>    */
>   struct utp_upiu_req {
>   	struct utp_upiu_header header;
> -	union {
> -		struct utp_upiu_cmd		sc;
> -		struct utp_upiu_query		qr;
> -		struct utp_upiu_query		uc;
> -	};
> +	struct_group(utp_upiu,
> +		union {
> +			struct utp_upiu_cmd	sc;
> +			struct utp_upiu_query	qr;
> +			struct utp_upiu_query	uc;
> +		};
> +	);
>   };

Is the above change perhaps independent of the rest of this patch? I
think that this change can be left out.

Thanks,

Bart.

