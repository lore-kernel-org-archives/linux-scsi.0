Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CBC1A255C
	for <linux-scsi@vger.kernel.org>; Mon,  5 May 2025 16:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746463870; cv=none; b=OX43whwHyjs2MU4FFIm3RzFX4LbaPSc6mQQWm3cOA7lx2vhspXKq0nGUDPM9Abtb/oZsNWOCqD+byW4m2Xd+JEwqDIJ2pElnFUu9+Vr+ZViX1sEt3FCsKNQaTsIs6ZNJt1wEp7LDqtGLbFEC+xOnRFViyXPSxnhgB0S8iZLJUB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746463870; c=relaxed/simple;
	bh=KbIGorI8WHb1WSmgVpWroLMOZYwgvzGhLbK2h4oVJD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PaaTjeprxDz/HNdz8/o0FH6sp1Yf05083sejnXwQyxASo3pwWJXgINFvP0kDjG6IOQTuO/0s6wcIbw4jQDlvvSJaYvYGf0QZuPneA1juw0LvOf8/XQgqk+2a1cJrH7+RbT2MiE/w/Ebz74XcfIc7LZSNnKjpuCj8Nx4Z+xsiEn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=eLi2gotZ; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="eLi2gotZ"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZrnbZ37XHzlgqTw;
	Mon,  5 May 2025 16:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1746463865; x=1749055866; bh=dOSFEKWDxjZ2ZHKyMTZbRm0e
	BVSR8njufkHwpEqppXo=; b=eLi2gotZ93W5o7OreYv60woebPMXabSRFpabvJ6/
	YjUkCSvTH2x9NSJzLQVztMhkwSlkhXhFWJH1nETBcoPFnYcpEj2GdaZrzP3Y1r5I
	an8LEdZXM8t54ex2Eq2zcebPGAHLVIMwfyZJsQzuEyvDJf3hWQja7r0dFs5DYXk4
	kko+PftUJ7wkz35kzkl6svi5Twrgs5/QinttgG+V1jnUMia2XR1KpojLyon45Us+
	YrGNWWvwspASGfhVMMqYSObmJS2bmMOkDVnEezXAi6x8cnbQkT+KDCclaO1o77me
	JfB5QvwD08R9r0oytvjSZGpp20B9DJhd78Y0mw2tkDV5UA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id iOYML4LnWyuA; Mon,  5 May 2025 16:51:05 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZrnbT6v4lzlgqVX;
	Mon,  5 May 2025 16:51:01 +0000 (UTC)
Message-ID: <e165d4e8-403f-4720-a005-7808108d5ee9@acm.org>
Date: Mon, 5 May 2025 09:50:59 -0700
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
Cc: linux-scsi@vger.kernel.org, "Gustavo A. R. Silva"
 <gustavoars@kernel.org>, John Garry <john.g.garry@oracle.com>
References: <20250505060640.3398500-1-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250505060640.3398500-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/4/25 11:06 PM, Christoph Hellwig wrote:
> Having a variable length array at the end of scsi_stream_status_header
> only cause problems.  Remove it and switch sd_is_perm_stream which is
> the only place that currently uses it to use the scsi_stream_status
> directly following it in the local buf structure.
> 
> Besides being a much better data structure design, this also avoids
> a -Wflex-array-member-not-at-end warning.
> 
> Reported-by: "Gustavo A. R. Silva" <gustavoars@kernel.org>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/scsi/sd.c         | 2 +-
>   include/scsi/scsi_proto.h | 3 +--
>   2 files changed, 2 insertions(+), 3 deletions(-)
> 
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
> index aeca37816506..f64385cde5b9 100644
> --- a/include/scsi/scsi_proto.h
> +++ b/include/scsi/scsi_proto.h
> @@ -346,10 +346,9 @@ static_assert(sizeof(struct scsi_stream_status) == 8);
>   
>   /* GET STREAM STATUS parameter data */
>   struct scsi_stream_status_header {
> -	__be32 len;	/* length in bytes of stream_status[] array. */
> +	__be32 len;	/* length in bytes of following payload */
>   	u16 reserved;
>   	__be16 number_of_open_streams;
> -	DECLARE_FLEX_ARRAY(struct scsi_stream_status, stream_status);
>   };
>   
>   static_assert(sizeof(struct scsi_stream_status_header) == 8);

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
