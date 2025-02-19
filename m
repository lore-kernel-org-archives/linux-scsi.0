Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61ACA9460
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 16:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739981047; cv=none; b=ERebbV/acpkKMciNpC1PW44omnxsOf6OmZFXpfXFNU/YoJo0twp87UZLSxaAJhxNAqJJEuLreQ4n+lzXthIIy8WieSitw1RiLen3t2tV62H172mDTJL7pE5UY1RSXtcav4Znixr1W/5s8fbxjzGdj6M/+jvG69z3EKCgVkOUUcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739981047; c=relaxed/simple;
	bh=ozmzW2aBNEgo4qh1Ow+EHOw5i3vYY/gQ7sir0jNZ4DQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YYk3g+xNJ27UPMqTdeg0C/n5F3xu8M6S64btELoZyKsxQlV1Ar7ycXMtJQfHMZccDm1TEwOZeFZbDwh2DcrGg+QzJFUuBcnL+oI3PDG93JCmrHwqnjOs12uVm3ZUiumTZy+dNxFUfWl0uKICbsd4+uJavGBnZxf3lcEz+BhWYEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gtivH0L3; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gtivH0L3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739981044;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iJ06mNez4jeNzHYLcRzIXsqw+XpkhnkM3xAxPQqxRu4=;
	b=gtivH0L3lbzBpp8KGfPfwdxm8Z9pqtz+4Vj8S3AjE+PthzO1bRs60iOn2oJTllloqGyczQ
	l3BCO8XCJX8CPV5hXpwkYrCGNPt9jmBvMknkba4ki45QvvNEAlqubsJ6msK9c5/dEExzxN
	eyCJXnP7TTcZ+paHFMmxdLrkjrq/1JA=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-679-n-y3Ei_rPLSWt44Tmn_WDg-1; Wed,
 19 Feb 2025 11:04:00 -0500
X-MC-Unique: n-y3Ei_rPLSWt44Tmn_WDg-1
X-Mimecast-MFC-AGG-ID: n-y3Ei_rPLSWt44Tmn_WDg_1739981039
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8AFBF18EB2CE;
	Wed, 19 Feb 2025 16:03:59 +0000 (UTC)
Received: from [10.22.65.116] (unknown [10.22.65.116])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 00EC71956094;
	Wed, 19 Feb 2025 16:03:57 +0000 (UTC)
Message-ID: <a6611656-4713-41f4-b881-d694fea34376@redhat.com>
Date: Wed, 19 Feb 2025 11:03:56 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/7] scsi: scsi_debug: First fixes for tapes
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org, dgilbert@interlog.com
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
References: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
 <20250213092636.2510-2-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250213092636.2510-2-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

These patches are particularly important because the REWIND command
now works when using the scsi_debug driver with the st.c.

The problem was so bad I had to remove "mt rewind" from my scsi_debug tape tests.
With this patch I've added "mt rewind" back to my tests.

Thanks!

