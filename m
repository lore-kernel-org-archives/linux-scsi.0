Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C821DA5F
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 21:46:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738273562; cv=none; b=Fi7qdLvB3nvTzDT1rsOuNqFR3T22t7RnFj8CS9AA9HFDAyCwEqamtn5xuJ2QW03aZiLy0YHh/kbLHQErjTPvE5YtUdIiyRgoqPNEto+/UBE3Y/D+ZI8oVCjKxaZXQ2GQhOrE+AmRpm+rX9bucVmoSqqe6plHwWGHaG//2GAiO0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738273562; c=relaxed/simple;
	bh=go2w54lTpW96xMOhcaEWEgecIOEnQ5KjPNhNhmL4ia0=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=KlotGrP4mYtldxAOawIw+QaLvB7m8VNk5GIaiC9JqbumnrgFZRFKIAXyVSmFa1IIwkaAc6r6j9HuKooX3EfNjiuCtFrsc42kJFlzpbsp3f0D0wZvlj/3SeLy7r/K0EC6h6VBLTHgH2oabvgdUxJAxMPNZzQSqYDJusNws8TcFk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JLLVTPyk; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JLLVTPyk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738273559;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LFj4m7YvosWx6xdPGhDniSk0GiUi48noVZw7j40v0ZU=;
	b=JLLVTPykBSKs9updC7VzBwHbRqZWb3Bal30sVYjTbfTsLJ0FByY5kvR9Jq6ooHycgo7zxu
	/kdjVhKqj4Qrfvs8S2YFBKDoJGT1jZTNT3/JvhaYMVL5x+0gvFYJnJttOMdJuYAVOTCKwZ
	zOC0atE8l5xtRbmOcHYzzAdGUZzYYKU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-221-jPlp-DMpNTawAIuTePu_8g-1; Thu,
 30 Jan 2025 16:45:57 -0500
X-MC-Unique: jPlp-DMpNTawAIuTePu_8g-1
X-Mimecast-MFC-AGG-ID: jPlp-DMpNTawAIuTePu_8g
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8295119560B7;
	Thu, 30 Jan 2025 21:45:56 +0000 (UTC)
Received: from [10.17.16.215] (unknown [10.17.16.215])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7959C19560A3;
	Thu, 30 Jan 2025 21:45:55 +0000 (UTC)
Message-ID: <e8a400e7-3ef8-46cc-857a-4d3484488fbd@redhat.com>
Date: Thu, 30 Jan 2025 16:45:54 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/6] scsi: scsi_debug: Add tape write support with
 block lengths and 4 bytes of data
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org, dgilbert@interlog.com
References: <20250128142250.163901-1-Kai.Makisara@kolumbus.fi>
 <20250128142250.163901-4-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250128142250.163901-4-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

