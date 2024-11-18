Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F7BB1DED7B
	for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2024 21:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731965895; cv=none; b=dAcdOIzk5KZL7efXWFg2+B/siAhEKtJJovxcsl8+1BZkhKCGP5qSrvy9n5tq/PZC3vlt32FZWpOZofdCbCpHbCdheCDmk7U8ieNTwbrCb07cKlzzlQ4e6FxiVeFHUQYoCLr0kRF+JmLB1FR/gta7nBiqx6xTZuAJYJOv3+jPMpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731965895; c=relaxed/simple;
	bh=itoNG9upeTqyphS0uJxQkVyvQNAb6a1PKuNNERO3hTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eqglTKB96kuR6jJ4ENFsYoyI30lCGdAZbbIS6J1oXZre+Mo36DLENRuIg0wB61gQBx9LTfCdfdGdTQH7MGkWaw7qKGkjl/jHmsMMSu7xX9d+sce7y42aN1Aw6591o/fDP2aLGYV61aI5A4KXr5uvkX9Ygi3Lip8gY8fDFc36N7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZWj17JiK reason="signature verification failed"; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZWj17JiK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731965892;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6pGb5jbEth9imQWgXuhcsQVZzJcLecxMWhpN0F9xdt0=;
	b=ZWj17JiKMt1crEGCeGGqBCoG2N9OOFoz33qC4vRfI8FKLDdXkUN4wdB8mrD5EtvYT4j89C
	AHyWx5XWCU5yllhACzO5xdDfxYM/pJPIBzXJtav1wlfHiRy83wcZpjwMrnVRZ0T2gpZGEi
	Wvb5ZBx8pmy6TE2JgsoLo9YLsu8rwiE=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-lFmbl7upMxytcCCChSv38A-1; Mon,
 18 Nov 2024 16:38:08 -0500
X-MC-Unique: lFmbl7upMxytcCCChSv38A-1
X-Mimecast-MFC-AGG-ID: lFmbl7upMxytcCCChSv38A
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 75A4219560AE;
	Mon, 18 Nov 2024 21:38:07 +0000 (UTC)
Received: from [10.22.81.39] (unknown [10.22.81.39])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 09B33195607C;
	Mon, 18 Nov 2024 21:38:05 +0000 (UTC)
Message-ID: <ed7b0142-32bc-41f8-8a89-a922796d3d62@redhat.com>
Date: Mon, 18 Nov 2024 16:38:05 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: st: Restore some drive settings after reset
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
 loberman@redhat.com
References: <20241115162003.3908-1-Kai.Makisara@kolumbus.fi>
 <20241115162003.3908-3-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20241115162003.3908-3-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

On 11/15/24 11:20, Kai Mäkisara wrote:
> Some of the allowed operations put the tape into a known position
> to continue operation, assuming only the tape position has changed.
> But reset sets partition, density and block size to drive default
> values. These should be restored to the values before reset. This
> is only done for the operations not starting a new tape session.
> 
> Normally the current block size and density are stored by the drive.
> If the settings have been changed, the changed values have to be
> saved by the driver across reset.
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/st.c | 22 ++++++++++++++++++++--
>   drivers/scsi/st.h |  2 ++
>   2 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 3acaa3561c81..0008843e33a8 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -955,7 +955,6 @@ static void reset_state(struct scsi_tape *STp)
>   		STp->partition = find_partition(STp);
>   		if (STp->partition < 0)
>   			STp->partition = 0;
> -		STp->new_partition = STp->partition;
>   	}
>   }
>   
> @@ -2928,14 +2927,17 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
>   		if (cmd_in == MTSETDENSITY) {
>   			(STp->buffer)->b_data[4] = arg;
>   			STp->density_changed = 1;	/* At least we tried ;-) */
> +			STp->changed_density = arg;
>   		} else if (cmd_in == SET_DENS_AND_BLK)
>   			(STp->buffer)->b_data[4] = arg >> 24;
>   		else
>   			(STp->buffer)->b_data[4] = STp->density;
>   		if (cmd_in == MTSETBLK || cmd_in == SET_DENS_AND_BLK) {
>   			ltmp = arg & MT_ST_BLKSIZE_MASK;
> -			if (cmd_in == MTSETBLK)
> +			if (cmd_in == MTSETBLK) {
>   				STp->blksize_changed = 1; /* At least we tried ;-) */
> +				STp->changed_blksize = arg;
> +			}
>   		} else
>   			ltmp = STp->block_size;
>   		(STp->buffer)->b_data[9] = (ltmp >> 16);
> @@ -3635,6 +3637,22 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
>   				goto out;
>   			}
>   			reset_state(STp); /* Clears pos_unknown */
> +
> +			/* Fix the device settings after reset, ignore errors */
> +			if (mtc.mt_op == MTREW || mtc.mt_op == MTSEEK ||
> +				mtc.mt_op == MTEOM) {
> +				if (STp->can_partitions) {
> +					/* STp->new_partition contains the
> +					 *  latest partition set
> +					 */
> +					STp->partition = 0;
> +					switch_partition(STp);
> +				}
> +				if (STp->density_changed)
> +					st_int_ioctl(STp, MTSETDENSITY, STp->changed_density);
> +				if (STp->blksize_changed)
> +					st_int_ioctl(STp, MTSETBLK, STp->changed_blksize);
> +			}
>   		}
>   
>   		if (mtc.mt_op != MTNOP && mtc.mt_op != MTSETBLK &&
> diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
> index 7a68eaba7e81..2105c6a5b458 100644
> --- a/drivers/scsi/st.h
> +++ b/drivers/scsi/st.h
> @@ -165,12 +165,14 @@ struct scsi_tape {
>   	unsigned char compression_changed;
>   	unsigned char drv_buffer;
>   	unsigned char density;
> +	unsigned char changed_density;
>   	unsigned char door_locked;
>   	unsigned char autorew_dev;   /* auto-rewind device */
>   	unsigned char rew_at_close;  /* rewind necessary at close */
>   	unsigned char inited;
>   	unsigned char cleaning_req;  /* cleaning requested? */
>   	int block_size;
> +	int changed_blksize;
>   	int min_block;
>   	int max_block;
>   	int recover_count;     /* From tape opening */

