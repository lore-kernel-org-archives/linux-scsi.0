From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v3 3/4] sd: Make synchronize cache upon shutdown
 asynchronous
Date: Mon, 24 Apr 2017 21:46:49 +0000
Message-ID: <1493070406.3394.17.camel@sandisk.com>
References: <20170417173436.15555-1-bart.vanassche@sandisk.com>
         <20170417173436.15555-4-bart.vanassche@sandisk.com>
         <20170418144429.GA28949@bblock-ThinkPad-W530>
         <1492530984.3306.25.camel@HansenPartnership.com>
         <1492559235.2689.27.camel@sandisk.com>
         <1492559772.3306.58.camel@HansenPartnership.com>
         <1492725550.2642.9.camel@sandisk.com>
         <1492726397.21601.16.camel@HansenPartnership.com>
         <1492728740.2642.14.camel@sandisk.com>
         <1492968509.2414.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:35370 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S978489AbdDXVqw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 17:46:52 -0400
In-Reply-To: <1492968509.2414.6.camel@HansenPartnership.com>
Content-Language: en-US
Content-ID: <E6B4FED8D9B9744D8FEBD5665423763D@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "bblock@linux.vnet.ibm.com" <bblock@linux.vnet.ibm.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "maxg@mellanox.com" <maxg@mellanox.com>, "israelr@mellanox.com" <israelr@mellanox.com>, "hare@suse.de" <hare@suse.de>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Sun, 2017-04-23 at 12:28 -0500, James Bottomley wrote:
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1250,6 +1250,12 @@ scsi_prep_state_check(struct scsi_device *sdev, st=
ruct request *req)
>  			break;
>  		case SDEV_BLOCK:
>  		case SDEV_CREATED_BLOCK:
> +			/* q lock is held only in the non-mq case */
> +			if (req->q->mq_ops)
> +				blk_mq_stop_hw_queues(req->q);
> +			else
> +				blk_stop_queue(req->q);
> +
>  			ret =3D BLKPREP_DEFER;
>  			break;
>  		case SDEV_QUIESCE:

Hello James,

This change swaps the order of changing the device state and the block laye=
r
state. Sorry but I don't like this. What will happen if e.g. the disk event
checker decides to check for events just before __scsi_remove_device()
changes the device state? I think that can that cause sd_shutdown() to be
called with the block layer queue stopped and hence that with this approach
it is still possible that sd_shutdown() hangs.

> @@ -2611,7 +2617,6 @@ scsi_device_set_state(struct scsi_device *sdev, enu=
m scsi_device_state state)
>  		case SDEV_QUIESCE:
>  		case SDEV_OFFLINE:
>  		case SDEV_TRANSPORT_OFFLINE:
> -		case SDEV_BLOCK:
>  			break;
>  		default:
>  			goto illegal;

A previous patch made two changes to scsi_device_set_state(). Are you sure
that we do no longer have to enable the SDEV_BLOCK to SDEV_DEL transition?

> @@ -2844,10 +2849,12 @@ static int scsi_request_fn_active(struct scsi_dev=
ice *sdev)
>   */
>  static void scsi_wait_for_queuecommand(struct scsi_device *sdev)
>  {
> -	WARN_ON_ONCE(sdev->host->use_blk_mq);
> -
> -	while (scsi_request_fn_active(sdev))
> -		msleep(20);
> +	if (sdev->request_queue->mq_ops) {
> +		synchronize_rcu();
> +	} else {
> +		while (scsi_request_fn_active(sdev))
> +			msleep(20);
> +	}
>  }

The above code makes an assumption about the block layer internals, namely
that calling synchronize_rcu() is sufficient to wait for outstanding reques=
ts
to finish. Please do not embed any assumptions about block layer internals =
in
SCSI code but keep code that relies on block layer internals in the block
layer. If you have a look at blk_mq_quiesce_queue() then you will see that
calling synchronize_rcu() is not sufficient for hardware queues for which
BLK_MQ_F_BLOCKING has been set. I am aware that today the SCSI core does no=
t
set that flag. However, the dependency of the dependency of the
synchronize_rcu() call on BLK_MQ_F_BLOCKING not being set is nontrivial.

Thanks,

Bart.
