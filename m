Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2C753B19A
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 18:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738260071; cv=none; b=PBs6S44VsqATYWod7FPaX6PQmRn1693a2Yg3kvRU1oPFpWNf/f0ve2u/Zj2vrxWiLMOGbkXumuiMhtFsAyJzRrF9v9/FqGg3lKCorxZUaiHi1D2ZPKyn/s5hASNuexapG+ha8/yb2/0cvSOzeECpf6o24sNbzghgCWXXfID7/eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738260071; c=relaxed/simple;
	bh=XkZQnII1Le9JgAGtk6qH7hjzvAfFVaRWjHKPe9h6YOs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=gMhak+F6qlEEAtTpdxuCgH00E9Rl5AW2Ucrz+RmY6Elk4PsNWFKHdSpNvkUt7oQ7omtlV45xinMhiZGATLd6iZNyYFkmzxfw6WPMTh2pRhEZki2rSpnuGLNmhYsN8RpHsgHooPELqQbGPKXeTZ+Umkv7NIuyn5W3YT6sfrb8qhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IVxdz1NB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IVxdz1NB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738260068;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DSUPzhZEVMYtri7baM8vsU+DCwqOd3ODARcaoD8qKR0=;
	b=IVxdz1NBIsSuiHMqs4JhBvYljlUIY5vhrrnP4+lR8Np3M7RHFRvIenM5DHcPmJckurkMsb
	5rtFIv4C3iU06qlKG0rnWzwI/oXLqMqTAmJEZS6HoHjhXCvrGflbezMMFqKgbHJBiOTTWl
	bF9dEx3XymEag6o+WUyvIDqFFpoHJYQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-633-ArQQRLkwPZeAg0wu831WBw-1; Thu,
 30 Jan 2025 13:01:05 -0500
X-MC-Unique: ArQQRLkwPZeAg0wu831WBw-1
X-Mimecast-MFC-AGG-ID: ArQQRLkwPZeAg0wu831WBw
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5559D1800A19;
	Thu, 30 Jan 2025 18:01:04 +0000 (UTC)
Received: from [10.17.16.215] (unknown [10.17.16.215])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 46CB71800951;
	Thu, 30 Jan 2025 18:01:03 +0000 (UTC)
Message-ID: <c4d70fec-fe89-4429-9c2b-08407378000a@redhat.com>
Date: Thu, 30 Jan 2025 13:01:02 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/6] scsi: scsi_debug: Add READ BLOCK LIMITS and
 modify LOAD for tapes
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org, dgilbert@interlog.com
References: <20250128142250.163901-1-Kai.Makisara@kolumbus.fi>
 <20250128142250.163901-3-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250128142250.163901-3-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Another much appreciated improvement for my scsi_debug tests.

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

