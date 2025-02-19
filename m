Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DF323DEB6
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 21:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740002188; cv=none; b=h39/IHRQDgbcmkpeITZiu80ryrJb4b9qXZZEj9FXnChmhGQhxlS0vS2oYpob1UpnwcfXKsE7kZyL76cBFVMJS3LKoMp4awzSmPOfx73yijuLDvelIJS0e7GdgHsk+G1QyE31l8yHGp22/l+QGz6+eFzuGgjrgnOY8fzLFFnHbuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740002188; c=relaxed/simple;
	bh=IBv2LiFOwcWA9R64VFdRr9cNljWv6xVnlX83tiyJNOo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PgxVsipX7kt2ZxmrkVbNNrZMcBMXAglR6nDKTaZaPswf9HA8MHg09SoS8Ke8SpNRSIPCPE4dPbfUV03LJ94yZlYyzgTOkkmNICxphI+S6fIYklgxR207bTnZXrM1FoTuHlH8cgJ8vLuPUQTq11bVrQrpsAgL+/U3U0kqFT1pCeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LzRUS7DP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LzRUS7DP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740002184;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6YHZG71NKl6LZ4/OIhvRQCeX329fNYpOgN/N3Jyg7/M=;
	b=LzRUS7DP7L1gXyLKgXfVuXdqcBywjM/YE8l+XvM1WnaY8JOL/WGDN6eeGlguwqocG1A9xJ
	Z70tNg6XrCqpeCWbWHzi8ET5gj6CF6jrosfDNsqR7iQBRWQN/wjVoe0MV5LkRMWqw4B/4U
	s6tk6Er01dFw4BT5XyrND/Eua3+Ox3Y=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-111-zVNTnVSzPBueJNLkEJFOzw-1; Wed,
 19 Feb 2025 16:56:20 -0500
X-MC-Unique: zVNTnVSzPBueJNLkEJFOzw-1
X-Mimecast-MFC-AGG-ID: zVNTnVSzPBueJNLkEJFOzw_1740002179
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 425DF19373D8;
	Wed, 19 Feb 2025 21:56:19 +0000 (UTC)
Received: from [10.22.65.116] (unknown [10.22.65.116])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9B90E1956094;
	Wed, 19 Feb 2025 21:56:16 +0000 (UTC)
Message-ID: <5cfe7954-b034-465f-b083-d3d5aabce49b@redhat.com>
Date: Wed, 19 Feb 2025 16:56:15 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/7] scsi: scsi_debug: Add read support and update
 locate for tapes
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org, dgilbert@interlog.com
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
References: <20250213092636.2510-1-Kai.Makisara@kolumbus.fi>
 <20250213092636.2510-5-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250213092636.2510-5-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

After this patch it looks like fsr and bsr are working well.

Before this patch... forget it. Don't even try if you are using the scsi_debug driver.

