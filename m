From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH] scsi_dh_rdac: Add dynamic match functionality to rdac
 handler
Date: Fri, 20 Apr 2012 11:27:12 -0500
Message-ID: <1334939232.3420.30.camel@chandra-lucid.austin.ibm.com>
References: <77471C95FAFD844C8CA02DD4F4C5FE2B0574C6@SACEXCMBX02-PRD.hq.netapp.com>
Reply-To: sekharan@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:59361 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2DTQ1m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Apr 2012 12:27:42 -0400
Received: from /spool/local
	by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <sekharan@us.ibm.com>;
	Fri, 20 Apr 2012 10:27:41 -0600
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id 0405419D805F
	for <linux-scsi@vger.kernel.org>; Fri, 20 Apr 2012 10:27:24 -0600 (MDT)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id q3KGRHXm182138
	for <linux-scsi@vger.kernel.org>; Fri, 20 Apr 2012 10:27:26 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id q3KGRF0a029968
	for <linux-scsi@vger.kernel.org>; Fri, 20 Apr 2012 10:27:16 -0600
In-Reply-To: <77471C95FAFD844C8CA02DD4F4C5FE2B0574C6@SACEXCMBX02-PRD.hq.netapp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@netapp.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, "Krishnasamy, Somasundaram" <Somasundaram.Krishnasamy@netapp.com>

Babu,

So, in effect, any SCSI devices with INQ C8 page with "edid" would be
treated as a rdac device, right ?

Is that enough to identify _any_ SCSI device as a rdac device (even in
future) ?

Also, instead of repeating the code, can you use submit_inquiry() ?

Chandra


On Tue, 2012-04-10 at 17:06 +0000, Moger, Babu wrote:
> This patch adds the dynamic match functionality to scsi_dh_rdac driver.
> New vendor and product strings are normally not there in the kernel. Whenever
> the new product is tested with this driver we see failures during the disco-
> very. Without the handler attached, the default scsi mid-level retries would
> take effect for certain check-conditions. Default retries(5) are not enough in
> some cases(especially with large configuration or huge lun cases).
> 
> This patch will send an inquiry if the vendor/product strings are not in the
> device list and match with vendor signature.
> 
> Signed-off-by: Babu Moger <babu.moger@netapp.com>
> Reviewed-by: Somasundaram Krishnasamy <Somasundaram.Krishnasamy@netapp.com>
> ---
> 
> --- linux-3.4-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2012-04-07 20:30:41.000000000 -0500
> +++ linux-3.4-rc2/drivers/scsi/device_handler/scsi_dh_rdac.c	2012-04-10 10:48:40.000000000 -0500
> @@ -818,7 +818,10 @@ static const struct scsi_dh_devlist rdac
> 
>  static bool rdac_match(struct scsi_device *sdev)
>  {
> -	int i;
> +	int i, err;
> +	struct c8_inquiry inqp;
> +	struct request *rq;
> +	struct request_queue *q = sdev->request_queue;
> 
>  	if (scsi_device_tpgs(sdev))
>  		return false;
> @@ -831,6 +834,27 @@ static bool rdac_match(struct scsi_devic
>  			return true;
>  		}
>  	}
> +
> +	/* Now lets try to match the signature on 0xC8 page */
> +	memset(&inqp, 0, sizeof(struct c8_inquiry));
> +	rq = get_rdac_req(sdev, &inqp, sizeof(struct c8_inquiry), READ);
> +	if (!rq)
> +		return false;
> +
> +	rq->cmd[0] = INQUIRY;
> +	rq->cmd[1] = 1;
> +	rq->cmd[2] = 0xC8;
> +	rq->cmd[4] = sizeof(struct c8_inquiry);
> +	rq->cmd_len = COMMAND_SIZE(INQUIRY);
> +
> +	err = blk_execute_rq(q, NULL, rq, 1);
> +	blk_put_request(rq);
> +	if (err != -EIO) {
> +		if (inqp.page_id[0] == 'e' && inqp.page_id[1] == 'd' &&
> +		    inqp.page_id[2] == 'i' && inqp.page_id[3] == 'd')
> +			return true;
> +	}
> +
>  	return false;
>  }
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


