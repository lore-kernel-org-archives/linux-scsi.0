Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9A938DD3
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jan 2025 18:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738261108; cv=none; b=CdwGm9v+YMMcuwzg2pMaG5XE+qb4OUmWJwOXneXKdLYX6RTDCp0afB1fRZzFZyPyO+QoISuEyR6rzl3CbDgMGbt+aAdx9+PvmMhb+Zbo/sAXbf7dDOiE2ddaCfDsx0SF8aJMur/kRvXR+ZZ3E2RwTAZi0XZEnxQSUq2r3NTlItI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738261108; c=relaxed/simple;
	bh=31IB3g5BHZWh8hnIei72Iu1bmpsk3vWEO+gY27pKGSM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IrtzTm2XYEWQ5rIQN+kIuMdB3wfiIP9DK5C6+/baD9GWnY5yzKjV/eLmN8CTxbFoOHNnBoq8GcP7HlT0p/WotfLqcbm8BwktCAxb02tBETO4BYH4H6E17Va88F87gpVBd4fI6ODFohLYWXGwRjpNpjaL2j9Fk8KO7aeOplbaUZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=O50NhQsm; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="O50NhQsm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738261105;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RDtvLUPN6jPg2v/Rmu1skD0uo4AdYi7w9YJ9LbN/Isk=;
	b=O50NhQsmWq4e6nAqk9MgfpidbTIJYAkizFTNHP/I4LFNBJyRvYE6t7C1ro2gaWc6iSTD8H
	FOC9rgOo4kTFoo8whA9mjPjo7Bs8qiZfCSl++9kyrMWZYdLo7U8Ks40amfUghryyQfjPFN
	M7vwm4CIyqbhW+DRHBNpvVG117ONEDE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-196-TKy0YSH3MCaMGhqCT5ieiQ-1; Thu,
 30 Jan 2025 13:18:24 -0500
X-MC-Unique: TKy0YSH3MCaMGhqCT5ieiQ-1
X-Mimecast-MFC-AGG-ID: TKy0YSH3MCaMGhqCT5ieiQ
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2F6EF180034F;
	Thu, 30 Jan 2025 18:18:23 +0000 (UTC)
Received: from [10.17.16.215] (unknown [10.17.16.215])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3401118008C0;
	Thu, 30 Jan 2025 18:18:22 +0000 (UTC)
Message-ID: <004b035e-34ed-4ce2-970e-92eeccf1edc3@redhat.com>
Date: Thu, 30 Jan 2025 13:18:21 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/4] scsi: st: scsi_device: Modify st.c to use the new
 scsi_error counters
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, loberman@redhat.com
References: <20250120194925.44432-1-Kai.Makisara@kolumbus.fi>
 <20250120194925.44432-4-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20250120194925.44432-4-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

Testing of this patch with my current tests show no regressions.

I'll work on a multi-ULD test to improve those tests.

/John

