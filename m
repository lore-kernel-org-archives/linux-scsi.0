From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [USB] UAS: eliminate infinite loop; add debug print
Date: Fri, 10 Dec 2010 02:51:28 -0800 (PST)
Message-ID: <978777.98320.qm@web31810.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31810.mail.mud.yahoo.com ([68.142.207.73]:45436 "HELO
	web31810.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752586Ab0LJKva convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Dec 2010 05:51:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Patch retracted for this still-born driver. Instead please use superior=
 uasp.c which was recently submitted.


--- On Fri, 10/29/10, Luben Tuikov <ltuikov@yahoo.com> wrote:

> From: Luben Tuikov <ltuikov@yahoo.com>
> Subject: [PATCH] [USB] UAS: eliminate infinite loop; add debug print
> To: "Greg KH" <greg@kroah.com>, linux-usb@vger.kernel.org, linux-scsi=
@vger.kernel.org, "Matthew Wilcox" <willy@linux.intel.com>
> Date: Friday, October 29, 2010, 5:33 PM
> Eliminate an infinite loop whereby
> the SCSI layer
> would reissue a command (which would be failed by
> the driver) ad infinitum. (Invariably due to the
> driver's profuse use of the
> SCSI_MLQUEUE_DEVICE_BUSY returned result in its
> queuecommand() method.)
>=20
> Also add a debug option and a few debug prints.
>=20
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
>  drivers/usb/storage/Kconfig=A0 |=A0=A0=A010
> ++++
>  drivers/usb/storage/Makefile |=A0 =A0 4 ++
>  drivers/usb/storage/uas.c=A0 =A0 |=A0 102
> +++++++++++++++++++++++++++--------------
>  3 files changed, 81 insertions(+), 35 deletions(-)
>=20
> diff --git a/drivers/usb/storage/Kconfig
> b/drivers/usb/storage/Kconfig
> index 49a489e..eb9f6af 100644
> --- a/drivers/usb/storage/Kconfig
> +++ b/drivers/usb/storage/Kconfig
> @@ -185,6 +185,16 @@ config USB_UAS
> =20
>  =A0=A0=A0 =A0 If you compile this driver as a
> module, it will be named uas.
> =20
> +config USB_UAS_DEBUG
> +=A0 =A0 =A0=A0=A0bool "Compile in debug
> mode"
> +=A0 =A0 =A0=A0=A0default n
> +=A0 =A0 =A0=A0=A0depends on USB_UAS
> +=A0 =A0 =A0=A0=A0help
> +=A0=A0=A0=A0=A0Compiles the uas driver in
> debug mode. In debug mode,
> +=A0=A0=A0=A0=A0the driver prints debug
> messages to the console.
> +
> +=A0=A0=A0=A0=A0If unsure, say 'N'.
> +
>  config USB_LIBUSUAL
>  =A0=A0=A0 bool "The shared table of common (or
> usual) storage devices"
>  =A0=A0=A0 depends on USB
> diff --git a/drivers/usb/storage/Makefile
> b/drivers/usb/storage/Makefile
> index fcf14cd..16715ab 100644
> --- a/drivers/usb/storage/Makefile
> +++ b/drivers/usb/storage/Makefile
> @@ -10,6 +10,10 @@ ccflags-y :=3D -Idrivers/scsi
>  obj-$(CONFIG_USB_UAS)=A0=A0=A0 =A0=A0=A0
> +=3D uas.o
>  obj-$(CONFIG_USB_STORAGE)=A0=A0=A0 +=3D
> usb-storage.o
> =20
> +ifeq ($(CONFIG_USB_UAS_DEBUG),y)
> +=A0=A0=A0 EXTRA_CFLAGS +=3D -DUAS_DEBUG
> +endif
> +
>  usb-storage-y :=3D scsiglue.o protocol.o transport.o usb.o
>  usb-storage-y +=3D initializers.o sierra_ms.o option_ms.o
> =20
> diff --git a/drivers/usb/storage/uas.c
> b/drivers/usb/storage/uas.c
> index 48dc2b8..ef6e707 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -21,6 +21,14 @@
>  #include <scsi/scsi_host.h>
>  #include <scsi/scsi_tcq.h>
> =20
> +#define uas_printk(fmt, ...)=A0=A0=A0
> printk(KERN_NOTICE "uas: " fmt, ## __VA_ARGS__)
> +
> +#ifdef UAS_DEBUG
> +#define UAS_DPRINTK uas_printk
> +#else
> +#define UAS_DPRINTK(fmt, ...)
> +#endif
> +
>  /* Common header for all IUs */
>  struct iu {
>  =A0=A0=A0 __u8 iu_id;
> @@ -128,6 +136,7 @@ static void uas_do_work(struct
> work_struct *work)
>  {
>  =A0=A0=A0 struct uas_cmd_info *cmdinfo;
>  =A0=A0=A0 struct list_head list;
> +=A0=A0=A0 int res;
> =20
>  =A0=A0=A0 spin_lock_irq(&uas_work_lock);
>  =A0=A0=A0 list_replace_init(&uas_work_list,
> &list);
> @@ -136,8 +145,10 @@ static void uas_do_work(struct
> work_struct *work)
>  =A0=A0=A0 list_for_each_entry(cmdinfo, &list,
> list) {
>  =A0=A0=A0 =A0=A0=A0 struct scsi_pointer
> *scp =3D (void *)cmdinfo;
>  =A0=A0=A0 =A0=A0=A0 struct scsi_cmnd
> *cmnd =3D container_of(scp,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 struct scsi_cmnd, SCp);
> -=A0=A0=A0 =A0=A0=A0
> uas_submit_urbs(cmnd, cmnd->device->hostdata,
> GFP_KERNEL);
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0 =A0 =A0 struct scsi_cmnd, SCp);
> +=A0=A0=A0 =A0=A0=A0 res =3D
> uas_submit_urbs(cmnd, cmnd->device->hostdata,
> GFP_KERNEL);
> +=A0=A0=A0 =A0=A0=A0 UAS_DPRINTK("%s:
> cmd:%p, res:%d, state:0x%x\n", __FUNCTION__,
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0 =A0 cmnd, res, cmdinfo->state);
>  =A0=A0=A0 }
>  }
> =20
> @@ -198,13 +209,15 @@ static void uas_sense_old(struct urb
> *urb, struct scsi_cmnd *cmnd)
>  }
> =20
>  static void uas_xfer_data(struct urb *urb, struct
> scsi_cmnd *cmnd,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 unsigned direction)
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0 unsigned direction)
>  {
>  =A0=A0=A0 struct uas_cmd_info *cmdinfo =3D (void
> *)&cmnd->SCp;
>  =A0=A0=A0 int err;
> =20
>  =A0=A0=A0 cmdinfo->state =3D direction |
> SUBMIT_STATUS_URB;
>  =A0=A0=A0 err =3D uas_submit_urbs(cmnd,
> cmnd->device->hostdata, GFP_ATOMIC);
> +=A0=A0=A0 UAS_DPRINTK("%s: cmd:%p, err:%d,
> state:0x%x\n", __FUNCTION__,
> +=A0=A0=A0 =A0=A0=A0 =A0 =A0 cmnd,
> err, cmdinfo->state);
>  =A0=A0=A0 if (err) {
>  =A0=A0=A0 =A0=A0=A0
> spin_lock(&uas_work_lock);
>  =A0=A0=A0 =A0=A0=A0
> list_add_tail(&cmdinfo->list, &uas_work_list);
> @@ -222,7 +235,8 @@ static void uas_stat_cmplt(struct urb
> *urb)
>  =A0=A0=A0 u16 tag;
> =20
>  =A0=A0=A0 if (urb->status) {
> -=A0=A0=A0 =A0=A0=A0
> dev_err(&urb->dev->dev, "URB BAD STATUS %d\n",
> urb->status);
> +=A0=A0=A0 =A0=A0=A0
> dev_err(&urb->dev->dev, "%s: URB BAD STATUS
> %d\n",
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> __FUNCTION__, urb->status);
>  =A0=A0=A0 =A0=A0=A0 usb_free_urb(urb);
>  =A0=A0=A0 =A0=A0=A0 return;
>  =A0=A0=A0 }
> @@ -259,6 +273,14 @@ static void uas_stat_cmplt(struct urb
> *urb)
>  static void uas_data_cmplt(struct urb *urb)
>  {
>  =A0=A0=A0 struct scsi_data_buffer *sdb =3D
> urb->context;
> +
> +=A0=A0=A0 if (urb->status) {
> +=A0=A0=A0 =A0=A0=A0
> dev_err(&urb->dev->dev, "%s: URB BAD STATUS
> %d\n",
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> __FUNCTION__, urb->status);
> +=A0=A0=A0 =A0=A0=A0 usb_free_urb(urb);
> +=A0=A0=A0 =A0=A0=A0 return;
> +=A0=A0=A0 }
> +=A0=A0=A0=20
>  =A0=A0=A0 sdb->resid =3D sdb->length -
> urb->actual_length;
>  =A0=A0=A0 usb_free_urb(urb);
>  }
> @@ -339,7 +361,7 @@ static struct urb
> *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
>  =A0=A0=A0 memcpy(iu->cdb, cmnd->cmnd,
> cmnd->cmd_len);
> =20
>  =A0=A0=A0 usb_fill_bulk_urb(urb, udev,
> devinfo->cmd_pipe, iu, sizeof(*iu) + len,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 usb_free_urb, NULL);
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0 usb_free_urb, NULL);
>  =A0=A0=A0 urb->transfer_flags |=3D
> URB_FREE_BUFFER;
> =A0 out:
>  =A0=A0=A0 return urb;
> @@ -355,23 +377,26 @@ static struct urb
> *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
> =A0 */
> =20
>  static int uas_submit_urbs(struct scsi_cmnd *cmnd,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 struct uas_dev_info
> *devinfo, gfp_t gfp)
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0struct uas_dev_info *devinfo, gfp_t gfp)
>  {
>  =A0=A0=A0 struct uas_cmd_info *cmdinfo =3D (void
> *)&cmnd->SCp;
> +=A0=A0=A0 int res;
> =20
>  =A0=A0=A0 if (cmdinfo->state &
> ALLOC_STATUS_URB) {
>  =A0=A0=A0 =A0=A0=A0
> cmdinfo->status_urb =3D uas_alloc_sense_urb(devinfo, gfp,
> cmnd,
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0 cmdinfo->stream);
>  =A0=A0=A0 =A0=A0=A0 if
> (!cmdinfo->status_urb)
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return SCSI_MLQUEUE_DEVICE_BUSY;
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return -ENOMEM;
>  =A0=A0=A0 =A0=A0=A0 cmdinfo->state
> &=3D ~ALLOC_STATUS_URB;
>  =A0=A0=A0 }
> =20
>  =A0=A0=A0 if (cmdinfo->state &
> SUBMIT_STATUS_URB) {
> -=A0=A0=A0 =A0=A0=A0 if
> (usb_submit_urb(cmdinfo->status_urb, gfp)) {
> +=A0=A0=A0 =A0=A0=A0 res =3D
> usb_submit_urb(cmdinfo->status_urb, gfp);
> +=A0=A0=A0 =A0=A0=A0 if (res) {
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> scmd_printk(KERN_INFO, cmnd,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 "sense urb submission
> failure\n");
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return SCSI_MLQUEUE_DEVICE_BUSY;
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0 =A0 "sense urb submission
> failure (%d)\n",
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0 =A0 res);
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return res;
>  =A0=A0=A0 =A0=A0=A0 }
>  =A0=A0=A0 =A0=A0=A0 cmdinfo->state
> &=3D ~SUBMIT_STATUS_URB;
>  =A0=A0=A0 }
> @@ -381,15 +406,17 @@ static int uas_submit_urbs(struct
> scsi_cmnd *cmnd,
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0
> devinfo->data_in_pipe, cmdinfo->stream,
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 scsi_in(cmnd),
> DMA_FROM_DEVICE);
>  =A0=A0=A0 =A0=A0=A0 if
> (!cmdinfo->data_in_urb)
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return SCSI_MLQUEUE_DEVICE_BUSY;
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return -ENOMEM;
>  =A0=A0=A0 =A0=A0=A0 cmdinfo->state
> &=3D ~ALLOC_DATA_IN_URB;
>  =A0=A0=A0 }
> =20
>  =A0=A0=A0 if (cmdinfo->state &
> SUBMIT_DATA_IN_URB) {
> -=A0=A0=A0 =A0=A0=A0 if
> (usb_submit_urb(cmdinfo->data_in_urb, gfp)) {
> +=A0=A0=A0 =A0=A0=A0 res =3D
> usb_submit_urb(cmdinfo->data_in_urb, gfp);
> +=A0=A0=A0 =A0=A0=A0 if (res) {
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> scmd_printk(KERN_INFO, cmnd,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 "data in urb
> submission failure\n");
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return SCSI_MLQUEUE_DEVICE_BUSY;
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0 =A0 "data in urb submission
> failure (%d)\n",
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0 =A0 res);
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return res;
>  =A0=A0=A0 =A0=A0=A0 }
>  =A0=A0=A0 =A0=A0=A0 cmdinfo->state
> &=3D ~SUBMIT_DATA_IN_URB;
>  =A0=A0=A0 }
> @@ -399,15 +426,17 @@ static int uas_submit_urbs(struct
> scsi_cmnd *cmnd,
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0
> devinfo->data_out_pipe, cmdinfo->stream,
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 scsi_out(cmnd),
> DMA_TO_DEVICE);
>  =A0=A0=A0 =A0=A0=A0 if
> (!cmdinfo->data_out_urb)
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return SCSI_MLQUEUE_DEVICE_BUSY;
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return -ENOMEM;
>  =A0=A0=A0 =A0=A0=A0 cmdinfo->state
> &=3D ~ALLOC_DATA_OUT_URB;
>  =A0=A0=A0 }
> =20
>  =A0=A0=A0 if (cmdinfo->state &
> SUBMIT_DATA_OUT_URB) {
> -=A0=A0=A0 =A0=A0=A0 if
> (usb_submit_urb(cmdinfo->data_out_urb, gfp)) {
> +=A0=A0=A0 =A0=A0=A0 res =3D
> usb_submit_urb(cmdinfo->data_out_urb, gfp);
> +=A0=A0=A0 =A0=A0=A0 if (res) {
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> scmd_printk(KERN_INFO, cmnd,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 "data out urb
> submission failure\n");
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return SCSI_MLQUEUE_DEVICE_BUSY;
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0 =A0 "data out urb submission
> failure (%d)\n",
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0 =A0 res);
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return res;
>  =A0=A0=A0 =A0=A0=A0 }
>  =A0=A0=A0 =A0=A0=A0 cmdinfo->state
> &=3D ~SUBMIT_DATA_OUT_URB;
>  =A0=A0=A0 }
> @@ -416,15 +445,16 @@ static int uas_submit_urbs(struct
> scsi_cmnd *cmnd,
>  =A0=A0=A0 =A0=A0=A0 cmdinfo->cmd_urb
> =3D uas_alloc_cmd_urb(devinfo, gfp, cmnd,
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 cmdinfo->stream);
>  =A0=A0=A0 =A0=A0=A0 if
> (!cmdinfo->cmd_urb)
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return SCSI_MLQUEUE_DEVICE_BUSY;
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return -ENOMEM;
>  =A0=A0=A0 =A0=A0=A0 cmdinfo->state
> &=3D ~ALLOC_CMD_URB;
>  =A0=A0=A0 }
> =20
>  =A0=A0=A0 if (cmdinfo->state &
> SUBMIT_CMD_URB) {
> -=A0=A0=A0 =A0=A0=A0 if
> (usb_submit_urb(cmdinfo->cmd_urb, gfp)) {
> +=A0=A0=A0 =A0=A0=A0 res =3D
> usb_submit_urb(cmdinfo->cmd_urb, gfp);
> +=A0=A0=A0 =A0=A0=A0 if (res) {
>  =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> scmd_printk(KERN_INFO, cmnd,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 "cmd urb submission
> failure\n");
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return SCSI_MLQUEUE_DEVICE_BUSY;
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0 =A0 "cmd urb submission failure
> (%d)\n", res);
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return res;
>  =A0=A0=A0 =A0=A0=A0 }
>  =A0=A0=A0 =A0=A0=A0 cmdinfo->state
> &=3D ~SUBMIT_CMD_URB;
>  =A0=A0=A0 }
> @@ -433,12 +463,12 @@ static int uas_submit_urbs(struct
> scsi_cmnd *cmnd,
>  }
> =20
>  static int uas_queuecommand(struct scsi_cmnd *cmnd,
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 void (*done)(struct
> scsi_cmnd *))
> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0 =A0 void (*done)(struct scsi_cmnd *))
>  {
>  =A0=A0=A0 struct scsi_device *sdev =3D
> cmnd->device;
>  =A0=A0=A0 struct uas_dev_info *devinfo =3D
> sdev->hostdata;
>  =A0=A0=A0 struct uas_cmd_info *cmdinfo =3D (void
> *)&cmnd->SCp;
> -=A0=A0=A0 int err;
> +=A0=A0=A0 int res;
> =20
>  =A0=A0=A0 BUILD_BUG_ON(sizeof(struct
> uas_cmd_info) > sizeof(struct scsi_pointer));
> =20
> @@ -474,17 +504,19 @@ static int uas_queuecommand(struct
> scsi_cmnd *cmnd,
>  =A0=A0=A0 =A0=A0=A0 cmdinfo->stream =3D
> 0;
>  =A0=A0=A0 }
> =20
> -=A0=A0=A0 err =3D uas_submit_urbs(cmnd, devinfo,
> GFP_ATOMIC);
> -=A0=A0=A0 if (err) {
> -=A0=A0=A0 =A0=A0=A0 /* If we did
> nothing, give up now */
> -=A0=A0=A0 =A0=A0=A0 if
> (cmdinfo->state & SUBMIT_STATUS_URB) {
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> usb_free_urb(cmdinfo->status_urb);
> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> return SCSI_MLQUEUE_DEVICE_BUSY;
> -=A0=A0=A0 =A0=A0=A0 }
> -=A0=A0=A0 =A0=A0=A0
> spin_lock(&uas_work_lock);
> -=A0=A0=A0 =A0=A0=A0
> list_add_tail(&cmdinfo->list, &uas_work_list);
> -=A0=A0=A0 =A0=A0=A0
> spin_unlock(&uas_work_lock);
> -=A0=A0=A0 =A0=A0=A0
> schedule_work(&uas_work);
> +=A0=A0=A0 res =3D uas_submit_urbs(cmnd, devinfo,
> GFP_ATOMIC);
> +=A0=A0=A0 UAS_DPRINTK("%s: cmd:%p (0x%02x),
> err:%d, state:0x%x\n", __FUNCTION__,
> +=A0=A0=A0 =A0=A0=A0 =A0 =A0 cmnd,
> cmnd->cmnd[0], res, cmdinfo->state);
> +=A0=A0=A0 if (res) {
> +=A0=A0=A0 =A0=A0=A0
> usb_unlink_urb(cmdinfo->status_urb);
> +=A0=A0=A0 =A0=A0=A0
> usb_unlink_urb(cmdinfo->data_in_urb);
> +=A0=A0=A0 =A0=A0=A0
> usb_unlink_urb(cmdinfo->data_out_urb);
> +=A0=A0=A0 =A0=A0=A0
> usb_unlink_urb(cmdinfo->cmd_urb);
> +
> +=A0=A0=A0 =A0=A0=A0
> sdev->current_cmnd =3D NULL;
> +
> +=A0=A0=A0 =A0=A0=A0 cmnd->result =3D
> DID_NO_CONNECT << 16;
> +=A0=A0=A0 =A0=A0=A0 done(cmnd);
>  =A0=A0=A0 }
> =20
>  =A0=A0=A0 return 0;
> --=20
> 1.7.0.1
>=20
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
