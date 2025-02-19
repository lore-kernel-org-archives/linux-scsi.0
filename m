Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B2723DEB6
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 21:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740002288; cv=none; b=DTkFuq/iLTTPK2fHvHZRB7bse+gkK8RUjUrSlJNMu9HN0RZHIfIl3MovieA9zGnO9sNS0wQiUHAT0S61B40/vCQhQslTaBBGg3dPYVc0eB1mJ2Z4CnGVg8n1NKeiHNLAXTuJrsglu3ZAqK15iLi1pQocdGgQePJSWvh/CJNLO10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740002288; c=relaxed/simple;
	bh=J3XlO+8j4R6eILGiphxJmK4Tgx6wMlpfa1jzpKRNggg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fitVaPxbBXYjEE+ox4nLAOdLNn9WcyUT5pXXc8cA6Y0vYXVw+hd2qR+v3CXadoyMK9i/5JwCI4D3DbU5ZEOvAzfwcnv8+Z1IOrYNqahxd219E0QFFm70QSuRTHFDak8LgTJpCDSeyn65QpCliB4iRokk0uLvL04TvcOotKNf3/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BUVaC+tt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BUVaC+tt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740002285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Zusfwcy86w2TLIzK+OXY/trfsMVcmY+ydm6n2Z/RgRg=;
	b=BUVaC+ttFVAkaX+9b0HvCVNvI75eyisp+Q6tXJmo7Qs1YMlbyXiHuJnaA2XB87k4V20UUc
	oB6ShyW/uLW1r+yj0yh7LU48DNbDxYE1HhcpAL6DxM08M+eh6GbdHivI5SAFMXO09MXEZ9
	ALT0M0pdb0qDFKx81n9v7Bj/MSFvtUg=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-186-u2xEeXNiOf2kdtRptq1ADQ-1; Wed,
 19 Feb 2025 16:58:04 -0500
X-MC-Unique: u2xEeXNiOf2kdtRptq1ADQ-1
X-Mimecast-MFC-AGG-ID: u2xEeXNiOf2kdtRptq1ADQ_1740002283
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 19FEF180034E;
	Wed, 19 Feb 2025 21:58:03 +0000 (UTC)
Received: from [10.22.65.116] (unknown [10.22.65.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 615B430001A6;
	Wed, 19 Feb 2025 21:58:01 +0000 (UTC)
Message-ID: <f81d5709-ec8a-4d3a-a37e-e9c9a60f5099@redhat.com>
Date: Wed, 19 Feb 2025 16:58:00 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/7] scsi: scsi_debug: Add compression mode page for
 tapes
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org, dgilbert@interlog.com
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
References: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
 <20250213092636.2510-6-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250213092636.2510-6-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

On 2/13/25 4:26 AM, Kai Mäkisara wrote:
> Add support for compression mode page. The compression status
> is saved and returned. No UA is generated.
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/scsi_debug.c | 33 +++++++++++++++++++++++++++++++++
>   1 file changed, 33 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 29a9aea30d22..0a5cd35c41de 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -405,6 +405,7 @@ struct sdebug_dev_info {
>   	unsigned int tape_density;
>   	unsigned char tape_partition;
>   	unsigned char tape_nbr_partitions;
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
> @@ -2983,6 +2998,12 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
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
> @@ -3143,6 +3164,14 @@ static int resp_mode_select(struct scsi_cmnd *scp,
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
> @@ -3158,6 +3187,10 @@ static int resp_mode_select(struct scsi_cmnd *scp,
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

