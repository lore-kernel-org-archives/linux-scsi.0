From: Bart Van Assche <Bart.VanAssche@sandisk.com>
Subject: Re: [PATCH v2] scsi_sysfs: fix hang when removing scsi device
Date: Thu, 9 Mar 2017 19:36:52 +0000
Message-ID: <1489088191.2597.9.camel@sandisk.com>
References: <1489077442-20610-1-git-send-email-israelr@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:5893 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750781AbdCIThB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2017 14:37:01 -0500
In-Reply-To: <1489077442-20610-1-git-send-email-israelr@mellanox.com>
Content-Language: en-US
Content-ID: <235C3EC9AD4D7249A929B93CA8207834@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "israelr@mellanox.com" <israelr@mellanox.com>
Cc: "maxg@mellanox.com" <maxg@mellanox.com>

On Thu, 2017-03-09 at 18:37 +0200, Israel Rukshin wrote:
> The bug reproduce when unloading srp module with one port down.
> sd_shutdown() hangs when __scsi_remove_device() get scsi_device with
> state SDEV_OFFLINE or SDEV_TRANSPORT_OFFLINE.
> It hangs because sd_shutdown() is trying to send sync cache command
> when the device is offline but with SDEV_CANCEL status.
> The status was changed to SDEV_CANCEL by __scsi_remove_device()
> before it calls to device_del().
>=20
> The block layer timeout mechanism doesn't cause the SYNCHRONIZE CACHE
> command to fail after the timeout expired because the request timer
> wasn't started.
> blk_peek_request() that is called from scsi_request_fn() didn't return
> this request and therefore the request timer didn't start.
>=20
> This commit doesn't accept new commands if the original state was offline=
.
>=20
> The bug was revealed after commit cff549 ("scsi: proper state checking
> and module refcount handling in scsi_device_get").
> After this commit scsi_device_get() returns error if the device state
> is SDEV_CANCEL.
> This eventually leads SRP fast I/O failure timeout handler not to clean
> the sync cache command because scsi_target_unblock() skip the canceled de=
vice.
> If this timeout handler is set to infinity then the hang remains forever
> also before commit cff549.

How could blk_peek_request() not return a request that has not yet been
started? How could a patch that changes scsi_device_get() affect I/O since
scsi_device_get() is not called from the I/O path? Anyway, could you try to
reproduce the hang with the patch below applied and see whether the output
produced by this patch helps to determine what is going on?

Thanks,

Bart.

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ba2286652ff6..855548ff4c4d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -3018,8 +3018,10 @@ scsi_internal_device_unblock(struct scsi_device *sde=
v,
=A0		else
=A0			sdev->sdev_state =3D SDEV_CREATED;
=A0	} else if (sdev->sdev_state !=3D SDEV_CANCEL &&
-		=A0sdev->sdev_state !=3D SDEV_OFFLINE)
+		=A0sdev->sdev_state !=3D SDEV_OFFLINE) {
+		WARN_ONCE(true, "sdev state =3D %d\n", sdev->sdev_state);
=A0		return -EINVAL;
+	}
=A0
=A0	if (q->mq_ops) {
=A0		blk_mq_start_stopped_hw_queues(q, false);
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 82dfe07b1d47..35aa6b37e199 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1289,6 +1289,13 @@ void __scsi_remove_device(struct scsi_device *sdev)
=A0		device_unregister(&sdev->sdev_dev);
=A0		transport_remove_device(dev);
=A0		scsi_dh_remove_device(sdev);
+
+		WARN_ON_ONCE(blk_queue_stopped(sdev->request_queue));
+		sdev_printk(KERN_INFO, sdev,
+			=A0=A0=A0=A0"%s: device_busy =3D %d device_blocked =3D %d\n",
+			=A0=A0=A0=A0__func__, atomic_read(&sdev->device_busy),
+			=A0=A0=A0=A0atomic_read(&sdev->device_blocked));
+
=A0		device_del(dev);
=A0	} else
=A0		put_device(&sdev->sdev_dev);
--=A0
2.12.0
