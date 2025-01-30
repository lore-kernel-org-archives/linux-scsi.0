Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98C11F0E45
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738260843; cv=none; b=jI5oJlePAQIoIhvTlLv3a+DCZkJKi/NACHw52tMo8ONcaeTBoWWaEX1IUPH8EjfNt7RClB5vOzMN/NqFM1hp70O9ce390vg2T9HgDhDLg2GUhBgzmyMmFIS5LZB68x9UsaIjIBm6c2tjEASxodNhgYxsJXoKbgSS2+YNJ50MAW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738260843; c=relaxed/simple;
	bh=tINOcTe+ZfUyfPBY9LFfs/ZK78CUEsbsC9hqPNEdlsA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kAieyjreENhXXgm5h99AuUwYYVwATiLM8a/8REpukYRd3DdLp6ELhehTrpP+wxT4tdchAzhPnErp+Oj+GeHK7j+DD8bEXlNzVtFqqvqzlxQkfy3qozsq+S/TzqogXMnx3E2yO5DsRQWwhbKKGuxNDEVGx6onWPzmkHUuJTuQT+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=fail (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ak0YdjpI reason="signature verification failed"; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ak0YdjpI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738260840;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RTanVCYNIvEcHCeSppjdWvys1KSUreh5uOBMY6z9bts=;
	b=ak0YdjpI7Jt+NHjoEtIM3YQkJWmmqKC6ntmGe936AbT+UdC0wM6zx2fnHpG87iEz0gl4YN
	XEqW2PhHeMwzAzcfpabfBOeLO19ir8aqdqSFbeW3TyWGkAzZRZ50P5Hanwd27F53P76bpZ
	0CmoOC8YDfegJtQJM2F+uzmVE1BY3fg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-82-Q-s7kGQ4OEWDDU9Arq3_yg-1; Thu,
 30 Jan 2025 13:13:58 -0500
X-MC-Unique: Q-s7kGQ4OEWDDU9Arq3_yg-1
X-Mimecast-MFC-AGG-ID: Q-s7kGQ4OEWDDU9Arq3_yg
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DA060180036E;
	Thu, 30 Jan 2025 18:13:57 +0000 (UTC)
Received: from [10.17.16.215] (unknown [10.17.16.215])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E1A721800358;
	Thu, 30 Jan 2025 18:13:56 +0000 (UTC)
Message-ID: <e9b1006a-078b-476e-949a-8fd6e62d72cc@redhat.com>
Date: Thu, 30 Jan 2025 13:13:55 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/4] scsi: st: Restore some drive settings after reset
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, loberman@redhat.com
References: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
 <20250120194925.44432-2-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250120194925.44432-2-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

I've tested this patch out and it works as expected.

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

On 1/20/25 2:49 PM, Kai Mäkisara wrote:
> Some of the allowed operations put the tape into a known position
> to continue operation assuming only the tape position has changed.
> But reset sets partition, density and block size to drive default
> values. These should be restored to the values before reset.
> 
> Normally the current block size and density are stored by the drive.
> If the settings have been changed, the changed values have to be
> saved by the driver across reset.
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index ebbd50ec0cda..0fc9afe60862 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
>   
> @@ -2930,14 +2929,17 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
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
> @@ -3636,9 +3638,25 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
>   				retval = (-EIO);
>   				goto out;
>   			}
> -			reset_state(STp);
> +			reset_state(STp); /* Clears pos_unknown */
>   			/* remove this when the midlevel properly clears was_reset */
>   			STp->device->was_reset = 0;

I see we are still clearing the mid layer was_reset flag here.  Is there any way we can remove this in a future patch?

/John

