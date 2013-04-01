From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ibmvscsi: Fix slave_configure deadlock
Date: Mon, 1 Apr 2013 09:49:43 -0500
Message-ID: <20130401144943.GA2944@linux.vnet.ibm.com>
References: <201304011444.r31EiRb3018412@d03av04.boulder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:50159 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758472Ab3DAOt4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Apr 2013 10:49:56 -0400
Received: from /spool/local
	by e28smtp08.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <rcjenn@linux.vnet.ibm.com>;
	Mon, 1 Apr 2013 20:14:46 +0530
Received: from d28relay02.in.ibm.com (d28relay02.in.ibm.com [9.184.220.59])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 4C7D61258023
	for <linux-scsi@vger.kernel.org>; Mon,  1 Apr 2013 20:21:07 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay02.in.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r31EnjlJ5964184
	for <linux-scsi@vger.kernel.org>; Mon, 1 Apr 2013 20:19:45 +0530
Received: from d28av02.in.ibm.com (loopback [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r31EnlY0013400
	for <linux-scsi@vger.kernel.org>; Tue, 2 Apr 2013 01:49:47 +1100
Content-Disposition: inline
In-Reply-To: <201304011444.r31EiRb3018412@d03av04.boulder.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

* Brian King (brking@linux.vnet.ibm.com) wrote:
> 
> No locks should be held when calling scsi_adjust_queue_depth
> so drop the lock in slave_configure prior to calling it.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Acked-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ibmvscsi/ibmvscsi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_slave_configure_deadlock drivers/scsi/ibmvscsi/ibmvscsi.c
> --- linux/drivers/scsi/ibmvscsi/ibmvscsi.c~ibmvscsi_slave_configure_deadlock	2013-03-06 16:36:26.000000000 -0600
> +++ linux-bjking1/drivers/scsi/ibmvscsi/ibmvscsi.c	2013-03-06 16:36:26.000000000 -0600
> @@ -1899,8 +1899,8 @@ static int ibmvscsi_slave_configure(stru
>  		sdev->allow_restart = 1;
>  		blk_queue_rq_timeout(sdev->request_queue, 120 * HZ);
>  	}
> -	scsi_adjust_queue_depth(sdev, 0, shost->cmd_per_lun);
>  	spin_unlock_irqrestore(shost->host_lock, lock_flags);
> +	scsi_adjust_queue_depth(sdev, 0, shost->cmd_per_lun);
>  	return 0;
>  }
> 
> _

