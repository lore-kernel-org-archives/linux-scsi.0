Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E61195
	for <linux-scsi@vger.kernel.org>; Wed, 11 Dec 2024 22:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733955252; cv=none; b=rBJfZ580ITTUgWj3ZT6UA0OofrjHlWA6tKEAf/BE8y+cVi6OcYzIYRWnYkB4ZuR5UBl+bdNXv/S6nk2AXphHqamJIjeKc8VqQaX/mhL6nuhzLQwm/Yw8HcRj03fo8tp63dbXj0Z2cb4rc1kHknYAQnaACUdwOQttMTnaKjAXMyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733955252; c=relaxed/simple;
	bh=v3SjzdDrJJyw/v9q2cHbRg7q3r2co6pH0hSJUS7uCMU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Llfy4XI57HKWpYIFO9pYywUMbRlxBa2PiA2TF9+MvF0VLEjxbiqAde92YlNoQRFhBamWhywtypmLAp2/qQP4d5yw0FveEsFVkZhswddJeb58ShJg9dzrQZv6hi1w5F4xFoiC4zmyBnWBjXbH9QEwOj+otKov02LlDVPO8u2fUwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=b5ft/hos; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="b5ft/hos"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733955249;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gSQuTIQstpzIyyKEv23xiIJoagUsxy9Zu2juA8/a18U=;
	b=b5ft/hosKbjLUuwtKiRFRBHR6iNYYinF2hCLG7tRpEvtHFb8T/6ya+qk3JbQQ8m8ed5dtq
	3k6LqWb/2hF0gIwRHpzSa+7g/CTF5RIwrymmcKPDJLeMhGdokZU6pArpCTQej3yU2nXema
	tfaGuUqPoojYli12d6d8Jq6TxZgIH08=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-vH0qWZixNu2YHzM0haUBIw-1; Wed,
 11 Dec 2024 17:14:08 -0500
X-MC-Unique: vH0qWZixNu2YHzM0haUBIw-1
X-Mimecast-MFC-AGG-ID: vH0qWZixNu2YHzM0haUBIw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 53257195608C;
	Wed, 11 Dec 2024 22:14:07 +0000 (UTC)
Received: from [10.22.64.187] (unknown [10.22.64.187])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 977DA19560AA;
	Wed, 11 Dec 2024 22:14:05 +0000 (UTC)
Message-ID: <039cfcda-6549-4a46-b945-27f4d749b789@redhat.com>
Date: Wed, 11 Dec 2024 17:14:04 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] scsi: st: Modify st.c to use the new scsi_error
 counters
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
 loberman@redhat.com
References: <20241125140301.3912-1-Kai.Makisara@kolumbus.fi>
 <20241125140301.3912-4-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <20241125140301.3912-4-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>

On 11/25/24 09:03, Kai Mäkisara wrote:
> Compare the stored values of por_ctr and new_media_ctr against
> the values in the device struct. In case of mismatch, the
> Unit Attention corresponding to the counter has happened.
> This is a safeguard against another ULD catching the
> Unit Attention sense data.
> 
> Remove use of the was_reset flag in struct scsi_device.
> 
> Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
> ---
>   drivers/scsi/st.c | 28 +++++++++++++++++++++++++---
>   drivers/scsi/st.h |  4 ++++
>   2 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index a0667a0ae4c9..ad86dfbc8919 100644
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
> @@ -4394,6 +4413,9 @@ static int st_probe(struct device *dev)
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
> index 2105c6a5b458..47b0e31b7828 100644
> --- a/drivers/scsi/st.h
> +++ b/drivers/scsi/st.h
> @@ -178,6 +178,10 @@ struct scsi_tape {
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

