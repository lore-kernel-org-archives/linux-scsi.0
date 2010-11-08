From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [USB] UAS: eliminate infinite loop; add debug print
Date: Mon, 8 Nov 2010 09:27:22 -0800 (PST)
Message-ID: <272723.33242.qm@web31808.mail.mud.yahoo.com>
References: <20101108112456.GI4173@linux.intel.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:31258 "HELO
	web31808.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755068Ab0KHR1Z convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Nov 2010 12:27:25 -0500
In-Reply-To: <20101108112456.GI4173@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

--- On Mon, 11/8/10, Matthew Wilcox <willy@linux.intel.com> wrote:
> -0700, Luben Tuikov wrote:
> > Eliminate an infinite loop whereby the SCSI layer
> > would reissue a command (which would be failed by
> > the driver) ad infinitum. (Invariably due to the
> > driver's profuse use of the
> > SCSI_MLQUEUE_DEVICE_BUSY returned result in its
> > queuecommand() method.)
> >=20
> > Also add a debug option and a few debug prints.
>=20
> Why have you added your own debug scheme instead of using
> dev_dbg?

Because, this debug "scheme" produces copious and otherwise unnecessary=
 volume of debug information in a working driver. And because you can t=
urn it on/off just for this driver. It is intended to be used only for =
debugging this driver and the UAS device(s) to which the driver communi=
cates. 99.9% of the time, this setting will be a 'N' out there.  And th=
is is what the Kconfig help entry says: "If unsure, say 'N'."

> You've made a lot of other random whitespace changes too.
> I'll pick through this and see what I like in it.

Yes, it's my emacs. I didn't find a setting to right-justify a continui=
ng argument list of a function definition, nor have I seen this in the =
kernel before (since 2000 A.D. at least). Have you tried a function dec=
laration instead, in this style? Do you think it would look good in a h=
eader file with more than one declaration?

