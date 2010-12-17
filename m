From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH v3][SCSI] scsi_dh: propagate SCSI device deletion
Date: Fri, 17 Dec 2010 08:46:58 -0700
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF4F54410DB@cosmail01.lsi.com>
References: <D8C50530D6022F40A817A35C40CC06A7064AFC9450@DUBX7MCDUB01.EMEA.DELL.COM>
 <20101215160952.GA20869@redhat.com>
 <D8C50530D6022F40A817A35C40CC06A7064AFFCA3E@DUBX7MCDUB01.EMEA.DELL.COM>
 <20101216140209.GA23507@redhat.com>
 <D8C50530D6022F40A817A35C40CC06A7064AFFCF09@DUBX7MCDUB01.EMEA.DELL.COM>
 <20101216152930.GB23507@redhat.com>
 <D8C50530D6022F40A817A35C40CC06A7064AFFD030@DUBX7MCDUB01.EMEA.DELL.COM>
 <20101216162951.GE23507@redhat.com>
 <D8C50530D6022F40A817A35C40CC06A7064AFFD087@DUBX7MCDUB01.EMEA.DELL.COM>
 <20101216195707.GB25957@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:53073 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754345Ab0LQPqf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Dec 2010 10:46:35 -0500
In-Reply-To: <20101216195707.GB25957@redhat.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "Menny_Hamburger@dell.com" <Menny_Hamburger@dell.com>, "Itay_Dar@dell.com" <Itay_Dar@dell.com>, "Rob_Thomas@dell.com" <Rob_Thomas@dell.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

Patches look good..

Reviewed-by: Babu Moger <babu.moger@lsi.com>

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Mike Snitzer
> Sent: Thursday, December 16, 2010 1:57 PM
> To: linux-scsi@vger.kernel.org
> Cc: Menny_Hamburger@dell.com; Itay_Dar@dell.com; Rob_Thomas@dell.com; dm-
> devel@redhat.com
> Subject: [PATCH v3][SCSI] scsi_dh: propagate SCSI device deletion
> 
> From: Menny Hamburger <Menny_Hamburger@Dell.com>
> 
> Currently, when scsi_dh_activate() returns with an error
> (e.g. SCSI_DH_NOSYS) the activate_complete callback is not called and
> the error is not propagated to DM mpath.
> 
> When a SCSI device attached to a device handler is deleted, userland
> processes currently performing I/O on the device will have their I/O
> hang forever.
> 
> - Set SCSI_DH_NOSYS error when the handler is in the process of being
>   deleted (e.g. the SCSI device is in a SDEV_CANCEL or SDEV_DEL state).
> 
> - Set SCSI_DH_DEV_OFFLINED error when device is in SDEV_OFFLINE state.
> 
> - Call the activate_complete callback function directly from
>   scsi_dh_activate if an error has been set (when either the scsi_dh
>   internal data has already been deleted or is in the process of being
>   deleted).
> 
> The patch was tested in an iSCSI environment, RDAC H/W handler and
> multipath.  In the following reproduction process, dd will I/O hang
> forever and the only way to release it will be to reboot the machine:
> 1) Perform I/O on a multipath device:
>     dd if=/dev/dm-0 of=/dev/zero bs=8k count=1000000 &
> 2) Delete all slave SCSI devices contained in the mpath device:
>    I)  In an iSCSI environment, the easiest way to do this is by
>    stopping iSCSI:
>        /etc/init.d/iscsi stop
>    II) Another way to delete the devices is by applying the following
>    bash scriptlet:
>        dm_devs=$(ls /sys/block/ | grep dm- | xargs)
>        for dm_dev in $dm_devs; do
>          devices=$(ls /sys/block/$dm_dev/slaves)
>          for device in $devices; do
>             echo 1 > /sys/block/$device/device/delete
>          done
>        done
> 
> NOTE: when DM mpath's fail_path uses blk_abort_queue this scsi_dh change
> isn't strictly required.  However, DM mpath's call to blk_abort_queue
> will soon be reverted because it has proven to be unsafe due to a race
> (between blk_abort_queue and scsi_request_fn) that can lead to list
> corruption.  Therefore we cannot rely on blk_abort_queue via fail_path,
> but even if we could this scsi_dh change is still preferrable.
> 
> Signed-off-by: Menny Hamburger <Menny_Hamburger@Dell.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> ---
>  drivers/scsi/device_handler/scsi_dh.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
> 
> v1 and v2 were posted/discussed on dm-devel
> v3: just tweaked the patch header a bit
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh.c
> b/drivers/scsi/device_handler/scsi_dh.c
> index 6fae3d2..b0c56f6 100644
> --- a/drivers/scsi/device_handler/scsi_dh.c
> +++ b/drivers/scsi/device_handler/scsi_dh.c
> @@ -442,12 +442,19 @@ int scsi_dh_activate(struct request_queue *q,
> activate_complete fn, void *data)
>  	sdev = q->queuedata;
>  	if (sdev && sdev->scsi_dh_data)
>  		scsi_dh = sdev->scsi_dh_data->scsi_dh;
> -	if (!scsi_dh || !get_device(&sdev->sdev_gendev))
> +	if (!scsi_dh || !get_device(&sdev->sdev_gendev) ||
> +	    sdev->sdev_state == SDEV_CANCEL ||
> +	    sdev->sdev_state == SDEV_DEL)
>  		err = SCSI_DH_NOSYS;
> +	if (sdev->sdev_state == SDEV_OFFLINE)
> +		err = SCSI_DH_DEV_OFFLINED;
>  	spin_unlock_irqrestore(q->queue_lock, flags);
> 
> -	if (err)
> +	if (err) {
> +		if (fn)
> +			fn(data, err);
>  		return err;
> +	}
> 
>  	if (scsi_dh->activate)
>  		err = scsi_dh->activate(sdev, fn, data);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
