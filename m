Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD641C433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 00:24:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7F71E613BA
	for <linux-scsi@archiver.kernel.org>; Fri,  7 May 2021 00:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbhEGAZx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 20:25:53 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:30772 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233539AbhEGAZv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 May 2021 20:25:51 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1620347093; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=ccf46jQUVaiaNTWTzikhMNTmLphP+O8YwzQFZTWu1SM=;
 b=sWJXu6XvmfFW4b7YxgIUtIlW0tVN/PMUjntejV7vgOz/+Spj0TXiIYa/briFQ3gY77fD75Ua
 0WCKb7VbUI9fjunt7qVo7Y7yvi0QZ8x8EjA7QOoKcceKkFxU6yELZxcHnRvVAq4uUk7YZQDI
 caHQusHmLgDrsG985swSxo3pWMQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-east-1.postgun.com with SMTP id
 609488b987ce1fbb5645e0b3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 07 May 2021 00:24:25
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 2A423C43145; Fri,  7 May 2021 00:24:25 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E7824C433D3;
        Fri,  7 May 2021 00:24:20 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 07 May 2021 08:24:20 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Don Brace <don.brace@microchip.com>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Lee Duncan <lduncan@suse.com>
Subject: Re: [PATCH 110/117] Finalize the switch from 'int' to 'union
 scsi_status'
