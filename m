Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AE221DA5F
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 21:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738273786; cv=none; b=Sb34xYpxG3At2j9bxpCP88IhJ4C/jxZo3l+50/t8Yzw+qU2/JMfOYTG+oOGcZoLStvGSLxA8HHtVt5WNS0mXsEe97rgHoR5zsf3qBSAZetT9+nlogtvzKhw1yWCiq2CvbG3HPNWOUSyWjaEtxsL/l1a73bQumBHXYPKSajmSPRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738273786; c=relaxed/simple;
	bh=rFZE8hWtXqRX45SYebmKT2SRa49sy691EvOHuVYCFmY=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=P9v3AgkXp/4DOlCpvLgF32TbA/rb9Uad481R67FasVtWx3zkrJakwXovPdebl/t+t2ThvEwwXgoubXRwZbPp7pzcClJ7J47DlBnYl73fWn4lFzbNAUeON5btbq9+YN6MKEdbNkiT0aBE1Eavx1CQFPNnjrbycRcx4I+hRAkJMQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QW6k2LU6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QW6k2LU6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738273783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=syYVoOE6lYWegG1eCDAWqGYDO5MzvbID1HeVrsjjzF4=;
	b=QW6k2LU6KIbZFgkxg9nnuZ0yIG9DCGiWBN4BEFcCY4S6XRmTql0PTlh9wJoT5WT7dMkE4D
	kDLytCrjNlxXP+lb4WvQxvIJUA78QhyM3Ag4/kP3B/R8DrvmDFRE6Ukrf/jSFtbw3vI9J4
	lQlMwwrLAS+LMddkz4MRU6jNC2utCR4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-595-Rh2w-BsyNbmNdonjggBF0Q-1; Thu,
 30 Jan 2025 16:49:41 -0500
X-MC-Unique: Rh2w-BsyNbmNdonjggBF0Q-1
X-Mimecast-MFC-AGG-ID: Rh2w-BsyNbmNdonjggBF0Q
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5E06E180034F;
	Thu, 30 Jan 2025 21:49:40 +0000 (UTC)
Received: from [10.17.16.215] (unknown [10.17.16.215])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7642130001BE;
	Thu, 30 Jan 2025 21:49:39 +0000 (UTC)
Message-ID: <88881831-fbc0-4db8-9c72-b90293302cd3@redhat.com>
Date: Thu, 30 Jan 2025 16:49:38 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 5/6] scsi: scsi_debug: Add compression mode page for
 tapes
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org, dgilbert@interlog.com
References: <20250128142250.163901-1-Kai.Makisara@kolumbus.fi>
 <20250128142250.163901-6-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250128142250.163901-6-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

I've tested out these patches my existing tests and found no regressions.

I'll work to add a compression mode test to my tape_tests in the future.

On 1/28/25 9:22 AM, Kai Mäkisara wrote:
> Add support for compression mode page. The compression status
> is saved and returned. No UA is generated.
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/scsi_debug.c | 33 +++++++++++++++++++++++++++++++++
>   1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 912b1c6cf92d..ceacf38cee71 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -405,6 +405,7 @@ struct sdebug_dev_info {
>   	unsigned int tape_blksize;
>   	unsigned int tape_density;
>   	unsigned char tape_partition;
> +	unsigned char tape_dce;
>   	unsigned int tape_location[TAPE_MAX_PARTITIONS];
>   	unsigned int tape_eop[TAPE_MAX_PARTITIONS];
>   	struct tape_block *tape_blocks[TAPE_MAX_PARTITIONS];
> @@ -2843,6 +2844,20 @@ static int resp_partition_m_pg(unsigned char *p, int pcontrol, int target)
>   	return sizeof(partition_pg);
>   }
>   
> +static int resp_compression_m_pg(unsigned char *p, int pcontrol, int target,
> +	unsigned char dce)
> +{	/* Compression page for mode_sense (tape) */
> +	unsigned char compression_pg[] = {0x0f, 14, 0x40, 0, 0, 0, 0, 0,
> +		0, 0, 0, 0, 00, 00};
> +
> +	memcpy(p, compression_pg, sizeof(compression_pg));
> +	if (dce)
> +		p[2] |= 0x80;
> +	if (pcontrol == 1)
> +		memset(p + 2, 0, sizeof(compression_pg) - 2);
> +	return sizeof(compression_pg);
> +}
> +
>   /* PAGE_SIZE is more than necessary but provides room for future expansion. */
>   #define SDEBUG_MAX_MSENSE_SZ PAGE_SIZE
>   
> @@ -2979,6 +2994,12 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
>   		}
>   		offset += len;
>   		break;
> +	case 0xf:	/* Compression Mode Page (tape) */
> +		if (!is_tape)
> +			goto bad_pcode;
> +		len += resp_compression_m_pg(ap, pcontrol, target, devip->tape_dce);
> +		offset += len;
> +		break;
>   	case 0x11:	/* Partition Mode Page (tape) */
>   		if (!is_tape)
>   			goto bad_pcode;
> @@ -3132,6 +3153,14 @@ static int resp_mode_select(struct scsi_cmnd *scp,
>   			goto set_mode_changed_ua;
>   		}
>   		break;
> +	case 0xf:       /* Compression mode page */
> +		if (sdebug_ptype != TYPE_TAPE)
> +			goto bad_pcode;
> +		if ((arr[off + 2] & 0x40) != 0) {
> +			devip->tape_dce = (arr[off + 2] & 0x80) != 0;
> +			return 0;
> +		}
> +		break;
>   	case 0x1c:      /* Informational Exceptions Mode page */
>   		if (iec_m_pg[1] == arr[off + 1]) {
>   			memcpy(iec_m_pg + 2, arr + off + 2,
> @@ -3147,6 +3176,10 @@ static int resp_mode_select(struct scsi_cmnd *scp,
>   set_mode_changed_ua:
>   	set_bit(SDEBUG_UA_MODE_CHANGED, devip->uas_bm);
>   	return 0;
> +
> +bad_pcode:
> +	mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, 5);
> +	return check_condition_result;
>   }
>   
>   static int resp_temp_l_pg(unsigned char *arr)