[root@to-be-determined ~]# mt -f /dev/nst1 rewind
[Wed Feb 19 16:46:03 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:46:03 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
[Wed Feb 19 16:46:03 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 16:46:03 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 16:46:03 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 16:46:03 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:46:03 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:46:03 2025] st 8:0:0:0: [st1] Rewinding tape.
[Wed Feb 19 16:46:03 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:46:03 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[root@to-be-determined ~]# mt -f /dev/nst1 fsr 2
[Wed Feb 19 16:46:41 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:46:41 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
[Wed Feb 19 16:46:41 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 16:46:41 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 16:46:41 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 16:46:41 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:46:41 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:46:41 2025] st 8:0:0:0: [st1] Spacing tape forward over 2 blocks.
[Wed Feb 19 16:46:41 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:46:41 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[root@to-be-determined ~]# mt -f /dev/nst1 status
[Wed Feb 19 16:46:54 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:46:54 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
SCSI 2 tape drive:
File number=0, block number=2, partition=0.
Tape block size 0 bytes. Density code 0x0 (default).
Soft error count since last status=0
General status bits on (1010000):
  ONLINE IM_REP_EN
[Wed Feb 19 16:46:54 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 16:46:54 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 16:46:54 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 16:46:54 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:46:54 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:46:54 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:46:54 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0

[root@to-be-determined ~]# mt -f /dev/nst1 bsr 2
[Wed Feb 19 16:47:35 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:47:35 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
[Wed Feb 19 16:47:35 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 16:47:35 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 16:47:35 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 16:47:35 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:47:35 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:47:35 2025] st 8:0:0:0: [st1] Spacing tape backward over 2 blocks.
[Wed Feb 19 16:47:35 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:47:35 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0

[root@to-be-determined ~]# mt -f /dev/nst1 status
[Wed Feb 19 16:47:40 2025] st 8:0:0:0: [st1] check_tape: 1087: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:47:40 2025] st 8:0:0:0: [st1] Block limits 512 - 1048576 bytes.
[Wed Feb 19 16:47:40 2025] st 8:0:0:0: [st1] Mode sense. Length 11, medium 0, WBS 0, BLL 8
[Wed Feb 19 16:47:40 2025] st 8:0:0:0: [st1] Density 0, tape length: 388000, drv buffer: 0
[Wed Feb 19 16:47:40 2025] st 8:0:0:0: [st1] Block size: 0, buffer size: 4096 (1 blocks).
[Wed Feb 19 16:47:40 2025] st 8:0:0:0: [st1] check_tape: 1287: CHKRES_READY pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:47:40 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0
SCSI 2 tape drive:
File number=0, block number=0, partition=0.
Tape block size 0 bytes. Density code 0x0 (default).
Soft error count since last status=0
General status bits on (41010000):
  BOT ONLINE IM_REP_EN
[Wed Feb 19 16:47:40 2025] st 8:0:0:0: [st1] st_flush: 1409: pos_unknown 0 was_reset 0/0 ready 0
[Wed Feb 19 16:47:40 2025] st 8:0:0:0: [st1] flush_buffer: 852: pos_unknown 0 was_reset 0/0 ready 0



On 2/13/25 4:26 AM, Kai Mäkisara wrote:
> Support for the READ (6) and SPACE (6) commands for tapes based on the
> previous write patch is added. The LOCATE (10) command is updated to use
> the written data.
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
> v1 -> v2:
> - initialized i to zero in resp_space() to fix the bug reported by
>    the Kernel Test Robot
> 
> drivers/scsi/scsi_debug.c | 240 +++++++++++++++++++++++++++++++++++++-
>   1 file changed, 235 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 69cae4c1712a..29a9aea30d22 100644
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
> @@ -3309,6 +3313,9 @@ static int resp_locate(struct scsi_cmnd *scp,
>   		struct sdebug_dev_info *devip)
>   {
>   	unsigned char *cmd = scp->cmnd;
> +	unsigned int i, pos;
> +	struct tape_block *blp;
> +	int partition;
>   
>   	if ((cmd[1] & 0x02) != 0) {
>   		if (cmd[8] >= devip->tape_nbr_partitions) {
> @@ -3317,8 +3324,19 @@ static int resp_locate(struct scsi_cmnd *scp,
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
> @@ -3353,6 +3371,123 @@ static int resp_write_filemarks(struct scsi_cmnd *scp,
>   	return 0;
>   }
>   
> +static int resp_space(struct scsi_cmnd *scp,
> +		struct sdebug_dev_info *devip)
> +{
> +	unsigned char *cmd = scp->cmnd, code;
> +	int i = 0, pos, count;
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
> @@ -4121,6 +4256,98 @@ static int prot_verify_read(struct scsi_cmnd *scp, sector_t start_sec,
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
> @@ -4132,6 +4359,9 @@ static int resp_read_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   	u8 *cmd = scp->cmnd;
>   	bool meta_data_locked = false;
>   
> +	if (sdebug_ptype == TYPE_TAPE)
> +		return resp_read_tape(scp, devip);
> +
>   	switch (cmd[0]) {
>   	case READ_16:
>   		ei_lba = 0;

