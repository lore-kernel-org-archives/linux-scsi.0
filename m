From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH] scsi_sysfs: fix hang when removing scsi device
Date: Thu, 2 Mar 2017 16:27:21 +0000
Message-ID: <1488472028.2659.1.camel@sandisk.com>
References: <1488465953-29832-1-git-send-email-israelr@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:62636 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751882AbdCBQ3I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2017 11:29:08 -0500
In-Reply-To: <1488465953-29832-1-git-send-email-israelr@mellanox.com>
Content-Language: en-US
Content-ID: <0D2BD63A36CAD942B68C04ED6B8917F6@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "israelr@mellanox.com" <israelr@mellanox.com>
Cc: "maxg@mellanox.com" <maxg@mellanox.com>

On Thu, 2017-03-02 at 16:45 +0200, Israel Rukshin wrote:
> The bug reproduce when unloading srp module with one port down.
> device_del() hangs when __scsi_remove_device() get scsi_device with
> state SDEV_OFFLINE or SDEV_TRANSPORT_OFFLINE.
> It hangs because device_del() is trying to send sync cache command
> when the device is offline but with SDEV_CANCEL status.
> The status was changed to SDEV_CANCEL by __scsi_remove_device()
> before it calls to device_del().

It is not device_del() but sd_shutdown() that submits the SYNCHRONIZE
CACHE command. It should also be explained in the commit message why
the block layer timeout mechanism did not cause the SYNCHRONIZE CACHE
commands to fail after the timeout expired.

> Fixes: e619e6cbe (Revert "scsi: Fix a bdi reregistration race")

This does not make sense. A revert is never the original introduction
of a bug but at most a reintroduction. Please refer to the commit that
originally introduced this hang.

> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1282,6 +1282,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  		return;
> =20
>  	if (sdev->is_visible) {
> +		enum scsi_device_state oldstate =3D sdev->sdev_state;
> +
>  		if (scsi_device_set_state(sdev, SDEV_CANCEL) !=3D 0)
>  			return;
> =20
> @@ -1289,6 +1291,15 @@ void __scsi_remove_device(struct scsi_device *sdev=
)
>  		device_unregister(&sdev->sdev_dev);
>  		transport_remove_device(dev);
>  		scsi_dh_remove_device(sdev);
> +
> +		/*
> +		 * Fail new requests if the old state was offline.
> +		 * This avoids from device_del() to hang.
> +		 */
> +		if (oldstate =3D=3D SDEV_TRANSPORT_OFFLINE ||
> +		    oldstate =3D=3D SDEV_OFFLINE)
> +			blk_set_queue_dying(sdev->request_queue);
> +
>  		device_del(dev);
>  	} else
>  		put_device(&sdev->sdev_dev);

Please refer to sd_shutdown() instead of device_del() in the above comment,
and also explain why the block layer timeout mechanism did not cause the
SYNCHRONIZE CACHE commands to fail.

Thanks,

Bart.=
