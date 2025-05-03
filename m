Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E28A2DC789
	for <linux-scsi@vger.kernel.org>; Sat,  3 May 2025 19:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746299155; cv=none; b=LXitfNX45sWs2cuCWC9xYpTU/wB4d313srUP6LSFIlnPLX30rprXbC6YYBIynOeLqa16nDj4/I/oP/5ne1GOkooylhPWlH7/ur0bDuHYoyUjYWKaZKitEyTuXu9tmImiu1JNBCOiuHv6FecnGSWXJbVBvdLK26OV76nWQUcTDPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746299155; c=relaxed/simple;
	bh=Y2yVz4sQqYZgMzOo8MWOjj/OA6fRyd3tT8PDGg28V+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=msNd6UMNsdlQzXOUtLZDSGo+eviMq6WV2d3CjkeEujwrkVK82DZsY2DTRWejdZ4ExlHXES6x968U+/eiy5MeJAhnu0+vDaNdJ88oDO9p31WM/5YY2LOOGUHLoiznrsHKHhcQA+UhchKxt7GDwa1+sTarQZzkwxGZq2vJlF++UkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VMVHn0Gl; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VMVHn0Gl"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4Zqch01qGmzlgqW1;
	Sat,  3 May 2025 19:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1746299151; x=1748891152; bh=t/7tzV3vIMoyyqeaLr8Op289
	8lp/C/y91BXTDRHi+9E=; b=VMVHn0GlVzGNN7XAgT36FonRHnmYQ4DcNjXAASxp
	cyPDvC6fnl95Yp76Uw4K+iLwxn3aP+ycuk+9nbEaC2TDfmpZYjV63q5YsoKv8iQv
	msNMFbhSzQDlBCStGIspKBpgkIuwjj9nXm+YqNPoTa/nQEbYrAPIsSkGgwKGa3/H
	MlWhTIpfw4s5DCUNvU0vbUqFTeRbaV8xJc5UzrPnR0iypiKSE1DIkWOxdbHut/2I
	n4KZwi0OuE4skUp8oZ7wSTs4sg3M2Hw8svhmbsLS2WHzOTvjFXUPteWki5MScbwz
	0caxucEQn2Qo9B9qr7aWLLniY8BsexDcbBtMF0PdquuY/w==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 04Hp65i91d-x; Sat,  3 May 2025 19:05:51 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Zqcgx0QkgzlgqTv;
	Sat,  3 May 2025 19:05:47 +0000 (UTC)
Message-ID: <399f47d3-2a78-4321-98c0-990f35dc0f9a@acm.org>
Date: Sat, 3 May 2025 12:05:46 -0700
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
> Having a variable length array at the end of scsi_stream_status_header
> only cause problems.  Remove it and switch the one place that actually
> used it to use the struct member directly following in the actual on-disk
> structure instead.

"on-disk" is misleading since these data structures should not be stored
on the storage medium.

> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 950d8c9fb884..3f6e87705b62 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3215,7 +3215,7 @@ static bool sd_is_perm_stream(struct scsi_disk *sdkp, unsigned int stream_id)
>   		return false;
>   	if (get_unaligned_be32(&buf.h.len) < sizeof(struct scsi_stream_status))
>   		return false;
> -	return buf.h.stream_status[0].perm;
> +	return buf.s.perm;
>   }
>   
>   static void sd_read_io_hints(struct scsi_disk *sdkp, unsigned char *buffer)
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
>   
>   static_assert(sizeof(struct scsi_stream_status_header) == 8);

There is an implicit assumption behind this patch, namely that the 
compiler does not insert padding bytes between struct
scsi_stream_status_header and struct scsi_stream_status. Shouldn't this 
be made explicit with a BUILD_BUG_ON() expression?

Thanks,

Bart.