On 1/28/25 9:22 AM, Kai Mäkisara wrote:
> The changes:
> - add READ BLOCK LIMITS (512 - 1048576 bytes)
> - make LOAD send New Media UA (not correct by the standard, but
>    makes possible to test also this UA)
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/scsi_debug.c | 130 ++++++++++++++++++++++++++++++++++++--
>   1 file changed, 123 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 00daa77f636c..19929625bd36 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -80,6 +80,7 @@ static const char *sdebug_version_date = "20210520";
>   #define INVALID_FIELD_IN_CDB 0x24
>   #define INVALID_FIELD_IN_PARAM_LIST 0x26
>   #define WRITE_PROTECTED 0x27
> +#define UA_READY_ASC 0x28
>   #define UA_RESET_ASC 0x29
>   #define UA_CHANGED_ASC 0x2a
>   #define TARGET_CHANGED_ASC 0x3f
> @@ -175,7 +176,11 @@ static const char *sdebug_version_date = "20210520";
>   
>   /* Default parameters for tape drives */
>   #define TAPE_DEF_DENSITY  0x0
> +#define TAPE_BAD_DENSITY  0x65
>   #define TAPE_DEF_BLKSIZE  0
> +#define TAPE_MIN_BLKSIZE  512
> +#define TAPE_MAX_BLKSIZE  1048576
> +#define TAPE_MAX_PARTITIONS 2
>   
>   #define SDEBUG_LUN_0_VAL 0
>   
> @@ -220,7 +225,8 @@ static const char *sdebug_version_date = "20210520";
>   #define SDEBUG_UA_LUNS_CHANGED 5
>   #define SDEBUG_UA_MICROCODE_CHANGED 6	/* simulate firmware change */
>   #define SDEBUG_UA_MICROCODE_CHANGED_WO_RESET 7
> -#define SDEBUG_NUM_UAS 8
> +#define SDEBUG_UA_NOT_READY_TO_READY 8
> +#define SDEBUG_NUM_UAS 9
>   
>   /* when 1==SDEBUG_OPT_MEDIUM_ERR, a medium error is simulated at this
>    * sector on read commands: */
> @@ -370,6 +376,8 @@ struct sdebug_dev_info {
>   	/* For tapes */
>   	unsigned int tape_blksize;
>   	unsigned int tape_density;
> +	unsigned char tape_partition;
> +	unsigned int tape_location[TAPE_MAX_PARTITIONS];
>   
>   	struct dentry *debugfs_entry;
>   	struct spinlock list_lock;
> @@ -491,14 +499,16 @@ enum sdeb_opcode_index {
>   	SDEB_I_ZONE_OUT = 30,		/* 0x94+SA; includes no data xfer */
>   	SDEB_I_ZONE_IN = 31,		/* 0x95+SA; all have data-in */
>   	SDEB_I_ATOMIC_WRITE_16 = 32,
> -	SDEB_I_LAST_ELEM_P1 = 33,	/* keep this last (previous + 1) */
> +	SDEB_I_READ_BLOCK_LIMITS = 33,
> +	SDEB_I_LOCATE = 34,
> +	SDEB_I_LAST_ELEM_P1 = 35,	/* keep this last (previous + 1) */
>   };
>   
>   
>   static const unsigned char opcode_ind_arr[256] = {
>   /* 0x0; 0x0->0x1f: 6 byte cdbs */
>   	SDEB_I_TEST_UNIT_READY, SDEB_I_REZERO_UNIT, 0, SDEB_I_REQUEST_SENSE,
> -	    0, 0, 0, 0,
> +	    0, SDEB_I_READ_BLOCK_LIMITS, 0, 0,
>   	SDEB_I_READ, 0, SDEB_I_WRITE, 0, 0, 0, 0, 0,
>   	0, 0, SDEB_I_INQUIRY, 0, 0, SDEB_I_MODE_SELECT, SDEB_I_RESERVE,
>   	    SDEB_I_RELEASE,
> @@ -506,7 +516,7 @@ static const unsigned char opcode_ind_arr[256] = {
>   	    SDEB_I_ALLOW_REMOVAL, 0,
>   /* 0x20; 0x20->0x3f: 10 byte cdbs */
>   	0, 0, 0, 0, 0, SDEB_I_READ_CAPACITY, 0, 0,
> -	SDEB_I_READ, 0, SDEB_I_WRITE, 0, 0, 0, 0, SDEB_I_VERIFY,
> +	SDEB_I_READ, 0, SDEB_I_WRITE, SDEB_I_LOCATE, 0, 0, 0, SDEB_I_VERIFY,
>   	0, 0, 0, 0, SDEB_I_PRE_FETCH, SDEB_I_SYNC_CACHE, 0, 0,
>   	0, 0, 0, SDEB_I_WRITE_BUFFER, 0, 0, 0, 0,
>   /* 0x40; 0x40->0x5f: 10 byte cdbs */
> @@ -581,6 +591,8 @@ static int resp_open_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
>   static int resp_close_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
>   static int resp_finish_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
>   static int resp_rwp_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
> +static int resp_read_blklimits(struct scsi_cmnd *, struct sdebug_dev_info *);
> +static int resp_locate(struct scsi_cmnd *, struct sdebug_dev_info *);
>   
>   static int sdebug_do_add_host(bool mk_new_store);
>   static int sdebug_add_host_helper(int per_host_idx);
> @@ -808,6 +820,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
>   	    resp_pre_fetch, pre_fetch_iarr,
>   	    {10,  0x2, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
>   	     0, 0, 0, 0} },			/* PRE-FETCH (10) */
> +						/* READ POSITION (10) */
>   
>   /* 30 */
>   	{ARRAY_SIZE(zone_out_iarr), 0x94, 0x3, F_SA_LOW | F_M_ACCESS,
> @@ -823,6 +836,12 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
>   	    resp_atomic_write, NULL, /* ATOMIC WRITE 16 */
>   		{16,  0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
>   		 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff} },
> +	{0, 0x05, 0, F_D_IN, resp_read_blklimits, NULL,    /* READ BLOCK LIMITS (6) */
> +	    {6,  0, 0, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
> +	{0, 0x2b, 0, F_D_UNKN, resp_locate, NULL,    /* LOCATE (10) */
> +	    {10,  0x2, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
> +	     0, 0, 0, 0} },
> +
>   /* sentinel */
>   	{0xff, 0, 0, 0, NULL, NULL,		/* terminating element */
>   	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
> @@ -1501,6 +1520,12 @@ static int make_ua(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   			if (sdebug_verbose)
>   				cp = "reported luns data has changed";
>   			break;
> +		case SDEBUG_UA_NOT_READY_TO_READY:
> +			mk_sense_buffer(scp, UNIT_ATTENTION, UA_READY_ASC,
> +					0);
> +			if (sdebug_verbose)
> +				cp = "not ready to ready transition/media change";
> +			break;
>   		default:
>   			pr_warn("unexpected unit attention code=%d\n", k);
>   			if (sdebug_verbose)
> @@ -2204,6 +2229,14 @@ static int resp_start_stop(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   	changing = (stopped_state != want_stop);
>   	if (changing)
>   		atomic_xchg(&devip->stopped, want_stop);
> +	if (sdebug_ptype == TYPE_TAPE && !want_stop) {
> +		int i;
> +
> +		set_bit(SDEBUG_UA_NOT_READY_TO_READY, devip->uas_bm); /* not legal! */
> +		for (i = 0; i < TAPE_MAX_PARTITIONS; i++)
> +			devip->tape_location[i] = 0;
> +		devip->tape_partition = 0;
> +	}
>   	if (!changing || (cmd[1] & 0x1))  /* state unchanged or IMMED bit set in cdb */
>   		return SDEG_RES_IMMED_MASK;
>   	else
> @@ -2736,6 +2769,17 @@ static int resp_sas_sha_m_spg(unsigned char *p, int pcontrol)
>   	return sizeof(sas_sha_m_pg);
>   }
>   
> +static int resp_partition_m_pg(unsigned char *p, int pcontrol, int target)
> +{	/* Partition page for mode_sense (tape) */
> +	unsigned char partition_pg[] = {0x11, 12, 1, 1, 0x80, 3, 9, 0,
> +					0xff, 0xff, 0x00, 40};
> +
> +	memcpy(p, partition_pg, sizeof(partition_pg));
> +	if (pcontrol == 1)
> +		memset(p + 2, 0, sizeof(partition_pg) - 2);
> +	return sizeof(partition_pg);
> +}
> +
>   /* PAGE_SIZE is more than necessary but provides room for future expansion. */
>   #define SDEBUG_MAX_MSENSE_SZ PAGE_SIZE
>   
> @@ -2872,6 +2916,12 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
>   		}
>   		offset += len;
>   		break;
> +	case 0x11:	/* Partition Mode Page (tape) */
> +		if (!is_tape)
> +			goto bad_pcode;
> +		len += resp_partition_m_pg(ap, pcontrol, target);
> +		offset += len;
> +		break;
>   	case 0x19:	/* if spc==1 then sas phy, control+discover */
>   		if (subpcode > 0x2 && subpcode < 0xff)
>   			goto bad_subpcode;
> @@ -2963,12 +3013,24 @@ static int resp_mode_select(struct scsi_cmnd *scp,
>   	bd_len = mselect6 ? arr[3] : get_unaligned_be16(arr + 6);
>   	off = (mselect6 ? 4 : 8);
>   	if (sdebug_ptype == TYPE_TAPE) {
> +		int blks;
> +
> +		if (arr[off] == TAPE_BAD_DENSITY) {
> +			mk_sense_invalid_fld(scp, SDEB_IN_DATA, 0, -1);
> +			return check_condition_result;
> +		}
> +		blks = get_unaligned_be16(arr + off + 6);
> +		if (blks != 0 &&
> +			(blks < TAPE_MIN_BLKSIZE || blks > TAPE_MAX_BLKSIZE)) {
> +			mk_sense_invalid_fld(scp, SDEB_IN_DATA, 1, -1);
> +			return check_condition_result;
> +		}
>   		devip->tape_density = arr[off];
> -		devip->tape_blksize = get_unaligned_be16(arr + off + 6);
> +		devip->tape_blksize = blks;
>   	}
>   	off += bd_len;
>   	if (res <= off)
> -		goto only_bd; /* No page written, just descriptors */
> +		return 0; /* No page written, just descriptors */
>   	if (md_len > 2 || off >= res) {
>   		mk_sense_invalid_fld(scp, SDEB_IN_DATA, 0, -1);
>   		return check_condition_result;
> @@ -3021,7 +3083,6 @@ static int resp_mode_select(struct scsi_cmnd *scp,
>   	return check_condition_result;
>   set_mode_changed_ua:
>   	set_bit(SDEBUG_UA_MODE_CHANGED, devip->uas_bm);
> -only_bd:
>   	return 0;
>   }
>   
> @@ -3162,6 +3223,36 @@ static int resp_log_sense(struct scsi_cmnd *scp,
>   		    min_t(u32, len, SDEBUG_MAX_INQ_ARR_SZ));
>   }
>   
> +#define SDEBUG_READ_BLOCK_LIMITS_ARR_SZ 6
> +static int resp_read_blklimits(struct scsi_cmnd *scp,
> +			struct sdebug_dev_info *devip)
> +{
> +	unsigned char arr[SDEBUG_READ_BLOCK_LIMITS_ARR_SZ];
> +
> +	memset(arr, 0, SDEBUG_READ_BLOCK_LIMITS_ARR_SZ);
> +	put_unaligned_be24(TAPE_MAX_BLKSIZE, arr + 1);
> +	put_unaligned_be16(TAPE_MIN_BLKSIZE, arr + 4);
> +	return fill_from_dev_buffer(scp, arr, SDEBUG_READ_BLOCK_LIMITS_ARR_SZ);
> +}
> +
> +static int resp_locate(struct scsi_cmnd *scp,
> +		struct sdebug_dev_info *devip)
> +{
> +	unsigned char *cmd = scp->cmnd;
> +
> +	if ((cmd[1] & 0x02) != 0) {
> +		if (cmd[8] >= TAPE_MAX_PARTITIONS) {
> +			mk_sense_invalid_fld(scp, SDEB_IN_CDB, 8, -1);
> +			return check_condition_result;
> +		}
> +		devip->tape_partition = cmd[8];
> +	}
> +	devip->tape_location[devip->tape_partition] =
> +		get_unaligned_be32(cmd + 3);
> +
> +	return 0;
> +}
> +
>   static inline bool sdebug_dev_is_zoned(struct sdebug_dev_info *devip)
>   {
>   	return devip->nr_zones != 0;
> @@ -4942,6 +5033,8 @@ static int resp_sync_cache(struct scsi_cmnd *scp,
>    * a GOOD status otherwise. Model a disk with a big cache and yield
>    * CONDITION MET. Actually tries to bring range in main memory into the
>    * cache associated with the CPU(s).
> + *
> + * The pcode 0x34 is also used for READ POSITION by tape devices.
>    */
>   static int resp_pre_fetch(struct scsi_cmnd *scp,
>   			  struct sdebug_dev_info *devip)
> @@ -4954,6 +5047,29 @@ static int resp_pre_fetch(struct scsi_cmnd *scp,
>   	struct sdeb_store_info *sip = devip2sip(devip, true);
>   	u8 *fsp = sip->storep;
>   
> +	if (sdebug_ptype == TYPE_TAPE) {
> +		if (cmd[0] == PRE_FETCH) { /* READ POSITION (10) */
> +			int all_length;
> +			unsigned char arr[20];
> +			unsigned int pos;
> +
> +			all_length = get_unaligned_be16(cmd + 7);
> +			if ((cmd[1] & 0xfe) != 0) { /* only short form */
> +				mk_sense_invalid_fld(scp, SDEB_IN_CDB,
> +						1, 0);
> +				return check_condition_result;
> +			}
> +			memset(arr, 0, 20);
> +			arr[1] = devip->tape_partition;
> +			pos = devip->tape_location[devip->tape_partition];
> +			put_unaligned_be32(pos, arr + 4);
> +			put_unaligned_be32(pos, arr + 8);
> +			return fill_from_dev_buffer(scp, arr, 20);
> +		}
> +		mk_sense_invalid_opcode(scp);
> +		return check_condition_result;
> +	}
> +
>   	if (cmd[0] == PRE_FETCH) {	/* 10 byte cdb */
>   		lba = get_unaligned_be32(cmd + 2);
>   		nblks = get_unaligned_be16(cmd + 7);

