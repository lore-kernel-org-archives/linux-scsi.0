Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2FB91DA5F
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 21:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738273608; cv=none; b=ubr+qberdYcGTM5m0w6iRxZzLKIY/vbPR1sps/4jKeFpe6XmTCt81CK106rnSITTkHfJlrpV7zSHJLJPR7MsAQ++3KNfM1id1MQj2r+Aw4J5hKnG9CQfQu9rIjcdYKssDqUBRr5pcR/RbwNqFY6DFtACHO0i6uuINiXA7ECWAZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738273608; c=relaxed/simple;
	bh=a2Ct17jD0ACaZb+19EEJJ7GGDV4pL95XaBgownjpTxg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uwnyEhK1HwW0L+J/CQkqcLW9X2zj3G+5EeDd2xqnQwv2qMYXb7JgRtcAZfcFJOdZmhaZNNvYi4nkkC7lUmEVfZPOsmMGvCkUcFIk3enilkSgG+p+rJ3M5eIc5hAnrkoZ1dXnPGEisdHhPBrArPxwb4eCoX8GdfN3dWGKqF6ovGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KwRYs/O7; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KwRYs/O7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738273605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/nh8EjxbyfpUh6Y3o9KtsriWcD8Nr+myZj1GoxpL/pM=;
	b=KwRYs/O7OL6dltsXd3gjc4AeP0eZrTjIB+4IzGvNoGcz95Q3GndSzm/hdXBWjUrKYf2k+r
	R/5HonQ8pJPdjdvNrlsxvTnQGZt4GYSLex00nWQA98h6WmCfJBOYlOhYMEbRsDcRsST/6y
	GHcd6+wqzkGyRV2LWsu5ALfz8sMV5Vg=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-594-pTZYzJW1Puq5xtvckC9Nzg-1; Thu,
 30 Jan 2025 16:46:41 -0500
X-MC-Unique: pTZYzJW1Puq5xtvckC9Nzg-1
X-Mimecast-MFC-AGG-ID: pTZYzJW1Puq5xtvckC9Nzg
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 566E61956087;
	Thu, 30 Jan 2025 21:46:40 +0000 (UTC)
Received: from [10.17.16.215] (unknown [10.17.16.215])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4961319560A3;
	Thu, 30 Jan 2025 21:46:38 +0000 (UTC)
Message-ID: <c7c055af-9ed1-4772-a0c2-a1e9091df21b@redhat.com>
Date: Thu, 30 Jan 2025 16:46:38 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/6] scsi: scsi_debug: Add read support and update
 locate for tapes
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org, dgilbert@interlog.com
References: <20250128142250.163901-1-Kai.Makisara@kolumbus.fi>
 <20250128142250.163901-5-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250128142250.163901-5-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

