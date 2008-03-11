From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 1/2] zfcp: Fix race during ERP thread shutdown
Date: Tue, 11 Mar 2008 17:43:41 +0100
Message-ID: <20080311164341.GA6380@osiris.boeblingen.de.ibm.com>
References: <20080310151852.808020000@de.ibm.com> <20080310152328.463410000@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:21056 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbYCKQno (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Mar 2008 12:43:44 -0400
Content-Disposition: inline
In-Reply-To: <20080310152328.463410000@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>

> --- a/drivers/s390/scsi/zfcp_erp.c	2008-03-10 12:34:48.000000000 +0100
> +++ b/drivers/s390/scsi/zfcp_erp.c	2008-03-10 16:05:26.000000000 +0100
> @@ -1002,7 +1002,7 @@ zfcp_erp_thread_setup(struct zfcp_adapte
>  					    &adapter->status));
>  		debug_text_event(adapter->erp_dbf, 5, "a_thset_ok");
>  	}
> -
> +	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_ACCEPT, &adapter->status);
>  	return (retval < 0);

This way the flag will be set even if the creation of the erp thread failed.
It should be done somewhere within zfcp_erp_thread() instead.

Besides that setting the flag must be done while holding the erp_lock.
Otherwise zfcp_erp_action_enqueue might check the flag, other cpu clears
the flag right after that, and then enqueueing continues while the flag is
not set.

>  }
> 
> @@ -1025,6 +1025,8 @@ zfcp_erp_thread_kill(struct zfcp_adapter
>  {
>  	int retval = 0;
> 
> +	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_ACCEPT, &adapter->status);
> +	zfcp_erp_wait(adapter);
>  	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL, &adapter->status);
>  	up(&adapter->erp_ready_sem);
> 
> @@ -2940,8 +2942,7 @@ zfcp_erp_action_enqueue(int action,
>  	 * efficient.
>  	 */
> 
> -	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP,
> -			      &adapter->status))
> +	if (!atomic_test_mask(ZFCP_STATUS_ADAPTER_ERP_ACCEPT, &adapter->status))
>  		return -EIO;
> 
>  	debug_event(adapter->erp_dbf, 4, &action, sizeof (int));
> --- a/drivers/s390/scsi/zfcp_ccw.c	2008-03-10 12:34:48.000000000 +0100
> +++ b/drivers/s390/scsi/zfcp_ccw.c	2008-03-10 16:05:26.000000000 +0100
> @@ -198,7 +198,6 @@ zfcp_ccw_set_offline(struct ccw_device *
>  	down(&zfcp_data.config_sema);
>  	adapter = dev_get_drvdata(&ccw_device->dev);
>  	zfcp_erp_adapter_shutdown(adapter, 0);
> -	zfcp_erp_wait(adapter);
>  	zfcp_erp_thread_kill(adapter);

And as a sidenote, if the scenario this patch is supposed to fix can really
happen, how can you make sure the adapter is still down before the erp thread
gets killed? Some action could have been enqueued and finished which reopened
the adapter after zfcp_erp_adapter_shutdown and before zfcp_erp_thread_kill.
Just wondering... :)
