From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 01/10] mpt3sas: Fix for improper info displayed in var
 log, while blocking or unblocking the device.
Date: Mon, 24 Oct 2016 16:44:01 +0200
Message-ID: <0e299cfd-6f34-bf35-8ab9-55f6bb1c5aca@suse.de>
References: <1476966018-10457-1-git-send-email-suganath-prabu.subramani@broadcom.com>
 <1476966018-10457-2-git-send-email-suganath-prabu.subramani@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1476966018-10457-2-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>, JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, krishnaraddi.mankani@broadcom.com, linux-kernel@vger.kernel.org, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com
List-Id: linux-scsi@vger.kernel.org

On 10/20/2016 02:20 PM, Suganath Prabu S wrote:
> Return value and Device_handle Arguments passed in correct order
>  to match with its format string.
>
> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
> Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 209a969..282ca40 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -2837,7 +2837,7 @@ _scsih_internal_device_block(struct scsi_device *sdev,
>  	if (r == -EINVAL)
>  		sdev_printk(KERN_WARNING, sdev,
>  		    "device_block failed with return(%d) for handle(0x%04x)\n",
> -		    sas_device_priv_data->sas_target->handle, r);
> +		    r, sas_device_priv_data->sas_target->handle);
>  }
>
>  /**
> @@ -2867,20 +2867,20 @@ _scsih_internal_device_unblock(struct scsi_device *sdev,
>  		sdev_printk(KERN_WARNING, sdev,
>  		    "device_unblock failed with return(%d) for handle(0x%04x) "
>  		    "performing a block followed by an unblock\n",
> -		    sas_device_priv_data->sas_target->handle, r);
> +		    r, sas_device_priv_data->sas_target->handle);
>  		sas_device_priv_data->block = 1;
>  		r = scsi_internal_device_block(sdev);
>  		if (r)
>  			sdev_printk(KERN_WARNING, sdev, "retried device_block "
>  			    "failed with return(%d) for handle(0x%04x)\n",
> -			    sas_device_priv_data->sas_target->handle, r);
> +			    r, sas_device_priv_data->sas_target->handle);
>
>  		sas_device_priv_data->block = 0;
>  		r = scsi_internal_device_unblock(sdev, SDEV_RUNNING);
>  		if (r)
>  			sdev_printk(KERN_WARNING, sdev, "retried device_unblock"
>  			    " failed with return(%d) for handle(0x%04x)\n",
> -			    sas_device_priv_data->sas_target->handle, r);
> +			    r, sas_device_priv_data->sas_target->handle);
>  	}
>  }
>
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