On 1/28/25 9:22 AM, Kai Mäkisara wrote:
> Support for the READ (6) and SPACE (6) commands for tapes based on the
> previous write patch is added. The LOCATE (10) command is updated to use
> the written data.
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/scsi_debug.c | 240 +++++++++++++++++++++++++++++++++++++-
>   1 file changed, 235 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 2f0c73bd37b8..912b1c6cf92d 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -532,7 +532,8 @@ enum sdeb_opcode_index {
>   	SDEB_I_READ_BLOCK_LIMITS = 33,
>   	SDEB_I_LOCATE = 34,
>   	SDEB_I_WRITE_FILEMARKS = 35,
> -	SDEB_I_LAST_ELEM_P1 = 36,	/* keep this last (previous + 1) */
> +	SDEB_I_SPACE = 36,
> +	SDEB_I_LAST_ELEM_P1 = 37,	/* keep this last (previous + 1) */
>   };
>   
>   
> @@ -541,7 +542,7 @@ static const unsigned char opcode_ind_arr[256] = {
>   	SDEB_I_TEST_UNIT_READY, SDEB_I_REZERO_UNIT, 0, SDEB_I_REQUEST_SENSE,
>   	    0, SDEB_I_READ_BLOCK_LIMITS, 0, 0,
>   	SDEB_I_READ, 0, SDEB_I_WRITE, 0, 0, 0, 0, 0,
> -	SDEB_I_WRITE_FILEMARKS, 0, SDEB_I_INQUIRY, 0, 0,
> +	SDEB_I_WRITE_FILEMARKS, SDEB_I_SPACE, SDEB_I_INQUIRY, 0, 0,
>   	    SDEB_I_MODE_SELECT, SDEB_I_RESERVE, SDEB_I_RELEASE,
>   	0, 0, SDEB_I_MODE_SENSE, SDEB_I_START_STOP, 0, SDEB_I_SEND_DIAG,
>   	    SDEB_I_ALLOW_REMOVAL, 0,
> @@ -625,6 +626,7 @@ static int resp_rwp_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
>   static int resp_read_blklimits(struct scsi_cmnd *, struct sdebug_dev_info *);
>   static int resp_locate(struct scsi_cmnd *, struct sdebug_dev_info *);
>   static int resp_write_filemarks(struct scsi_cmnd *, struct sdebug_dev_info *);
> +static int resp_space(struct scsi_cmnd *, struct sdebug_dev_info *);
>   static int resp_rewind(struct scsi_cmnd *, struct sdebug_dev_info *);
>   
>   static int sdebug_do_add_host(bool mk_new_store);
> @@ -872,10 +874,12 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
>   	{0, 0x05, 0, F_D_IN, resp_read_blklimits, NULL,    /* READ BLOCK LIMITS (6) */
>   	    {6,  0, 0, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
>   	{0, 0x2b, 0, F_D_UNKN, resp_locate, NULL,    /* LOCATE (10) */
> -	    {10,  0x2, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
> +	    {10,  0x07, 0, 0xff, 0xff, 0xff, 0xff, 0, 0xff, 0xc7, 0, 0,
>   	     0, 0, 0, 0} },
>   	{0, 0x10, 0, F_D_IN, resp_write_filemarks, NULL,    /* WRITE FILEMARKS (6) */
>   	    {6,  0x01, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
> +	{0, 0x11, 0, F_D_IN, resp_space, NULL,    /* SPACE (6) */
> +	    {6,  0x07, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
>   
>   /* sentinel */
>   	{0xff, 0, 0, 0, NULL, NULL,		/* terminating element */
> @@ -3298,6 +3302,9 @@ static int resp_locate(struct scsi_cmnd *scp,
>   		struct sdebug_dev_info *devip)
>   {
>   	unsigned char *cmd = scp->cmnd;
> +	unsigned int i, pos;
> +	struct tape_block *blp;
> +	int partition;
>   
>   	if ((cmd[1] & 0x02) != 0) {
>   		if (cmd[8] >= TAPE_MAX_PARTITIONS) {
> @@ -3306,8 +3313,19 @@ static int resp_locate(struct scsi_cmnd *scp,
>   		}
>   		devip->tape_partition = cmd[8];
>   	}
> -	devip->tape_location[devip->tape_partition] =
> -		get_unaligned_be32(cmd + 3);
> +	pos = get_unaligned_be32(cmd + 3);
> +	partition = devip->tape_partition;
> +
> +	for (i = 0, blp = devip->tape_blocks[partition];
> +	     i < pos && i < devip->tape_eop[partition]; i++, blp++)
> +		if (IS_TAPE_BLOCK_EOD(blp->fl_size))
> +			break;
> +	if (i < pos) {
> +		devip->tape_location[partition] = i;
> +		mk_sense_buffer(scp, BLANK_CHECK, 0x05, 0);
> +		return check_condition_result;
> +	}
> +	devip->tape_location[partition] = pos;
>   
>   	return 0;
>   }
> @@ -3342,6 +3360,123 @@ static int resp_write_filemarks(struct scsi_cmnd *scp,
>   	return 0;
>   }
>   
> +static int resp_space(struct scsi_cmnd *scp,
> +		struct sdebug_dev_info *devip)
> +{
> +	unsigned char *cmd = scp->cmnd, code;
> +	int i, pos, count;
> +	struct tape_block *blp;
> +	int partition = devip->tape_partition;
> +
> +	count = get_unaligned_be24(cmd + 2);
> +	if ((count & 0x800000) != 0) /* extend negative to 32-bit count */
> +		count |= 0xff000000;
> +	code = cmd[1] & 0x0f;
> +
> +	pos = devip->tape_location[partition];
> +	if (code == 0) { /* blocks */
> +		if (count < 0) {
> +			count = (-count);
> +			pos -= 1;
> +			for (i = 0, blp = devip->tape_blocks[partition] + pos; i < count;
> +			     i++) {
> +				if (pos < 0)
> +					goto is_bop;
> +				else if (IS_TAPE_BLOCK_FM(blp->fl_size))
> +					goto is_fm;
> +				if (i > 0) {
> +					pos--;
> +					blp--;
> +				}
> +			}
> +		} else if (count > 0) {
> +			for (i = 0, blp = devip->tape_blocks[partition] + pos; i < count;
> +			     i++, pos++, blp++) {
> +				if (IS_TAPE_BLOCK_EOD(blp->fl_size))
> +					goto is_eod;
> +				if (IS_TAPE_BLOCK_FM(blp->fl_size)) {
> +					pos += 1;
> +					goto is_fm;
> +				}
> +				if (pos >= devip->tape_eop[partition])
> +					goto is_eop;
> +			}
> +		}
> +	} else if (code == 1) { /* filemarks */
> +		if (count < 0) {
> +			count = (-count);
> +			if (pos == 0)
> +				goto is_bop;
> +			else {
> +				for (i = 0, blp = devip->tape_blocks[partition] + pos;
> +				     i < count && pos >= 0; i++, pos--, blp--) {
> +					for (pos--, blp-- ; !IS_TAPE_BLOCK_FM(blp->fl_size) &&
> +						     pos >= 0; pos--, blp--)
> +						; /* empty */
> +					if (pos < 0)
> +						goto is_bop;
> +				}
> +			}
> +			pos += 1;
> +		} else if (count > 0) {
> +			for (i = 0, blp = devip->tape_blocks[partition] + pos;
> +			     i < count; i++, pos++, blp++) {
> +				for ( ; !IS_TAPE_BLOCK_FM(blp->fl_size) &&
> +					      !IS_TAPE_BLOCK_EOD(blp->fl_size) &&
> +					      pos < devip->tape_eop[partition];
> +				      pos++, blp++)
> +					; /* empty */
> +				if (IS_TAPE_BLOCK_EOD(blp->fl_size))
> +					goto is_eod;
> +				if (pos >= devip->tape_eop[partition])
> +					goto is_eop;
> +			}
> +		}
> +	} else if (code == 3) { /* EOD */
> +		for (blp = devip->tape_blocks[partition] + pos;
> +		     !IS_TAPE_BLOCK_EOD(blp->fl_size) && pos < devip->tape_eop[partition];
> +		     pos++, blp++)
> +			; /* empty */
> +		if (pos >= devip->tape_eop[partition])
> +			goto is_eop;
> +	} else {
> +		/* sequential filemarks not supported */
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 8, -1);
> +		return check_condition_result;
> +	}
> +	devip->tape_location[partition] = pos;
> +	return 0;
> +
> +is_fm:
> +	devip->tape_location[partition] = pos;
> +	mk_sense_info_tape(scp, NO_SENSE, NO_ADDITIONAL_SENSE,
> +			FILEMARK_DETECTED_ASCQ, count - i,
> +			SENSE_FLAG_FILEMARK);
> +	return check_condition_result;
> +
> +is_eod:
> +	devip->tape_location[partition] = pos;
> +	mk_sense_info_tape(scp, BLANK_CHECK, NO_ADDITIONAL_SENSE,
> +			EOD_DETECTED_ASCQ, count - i,
> +			0);
> +	return check_condition_result;
> +
> +is_bop:
> +	devip->tape_location[partition] = 0;
> +	mk_sense_info_tape(scp, NO_SENSE, NO_ADDITIONAL_SENSE,
> +			BEGINNING_OF_P_M_DETECTED_ASCQ, count - i,
> +			SENSE_FLAG_EOM);
> +	devip->tape_location[partition] = 0;
> +	return check_condition_result;
> +
> +is_eop:
> +	devip->tape_location[partition] = devip->tape_eop[partition] - 1;
> +	mk_sense_info_tape(scp, MEDIUM_ERROR, NO_ADDITIONAL_SENSE,
> +			EOP_EOM_DETECTED_ASCQ, (unsigned int)i,
> +			SENSE_FLAG_EOM);
> +	return check_condition_result;
> +}
> +
>   static int resp_rewind(struct scsi_cmnd *scp,
>   		struct sdebug_dev_info *devip)
>   {
> @@ -4083,6 +4218,98 @@ static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
>   	return ret;
>   }
>   
> +static int resp_read_tape(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
> +{
> +	u32 i, num, transfer, size;
> +	u8 *cmd = scp->cmnd;
> +	struct scsi_data_buffer *sdb = &scp->sdb;
> +	int partition = devip->tape_partition;
> +	u32 pos = devip->tape_location[partition];
> +	struct tape_block *blp;
> +	bool fixed, sili;
> +
> +	if (cmd[0] != READ_6) { /* Only Read(6) supported */
> +		mk_sense_invalid_opcode(scp);
> +		return illegal_condition_result;
> +	}
> +	fixed = (cmd[1] & 0x1) != 0;
> +	sili = (cmd[1] & 0x2) != 0;
> +	if (fixed && sili) {
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, 1);
> +		return check_condition_result;
> +	}
> +
> +	transfer = get_unaligned_be24(cmd + 2);
> +	if (fixed) {
> +		num = transfer;
> +		size = devip->tape_blksize;
> +	} else {
> +		if (transfer < TAPE_MIN_BLKSIZE ||
> +			transfer > TAPE_MAX_BLKSIZE) {
> +			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 2, -1);
> +			return check_condition_result;
> +		}
> +		num = 1;
> +		size = transfer;
> +	}
> +
> +	for (i = 0, blp = devip->tape_blocks[partition] + pos;
> +	     i < num && pos < devip->tape_eop[partition];
> +	     i++, pos++, blp++) {
> +		devip->tape_location[partition] = pos + 1;
> +		if (IS_TAPE_BLOCK_FM(blp->fl_size)) {
> +			mk_sense_info_tape(scp, NO_SENSE, NO_ADDITIONAL_SENSE,
> +					FILEMARK_DETECTED_ASCQ, fixed ? num - i : size,
> +					SENSE_FLAG_FILEMARK);
> +			scsi_set_resid(scp, (num - i) * size);
> +			return check_condition_result;
> +		}
> +		/* Assume no REW */
> +		if (IS_TAPE_BLOCK_EOD(blp->fl_size)) {
> +			mk_sense_info_tape(scp, BLANK_CHECK, NO_ADDITIONAL_SENSE,
> +					EOD_DETECTED_ASCQ, fixed ? num - i : size,
> +					0);
> +			devip->tape_location[partition] = pos;
> +			scsi_set_resid(scp, (num - i) * size);
> +			return check_condition_result;
> +		}
> +		sg_zero_buffer(sdb->table.sgl, sdb->table.nents,
> +			size, i * size);
> +		sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
> +			&(blp->data), 4, i * size, false);
> +		if (fixed) {
> +			if (blp->fl_size != devip->tape_blksize) {
> +				scsi_set_resid(scp, (num - i) * size);
> +				mk_sense_info_tape(scp, NO_SENSE, NO_ADDITIONAL_SENSE,
> +						0, num - i,
> +						SENSE_FLAG_ILI);
> +				return check_condition_result;
> +			}
> +		} else {
> +			if (blp->fl_size != size) {
> +				if (blp->fl_size < size)
> +					scsi_set_resid(scp, size - blp->fl_size);
> +				if (!sili) {
> +					mk_sense_info_tape(scp, NO_SENSE, NO_ADDITIONAL_SENSE,
> +							0, size - blp->fl_size,
> +							SENSE_FLAG_ILI);
> +					return check_condition_result;
> +				}
> +			}
> +		}
> +	}
> +	if (pos >= devip->tape_eop[partition]) {
> +		mk_sense_info_tape(scp, NO_SENSE, NO_ADDITIONAL_SENSE,
> +				EOP_EOM_DETECTED_ASCQ, fixed ? num - i : size,
> +				SENSE_FLAG_EOM);
> +		devip->tape_location[partition] = pos - 1;
> +		return check_condition_result;
> +	}
> +	devip->tape_location[partition] = pos;
> +
> +	return 0;
> +}
> +
>   static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   {
>   	bool check_prot;
> @@ -4094,6 +4321,9 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   	u8 *cmd = scp->cmnd;
>   	bool meta_data_locked = false;
>   
> +	if (sdebug_ptype == TYPE_TAPE)
> +		return resp_read_tape(scp, devip);
> +
>   	switch (cmd[0]) {
>   	case READ_16:
>   		ei_lba = 0;