>=20
> > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> > ---
> >=A0 drivers/usb/storage/Kconfig=A0
> |=A0=A0=A010 ++++
> >=A0 drivers/usb/storage/Makefile |=A0 =A0 4
> ++
> >=A0 drivers/usb/storage/uas.c=A0 =A0 |=A0
> 102 +++++++++++++++++++++++++++--------------
> >=A0 3 files changed, 81 insertions(+), 35
> deletions(-)
> >=20
> > diff --git a/drivers/usb/storage/Kconfig
> b/drivers/usb/storage/Kconfig
> > index 49a489e..eb9f6af 100644
> > --- a/drivers/usb/storage/Kconfig
> > +++ b/drivers/usb/storage/Kconfig
> > @@ -185,6 +185,16 @@ config USB_UAS
> >=A0=20
> >=A0 =A0=A0=A0 =A0 If you compile this
> driver as a module, it will be named uas.
> >=A0=20
> > +config USB_UAS_DEBUG
> > +=A0 =A0 =A0=A0=A0bool "Compile in
> debug mode"
> > +=A0 =A0 =A0=A0=A0default n
> > +=A0 =A0 =A0=A0=A0depends on USB_UAS
> > +=A0 =A0 =A0=A0=A0help
> > +=A0=A0=A0=A0=A0Compiles the uas driver
> in debug mode. In debug mode,
> > +=A0=A0=A0=A0=A0the driver prints debug
> messages to the console.
> > +
> > +=A0=A0=A0=A0=A0If unsure, say 'N'.
> > +
> >=A0 config USB_LIBUSUAL
> >=A0 =A0=A0=A0 bool "The shared table of
> common (or usual) storage devices"
> >=A0 =A0=A0=A0 depends on USB
> > diff --git a/drivers/usb/storage/Makefile
> b/drivers/usb/storage/Makefile
> > index fcf14cd..16715ab 100644
> > --- a/drivers/usb/storage/Makefile
> > +++ b/drivers/usb/storage/Makefile
> > @@ -10,6 +10,10 @@ ccflags-y :=3D -Idrivers/scsi
> >=A0 obj-$(CONFIG_USB_UAS)=A0=A0=A0
> =A0=A0=A0 +=3D uas.o
> >=A0 obj-$(CONFIG_USB_STORAGE)=A0=A0=A0 +=3D
> usb-storage.o
> >=A0=20
> > +ifeq ($(CONFIG_USB_UAS_DEBUG),y)
> > +=A0=A0=A0 EXTRA_CFLAGS +=3D -DUAS_DEBUG
> > +endif
> > +
> >=A0 usb-storage-y :=3D scsiglue.o protocol.o
> transport.o usb.o
> >=A0 usb-storage-y +=3D initializers.o sierra_ms.o
> option_ms.o
> >=A0=20
> > diff --git a/drivers/usb/storage/uas.c
> b/drivers/usb/storage/uas.c
> > index 48dc2b8..ef6e707 100644
> > --- a/drivers/usb/storage/uas.c
> > +++ b/drivers/usb/storage/uas.c
> > @@ -21,6 +21,14 @@
> >=A0 #include <scsi/scsi_host.h>
> >=A0 #include <scsi/scsi_tcq.h>
> >=A0=20
> > +#define uas_printk(fmt, ...)=A0=A0=A0
> printk(KERN_NOTICE "uas: " fmt, ## __VA_ARGS__)
> > +
> > +#ifdef UAS_DEBUG
> > +#define UAS_DPRINTK uas_printk
> > +#else
> > +#define UAS_DPRINTK(fmt, ...)
> > +#endif
> > +
> >=A0 /* Common header for all IUs */
> >=A0 struct iu {
> >=A0 =A0=A0=A0 __u8 iu_id;
> > @@ -128,6 +136,7 @@ static void uas_do_work(struct
> work_struct *work)
> >=A0 {
> >=A0 =A0=A0=A0 struct uas_cmd_info
> *cmdinfo;
> >=A0 =A0=A0=A0 struct list_head list;
> > +=A0=A0=A0 int res;
> >=A0=20
> >=A0 =A0=A0=A0
> spin_lock_irq(&uas_work_lock);
> >=A0 =A0=A0=A0
> list_replace_init(&uas_work_list, &list);
> > @@ -136,8 +145,10 @@ static void uas_do_work(struct
> work_struct *work)
> >=A0 =A0=A0=A0 list_for_each_entry(cmdinfo,
> &list, list) {
> >=A0 =A0=A0=A0 =A0=A0=A0 struct
> scsi_pointer *scp =3D (void *)cmdinfo;
> >=A0 =A0=A0=A0 =A0=A0=A0 struct
> scsi_cmnd *cmnd =3D container_of(scp,
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 struct scsi_cmnd,
> SCp);
> > -=A0=A0=A0 =A0=A0=A0
> uas_submit_urbs(cmnd, cmnd->device->hostdata,
> GFP_KERNEL);
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0 =A0 =A0 struct scsi_cmnd,
> SCp);
> > +=A0=A0=A0 =A0=A0=A0 res =3D
> uas_submit_urbs(cmnd, cmnd->device->hostdata,
> GFP_KERNEL);
> > +=A0=A0=A0 =A0=A0=A0
> UAS_DPRINTK("%s: cmd:%p, res:%d, state:0x%x\n",
> __FUNCTION__,
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0 =A0 cmnd, res,
> cmdinfo->state);
> >=A0 =A0=A0=A0 }
> >=A0 }
> >=A0=20
> > @@ -198,13 +209,15 @@ static void uas_sense_old(struct
> urb *urb, struct scsi_cmnd *cmnd)
> >=A0 }
> >=A0=20
> >=A0 static void uas_xfer_data(struct urb *urb,
> struct scsi_cmnd *cmnd,
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 unsigned direction)
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0 unsigned direction)
> >=A0 {
> >=A0 =A0=A0=A0 struct uas_cmd_info *cmdinfo
> =3D (void *)&cmnd->SCp;
> >=A0 =A0=A0=A0 int err;
> >=A0=20
> >=A0 =A0=A0=A0 cmdinfo->state =3D direction
> | SUBMIT_STATUS_URB;
> >=A0 =A0=A0=A0 err =3D uas_submit_urbs(cmnd,
> cmnd->device->hostdata, GFP_ATOMIC);
> > +=A0=A0=A0 UAS_DPRINTK("%s: cmd:%p, err:%d,
> state:0x%x\n", __FUNCTION__,
> > +=A0=A0=A0 =A0=A0=A0 =A0 =A0
> cmnd, err, cmdinfo->state);
> >=A0 =A0=A0=A0 if (err) {
> >=A0 =A0=A0=A0 =A0=A0=A0
> spin_lock(&uas_work_lock);
> >=A0 =A0=A0=A0 =A0=A0=A0
> list_add_tail(&cmdinfo->list, &uas_work_list);
> > @@ -222,7 +235,8 @@ static void uas_stat_cmplt(struct
> urb *urb)
> >=A0 =A0=A0=A0 u16 tag;
> >=A0=20
> >=A0 =A0=A0=A0 if (urb->status) {
> > -=A0=A0=A0 =A0=A0=A0
> dev_err(&urb->dev->dev, "URB BAD STATUS %d\n",
> urb->status);
> > +=A0=A0=A0 =A0=A0=A0
> dev_err(&urb->dev->dev, "%s: URB BAD STATUS
> %d\n",
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 __FUNCTION__, urb->status);
> >=A0 =A0=A0=A0 =A0=A0=A0
> usb_free_urb(urb);
> >=A0 =A0=A0=A0 =A0=A0=A0 return;
> >=A0 =A0=A0=A0 }
> > @@ -259,6 +273,14 @@ static void uas_stat_cmplt(struct
> urb *urb)
> >=A0 static void uas_data_cmplt(struct urb *urb)
> >=A0 {
> >=A0 =A0=A0=A0 struct scsi_data_buffer *sdb
> =3D urb->context;
> > +
> > +=A0=A0=A0 if (urb->status) {
> > +=A0=A0=A0 =A0=A0=A0
> dev_err(&urb->dev->dev, "%s: URB BAD STATUS
> %d\n",
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 __FUNCTION__, urb->status);
> > +=A0=A0=A0 =A0=A0=A0
> usb_free_urb(urb);
> > +=A0=A0=A0 =A0=A0=A0 return;
> > +=A0=A0=A0 }
> > +=A0=A0=A0=20
> >=A0 =A0=A0=A0 sdb->resid =3D
> sdb->length - urb->actual_length;
> >=A0 =A0=A0=A0 usb_free_urb(urb);
> >=A0 }
> > @@ -339,7 +361,7 @@ static struct urb
> *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
> >=A0 =A0=A0=A0 memcpy(iu->cdb,
> cmnd->cmnd, cmnd->cmd_len);
> >=A0=20
> >=A0 =A0=A0=A0 usb_fill_bulk_urb(urb, udev,
> devinfo->cmd_pipe, iu, sizeof(*iu) + len,
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 usb_free_urb, NULL);
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0 usb_free_urb, NULL);
> >=A0 =A0=A0=A0 urb->transfer_flags |=3D
> URB_FREE_BUFFER;
> >=A0=A0=A0out:
> >=A0 =A0=A0=A0 return urb;
> > @@ -355,23 +377,26 @@ static struct urb
> *uas_alloc_cmd_urb(struct uas_dev_info *devinfo, gfp_t gfp,
> >=A0=A0=A0*/
> >=A0=20
> >=A0 static int uas_submit_urbs(struct scsi_cmnd
> *cmnd,
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> struct uas_dev_info *devinfo, gfp_t gfp)
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0struct uas_dev_info
> *devinfo, gfp_t gfp)
> >=A0 {
> >=A0 =A0=A0=A0 struct uas_cmd_info *cmdinfo
> =3D (void *)&cmnd->SCp;
> > +=A0=A0=A0 int res;
> >=A0=20
> >=A0 =A0=A0=A0 if (cmdinfo->state &
> ALLOC_STATUS_URB) {
> >=A0 =A0=A0=A0 =A0=A0=A0
> cmdinfo->status_urb =3D uas_alloc_sense_urb(devinfo, gfp,
> cmnd,
> >=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0
> cmdinfo->stream);
> >=A0 =A0=A0=A0 =A0=A0=A0 if
> (!cmdinfo->status_urb)
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return SCSI_MLQUEUE_DEVICE_BUSY;
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return -ENOMEM;
> >=A0 =A0=A0=A0 =A0=A0=A0
> cmdinfo->state &=3D ~ALLOC_STATUS_URB;
> >=A0 =A0=A0=A0 }
> >=A0=20
> >=A0 =A0=A0=A0 if (cmdinfo->state &
> SUBMIT_STATUS_URB) {
> > -=A0=A0=A0 =A0=A0=A0 if
> (usb_submit_urb(cmdinfo->status_urb, gfp)) {
> > +=A0=A0=A0 =A0=A0=A0 res =3D
> usb_submit_urb(cmdinfo->status_urb, gfp);
> > +=A0=A0=A0 =A0=A0=A0 if (res) {
> >=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 scmd_printk(KERN_INFO, cmnd,
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> "sense urb submission failure\n");
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return SCSI_MLQUEUE_DEVICE_BUSY;
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0 =A0 "sense
> urb submission failure (%d)\n",
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0 =A0 res);
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return res;
> >=A0 =A0=A0=A0 =A0=A0=A0 }
> >=A0 =A0=A0=A0 =A0=A0=A0
> cmdinfo->state &=3D ~SUBMIT_STATUS_URB;
> >=A0 =A0=A0=A0 }
> > @@ -381,15 +406,17 @@ static int
> uas_submit_urbs(struct scsi_cmnd *cmnd,
> >=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> devinfo->data_in_pipe, cmdinfo->stream,
> >=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> scsi_in(cmnd), DMA_FROM_DEVICE);
> >=A0 =A0=A0=A0 =A0=A0=A0 if
> (!cmdinfo->data_in_urb)
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return SCSI_MLQUEUE_DEVICE_BUSY;
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return -ENOMEM;
> >=A0 =A0=A0=A0 =A0=A0=A0
> cmdinfo->state &=3D ~ALLOC_DATA_IN_URB;
> >=A0 =A0=A0=A0 }
> >=A0=20
> >=A0 =A0=A0=A0 if (cmdinfo->state &
> SUBMIT_DATA_IN_URB) {
> > -=A0=A0=A0 =A0=A0=A0 if
> (usb_submit_urb(cmdinfo->data_in_urb, gfp)) {
> > +=A0=A0=A0 =A0=A0=A0 res =3D
> usb_submit_urb(cmdinfo->data_in_urb, gfp);
> > +=A0=A0=A0 =A0=A0=A0 if (res) {
> >=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 scmd_printk(KERN_INFO, cmnd,

> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> "data in urb submission failure\n");
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return SCSI_MLQUEUE_DEVICE_BUSY;
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0 =A0 "data in
> urb submission failure (%d)\n",
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0 =A0 res);
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return res;
> >=A0 =A0=A0=A0 =A0=A0=A0 }
> >=A0 =A0=A0=A0 =A0=A0=A0
> cmdinfo->state &=3D ~SUBMIT_DATA_IN_URB;
> >=A0 =A0=A0=A0 }
> > @@ -399,15 +426,17 @@ static int
> uas_submit_urbs(struct scsi_cmnd *cmnd,
> >=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> devinfo->data_out_pipe, cmdinfo->stream,
> >=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> scsi_out(cmnd), DMA_TO_DEVICE);
> >=A0 =A0=A0=A0 =A0=A0=A0 if
> (!cmdinfo->data_out_urb)
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return SCSI_MLQUEUE_DEVICE_BUSY;
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return -ENOMEM;
> >=A0 =A0=A0=A0 =A0=A0=A0
> cmdinfo->state &=3D ~ALLOC_DATA_OUT_URB;
> >=A0 =A0=A0=A0 }
> >=A0=20
> >=A0 =A0=A0=A0 if (cmdinfo->state &
> SUBMIT_DATA_OUT_URB) {
> > -=A0=A0=A0 =A0=A0=A0 if
> (usb_submit_urb(cmdinfo->data_out_urb, gfp)) {
> > +=A0=A0=A0 =A0=A0=A0 res =3D
> usb_submit_urb(cmdinfo->data_out_urb, gfp);
> > +=A0=A0=A0 =A0=A0=A0 if (res) {
> >=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 scmd_printk(KERN_INFO, cmnd,
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> "data out urb submission failure\n");
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return SCSI_MLQUEUE_DEVICE_BUSY;
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0 =A0 "data
> out urb submission failure (%d)\n",
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0 =A0 res);
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return res;
> >=A0 =A0=A0=A0 =A0=A0=A0 }
> >=A0 =A0=A0=A0 =A0=A0=A0
> cmdinfo->state &=3D ~SUBMIT_DATA_OUT_URB;
> >=A0 =A0=A0=A0 }
> > @@ -416,15 +445,16 @@ static int
> uas_submit_urbs(struct scsi_cmnd *cmnd,
> >=A0 =A0=A0=A0 =A0=A0=A0
> cmdinfo->cmd_urb =3D uas_alloc_cmd_urb(devinfo, gfp, cmnd,
> >=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 cmdinfo->stream);
> >=A0 =A0=A0=A0 =A0=A0=A0 if
> (!cmdinfo->cmd_urb)
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return SCSI_MLQUEUE_DEVICE_BUSY;
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return -ENOMEM;
> >=A0 =A0=A0=A0 =A0=A0=A0
> cmdinfo->state &=3D ~ALLOC_CMD_URB;
> >=A0 =A0=A0=A0 }
> >=A0=20
> >=A0 =A0=A0=A0 if (cmdinfo->state &
> SUBMIT_CMD_URB) {
> > -=A0=A0=A0 =A0=A0=A0 if
> (usb_submit_urb(cmdinfo->cmd_urb, gfp)) {
> > +=A0=A0=A0 =A0=A0=A0 res =3D
> usb_submit_urb(cmdinfo->cmd_urb, gfp);
> > +=A0=A0=A0 =A0=A0=A0 if (res) {
> >=A0 =A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 scmd_printk(KERN_INFO, cmnd,
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> "cmd urb submission failure\n");
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return SCSI_MLQUEUE_DEVICE_BUSY;
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0 =A0 "cmd urb
> submission failure (%d)\n", res);
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return res;
> >=A0 =A0=A0=A0 =A0=A0=A0 }
> >=A0 =A0=A0=A0 =A0=A0=A0
> cmdinfo->state &=3D ~SUBMIT_CMD_URB;
> >=A0 =A0=A0=A0 }
> > @@ -433,12 +463,12 @@ static int
> uas_submit_urbs(struct scsi_cmnd *cmnd,
> >=A0 }
> >=A0=20
> >=A0 static int uas_queuecommand(struct scsi_cmnd
> *cmnd,
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0
> void (*done)(struct scsi_cmnd *))
> > +=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 =A0 =A0 void (*done)(struct
> scsi_cmnd *))
> >=A0 {
> >=A0 =A0=A0=A0 struct scsi_device *sdev =3D
> cmnd->device;
> >=A0 =A0=A0=A0 struct uas_dev_info *devinfo
> =3D sdev->hostdata;
> >=A0 =A0=A0=A0 struct uas_cmd_info *cmdinfo
> =3D (void *)&cmnd->SCp;
> > -=A0=A0=A0 int err;
> > +=A0=A0=A0 int res;
> >=A0=20
> >=A0 =A0=A0=A0 BUILD_BUG_ON(sizeof(struct
> uas_cmd_info) > sizeof(struct scsi_pointer));
> >=A0=20
> > @@ -474,17 +504,19 @@ static int
> uas_queuecommand(struct scsi_cmnd *cmnd,
> >=A0 =A0=A0=A0 =A0=A0=A0
> cmdinfo->stream =3D 0;
> >=A0 =A0=A0=A0 }
> >=A0=20
> > -=A0=A0=A0 err =3D uas_submit_urbs(cmnd,
> devinfo, GFP_ATOMIC);
> > -=A0=A0=A0 if (err) {
> > -=A0=A0=A0 =A0=A0=A0 /* If we did
> nothing, give up now */
> > -=A0=A0=A0 =A0=A0=A0 if
> (cmdinfo->state & SUBMIT_STATUS_URB) {
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 usb_free_urb(cmdinfo->status_urb);
> > -=A0=A0=A0 =A0=A0=A0
> =A0=A0=A0 return SCSI_MLQUEUE_DEVICE_BUSY;
> > -=A0=A0=A0 =A0=A0=A0 }
> > -=A0=A0=A0 =A0=A0=A0
> spin_lock(&uas_work_lock);
> > -=A0=A0=A0 =A0=A0=A0
> list_add_tail(&cmdinfo->list, &uas_work_list);
> > -=A0=A0=A0 =A0=A0=A0
> spin_unlock(&uas_work_lock);
> > -=A0=A0=A0 =A0=A0=A0
> schedule_work(&uas_work);
> > +=A0=A0=A0 res =3D uas_submit_urbs(cmnd,
> devinfo, GFP_ATOMIC);
> > +=A0=A0=A0 UAS_DPRINTK("%s: cmd:%p (0x%02x),
> err:%d, state:0x%x\n", __FUNCTION__,
> > +=A0=A0=A0 =A0=A0=A0 =A0 =A0
> cmnd, cmnd->cmnd[0], res, cmdinfo->state);
> > +=A0=A0=A0 if (res) {
> > +=A0=A0=A0 =A0=A0=A0
> usb_unlink_urb(cmdinfo->status_urb);
> > +=A0=A0=A0 =A0=A0=A0
> usb_unlink_urb(cmdinfo->data_in_urb);
> > +=A0=A0=A0 =A0=A0=A0
> usb_unlink_urb(cmdinfo->data_out_urb);
> > +=A0=A0=A0 =A0=A0=A0
> usb_unlink_urb(cmdinfo->cmd_urb);
> > +
> > +=A0=A0=A0 =A0=A0=A0
> sdev->current_cmnd =3D NULL;
> > +
> > +=A0=A0=A0 =A0=A0=A0 cmnd->result
> =3D DID_NO_CONNECT << 16;
> > +=A0=A0=A0 =A0=A0=A0 done(cmnd);
> >=A0 =A0=A0=A0 }
> >=A0=20
> >=A0 =A0=A0=A0 return 0;
> > --=20
> > 1.7.0.1
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
