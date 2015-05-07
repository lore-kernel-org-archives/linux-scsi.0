From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 04/17] scsi_dh_alua: Improve error handling
Date: Thu, 7 May 2015 13:48:35 +0200
Message-ID: <554B5113.7050800@sandisk.com>
References: <1430743343-47174-1-git-send-email-hare@suse.de>
 <1430743343-47174-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2on0095.outbound.protection.outlook.com ([65.55.169.95]:52246
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753011AbbEGLsm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 May 2015 07:48:42 -0400
In-Reply-To: <1430743343-47174-5-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On 05/04/15 14:42, Hannes Reinecke wrote:
> @@ -161,12 +164,12 @@ static unsigned submit_rtpg(struct scsi_device *sdev, struct alua_dh_data *h,
>   	rq->sense_len = h->senselen = 0;
>
>   	err = blk_execute_rq(rq->q, NULL, rq, 1);
> -	if (err == -EIO) {
> -		sdev_printk(KERN_INFO, sdev,
> -			    "%s: rtpg failed with %x\n",
> -			    ALUA_DH_NAME, rq->errors);
> +	if (err < 0) {
> +		if (!rq->errors)
> +			err = DID_ERROR << 16;
> +		else
> +			err = rq->errors;
>   		h->senselen = rq->sense_len;
> -		err = SCSI_DH_IO;
>   	}
>   	blk_put_request(rq);
>   done:

Running the grep query "->errors = " over the Linux kernel source tree 
shows that sometimes a SCSI error code is written into that field and 
sometimes a negative error code. Does this mean that the test 
!rq->errors should be modified into !rq->errors && 
!IS_ERR_VALUE(rq->errors) ?

Bart.