On 1/28/25 9:22 AM, Kai Mäkisara wrote:
> The tape partitions are implemented as fixed number of 8-byte
> units (partition zero 100 000 units and partition one 1000 units).
> The first four bytes of a unit contains the type of the unit (data
> block, filemark or end-of-data mark). If the units is a data block,
> the first four bytes contain the block length and the remaining
> four bytes the first bytes of written data. This allows the user
> to use tags to see that the read block is what it was supposed to be.
> 
> This patch adds the WRITE(6) command for tapes and the WRITE FILEMARKS (6)
> command. The REWIND command is updated.
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/scsi_debug.c | 188 +++++++++++++++++++++++++++++++++++++-
>   1 file changed, 184 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 19929625bd36..2f0c73bd37b8 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -71,6 +71,10 @@ static const char *sdebug_version_date = "20210520";
>   #define NO_ADDITIONAL_SENSE 0x0
>   #define OVERLAP_ATOMIC_COMMAND_ASC 0x0
>   #define OVERLAP_ATOMIC_COMMAND_ASCQ 0x23
> +#define FILEMARK_DETECTED_ASCQ 0x1
> +#define EOP_EOM_DETECTED_ASCQ 0x2
> +#define BEGINNING_OF_P_M_DETECTED_ASCQ 0x4
> +#define EOD_DETECTED_ASCQ 0x5
>   #define LOGICAL_UNIT_NOT_READY 0x4
>   #define LOGICAL_UNIT_COMMUNICATION_FAILURE 0x8
>   #define UNRECOVERED_READ_ERR 0x11
> @@ -83,6 +87,7 @@ static const char *sdebug_version_date = "20210520";
>   #define UA_READY_ASC 0x28
>   #define UA_RESET_ASC 0x29
>   #define UA_CHANGED_ASC 0x2a
> +#define TOO_MANY_IN_PARTITION_ASC 0x3b
>   #define TARGET_CHANGED_ASC 0x3f
>   #define LUNS_CHANGED_ASCQ 0x0e
>   #define INSUFF_RES_ASC 0x55
> @@ -180,7 +185,30 @@ static const char *sdebug_version_date = "20210520";
>   #define TAPE_DEF_BLKSIZE  0
>   #define TAPE_MIN_BLKSIZE  512
>   #define TAPE_MAX_BLKSIZE  1048576
> +#define TAPE_EW 20
>   #define TAPE_MAX_PARTITIONS 2
> +#define TAPE_PARTITION_0_UNITS 100000
> +#define TAPE_PARTITION_1_UNITS 1000
> +
> +/* The tape block data definitions */
> +#define TAPE_BLOCK_FM_FLAG   ((u32)0x1 << 30)
> +#define TAPE_BLOCK_EOD_FLAG  ((u32)0x2 << 30)
> +#define TAPE_BLOCK_MARK_MASK ((u32)0x3 << 30)
> +#define TAPE_BLOCK_SIZE_MASK (~TAPE_BLOCK_MARK_MASK)
> +#define TAPE_BLOCK_MARK(a) (a & TAPE_BLOCK_MARK_MASK)
> +#define TAPE_BLOCK_SIZE(a) (a & TAPE_BLOCK_SIZE_MASK)
> +#define IS_TAPE_BLOCK_FM(a)   ((a & TAPE_BLOCK_FM_FLAG) != 0)
> +#define IS_TAPE_BLOCK_EOD(a)  ((a & TAPE_BLOCK_EOD_FLAG) != 0)
> +
> +struct tape_block {
> +	u32 fl_size;
> +	unsigned char data[4];
> +};
> +
> +/* Flags for sense data */
> +#define SENSE_FLAG_FILEMARK  0x80
> +#define SENSE_FLAG_EOM 0x40
> +#define SENSE_FLAG_ILI 0x20
>   
>   #define SDEBUG_LUN_0_VAL 0
>   
> @@ -378,6 +406,8 @@ struct sdebug_dev_info {
>   	unsigned int tape_density;
>   	unsigned char tape_partition;
>   	unsigned int tape_location[TAPE_MAX_PARTITIONS];
> +	unsigned int tape_eop[TAPE_MAX_PARTITIONS];
> +	struct tape_block *tape_blocks[TAPE_MAX_PARTITIONS];
>   
>   	struct dentry *debugfs_entry;
>   	struct spinlock list_lock;
> @@ -501,7 +531,8 @@ enum sdeb_opcode_index {
>   	SDEB_I_ATOMIC_WRITE_16 = 32,
>   	SDEB_I_READ_BLOCK_LIMITS = 33,
>   	SDEB_I_LOCATE = 34,
> -	SDEB_I_LAST_ELEM_P1 = 35,	/* keep this last (previous + 1) */
> +	SDEB_I_WRITE_FILEMARKS = 35,
> +	SDEB_I_LAST_ELEM_P1 = 36,	/* keep this last (previous + 1) */
>   };
>   
>   
> @@ -510,8 +541,8 @@ static const unsigned char opcode_ind_arr[256] = {
>   	SDEB_I_TEST_UNIT_READY, SDEB_I_REZERO_UNIT, 0, SDEB_I_REQUEST_SENSE,
>   	    0, SDEB_I_READ_BLOCK_LIMITS, 0, 0,
>   	SDEB_I_READ, 0, SDEB_I_WRITE, 0, 0, 0, 0, 0,
> -	0, 0, SDEB_I_INQUIRY, 0, 0, SDEB_I_MODE_SELECT, SDEB_I_RESERVE,
> -	    SDEB_I_RELEASE,
> +	SDEB_I_WRITE_FILEMARKS, 0, SDEB_I_INQUIRY, 0, 0,
> +	    SDEB_I_MODE_SELECT, SDEB_I_RESERVE, SDEB_I_RELEASE,
>   	0, 0, SDEB_I_MODE_SENSE, SDEB_I_START_STOP, 0, SDEB_I_SEND_DIAG,
>   	    SDEB_I_ALLOW_REMOVAL, 0,
>   /* 0x20; 0x20->0x3f: 10 byte cdbs */
> @@ -593,6 +624,8 @@ static int resp_finish_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
>   static int resp_rwp_zone(struct scsi_cmnd *, struct sdebug_dev_info *);
>   static int resp_read_blklimits(struct scsi_cmnd *, struct sdebug_dev_info *);
>   static int resp_locate(struct scsi_cmnd *, struct sdebug_dev_info *);
> +static int resp_write_filemarks(struct scsi_cmnd *, struct sdebug_dev_info *);
> +static int resp_rewind(struct scsi_cmnd *, struct sdebug_dev_info *);
>   
>   static int sdebug_do_add_host(bool mk_new_store);
>   static int sdebug_add_host_helper(int per_host_idx);
> @@ -793,7 +826,7 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
>   /* 20 */
>   	{0, 0x1e, 0, 0, NULL, NULL, /* ALLOW REMOVAL */
>   	    {6,  0, 0, 0, 0x3, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
> -	{0, 0x1, 0, 0, NULL, NULL, /* REWIND ?? */
> +	{0, 0x1, 0, 0, resp_rewind, NULL,
>   	    {6,  0x1, 0, 0, 0, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
>   	{0, 0, 0, F_INV_OP | FF_RESPOND, NULL, NULL, /* ATA_PT */
>   	    {0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
> @@ -841,6 +874,8 @@ static const struct opcode_info_t opcode_info_arr[SDEB_I_LAST_ELEM_P1 + 1] = {
>   	{0, 0x2b, 0, F_D_UNKN, resp_locate, NULL,    /* LOCATE (10) */
>   	    {10,  0x2, 0xff, 0xff, 0xff, 0xff, 0x3f, 0xff, 0xff, 0xc7, 0, 0,
>   	     0, 0, 0, 0} },
> +	{0, 0x10, 0, F_D_IN, resp_write_filemarks, NULL,    /* WRITE FILEMARKS (6) */
> +	    {6,  0x01, 0xff, 0xff, 0xff, 0xc7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} },
>   
>   /* sentinel */
>   	{0xff, 0, 0, 0, NULL, NULL,		/* terminating element */
> @@ -1358,6 +1393,30 @@ static void mk_sense_buffer(struct scsi_cmnd *scp, int key, int asc, int asq)
>   			    my_name, key, asc, asq);
>   }
>   
> +/* Sense data that has information fields for tapes */
> +static void mk_sense_info_tape(struct scsi_cmnd *scp, int key, int asc, int asq,
> +			unsigned int information, unsigned char tape_flags)
> +{
> +	if (!scp->sense_buffer) {
> +		sdev_printk(KERN_ERR, scp->device,
> +			    "%s: sense_buffer is NULL\n", __func__);
> +		return;
> +	}
> +	memset(scp->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
> +
> +	scsi_build_sense(scp, /*sdebug_dsense*/ 0, key, asc, asq);
> +	/* only fixed format so far */
> +
> +	scp->sense_buffer[0] |= 0x80; /* valid */
> +	scp->sense_buffer[2] |= tape_flags;
> +	put_unaligned_be32(information, &scp->sense_buffer[3]);
> +
> +	if (sdebug_verbose)
> +		sdev_printk(KERN_INFO, scp->device,
> +			    "%s:  [sense_key,asc,ascq]: [0x%x,0x%x,0x%x]\n",
> +			    my_name, key, asc, asq);
> +}
> +
>   static void mk_sense_invalid_opcode(struct scsi_cmnd *scp)
>   {
>   	mk_sense_buffer(scp, ILLEGAL_REQUEST, INVALID_OPCODE, 0);
> @@ -3253,6 +3312,44 @@ static int resp_locate(struct scsi_cmnd *scp,
>   	return 0;
>   }
>   
> +static int resp_write_filemarks(struct scsi_cmnd *scp,
> +		struct sdebug_dev_info *devip)
> +{
> +	unsigned char *cmd = scp->cmnd;
> +	unsigned int i, count, pos;
> +	u32 data;
> +	int partition = devip->tape_partition;
> +
> +	if ((cmd[1] & 0xfe) != 0) { /* probably write setmarks, not in >= SCSI-3 */
> +		mk_sense_invalid_fld(scp, SDEB_IN_CDB, 1, 1);
> +		return check_condition_result;
> +	}
> +	count = get_unaligned_be24(cmd + 2);
> +	data = TAPE_BLOCK_FM_FLAG;
> +	for (i = 0, pos = devip->tape_location[partition]; i < count; i++, pos++) {
> +		if (pos >= devip->tape_eop[partition] - 1) { /* don't overwrite EOD */
> +			devip->tape_location[partition] = devip->tape_eop[partition] - 1;
> +			mk_sense_info_tape(scp, VOLUME_OVERFLOW, NO_ADDITIONAL_SENSE,
> +					EOP_EOM_DETECTED_ASCQ, count, SENSE_FLAG_EOM);
> +			return check_condition_result;
> +		}
> +		(devip->tape_blocks[partition] + pos)->fl_size = data;
> +	}
> +	(devip->tape_blocks[partition] + pos)->fl_size =
> +		TAPE_BLOCK_EOD_FLAG;
> +	devip->tape_location[partition] = pos;
> +
> +	return 0;
> +}
> +
> +static int resp_rewind(struct scsi_cmnd *scp,
> +		struct sdebug_dev_info *devip)
> +{
> +	devip->tape_location[devip->tape_partition] = 0;
> +
> +	return 0;
> +}
> +
>   static inline bool sdebug_dev_is_zoned(struct sdebug_dev_info *devip)
>   {
>   	return devip->nr_zones != 0;
> @@ -4293,6 +4390,67 @@ static void unmap_region(struct sdeb_store_info *sip, sector_t lba,
>   	}
>   }
>   
> +static int resp_write_tape(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
> +{
> +	u32 i, num, transfer, size, written = 0;
> +	u8 *cmd = scp->cmnd;
> +	struct scsi_data_buffer *sdb = &scp->sdb;
> +	int partition = devip->tape_partition;
> +	int pos = devip->tape_location[partition];
> +	struct tape_block *blp;
> +	bool fixed, ew;
> +
> +	if (cmd[0] != WRITE_6) { /* Only Write(6) supported */
> +		mk_sense_invalid_opcode(scp);
> +		return illegal_condition_result;
> +	}
> +
> +	fixed = (cmd[1] & 1) != 0;
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
> +	scsi_set_resid(scp, num * transfer);
> +	for (i = 0, blp = devip->tape_blocks[partition] + pos, ew = false;
> +	     i < num && pos < devip->tape_eop[partition] - 1; i++, pos++, blp++) {
> +		blp->fl_size = size;
> +		sg_copy_buffer(sdb->table.sgl, sdb->table.nents,
> +			&(blp->data), 4, i * size, true);
> +		written += size;
> +		scsi_set_resid(scp, num * transfer - written);
> +		ew |= (pos == devip->tape_eop[partition] - TAPE_EW);
> +	}
> +
> +	devip->tape_location[partition] = pos;
> +	blp->fl_size = TAPE_BLOCK_EOD_FLAG;
> +	if (pos >= devip->tape_eop[partition] - 1) {
> +		mk_sense_info_tape(scp, VOLUME_OVERFLOW,
> +				NO_ADDITIONAL_SENSE, EOP_EOM_DETECTED_ASCQ,
> +				fixed ? num - i : transfer,
> +				SENSE_FLAG_EOM);
> +		return check_condition_result;
> +	}
> +	if (ew) { /* early warning */
> +		mk_sense_info_tape(scp, NO_SENSE,
> +				NO_ADDITIONAL_SENSE, EOP_EOM_DETECTED_ASCQ,
> +				fixed ? num - i : transfer,
> +				SENSE_FLAG_EOM);
> +		return check_condition_result;
> +	}
> +
> +	return 0;
> +}
> +
>   static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   {
>   	bool check_prot;
> @@ -4305,6 +4463,9 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   	u8 *cmd = scp->cmnd;
>   	bool meta_data_locked = false;
>   
> +	if (sdebug_ptype == TYPE_TAPE)
> +		return resp_write_tape(scp, devip);
> +
>   	switch (cmd[0]) {
>   	case WRITE_16:
>   		ei_lba = 0;
> @@ -5976,8 +6137,27 @@ static struct sdebug_dev_info *sdebug_device_create(
>   			devip->zoned = false;
>   		}
>   		if (sdebug_ptype == TYPE_TAPE) {
> +			int i;
> +
>   			devip->tape_density = TAPE_DEF_DENSITY;
>   			devip->tape_blksize = TAPE_DEF_BLKSIZE;
> +			for (i = 0; i < TAPE_MAX_PARTITIONS; i++) {
> +				devip->tape_eop[i] = i ? TAPE_PARTITION_1_UNITS :
> +					TAPE_PARTITION_0_UNITS;
> +				devip->tape_blocks[i] =
> +					kcalloc(devip->tape_eop[i],
> +						sizeof(struct tape_block),
> +						GFP_KERNEL);
> +				if (!devip->tape_blocks[i]) {
> +					int j;
> +
> +					for (j = 0; j < i; j++)
> +						kfree(devip->tape_blocks[j]);
> +					kfree(devip);
> +					return NULL;
> +				}
> +				devip->tape_blocks[i]->fl_size = TAPE_BLOCK_EOD_FLAG;
> +			}
>   		}
>   		devip->create_ts = ktime_get_boottime();
>   		atomic_set(&devip->stopped, (sdeb_tur_ms_to_ready > 0 ? 2 : 0));