On 2/13/25 4:26 AM, Kai Mäkisara wrote:
> Patch includes the following:
> - enable MODE SENSE/SELECT without actual page (to read/write only
>    the Block Descriptor)
> - store the density code and block size in the Block Descriptor
>    (only short version for tapes)
> - fix REWIND not to use the wrong page filling function
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/scsi_debug.c | 55 ++++++++++++++++++++++++++++++++++-----
>   1 file changed, 49 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 5ceaa4665e5d..4da0c259390b 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -173,6 +173,10 @@ static const char *sdebug_version_date = "20210520";
>   #define DEF_ZBC_MAX_OPEN_ZONES	8
>   #define DEF_ZBC_NR_CONV_ZONES	1
>   
> +/* Default parameters for tape drives */
> +#define TAPE_DEF_DENSITY  0x0
> +#define TAPE_DEF_BLKSIZE  0
> +
>   #define SDEBUG_LUN_0_VAL 0
>   
>   /* bit mask values for sdebug_opts */
> @@ -363,6 +367,10 @@ struct sdebug_dev_info {
>   	ktime_t create_ts;	/* time since bootup that this device was created */
>   	struct sdeb_zone_state *zstate;
>   
> +	/* For tapes */
> +	unsigned int tape_blksize;
> +	unsigned int tape_density;
> +
>   	struct dentry *debugfs_entry;
>   	struct spinlock list_lock;
>   	struct list_head inject_err_list;
> @@ -773,7 +781,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
>   /* 20 */
>   	{0, 0x1e, 0, 0, NULL, NULL, /* ALLOW REMOVAL */
>   	    {6,  0, 0, 0, 0x3, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
> -	{0, 0x1, 0, 0, resp_start_stop, NULL, /* REWIND ?? */
> +	{0, 0x1, 0, 0, NULL, NULL, /* REWIND ?? */
>   	    {6,  0x1, 0, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
>   	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* ATA_PT */
>   	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
> @@ -2742,7 +2750,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
>   	unsigned char *ap;
>   	unsigned char *arr __free(kfree);
>   	unsigned char *cmd = scp->cmnd;
> -	bool dbd, llbaa, msense_6, is_disk, is_zbc;
> +	bool dbd, llbaa, msense_6, is_disk, is_zbc, is_tape;
>   
>   	arr = kzalloc(SDEBUG_MAX_MSENSE_SZ, GFP_ATOMIC);
>   	if (!arr)
> @@ -2755,7 +2763,8 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
>   	llbaa = msense_6 ? false : !!(cmd[1] & 0x10);
>   	is_disk = (sdebug_ptype == TYPE_DISK);
>   	is_zbc = devip->zoned;
> -	if ((is_disk || is_zbc) && !dbd)
> +	is_tape = (sdebug_ptype == TYPE_TAPE);
> +	if ((is_disk || is_zbc || is_tape) && !dbd)
>   		bd_len = llbaa ? 16 : 8;
>   	else
>   		bd_len = 0;
> @@ -2793,15 +2802,25 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
>   			put_unaligned_be32(0xffffffff, ap + 0);
>   		else
>   			put_unaligned_be32(sdebug_capacity, ap + 0);
> -		put_unaligned_be16(sdebug_sector_size, ap + 6);
> +		if (is_tape) {
> +			ap[0] = devip->tape_density;
> +			put_unaligned_be16(devip->tape_blksize, ap + 6);
> +		} else
> +			put_unaligned_be16(sdebug_sector_size, ap + 6);
>   		offset += bd_len;
>   		ap = arr + offset;
>   	} else if (16 == bd_len) {
> +		if (is_tape) {
> +			mk_sense_invalid_fld(scp, SDEB_IN_DATA, 1, 4);
> +			return check_condition_result;
> +		}
>   		put_unaligned_be64((u64)sdebug_capacity, ap + 0);
>   		put_unaligned_be32(sdebug_sector_size, ap + 12);
>   		offset += bd_len;
>   		ap = arr + offset;
>   	}
> +	if (cmd[2] == 0)
> +		goto only_bd; /* Only block descriptor requested */
>   
>   	/*
>   	 * N.B. If len>0 before resp_*_pg() call, then form of that call should be:
> @@ -2902,6 +2921,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
>   	default:
>   		goto bad_pcode;
>   	}
> +only_bd:
>   	if (msense_6)
>   		arr[0] = offset - 1;
>   	else
> @@ -2945,8 +2965,27 @@ static int resp_mode_select(struct scsi_cmnd *scp,
>   			    __func__, param_len, res);
>   	md_len = mselect6 ? (arr[0] + 1) : (get_unaligned_be16(arr + 0) + 2);
>   	bd_len = mselect6 ? arr[3] : get_unaligned_be16(arr + 6);
> -	off = bd_len + (mselect6 ? 4 : 8);
> -	if (md_len > 2 || off >= res) {
> +	off = (mselect6 ? 4 : 8);
> +	if (sdebug_ptype == TYPE_TAPE) {
> +		int blksize;
> +
> +		if (bd_len != 8) {
> +			mk_sense_invalid_fld(scp, SDEB_IN_DATA,
> +					mselect6 ? 3 : 6, -1);
> +			return check_condition_result;
> +		}
> +		blksize = get_unaligned_be16(arr + off + 6);
> +		if ((blksize % 4) != 0) {
> +			mk_sense_invalid_fld(scp, SDEB_IN_DATA, off + 6, -1);
> +			return check_condition_result;
> +		}
> +		devip->tape_density = arr[off];
> +		devip->tape_blksize = blksize;
> +	}
> +	off += bd_len;
> +	if (off >= res)
> +		return 0; /* No page written, just descriptors */
> +	if (md_len > 2) {
>   		mk_sense_invalid_fld(scp, SDEB_IN_DATA, 0, -1);
>   		return check_condition_result;
>   	}
> @@ -5835,6 +5874,10 @@ static struct sdebug_dev_info *sdebug_device_create(
>   		} else {
>   			devip->zoned = false;
>   		}
> +		if (sdebug_ptype == TYPE_TAPE) {
> +			devip->tape_density = TAPE_DEF_DENSITY;
> +			devip->tape_blksize = TAPE_DEF_BLKSIZE;
> +		}
>   		devip->create_ts = ktime_get_boottime();
>   		atomic_set(&devip->stopped, (sdeb_tur_ms_to_ready > 0 ? 2 : 0));
>   		spin_lock_init(&devip->list_lock);

