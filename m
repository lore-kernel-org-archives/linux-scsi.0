Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F459CA9ED5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 06:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0AC7B20818
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 06:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730565AbfKEGDe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 01:03:34 -0500
Received: from smtp.infotech.no ([82.134.31.41]:53562 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730152AbfKEGDe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 Nov 2019 01:03:34 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id B346920424C;
        Tue,  5 Nov 2019 07:03:31 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZrGnv5vkRgIl; Tue,  5 Nov 2019 07:03:25 +0100 (CET)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id C490F20414D;
        Tue,  5 Nov 2019 07:03:24 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH 20/52] sg: use SAM status definitions and avoid using
 masked_status
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-21-hare@suse.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <4a49bf06-3f4b-b63d-4d8e-de9da15b7a53@interlog.com>
Date:   Tue, 5 Nov 2019 01:03:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-21-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-04 4:01 a.m., Hannes Reinecke wrote:
> Use standard SAM status definitions and avoid using masked status
> values.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/sg.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index e88fb3daebcc..60ff388d04b9 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -503,7 +503,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
>   	old_hdr->target_status = hp->masked_status;
>   	old_hdr->host_status = hp->host_status;
>   	old_hdr->driver_status = hp->driver_status;
> -	if ((CHECK_CONDITION & hp->masked_status) ||
> +	if ((SAM_STAT_CHECK_CONDITION & hp->status) ||
>   	    (DRIVER_SENSE & hp->driver_status))
>   		memcpy(old_hdr->sense_buffer, srp->sense_b,
>   		       sizeof (old_hdr->sense_buffer));
> @@ -529,7 +529,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
>   		break;
>   	case DID_ERROR:
>   		old_hdr->result = (srp->sense_b[0] == 0 &&
> -				  hp->masked_status == GOOD) ? 0 : EIO;
> +				  hp->status == SAM_STAT_GOOD) ? 0 : EIO;
>   		break;
>   	default:
>   		old_hdr->result = EIO;
> @@ -574,7 +574,7 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
>   	}
>   	hp->sb_len_wr = 0;
>   	if ((hp->mx_sb_len > 0) && hp->sbp) {
> -		if ((CHECK_CONDITION & hp->masked_status) ||
> +		if ((SAM_STAT_CHECK_CONDITION & hp->status) ||
>   		    (DRIVER_SENSE & hp->driver_status)) {
>   			int sb_len = SCSI_SENSE_BUFFERSIZE;
>   			sb_len = (hp->mx_sb_len > sb_len) ? sb_len : hp->mx_sb_len;
> @@ -587,7 +587,7 @@ sg_new_read(Sg_fd * sfp, char __user *buf, size_t count, Sg_request * srp)
>   			hp->sb_len_wr = len;
>   		}
>   	}
> -	if (hp->masked_status || hp->host_status || hp->driver_status)
> +	if (hp->status || hp->host_status || hp->driver_status)
>   		hp->info |= SG_INFO_CHECK;
>   	if (copy_to_user(buf, hp, SZ_SG_IO_HDR)) {
>   		err = -EFAULT;
> @@ -873,7 +873,7 @@ sg_fill_request_table(Sg_fd *sfp, sg_req_info_t *rinfo)
>   			break;
>   		rinfo[val].req_state = srp->done + 1;
>   		rinfo[val].problem =
> -			srp->header.masked_status &
> +			srp->header.status &
>   			srp->header.host_status &
>   			srp->header.driver_status;
>   		if (srp->done)
> @@ -1355,8 +1355,8 @@ sg_rq_end_io(struct request *rq, blk_status_t status)
>   		srp->header.host_status = host_byte(result);
>   		srp->header.driver_status = driver_byte(result);
>   		if ((sdp->sgdebug > 0) &&
> -		    ((CHECK_CONDITION == srp->header.masked_status) ||
> -		     (COMMAND_TERMINATED == srp->header.masked_status)))
> +		    ((SAM_STAT_CHECK_CONDITION == srp->header.status) ||
> +		     (SAM_STAT_COMMAND_TERMINATED == srp->header.status)))
>   			__scsi_print_sense(sdp->device, __func__, sense,
>   					   SCSI_SENSE_BUFFERSIZE);
>   
> 

