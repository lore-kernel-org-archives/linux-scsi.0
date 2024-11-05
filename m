Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740D52139D7
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 20:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730837583; cv=none; b=JvS6k9ncxIJ+kTfrSTqO/yGhMz9lcBGkK1Q6iR41wASHVarG5K9DQv633ziN0qHK1zPt0rniDDKZYQLwK1Q3URcPvNG2qP6FawUyoHKa+zrowHOubw5gsbxJuiyRBLsXlA5fXyetDR6LgN9uSnoJrHdK9wGGOMwm1SPBr6a/Ysw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730837583; c=relaxed/simple;
	bh=pwzETRru0DHzMsCVrqXN0BVB+GU9wD+Zy4Z/KepZ65I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g4FXM9kyOzMigHnz9B6M5oKUU42ZCccIqjZAP1RUulZ1NAbikeN0aHe9r1yRFElaFBdGGCaylRT7v8Bq/HdPnnPYwEi8pn+IuGq4YqgJKJ+iWShQs/RzgOkzb/MA+BF9mdLw0bUvSs+94XEWxcdrTrT8fXCiODrOxRs6KB2E5Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bz52qfs7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bz52qfs7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730837580;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kjc3UoGPHsJpkKNJ5Gd7btUqQlVu3XC7u0L/gmmoHUI=;
	b=bz52qfs7nOzy8NY1h5pcZ2Bc2recatPqwXypgIggZLTLq2V1GFAiNTgCcdeVq59akXoHnv
	dZc9lm+lIVXrXy3oUicxtX5IiXjQj6RKSR6q0eZ5SxAygqZlZtds6ZpUzsZ/2LhFx42WWT
	qabgrnxnj+UmIAO2WV1mt409gt9ZKlY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-154-7eGOkDSEMwatogCDgEwiRg-1; Tue,
 05 Nov 2024 15:12:57 -0500
X-MC-Unique: 7eGOkDSEMwatogCDgEwiRg-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B02D71955F41;
	Tue,  5 Nov 2024 20:12:55 +0000 (UTC)
Received: from [10.22.88.108] (unknown [10.22.88.108])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 69B691955F22;
	Tue,  5 Nov 2024 20:12:54 +0000 (UTC)
Message-ID: <9bfdc234-ae6c-4da5-a510-25f890ba6d79@redhat.com>
Date: Tue, 5 Nov 2024 15:12:53 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: st: Add MTIOCGET and MTLOAD to ioctls allowed
 after device reset
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
 loberman@redhat.com
References: <20241104112623.2675-1-Kai.Makisara@kolumbus.fi>
 <20241104112623.2675-3-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20241104112623.2675-3-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

Looks great, please merge.

On 11/4/24 06:26, Kai Mäkisara wrote:
> Most drives rewind the tape when the device is reset. Reading
> and writing are not allowed until something is done to make
> the tape position match the user's expectation (e.g.,
> rewind the tape). Add MTIOCGET and MTLOAD to operations allowed
> after reset. MTIOCGET is modified to not touch the tape if
> pos_unknown is non-zero. The tape location is known after MTLOAD.
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/st.c | 29 +++++++++++++++++++++--------
>   1 file changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 8d27e6caf027..c9038284bc89 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -3506,6 +3506,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
>   	int i, cmd_nr, cmd_type, bt;
>   	int retval = 0;
>   	unsigned int blk;
> +	bool cmd_mtiocget;
>   	struct scsi_tape *STp = file->private_data;
>   	struct st_modedef *STm;
>   	struct st_partstat *STps;
> @@ -3619,6 +3620,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
>   			 */
>   			if (mtc.mt_op != MTREW &&
>   			    mtc.mt_op != MTOFFL &&
> +			    mtc.mt_op != MTLOAD &&
>   			    mtc.mt_op != MTRETEN &&
>   			    mtc.mt_op != MTERASE &&
>   			    mtc.mt_op != MTSEEK &&
> @@ -3732,17 +3734,28 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
>   		goto out;
>   	}
>   
> +	cmd_mtiocget = cmd_type == _IOC_TYPE(MTIOCGET) && cmd_nr == _IOC_NR(MTIOCGET);
> +
>   	if ((i = flush_buffer(STp, 0)) < 0) {
> -		retval = i;
> -		goto out;
> -	}
> -	if (STp->can_partitions &&
> -	    (i = switch_partition(STp)) < 0) {
> -		retval = i;
> -		goto out;
> +		if (cmd_mtiocget && STp->pos_unknown) {
> +			/* flush fails -> modify status accordingly */
> +			reset_state(STp);
> +			STp->pos_unknown = 1;
> +		} else { /* return error */
> +			retval = i;
> +			goto out;
> +		}
> +	} else { /* flush_buffer succeeds */
> +		if (STp->can_partitions) {
> +			i = switch_partition(STp);
> +			if (i < 0) {
> +				retval = i;
> +				goto out;
> +			}
> +		}
>   	}
>   
> -	if (cmd_type == _IOC_TYPE(MTIOCGET) && cmd_nr == _IOC_NR(MTIOCGET)) {
> +	if (cmd_mtiocget) {
>   		struct mtget mt_status;
>   
>   		if (_IOC_SIZE(cmd_in) != sizeof(struct mtget)) {

