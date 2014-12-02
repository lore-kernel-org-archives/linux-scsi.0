From: wenxiong@linux.vnet.ibm.com
Subject: Re: [PATCH RESEND 4/5] ipr: Set scsi_level correctly for disk
 arrays
Date: Tue, 02 Dec 2014 16:25:05 -0500
Message-ID: <20141202162505.Horde.U_nJk5i2nwL2Yzf6abYzBQ9@ltc.linux.ibm.com>
References: <201412021847.sB2IlkT5007118@d03av01.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed; DelSp=Yes
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:42219 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932692AbaLBVZM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2014 16:25:12 -0500
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <wenxiong@linux.vnet.ibm.com>;
	Tue, 2 Dec 2014 14:25:11 -0700
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
	by d03dlp03.boulder.ibm.com (Postfix) with ESMTP id A5B3019D801C
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2014 14:13:49 -0700 (MST)
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id sB2LPa8739387204
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 14:25:36 -0700
Received: from d03av03.boulder.ibm.com (localhost [127.0.0.1])
	by d03av03.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id sB2LP7U2024054
	for <linux-scsi@vger.kernel.org>; Tue, 2 Dec 2014 14:25:08 -0700
In-Reply-To: <201412021847.sB2IlkT5007118@d03av01.boulder.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@hansenpartnership.com, hch@lst.de, linux-scsi@vger.kernel.org, anton@samba.org

Reviewed-by: Wen Xiong<wenxiong@linux.vnet.ibm.com>

Thanks,
Wendy

Quoting Brian King <brking@linux.vnet.ibm.com>:

> Set the scsi_level correctly for disk arrays such
> that things like the rotational field get set
> properly by sd.c.
>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
>
>  drivers/scsi/ipr.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff -puN drivers/scsi/ipr.c~ipr_array_scsi_level drivers/scsi/ipr.c
> --- scsi-queue/drivers/scsi/ipr.c~ipr_array_scsi_level	2014-12-02  
> 12:13:28.585275691 -0600
> +++ scsi-queue-bjking1/drivers/scsi/ipr.c	2014-12-02 12:13:28.591275641 -0600
> @@ -4740,6 +4740,7 @@ static int ipr_slave_configure(struct sc
>  			sdev->no_uld_attach = 1;
>  		}
>  		if (ipr_is_vset_device(res)) {
> +			sdev->scsi_level = SCSI_SPC_3;
>  			blk_queue_rq_timeout(sdev->request_queue,
>  					     IPR_VSET_RW_TIMEOUT);
>  			blk_queue_max_hw_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
> _


