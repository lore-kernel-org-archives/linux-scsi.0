From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 1/3][RESUBMIT] scsi_dh_rdac: move the init code from
	rdac_activate to rdac_bus_attach
Date: Tue, 08 Sep 2009 08:35:30 -0700
Message-ID: <1252424130.13253.0.camel@chandra-ubuntu>
References: <E463DF2B2E584B4A82673F53D62C2EF474CCD1BA@cosmail01.lsi.com>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47353 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbZIHPf1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Sep 2009 11:35:27 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e8.ny.us.ibm.com (8.14.3/8.13.1) with ESMTP id n88FZ0UB002513
	for <linux-scsi@vger.kernel.org>; Tue, 8 Sep 2009 11:35:00 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n88FZQW31187876
	for <linux-scsi@vger.kernel.org>; Tue, 8 Sep 2009 11:35:26 -0400
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n88FZLdp021706
	for <linux-scsi@vger.kernel.org>; Tue, 8 Sep 2009 09:35:22 -0600
In-Reply-To: <E463DF2B2E584B4A82673F53D62C2EF474CCD1BA@cosmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moger, Babu" <Babu.Moger@lsi.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, 'device mapper development' <dm-devel@redhat.com>, "Chauhan, Vijay" <Vijay.Chauhan@lsi.com>, "Stankey, Robert" <Robert.Stankey@lsi.com>, "Dachepalli, Sudhir" <Sudhir.Dachepalli@lsi.com>

Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>
On Thu, 2009-09-03 at 21:42 -0600, Moger, Babu wrote:
> Moving the initialization code from rdac_activate to rdac_bus_attach which is more efficient.
> We don't have to collect all the information during every activate. 
> 
> Signed-off-by: Babu Moger <babu.moger@lsi.com>
> Reviewed-by: Vijay Chauhan <vijay.chauhan@lsi.com>
> Reviewed-by: Bob Stankey <Robert.stankey@lsi.com>
> 
> ---
> --- linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c.orig	2009-09-03 13:39:52.000000000 -0500
> +++ linux-2.6.31-rc5/drivers/scsi/device_handler/scsi_dh_rdac.c	2009-09-03 14:10:40.000000000 -0500
> @@ -525,17 +525,6 @@ static int rdac_activate(struct scsi_dev
>  	if (err != SCSI_DH_OK)
>  		goto done;
>  
> -	if (!h->ctlr) {
> -		err = initialize_controller(sdev, h);
> -		if (err != SCSI_DH_OK)
> -			goto done;
> -	}
> -
> -	if (h->ctlr->use_ms10 == -1) {
> -		err = set_mode_select(sdev, h);
> -		if (err != SCSI_DH_OK)
> -			goto done;
> -	}
>  	if (h->lun_state == RDAC_LUN_UNOWNED)
>  		err = send_mode_select(sdev, h);
>  done:
> @@ -674,12 +663,20 @@ static int rdac_bus_attach(struct scsi_d
>  	if (err != SCSI_DH_OK)
>  		goto failed;
>  
> -	err = check_ownership(sdev, h);
> +	err = initialize_controller(sdev, h);
>  	if (err != SCSI_DH_OK)
>  		goto failed;
>  
> +	err = check_ownership(sdev, h);
> +	if (err != SCSI_DH_OK)
> +		goto clean_ctlr;
> +
> +	err = set_mode_select(sdev, h);
> +	if (err != SCSI_DH_OK)
> +		goto clean_ctlr;
> +
>  	if (!try_module_get(THIS_MODULE))
> -		goto failed;
> +		goto clean_ctlr;
>  
>  	spin_lock_irqsave(sdev->request_queue->queue_lock, flags);
>  	sdev->scsi_dh_data = scsi_dh_data;
> @@ -691,6 +688,9 @@ static int rdac_bus_attach(struct scsi_d
>  
>  	return 0;
>  
> +clean_ctlr:
> +	kref_put(&h->ctlr->kref, release_controller);
> +
>  failed:
>  	kfree(scsi_dh_data);
>  	sdev_printk(KERN_ERR, sdev, "%s: not attached\n",
> 
> 