In-Reply-To: <20210420021402.27678-20-bvanassche@acm.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420021402.27678-20-bvanassche@acm.org>
Message-ID: <3ab15b8e1564937fd823cdd135c86da9@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-04-20 10:13, Bart Van Assche wrote:
> A previous patch changed 'int result;' into a union and introduced the
> scsi_status member in that union. Now that the conversion from type
> 'int' into 'union scsi_status' is complete, remove the 'result' member.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Lee Duncan <lduncan@suse.com>
> Cc: Can Guo <cang@codeaurora.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  include/linux/bsg-lib.h          | 5 +----
>  include/scsi/scsi_bsg_iscsi.h    | 7 ++-----
>  include/scsi/scsi_cmnd.h         | 5 +----
>  include/scsi/scsi_eh.h           | 5 +----
>  include/scsi/scsi_request.h      | 5 +----
>  include/uapi/scsi/scsi_bsg_fc.h  | 5 +----
>  include/uapi/scsi/scsi_bsg_ufs.h | 7 ++-----
>  7 files changed, 9 insertions(+), 30 deletions(-)
> 
> diff --git a/include/linux/bsg-lib.h b/include/linux/bsg-lib.h
> index f934afc45760..6143a54454db 100644
> --- a/include/linux/bsg-lib.h
> +++ b/include/linux/bsg-lib.h
> @@ -53,10 +53,7 @@ struct bsg_job {
>  	struct bsg_buffer request_payload;
>  	struct bsg_buffer reply_payload;
> 
> -	union {
> -		int		  result; /* do not use in new code */
> -		union scsi_status status;
> -	};
> +	union scsi_status status;
>  	unsigned int reply_payload_rcv_len;
> 
>  	/* BIDI support */
> diff --git a/include/scsi/scsi_bsg_iscsi.h 
> b/include/scsi/scsi_bsg_iscsi.h
> index d18e7e061927..e384df88fab1 100644
> --- a/include/scsi/scsi_bsg_iscsi.h
> +++ b/include/scsi/scsi_bsg_iscsi.h
> @@ -76,17 +76,14 @@ struct iscsi_bsg_request {
>  /* response (request sense data) structure of the sg_io_v4 */
>  struct iscsi_bsg_reply {
>  	/*
> -	 * The completion result. Result exists in two forms:
> +	 * The completion status. Result exists in two forms:
>  	 * if negative, it is an -Exxx system errno value. There will
>  	 * be no further reply information supplied.
>  	 * else, it's the 4-byte scsi error result, with driver, host,
>  	 * msg and status fields. The per-msgcode reply structure
>  	 * will contain valid data.
>  	 */
> -	union {
> -		uint32_t	  result; /* do not use in new code */
> -		union scsi_status status;
> -	};
> +	union scsi_status status;
> 
>  	/* If there was reply_payload, how much was recevied ? */
>  	uint32_t reply_payload_rcv_len;
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 539be97b0a7d..b616e1d8af9a 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -141,10 +141,7 @@ struct scsi_cmnd {
>  					 * to be at an address < 16Mb). */
> 
>  	/* Status code from lower level driver */
> -	union {
> -		int		  result; /* do not use in new code. */
> -		union scsi_status status;
> -	};
> +	union scsi_status status;
>  	int flags;		/* Command flags */
>  	unsigned long state;	/* Command completion state */
> 
> diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
> index dcd66bb9a1ba..406e22887d96 100644
> --- a/include/scsi/scsi_eh.h
> +++ b/include/scsi/scsi_eh.h
> @@ -33,10 +33,7 @@ extern int scsi_ioctl_reset(struct scsi_device *,
> int __user *);
> 
>  struct scsi_eh_save {
>  	/* saved state */
> -	union {
> -		int		  result; /* do not use in new code */
> -		union scsi_status status;
> -	};
> +	union scsi_status status;
>  	unsigned int resid_len;
>  	int eh_eflags;
>  	enum dma_data_direction data_direction;
> diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
> index 83f5549cc74c..41b8f9f6a349 100644
> --- a/include/scsi/scsi_request.h
> +++ b/include/scsi/scsi_request.h
> @@ -11,10 +11,7 @@ struct scsi_request {
>  	unsigned char	__cmd[BLK_MAX_CDB];
>  	unsigned char	*cmd;
>  	unsigned short	cmd_len;
> -	union {
> -		int		  result; /* do not use in new code */
> -		union scsi_status status;
> -	};
> +	union scsi_status status;
>  	unsigned int	sense_len;
>  	unsigned int	resid_len;	/* residual count */
>  	int		retries;
> diff --git a/include/uapi/scsi/scsi_bsg_fc.h 
> b/include/uapi/scsi/scsi_bsg_fc.h
> index 419db719fe8e..6d095aefc265 100644
> --- a/include/uapi/scsi/scsi_bsg_fc.h
> +++ b/include/uapi/scsi/scsi_bsg_fc.h
> @@ -295,10 +295,7 @@ struct fc_bsg_reply {
>  	 *    will contain valid data.
>  	 */
>  #ifdef __KERNEL__
> -	union {
> -		__u32		  result; /* do not use in new kernel code */
> -		union scsi_status status;
> -	};
> +	union scsi_status status;
>  #else
>  	__u32 result;
>  #endif
> diff --git a/include/uapi/scsi/scsi_bsg_ufs.h 
> b/include/uapi/scsi/scsi_bsg_ufs.h
> index 3dfe5a5a0842..1c282ab144f6 100644
> --- a/include/uapi/scsi/scsi_bsg_ufs.h
> +++ b/include/uapi/scsi/scsi_bsg_ufs.h
> @@ -92,7 +92,7 @@ struct ufs_bsg_request {
>  /* response (request sense data) structure of the sg_io_v4 */
>  struct ufs_bsg_reply {
>  	/*
> -	 * The completion result. Result exists in two forms:
> +	 * The completion status. Exists in two forms:
>  	 * if negative, it is an -Exxx system errno value. There will
>  	 * be no further reply information supplied.
>  	 * else, it's the 4-byte scsi error result, with driver, host,
> @@ -100,10 +100,7 @@ struct ufs_bsg_reply {
>  	 * will contain valid data.
>  	 */
>  #ifdef __KERNEL__
> -	union {
> -		__u32		  result; /* do not use in new kernel code */
> -		union scsi_status status;
> -	};
> +	union scsi_status status;
>  #else
>  	__u32 result;
>  #endif

Reviewed-by: Can Guo <cang@codeaurora.org>
