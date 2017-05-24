From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 03/31] Protect SCSI device state changes with a mutex
Date: Wed, 24 May 2017 07:51:13 +0200
Message-ID: <7d437d97-29ff-14f4-1564-5ba32f00948f@suse.de>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
 <20170524003420.5381-4-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-4-bart.vanassche@sandisk.com>
Content-Language: en-US
Sender: linux-block-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

On 05/24/2017 02:33 AM, Bart Van Assche wrote:
> Enable this mechanism for all scsi_target_*block() callers but not
> for the scsi_internal_device_unblock() calls from the mpt3sas driver
> because that driver can call scsi_internal_device_unblock() from
> atomic context.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/scsi/scsi_error.c         |  8 +++++++-
>  drivers/scsi/scsi_lib.c           | 27 +++++++++++++++++++++------
>  drivers/scsi/scsi_scan.c          | 16 +++++++++-------
>  drivers/scsi/scsi_sysfs.c         | 24 +++++++++++++++++++-----
>  drivers/scsi/scsi_transport_srp.c |  7 ++++---
>  drivers/scsi/sd.c                 |  7 +++++--
>  include/scsi/scsi_device.h        |  1 +
>  7 files changed, 66 insertions(+), 24 deletions(-)
> 
[ .. ]
> diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
> index 3c5d89852e9f..f617021c94f7 100644
> --- a/drivers/scsi/scsi_transport_srp.c
> +++ b/drivers/scsi/scsi_transport_srp.c
> @@ -554,11 +554,12 @@ int srp_reconnect_rport(struct srp_rport *rport)
>  		 * invoking scsi_target_unblock() won't change the state of
>  		 * these devices into running so do that explicitly.
>  		 */
> -		spin_lock_irq(shost->host_lock);
> -		__shost_for_each_device(sdev, shost)
> +		shost_for_each_device(sdev, shost) {
> +			mutex_lock(&sdev->state_mutex);
>  			if (sdev->sdev_state == SDEV_OFFLINE)
>  				sdev->sdev_state = SDEV_RUNNING;
> -		spin_unlock_irq(shost->host_lock);
> +			mutex_unlock(&sdev->state_mutex);
> +		}
>  	} else if (rport->state == SRP_RPORT_RUNNING) {
>  		/*
>  		 * srp_reconnect_rport() has been invoked with fast_io_fail
Why do you drop the host lock here? I thought that the host lock is
needed to protect shost_for_each_device()?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
