From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 4/6] fusion: don't use flush_scheduled_work()
Date: Mon, 10 Jan 2011 13:00:58 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70916AAA0@inbmail01.lsi.com>
References: <1292943721-4519-1-git-send-email-tj@kernel.org>
 <1292943721-4519-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:45145 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009Ab1AJHaj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2011 02:30:39 -0500
In-Reply-To: <1292943721-4519-5-git-send-email-tj@kernel.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomo>

Tejun,

Need to add header of function mptspi_suspend.
Logical part of the patch looks OK to me. Please consider this patch as an ACKed by me.

Thanks, Kashyap

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Tejun Heo
> Sent: Tuesday, December 21, 2010 8:32 PM
> To: linux-scsi@vger.kernel.org; James.Bottomley@suse.de;
> fujita.tomonori@lab.ntt.co.jp; linux-kernel@vger.kernel.org; Moore,
> Eric; dgilbert@interlog.com
> Cc: Tejun Heo
> Subject: [PATCH 4/6] fusion: don't use flush_scheduled_work()
> 
> mptscsih_suspend() does flush_scheduled_work() but mptscsih is the
> only one using the system_wq.  Make mptspi use its own workqueue, and
> on suspend, flush it and then call mptscsih_suspend().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Eric Moore <Eric.Moore@lsi.com>
> ---
>  drivers/message/fusion/mptscsih.c |    1 -
>  drivers/message/fusion/mptspi.c   |   33 ++++++++++++++++++++++++++++-
> ----
>  2 files changed, 28 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/message/fusion/mptscsih.c
> b/drivers/message/fusion/mptscsih.c
> index 59b8f53..c99043a 100644
> --- a/drivers/message/fusion/mptscsih.c
> +++ b/drivers/message/fusion/mptscsih.c
> @@ -1227,7 +1227,6 @@ mptscsih_suspend(struct pci_dev *pdev,
> pm_message_t state)
>  	MPT_ADAPTER 		*ioc = pci_get_drvdata(pdev);
> 
>  	scsi_block_requests(ioc->sh);
> -	flush_scheduled_work();
>  	mptscsih_shutdown(pdev);
>  	return mpt_suspend(pdev,state);
>  }
> diff --git a/drivers/message/fusion/mptspi.c
> b/drivers/message/fusion/mptspi.c
> index 6d9568d..e7de938 100644
> --- a/drivers/message/fusion/mptspi.c
> +++ b/drivers/message/fusion/mptspi.c
> @@ -90,6 +90,7 @@ static int mptspi_write_spi_device_pg1(struct
> scsi_target *,
>  				       struct _CONFIG_PAGE_SCSI_DEVICE_1 *);
> 
>  static struct scsi_transport_template *mptspi_transport_template =
> NULL;
> +static struct workqueue_struct *mptspi_wq;
> 
>  static u8	mptspiDoneCtx = MPT_MAX_PROTOCOL_DRIVERS;
>  static u8	mptspiTaskCtx = MPT_MAX_PROTOCOL_DRIVERS;
> @@ -1150,7 +1151,7 @@ static void mpt_dv_raid(struct _MPT_SCSI_HOST
> *hd, int disk)
>  	wqw->hd = hd;
>  	wqw->disk = disk;
> 
> -	schedule_work(&wqw->work);
> +	queue_work(mptspi_wq, &wqw->work);
>  }
> 
>  static int
> @@ -1281,7 +1282,7 @@ mptspi_dv_renegotiate(struct _MPT_SCSI_HOST *hd)
>  	INIT_WORK(&wqw->work, mptspi_dv_renegotiate_work);
>  	wqw->hd = hd;
> 
> -	schedule_work(&wqw->work);
> +	queue_work(mptspi_wq, &wqw->work);
>  }
> 
>  /*
> @@ -1524,6 +1525,18 @@ out_mptspi_probe:
>  	return error;
>  }
> 
> +/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
> =-=-=-=*/
> +/*
> + *	mptspi_suspend - Fusion MPT SPI driver suspend routine.
> + *
> + *
> + */
> +int mptspi_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> +	flush_workqueue(mptspi_wq);
> +	return mptscsih_suspend(pdev, state);
> +}
> +
>  static struct pci_driver mptspi_driver = {
>  	.name		= "mptspi",
>  	.id_table	= mptspi_pci_table,
> @@ -1531,7 +1544,7 @@ static struct pci_driver mptspi_driver = {
>  	.remove		= __devexit_p(mptscsih_remove),
>  	.shutdown	= mptscsih_shutdown,
>  #ifdef CONFIG_PM
> -	.suspend	= mptscsih_suspend,
> +	.suspend	= mptspi_suspend,
>  	.resume		= mptspi_resume,
>  #endif
>  };
> @@ -1549,9 +1562,15 @@ mptspi_init(void)
> 
>  	show_mptmod_ver(my_NAME, my_VERSION);
> 
> +	mptspi_wq = alloc_workqueue("mptspi", 0, 0);
> +	if (!mptspi_wq)
> +		return -ENOMEM;
> +
>  	mptspi_transport_template =
> spi_attach_transport(&mptspi_transport_functions);
> -	if (!mptspi_transport_template)
> +	if (!mptspi_transport_template) {
> +		destroy_workqueue(mptspi_wq);
>  		return -ENODEV;
> +	}
> 
>  	mptspiDoneCtx = mpt_register(mptscsih_io_done, MPTSPI_DRIVER,
>  	    "mptscsih_io_done");
> @@ -1564,8 +1583,10 @@ mptspi_init(void)
>  	mpt_reset_register(mptspiDoneCtx, mptspi_ioc_reset);
> 
>  	error = pci_register_driver(&mptspi_driver);
> -	if (error)
> +	if (error) {
> +		destroy_workqueue(mptspi_wq);
>  		spi_release_transport(mptspi_transport_template);
> +	}
> 
>  	return error;
>  }
> @@ -1587,6 +1608,8 @@ mptspi_exit(void)
>  	mpt_deregister(mptspiTaskCtx);
>  	mpt_deregister(mptspiDoneCtx);
>  	spi_release_transport(mptspi_transport_template);
> +
> +	destroy_workqueue(mptspi_wq);
>  }
> 
>  module_init(mptspi_init);
> --
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
