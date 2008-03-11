From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [BUG 1/3] bsg queue oops with iscsi logout
Date: Wed, 12 Mar 2008 07:46:24 +0900
Message-ID: <20080312074624A.fujita.tomonori@lab.ntt.co.jp>
References: <20080309165359.GA24388@osc.edu>
	<47D5766C.3020206@cs.wisc.edu>
	<47D61A73.3000803@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:56230 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbYCKWrH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Mar 2008 18:47:07 -0400
In-Reply-To: <47D61A73.3000803@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: pw@osc.edu, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, erezz@voltaire.com

On Tue, 11 Mar 2008 00:36:51 -0500
Mike Christie <michaelc@cs.wisc.edu> wrote:

> Delay bsg unregistration, because we want to wait until all the request/cmds
> have released their reference.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

Thanks!

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index ed83cdb..b9b09a7 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -294,6 +294,7 @@ static void scsi_device_dev_release_usercontext(struct work_struct *work)
>  	}
>  
>  	if (sdev->request_queue) {
> +		bsg_unregister_queue(sdev->request_queue);
>  		sdev->request_queue->queuedata = NULL;
>  		/* user context needed to free queue */
>  		scsi_free_queue(sdev->request_queue);
> @@ -857,7 +858,6 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  	if (scsi_device_set_state(sdev, SDEV_CANCEL) != 0)
>  		return;
>  
> -	bsg_unregister_queue(sdev->request_queue);
>  	class_device_unregister(&sdev->sdev_classdev);
>  	transport_remove_device(dev);
>  	device_del(dev);
