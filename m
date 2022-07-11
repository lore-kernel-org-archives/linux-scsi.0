Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B3BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 19:37:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiGKThH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 15:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiGKThG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 15:37:06 -0400
Received: from mp-relay-02.fibernetics.ca (mp-relay-02.fibernetics.ca [208.85.217.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DF752BB36
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 12:37:05 -0700 (PDT)
Received: from mailpool-fe-02.fibernetics.ca (mailpool-fe-02.fibernetics.ca [208.85.217.145])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mp-relay-02.fibernetics.ca (Postfix) with ESMTPS id 1D71661210;
        Mon, 11 Jul 2022 19:37:04 +0000 (UTC)
Received: from localhost (mailpool-mx-01.fibernetics.ca [208.85.217.140])
        by mailpool-fe-02.fibernetics.ca (Postfix) with ESMTP id 0D6506041D;
        Mon, 11 Jul 2022 19:37:04 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at 
Received: from mailpool-fe-02.fibernetics.ca ([208.85.217.145])
        by localhost (mail-mx-01.fibernetics.ca [208.85.217.140]) (amavisd-new, port 10024)
        with ESMTP id UwRlEjIrXDVe; Mon, 11 Jul 2022 19:37:03 +0000 (UTC)
Received: from [192.168.48.23] (host-104-157-202-215.dyn.295.ca [104.157.202.215])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail.ca.inter.net (Postfix) with ESMTPSA id 3B8BB60418;
        Mon, 11 Jul 2022 19:37:03 +0000 (UTC)
Message-ID: <9ab54290-bf4a-4581-5c13-5ccae06013d5@interlog.com>
Date:   Mon, 11 Jul 2022 15:37:02 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH RESEND] sg: allow waiting for commands to complete on
 removed device
Content-Language: en-CA
To:     Tony Battersby <tonyb@cybernetics.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>
References: <5ebea46f-fe83-2d0b-233d-d0dcb362dd0a@cybernetics.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <5ebea46f-fe83-2d0b-233d-d0dcb362dd0a@cybernetics.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022-07-11 10:51, Tony Battersby wrote:
> When a SCSI device is removed while in active use, currently sg will
> immediately return -ENODEV on any attempt to wait for active commands
> that were sent before the removal.  This is problematic for commands
> that use SG_FLAG_DIRECT_IO since the data buffer may still be in use by
> the kernel when userspace frees or reuses it after getting ENODEV,
> leading to corrupted userspace memory (in the case of READ-type
> commands) or corrupted data being sent to the device (in the case of
> WRITE-type commands).  This has been seen in practice when logging out
> of a iscsi_tcp session, where the iSCSI driver may still be processing
> commands after the device has been marked for removal.
> 
> So change the policy to allow userspace to wait for active sg commands
> even when the device is being removed.  Return -ENODEV only when there
> are no more responses to read.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

Thanks.

> ---
>   drivers/scsi/sg.c | 53 +++++++++++++++++++++++++++++------------------
>   1 file changed, 33 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 118c7b4a8af2..340b050ad28d 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -195,7 +195,7 @@ static void sg_link_reserve(Sg_fd * sfp, Sg_request * srp, int size);
>   static void sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp);
>   static Sg_fd *sg_add_sfp(Sg_device * sdp);
>   static void sg_remove_sfp(struct kref *);
> -static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id);
> +static Sg_request *sg_get_rq_mark(Sg_fd * sfp, int pack_id, bool *busy);
>   static Sg_request *sg_add_request(Sg_fd * sfp);
>   static int sg_remove_request(Sg_fd * sfp, Sg_request * srp);
>   static Sg_device *sg_get_dev(int dev);
> @@ -444,6 +444,7 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
>   	Sg_fd *sfp;
>   	Sg_request *srp;
>   	int req_pack_id = -1;
> +	bool busy;
>   	sg_io_hdr_t *hp;
>   	struct sg_header *old_hdr;
>   	int retval;
> @@ -466,20 +467,16 @@ sg_read(struct file *filp, char __user *buf, size_t count, loff_t * ppos)
>   	if (retval)
>   		return retval;
>   
> -	srp = sg_get_rq_mark(sfp, req_pack_id);
> +	srp = sg_get_rq_mark(sfp, req_pack_id, &busy);
>   	if (!srp) {		/* now wait on packet to arrive */
> -		if (atomic_read(&sdp->detaching))
> -			return -ENODEV;
>   		if (filp->f_flags & O_NONBLOCK)
>   			return -EAGAIN;
>   		retval = wait_event_interruptible(sfp->read_wait,
> -			(atomic_read(&sdp->detaching) ||
> -			(srp = sg_get_rq_mark(sfp, req_pack_id))));
> -		if (atomic_read(&sdp->detaching))
> -			return -ENODEV;
> -		if (retval)
> -			/* -ERESTARTSYS as signal hit process */
> -			return retval;
> +			((srp = sg_get_rq_mark(sfp, req_pack_id, &busy)) ||
> +			(!busy && atomic_read(&sdp->detaching))));
> +		if (!srp)
> +			/* signal or detaching */
> +			return retval ? retval : -ENODEV;
>   	}
>   	if (srp->header.interface_id != '\0')
>   		return sg_new_read(sfp, buf, count, srp);
> @@ -940,9 +937,7 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
>   		if (result < 0)
>   			return result;
>   		result = wait_event_interruptible(sfp->read_wait,
> -			(srp_done(sfp, srp) || atomic_read(&sdp->detaching)));
> -		if (atomic_read(&sdp->detaching))
> -			return -ENODEV;
> +			srp_done(sfp, srp));
>   		write_lock_irq(&sfp->rq_list_lock);
>   		if (srp->done) {
>   			srp->done = 2;
> @@ -2079,19 +2074,28 @@ sg_unlink_reserve(Sg_fd * sfp, Sg_request * srp)
>   }
>   
>   static Sg_request *
> -sg_get_rq_mark(Sg_fd * sfp, int pack_id)
> +sg_get_rq_mark(Sg_fd * sfp, int pack_id, bool *busy)
>   {
>   	Sg_request *resp;
>   	unsigned long iflags;
>   
> +	*busy = false;
>   	write_lock_irqsave(&sfp->rq_list_lock, iflags);
>   	list_for_each_entry(resp, &sfp->rq_list, entry) {
> -		/* look for requests that are ready + not SG_IO owned */
> -		if ((1 == resp->done) && (!resp->sg_io_owned) &&
> +		/* look for requests that are not SG_IO owned */
> +		if ((!resp->sg_io_owned) &&
>   		    ((-1 == pack_id) || (resp->header.pack_id == pack_id))) {
> -			resp->done = 2;	/* guard against other readers */
> -			write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> -			return resp;
> +			switch (resp->done) {
> +			case 0: /* request active */
> +				*busy = true;
> +				break;
> +			case 1: /* request done; response ready to return */
> +				resp->done = 2;	/* guard against other readers */
> +				write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> +				return resp;
> +			case 2: /* response already being returned */
> +				break;
> +			}
>   		}
>   	}
>   	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> @@ -2145,6 +2149,15 @@ sg_remove_request(Sg_fd * sfp, Sg_request * srp)
>   		res = 1;
>   	}
>   	write_unlock_irqrestore(&sfp->rq_list_lock, iflags);
> +
> +	/*
> +	 * If the device is detaching, wakeup any readers in case we just
> +	 * removed the last response, which would leave nothing for them to
> +	 * return other than -ENODEV.
> +	 */
> +	if (unlikely(atomic_read(&sfp->parentdp->detaching)))
> +		wake_up_interruptible_all(&sfp->read_wait);
> +
>   	return res;
>   }
>   
> -- 2.25.1
> 

