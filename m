From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Thu, 20 Apr 2017 21:59:11 +0000
Message-ID: <1492725550.2642.9.camel@sandisk.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
         <20170417173436.15555-4-bart.vanassche@sandisk.com>
         <20170418144429.GA28949@bblock-ThinkPad-W530>
         <1492530984.3306.25.camel@HansenPartnership.com>
         <1492559235.2689.27.camel@sandisk.com>
         <1492559772.3306.58.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:46058 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S947836AbdDTV7U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 17:59:20 -0400
In-Reply-To: <1492559772.3306.58.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <937CA135D74D2D4A852A55A6899778EC@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Tue, 2017-04-18 at 16:56 -0700, James Bottomley wrote:
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e5a2d590a104..31171204cfd1 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -2611,7 +2611,6 @@ scsi_device_set_state(struct scsi_device *sdev, enu=
m scsi_device_state state)
>  		case SDEV_QUIESCE:
>  		case SDEV_OFFLINE:
>  		case SDEV_TRANSPORT_OFFLINE:
> -		case SDEV_BLOCK:
>  			break;
>  		default:
>  			goto illegal;
> @@ -2625,6 +2624,7 @@ scsi_device_set_state(struct scsi_device *sdev, enu=
m scsi_device_state state)
>  		case SDEV_OFFLINE:
>  		case SDEV_TRANSPORT_OFFLINE:
>  		case SDEV_CANCEL:
> +		case SDEV_BLOCK:
>  		case SDEV_CREATED_BLOCK:
>  			break;
>  		default:
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 82dfe07b1d47..e477f95bf169 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1282,8 +1282,17 @@ void __scsi_remove_device(struct scsi_device *sdev=
)
>  		return;
> =20
>  	if (sdev->is_visible) {
> -		if (scsi_device_set_state(sdev, SDEV_CANCEL) !=3D 0)
> -			return;
> +		/*
> +		 * If blocked, we go straight to DEL so any commands
> +		 * issued during the driver shutdown (like sync cache)
> +		 * are errored
> +		 */
> +		if (scsi_device_set_state(sdev, SDEV_CANCEL) !=3D 0) {
> +			if (scsi_device_set_state(sdev, SDEV_DEL) !=3D 0)
> +				return;
> +			else
> +				scsi_start_queue(sdev);
> +		}
> =20
>  		bsg_unregister_queue(sdev->request_queue);
>  		device_unregister(&sdev->sdev_dev);

Hello James,

This approach cannot work.=A0A scsi_target_block() call by the transport
layer can happen concurrently with the __scsi_remove_device() call and henc=
e
can occur at any time between the scsi_start_queue() call by
__scsi_remove_device() and the sd_shutdown() call, resulting in a deadlock.
I have been able to trigger this with my tests by simulating a cable pull
shortly before running "rmmod ib_srp".

That deadlock did not occur with the patch series that makes synchronize
cache upon shutdown asynchronous. I'm going to resubmit that patch series.

Bart.=