On 1/20/25 2:49 PM, Kai Mäkisara wrote:
> Compare the stored values of por_ctr and new_media_ctr against
> the values in the device struct. In case of mismatch, the
> Unit Attention corresponding to the counter has happened.
> This is a safeguard against another ULD catching the
> Unit Attention sense data.
> 
> Macros scsi_get_ua_new_media_ctr and scsi_get_ua_por_ctr are added to
> read the current values of the counters.
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/st.c          | 30 +++++++++++++++++++++++++-----
>   drivers/scsi/st.h          |  4 ++++
>   include/scsi/scsi_device.h |  6 ++++++
>   3 files changed, 35 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index 0fc9afe60862..6ec1cfeb92ff 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -163,9 +163,11 @@ static const char *st_formats[] = {
>   
>   static int debugging = DEBUG;
>   
> +/* Setting these non-zero may risk recognizing resets */
>   #define MAX_RETRIES 0
>   #define MAX_WRITE_RETRIES 0
>   #define MAX_READY_RETRIES 0
> +
>   #define NO_TAPE  NOT_READY
>   
>   #define ST_TIMEOUT (900 * HZ)
> @@ -357,10 +359,18 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
>   {
>   	int result = SRpnt->result;
>   	u8 scode;
> +	unsigned int ctr;
>   	DEB(const char *stp;)
>   	char *name = STp->name;
>   	struct st_cmdstatus *cmdstatp;
>   
> +	ctr = scsi_get_ua_por_ctr(STp->device);
> +	if (ctr != STp->por_ctr) {
> +		STp->por_ctr = ctr;
> +		STp->pos_unknown = 1; /* ASC => power on / reset */
> +		st_printk(KERN_WARNING, STp, "Power on/reset recognized.");
> +	}
> +
>   	if (!result)
>   		return 0;
>   
> @@ -413,10 +423,11 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
>   	if (cmdstatp->have_sense &&
>   	    cmdstatp->sense_hdr.asc == 0 && cmdstatp->sense_hdr.ascq == 0x17)
>   		STp->cleaning_req = 1; /* ASC and ASCQ => cleaning requested */
> -	if (cmdstatp->have_sense && scode == UNIT_ATTENTION && cmdstatp->sense_hdr.asc == 0x29)
> +	if (cmdstatp->have_sense && scode == UNIT_ATTENTION &&
> +		cmdstatp->sense_hdr.asc == 0x29 && !STp->pos_unknown) {
>   		STp->pos_unknown = 1; /* ASC => power on / reset */
> -
> -	STp->pos_unknown |= STp->device->was_reset;
> +		st_printk(KERN_WARNING, STp, "Power on/reset recognized.");
> +	}
>   
>   	if (cmdstatp->have_sense &&
>   	    scode == RECOVERED_ERROR
> @@ -968,6 +979,7 @@ static int test_ready(struct scsi_tape *STp, int do_wait)
>   {
>   	int attentions, waits, max_wait, scode;
>   	int retval = CHKRES_READY, new_session = 0;
> +	unsigned int ctr;
>   	unsigned char cmd[MAX_COMMAND_SIZE];
>   	struct st_request *SRpnt = NULL;
>   	struct st_cmdstatus *cmdstatp = &STp->buffer->cmdstat;
> @@ -1024,6 +1036,13 @@ static int test_ready(struct scsi_tape *STp, int do_wait)
>   			}
>   		}
>   
> +		ctr = scsi_get_ua_new_media_ctr(STp->device);
> +		if (ctr != STp->new_media_ctr) {
> +			STp->new_media_ctr = ctr;
> +			new_session = 1;
> +			DEBC_printk(STp, "New tape session.");
> +		}
> +
>   		retval = (STp->buffer)->syscall_result;
>   		if (!retval)
>   			retval = new_session ? CHKRES_NEW_SESSION : CHKRES_READY;
> @@ -3639,8 +3658,6 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
>   				goto out;
>   			}
>   			reset_state(STp); /* Clears pos_unknown */
> -			/* remove this when the midlevel properly clears was_reset */
> -			STp->device->was_reset = 0;
>   
>   			/* Fix the device settings after reset, ignore errors */
>   			if (mtc.mt_op == MTREW || mtc.mt_op == MTSEEK ||
> @@ -4402,6 +4419,9 @@ static int st_probe(struct device *dev)
>   		goto out_idr_remove;
>   	}
>   
> +	tpnt->new_media_ctr = scsi_get_ua_new_media_ctr(SDp);
> +	tpnt->por_ctr = scsi_get_ua_por_ctr(SDp);
> +
>   	dev_set_drvdata(dev, tpnt);
>   
>   
> diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
> index 6d31b894ee84..0d7c4b8c2c8a 100644
> --- a/drivers/scsi/st.h
> +++ b/drivers/scsi/st.h
> @@ -179,6 +179,10 @@ struct scsi_tape {
>   	int recover_count;     /* From tape opening */
>   	int recover_reg;       /* From last status call */
>   
> +	/* The saved values of midlevel counters */
> +	unsigned int new_media_ctr;
> +	unsigned int por_ctr;
> +
>   #if DEBUG
>   	unsigned char write_pending;
>   	int nbr_finished;
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index f5c0f07a053a..013018608370 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -687,6 +687,12 @@ static inline int scsi_device_busy(struct scsi_device *sdev)
>   	return sbitmap_weight(&sdev->budget_map);
>   }
>   
> +/* Macros to access the UNIT ATTENTION counters */
> +#define scsi_get_ua_new_media_ctr(sdev) \
> +	((const unsigned int)(sdev->ua_new_media_ctr))
> +#define scsi_get_ua_por_ctr(sdev) \
> +	((const unsigned int)(sdev->ua_por_ctr))
> +
>   #define MODULE_ALIAS_SCSI_DEVICE(type) \
>   	MODULE_ALIAS("scsi:t-" __stringify(type) "*")
>   #define SCSI_DEVICE_MODALIAS_FMT "scsi:t-0x%02x"

