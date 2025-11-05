Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0407246766
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 17:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762364068; cv=none; b=CmTIC6AVN2SL0sh69BNVEfs9NX33GK9/RbEodnYzUJAt+7h9Ec90h33dljyKO4sd3eVnhcfTZ2bN/jpwTye2yVwH2pWhJlGHuGRAzirJCtYAvoPTxBf2b5I3cTCO8UmegCzc0QsRYeqTbM5T54f8z86wO84z07Q6SGYCuebbDdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762364068; c=relaxed/simple;
	bh=n8WXqADTz428irdvd/AYWJTZKs7jj6J/ZchPP/j6DkA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AH3qBvEQgnKYqIJtNt4EsK24KD3kXIGrvEbR6dndABetbGoqvd7EByCH73XbV+oHcOlbE5rSJmpkM1/n+za2wwwKGvx2tLBSJFI+R8+LEPMcLTzONZ/xZcwwR2wLKNcASWqb7pJOMC7NS486xhbeF3+TsmZfKXLsWD5d4k8pX38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UfXKvR7L; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UfXKvR7L"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762364065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iK8ECJzxs2aZnh6FlhO8aYnZps0ddg1fkHKWYTPd7uk=;
	b=UfXKvR7LURHxLnK271r3gYzngFJdjEhhIZyS3dVBzedBU/AWtZAMe03GJVbyEtCorJdhNr
	fZyfw8JATHXVJ6EhodQh1xfp5rgjDxjgvMaRzwTfLREMNWbk8745uCNn9wvedEzjlyYUWl
	V4X8/mBBh2p5Qii5rISQp+Kvmk08mfg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-274-z-UKz8i2OSeHWNYHxYcjoA-1; Wed,
 05 Nov 2025 12:34:20 -0500
X-MC-Unique: z-UKz8i2OSeHWNYHxYcjoA-1
X-Mimecast-MFC-AGG-ID: z-UKz8i2OSeHWNYHxYcjoA_1762364059
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DAA7B1954B00;
	Wed,  5 Nov 2025 17:34:18 +0000 (UTC)
Received: from [10.22.88.66] (unknown [10.22.88.66])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8750E300018D;
	Wed,  5 Nov 2025 17:34:17 +0000 (UTC)
Message-ID: <60d25046-036e-45fc-aca9-f924f64da76d@redhat.com>
Date: Wed, 5 Nov 2025 12:34:16 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] st: skip buffer flush for information ioctls
To: David Jeffery <djeffery@redhat.com>,
 =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Laurence Oberman <loberman@redhat.com>, linux-scsi@vger.kernel.org
References: <20251104154709.6436-1-djeffery@redhat.com>
 <20251104154709.6436-2-djeffery@redhat.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20251104154709.6436-2-djeffery@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

I've reviewed and tested this patch and it correctly fixes the problem.

Kia, please approve this patch.

Martin, please merge these two patches.

/John

On 11/4/25 10:46 AM, David Jeffery wrote:
> With commit 9604eea5bd3a ("scsi: st: Add third party poweron reset handling")
> some customer tape applications fail from being unable to complete ioctls
> to verify ID information for the device when there has been any type of
> reset event to their tape devices.
> 
> The st driver currently will fail all standard scsi ioctls if a call to
> flush_buffer fails in st_ioctl. This causes ioctls which otherwise have no
> effect on tape state to succeed or fail based on events unrelated to the
> requested ioctl.
> 
> This makes scsi information ioctls unreliable after a reset even
> if no buffering is in use. With a reset setting the pos_unknown field,
> flush_buffer will report failure and fail all ioctls. So any application
> expecting to use ioctls to check the identify the device will be unable to
> do so in such a state.
> 
> For scsi information ioctls, avoid the need for a buffer flush and allow
> the ioctls to execute regardless of buffer state.
> 
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Tested-by:     Laurence Oberman <loberman@redhat.com>
> ---
> 
>   drivers/scsi/st.c | 40 ++++++++++++++++++++++------------------
>   1 file changed, 22 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 87f0e303fdd6..d4d2c8e3f912 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -3542,30 +3542,34 @@ static long st_common_ioctl(struct scsi_tape *STp, struct st_modedef *STm,
>   		goto out;
>   	}
>   
> -	if ((i = flush_buffer(STp, 0)) < 0) {
> -		retval = i;
> -		goto out;
> -	} else { /* flush_buffer succeeds */
> -		if (STp->can_partitions) {
> -			i = switch_partition(STp);
> -			if (i < 0) {
> -				retval = i;
> -				goto out;
> -			}
> -		}
> -	}
> -	mutex_unlock(&STp->lock);
> -
>   	switch (cmd_in) {
> +	case SCSI_IOCTL_GET_IDLUN:
> +	case SCSI_IOCTL_GET_BUS_NUMBER:
> +	case SCSI_IOCTL_GET_PCI:
> +		break;
>   	case SG_IO:
>   	case SCSI_IOCTL_SEND_COMMAND:
>   	case CDROM_SEND_PACKET:
> -		if (!capable(CAP_SYS_RAWIO))
> -			return -EPERM;
> -		break;
> +		if (!capable(CAP_SYS_RAWIO)) {
> +			retval = -EPERM;
> +			goto out;
> +		}
> +		fallthrough;
>   	default:
> -		break;
> +		if ((i = flush_buffer(STp, 0)) < 0) {
> +			retval = i;
> +			goto out;
> +		} else { /* flush_buffer succeeds */
> +			if (STp->can_partitions) {
> +				i = switch_partition(STp);
> +				if (i < 0) {
> +					retval = i;
> +					goto out;
> +				}
> +			}
> +		}
>   	}
> +	mutex_unlock(&STp->lock);
>   
>   	retval = scsi_ioctl(STp->device, file->f_mode & FMODE_WRITE,
>   			    cmd_in, (void __user *)arg);

