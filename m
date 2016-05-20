From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi: use spinlock instead of mutex for RCU-protected
 VPD inquiry data
Date: Fri, 20 May 2016 10:33:05 -0400 (EDT)
Message-ID: <1424252122.37276521.1463754785510.JavaMail.zimbra@redhat.com>
References: <1463748974-31315-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:43677 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbcETOdH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 May 2016 10:33:07 -0400
In-Reply-To: <1463748974-31315-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org



----- Original Message -----
> From: "Ewan D. Milne" <emilne@redhat.com>
> To: linux-scsi@vger.kernel.org
> Sent: Friday, May 20, 2016 8:56:14 AM
> Subject: [PATCH] scsi: use spinlock instead of mutex for RCU-protected VPD inquiry data
> 
> From: "Ewan D. Milne" <emilne@redhat.com>
> 
> A spinlock is sufficient for this purpose, and much smaller.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/scsi.c        | 8 ++++----
>  drivers/scsi/scsi_scan.c   | 2 +-
>  include/scsi/scsi_device.h | 2 +-
>  3 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index 1deb6ad..330d807 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -829,11 +829,11 @@ retry_pg80:
>  			kfree(vpd_buf);
>  			goto retry_pg80;
>  		}
> -		mutex_lock(&sdev->inquiry_mutex);
> +		spin_lock(&sdev->inquiry_lock);
>  		orig_vpd_buf = sdev->vpd_pg80;
>  		sdev->vpd_pg80_len = result;
>  		rcu_assign_pointer(sdev->vpd_pg80, vpd_buf);
> -		mutex_unlock(&sdev->inquiry_mutex);
> +		spin_unlock(&sdev->inquiry_lock);
>  		synchronize_rcu();
>  		if (orig_vpd_buf) {
>  			kfree(orig_vpd_buf);
> @@ -858,11 +858,11 @@ retry_pg83:
>  			kfree(vpd_buf);
>  			goto retry_pg83;
>  		}
> -		mutex_lock(&sdev->inquiry_mutex);
> +		spin_lock(&sdev->inquiry_lock);
>  		orig_vpd_buf = sdev->vpd_pg83;
>  		sdev->vpd_pg83_len = result;
>  		rcu_assign_pointer(sdev->vpd_pg83, vpd_buf);
> -		mutex_unlock(&sdev->inquiry_mutex);
> +		spin_unlock(&sdev->inquiry_lock);
>  		synchronize_rcu();
>  		if (orig_vpd_buf)
>  			kfree(orig_vpd_buf);
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index e0a78f5..f445615 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -240,7 +240,7 @@ static struct scsi_device *scsi_alloc_sdev(struct
> scsi_target *starget,
>  	INIT_LIST_HEAD(&sdev->starved_entry);
>  	INIT_LIST_HEAD(&sdev->event_list);
>  	spin_lock_init(&sdev->list_lock);
> -	mutex_init(&sdev->inquiry_mutex);
> +	spin_lock_init(&sdev->inquiry_lock);
>  	INIT_WORK(&sdev->event_work, scsi_evt_thread);
>  	INIT_WORK(&sdev->requeue_work, scsi_requeue_run_queue);
>  
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index a6c346d..0410ed8 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -115,7 +115,7 @@ struct scsi_device {
>  	char type;
>  	char scsi_level;
>  	char inq_periph_qual;	/* PQ from INQUIRY data */
> -	struct mutex inquiry_mutex;
> +	spinlock_t inquiry_lock;
>  	unsigned char inquiry_len;	/* valid bytes in 'inquiry' */
>  	unsigned char * inquiry;	/* INQUIRY response data */
>  	const char * vendor;		/* [back_compat] point into 'inquiry' ... */
> --
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Look fine to me:
Reviewed by: Laurence Oberman <loberman@redhat.com>
