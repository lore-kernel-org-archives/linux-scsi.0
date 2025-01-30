Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6345B1EBFE2
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 17:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738259902; cv=none; b=m8nn0Kpz4haR4loxAbAaAK5yRjv/NtspTWOwYxSH6YNIdTSsUcqIXgtNl7Mzv1+R0AXpjojyOc/WZvyzChHLHeCRdLuJCTHZEPPU7TRF1zHuxoTriJNxfc/EEGB2VOJIGVO6+fn/y14Tye3oXDuxRLapev59IhXun60Bz1147ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738259902; c=relaxed/simple;
	bh=aZXBNsGkgYSUxcQvEhUvArXLIyz+PnfnaUk7aWXSLFE=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=ELhxIHiE6Mx4AR+uJh4wvOHiVifgghSpo593N/NeTQCZULHFj5yZynP7PFt9+KDbnDpYty82VkYOz579IaodBVaJEsSxRFDJ+M+z+BdV6vAcxFKKcZmRdPCjqD8jAWF1oE0xgvAJtiaLudgc6J5euPmevQJ9XCpMUeCKzGbPYY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fOgE60g6; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fOgE60g6"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738259899;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ydxIK+alm8hF5d8MwnyHoNu64i96oMQA3hvQh4mfaB0=;
	b=fOgE60g6mxcuktsNSrwfvb1+uWzyJvYj2Ysg3vDyYglWZk2CgGXeZ3SQ5+XIqjW6yBoxDM
	AhSbjClUJcP5pAuKH2XkAvS4UaL/OgxU5yMkxojxIfsuxqIndNpjFOX4cIOIs+XwrRCF6q
	7PAphcFuobRFyaqZSNqWOyMA3kv1B/4=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-103-x8JHuTJiNPijJcef-V1JXA-1; Thu,
 30 Jan 2025 12:58:14 -0500
X-MC-Unique: x8JHuTJiNPijJcef-V1JXA-1
X-Mimecast-MFC-AGG-ID: x8JHuTJiNPijJcef-V1JXA
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5A82319560BD;
	Thu, 30 Jan 2025 17:58:12 +0000 (UTC)
Received: from [10.17.16.215] (unknown [10.17.16.215])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 73ED9180035E;
	Thu, 30 Jan 2025 17:58:11 +0000 (UTC)
Message-ID: <34dbab52-c3e1-4f12-9cd5-ff3be3baf4b8@redhat.com>
Date: Thu, 30 Jan 2025 12:58:10 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/6] scsi: scsi_debug: First fixes for tapes
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org, dgilbert@interlog.com
References: <20250128142250.163901-1-Kai.Makisara@kolumbus.fi>
 <20250128142250.163901-2-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250128142250.163901-2-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

This is great.  My scsi_debug tests are no longer complaining about failing Mode Sense commands.

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

On 1/28/25 9:22 AM, Kai Mäkisara wrote:
> Patch includes the following:
> - enable MODE SENSE/SELECT without actual page (to read/write only
>    the Block Descriptor)
> - store the density code and block size in the Block Descriptor
> - fix REWIND not to use the wrong page filling function
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/scsi_debug.c | 38 +++++++++++++++++++++++++++++++++-----
>   1 file changed, 33 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 680ba180a672..00daa77f636c 100644
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
> @@ -2793,7 +2802,11 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
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
> @@ -2802,6 +2815,8 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
>   		offset += bd_len;
>   		ap = arr + offset;
>   	}
> +	if (cmd[2] == 0)
> +		goto only_bd; /* Only block descriptor requested */
>   
>   	/*
>   	 * N.B. If len>0 before resp_*_pg() call, then form of that call should be:
> @@ -2902,6 +2917,7 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
>   	default:
>   		goto bad_pcode;
>   	}
> +only_bd:
>   	if (msense_6)
>   		arr[0] = offset - 1;
>   	else
> @@ -2945,7 +2961,14 @@ static int resp_mode_select(struct scsi_cmnd *scp,
>   			    __func__, param_len, res);
>   	md_len = mselect6 ? (arr[0] + 1) : (get_unaligned_be16(arr + 0) + 2);
>   	bd_len = mselect6 ? arr[3] : get_unaligned_be16(arr + 6);
> -	off = bd_len + (mselect6 ? 4 : 8);
> +	off = (mselect6 ? 4 : 8);
> +	if (sdebug_ptype == TYPE_TAPE) {
> +		devip->tape_density = arr[off];
> +		devip->tape_blksize = get_unaligned_be16(arr + off + 6);
> +	}
> +	off += bd_len;
> +	if (res <= off)
> +		goto only_bd; /* No page written, just descriptors */
>   	if (md_len > 2 || off >= res) {
>   		mk_sense_invalid_fld(scp, SDEB_IN_DATA, 0, -1);
>   		return check_condition_result;
> @@ -2998,6 +3021,7 @@ static int resp_mode_select(struct scsi_cmnd *scp,
>   	return check_condition_result;
>   set_mode_changed_ua:
>   	set_bit(SDEBUG_UA_MODE_CHANGED, devip->uas_bm);
> +only_bd:
>   	return 0;
>   }
>   
> @@ -5835,6 +5859,10 @@ static struct sdebug_dev_info *sdebug_device_create(
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

