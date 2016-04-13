From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [-next] BUG_ON in scsi_target_destroy()
Date: Wed, 13 Apr 2016 08:14:34 -0700
Message-ID: <1460560474.2322.3.camel@linux.vnet.ibm.com>
References: <20160411090146.GA537@swordfish> <2201725.I2to9GCRQJ@c203>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <2201725.I2to9GCRQJ@c203>
Sender: linux-next-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: "Ewan D. Milne" <emilne@redhat.com>, Hannes Reinecke <hare@suse.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, linux-next@vger.kernel.org, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Xiong Zhou <jencce.kernel@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-04-13 at 10:41 +0200, Johannes Thumshirn wrote:
> Hi Sergey,  Xiong,
> 
> Can you try below patch?
> 
> On Montag, 11. April 2016 18:01:47 CEST Sergey Senozhatsky wrote:
> > Hello,
> > 
> > commit 7b106f2de6938c31ce5e9c86bc70ad3904666b96
> > Author: Johannes Thumshirn <jthumshirn@suse.de>
> > Date:   Tue Apr 5 11:50:44 2016 +0200
> > 
> >     scsi: Add intermediate STARGET_REMOVE state to
> > scsi_target_state
> > 
> > 
> > BUG_ON()s (next-20160411) each time I remove a usb flash
> > 
> > [   49.561600]  [<ffffffffa0087f42>] scsi_target_destroy+0x5a/0xcb
> > [scsi_mod]
> > [   49.561607]  [<ffffffffa0089099>] scsi_target_reap+0x4a/0x4f
> > [scsi_mod]
> > [   49.561613]  [<ffffffffa008b453>] __scsi_remove_device+0xc3/0xd0
> > [scsi_mod]
> > [   49.561619]  [<ffffffffa0089d7b>] scsi_forget_host+0x52/0x63
> > [scsi_mod]
> > [   49.561623]  [<ffffffffa0080dbc>] scsi_remove_host+0x8c/0x102
> > [scsi_mod]
> > [   49.561627]  [<ffffffffa015c447>] usb_stor_disconnect+0x6b/0xab
> > [usb_storage]
> > [   49.561634]  [<ffffffffa0013f73>]
> > usb_unbind_interface+0x77/0x1ca [usbcore]
> > [   49.561636]  [<ffffffff813ae064>]
> > __device_release_driver+0x9d/0x121
> > [   49.561638]  [<ffffffff813ae10b>]
> > device_release_driver+0x23/0x30
> > [   49.561639]  [<ffffffff813ad2d1>] bus_remove_device+0xfb/0x10e
> > [   49.561641]  [<ffffffff813aac05>] device_del+0x164/0x1e6
> > [   49.561648]  [<ffffffffa0011b09>] ?
> > remove_intf_ep_devs+0x3b/0x48 [usbcore]
> > [   49.561655]  [<ffffffffa001200e>] usb_disable_device+0x84/0x1a5
> > [usbcore]
> > [   49.561661]  [<ffffffffa000ac7b>] usb_disconnect+0x94/0x19f
> > [usbcore]
> > [   49.561667]  [<ffffffffa000c2ab>] hub_event+0x5c1/0xdea
> > [usbcore]
> > [   49.561670]  [<ffffffff810530b1>] process_one_work+0x1dc/0x37f
> > [   49.561672]  [<ffffffff81053dc5>] worker_thread+0x282/0x36d
> > [   49.561673]  [<ffffffff81053b43>] ? rescuer_thread+0x2ae/0x2ae
> > [   49.561675]  [<ffffffff810580a8>] kthread+0xd2/0xda
> > [   49.561678]  [<ffffffff814bbf92>] ret_from_fork+0x22/0x40
> > [   49.561679]  [<ffffffff81057fd6>] ?
> > kthread_worker_fn+0x13e/0x13e
> > 
> > 	-ss
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux
> > -scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 0734927..0c00928 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1276,6 +1276,7 @@ int scsi_sysfs_add_sdev(struct scsi_device
> *sdev)
>  void __scsi_remove_device(struct scsi_device *sdev)
>  {
>  	struct device *dev = &sdev->sdev_gendev;
> +	struct scsi_target *starget;
>  
>  	/*
>  	 * This cleanup path is not reentrant and while it is
> impossible
> @@ -1315,7 +1316,9 @@ void __scsi_remove_device(struct scsi_device
> *sdev)
>  	 * remoed sysfs visibility from the device, so make the
> target
>  	 * invisible if this was the last device underneath it.
>  	 */
> -	scsi_target_reap(scsi_target(sdev));
> +	starget = scsi_target(sdev);
> +	starget->state = STARGET_REMOVE;
> +	scsi_target_reap(starget);

How about good grief no!  A device with multiple targets will get it's
lists screwed with this

The STARGET_REMOVE state you added only applies to the case we're
trying to kill a target.  In the natural operation case, which is what
everyone else is running into, we will try to remove a running target
when it has no more scsi devices left on it.  So the correct patch
should be to make the BUG_ON see this:

James

---

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 27df7e7..e0a78f5 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -319,8 +319,7 @@ static void scsi_target_destroy(struct scsi_target *starget)
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
 	unsigned long flags;
 
-	BUG_ON(starget->state != STARGET_REMOVE &&
-	       starget->state != STARGET_CREATED);
+	BUG_ON(starget->state == STARGET_DEL);
 	starget->state = STARGET_DEL;
 	transport_destroy_device(dev);
 	spin_lock_irqsave(shost->host_lock, flags);
