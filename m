From: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [-next] BUG_ON in scsi_target_destroy()
Date: Wed, 13 Apr 2016 10:41:50 +0200
Message-ID: <2201725.I2to9GCRQJ@c203>
References: <20160411090146.GA537@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160411090146.GA537@swordfish>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Ewan D. Milne" <emilne-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hannes Reinecke <hare-IBi9RG/b67k@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sergey Senozhatsky <sergey.senozhatsky-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Xiong Zhou <jencce.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hi Sergey,  Xiong,

Can you try below patch?

On Montag, 11. April 2016 18:01:47 CEST Sergey Senozhatsky wrote:
> Hello,
>=20
> commit 7b106f2de6938c31ce5e9c86bc70ad3904666b96
> Author: Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>
> Date:   Tue Apr 5 11:50:44 2016 +0200
>=20
>     scsi: Add intermediate STARGET_REMOVE state to scsi_target_state
>=20
>=20
> BUG_ON()s (next-20160411) each time I remove a usb flash
>=20
> [   49.561600]  [<ffffffffa0087f42>] scsi_target_destroy+0x5a/0xcb [s=
csi_mod]
> [   49.561607]  [<ffffffffa0089099>] scsi_target_reap+0x4a/0x4f [scsi=
_mod]
> [   49.561613]  [<ffffffffa008b453>] __scsi_remove_device+0xc3/0xd0 [=
scsi_mod]
> [   49.561619]  [<ffffffffa0089d7b>] scsi_forget_host+0x52/0x63 [scsi=
_mod]
> [   49.561623]  [<ffffffffa0080dbc>] scsi_remove_host+0x8c/0x102 [scs=
i_mod]
> [   49.561627]  [<ffffffffa015c447>] usb_stor_disconnect+0x6b/0xab [u=
sb_storage]
> [   49.561634]  [<ffffffffa0013f73>] usb_unbind_interface+0x77/0x1ca =
[usbcore]
> [   49.561636]  [<ffffffff813ae064>] __device_release_driver+0x9d/0x1=
21
> [   49.561638]  [<ffffffff813ae10b>] device_release_driver+0x23/0x30
> [   49.561639]  [<ffffffff813ad2d1>] bus_remove_device+0xfb/0x10e
> [   49.561641]  [<ffffffff813aac05>] device_del+0x164/0x1e6
> [   49.561648]  [<ffffffffa0011b09>] ? remove_intf_ep_devs+0x3b/0x48 =
[usbcore]
> [   49.561655]  [<ffffffffa001200e>] usb_disable_device+0x84/0x1a5 [u=
sbcore]
> [   49.561661]  [<ffffffffa000ac7b>] usb_disconnect+0x94/0x19f [usbco=
re]
> [   49.561667]  [<ffffffffa000c2ab>] hub_event+0x5c1/0xdea [usbcore]
> [   49.561670]  [<ffffffff810530b1>] process_one_work+0x1dc/0x37f
> [   49.561672]  [<ffffffff81053dc5>] worker_thread+0x282/0x36d
> [   49.561673]  [<ffffffff81053b43>] ? rescuer_thread+0x2ae/0x2ae
> [   49.561675]  [<ffffffff810580a8>] kthread+0xd2/0xda
> [   49.561678]  [<ffffffff814bbf92>] ret_from_fork+0x22/0x40
> [   49.561679]  [<ffffffff81057fd6>] ? kthread_worker_fn+0x13e/0x13e
>=20
> 	-ss
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 0734927..0c00928 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1276,6 +1276,7 @@ int scsi_sysfs_add_sdev(struct scsi_device *sdev)
 void __scsi_remove_device(struct scsi_device *sdev)
 {
 	struct device *dev =3D &sdev->sdev_gendev;
+	struct scsi_target *starget;
=20
 	/*
 	 * This cleanup path is not reentrant and while it is impossible
@@ -1315,7 +1316,9 @@ void __scsi_remove_device(struct scsi_device *sde=
v)
 	 * remoed sysfs visibility from the device, so make the target
 	 * invisible if this was the last device underneath it.
 	 */
-	scsi_target_reap(scsi_target(sdev));
+	starget =3D scsi_target(sdev);
+	starget->state =3D STARGET_REMOVE;
+	scsi_target_reap(starget);
=20
 	put_device(dev);
 }



--=20
Johannes Thumshirn                                                     =
                           Storage
jthumshirn-l3A5Bk7waGM@public.gmane.org                                                     =
        +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
