From: Oliver Neukum <oliver-GvhC2dPhHPQdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] Add UAS driver
Date: Tue, 28 Sep 2010 15:13:53 +0200
Message-ID: <201009281513.53869.oliver@neukum.org>
References: <1285668896-6356-1-git-send-email-willy@linux.intel.com> <1285668896-6356-2-git-send-email-willy@linux.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1285668896-6356-2-git-send-email-willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Matthew Wilcox <matthew.r.wilcox-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Am Dienstag, 28. September 2010, 12:14:56 schrieb Matthew Wilcox:
> From: Matthew Wilcox <matthew.r.wilcox-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> USB Attached SCSI is a new protocol specified jointly by the SCSI T10
> committee and the USB Implementors Forum.
> 
> Signed-off-by: Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  MAINTAINERS                  |    8 +
>  drivers/usb/storage/Kconfig  |   13 +
>  drivers/usb/storage/Makefile |    1 +
>  drivers/usb/storage/uas.c    |  751 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 773 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/usb/storage/uas.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 668682d..30a5c22 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5900,6 +5900,14 @@ S:	Maintained
>  F:	Documentation/usb/acm.txt
>  F:	drivers/usb/class/cdc-acm.*
>  
> +USB ATTACHED SCSI
> +M:	Matthew Wilcox <willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> +M:	Sarah Sharp <sarah.a.sharp-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> +L:	linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +L:	linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +S:	Supported
> +F:	drivers/usb/storage/uas.c
> +
>  USB BLOCK DRIVER (UB ub)
>  M:	Pete Zaitcev <zaitcev-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>  L:	linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
> index 8a372ba..f2767cf 100644
> --- a/drivers/usb/storage/Kconfig
> +++ b/drivers/usb/storage/Kconfig
> @@ -172,6 +172,19 @@ config USB_STORAGE_CYPRESS_ATACB
>  
>  	  If this driver is compiled as a module, it will be named ums-cypress.
>  
> +config USB_UAS
> +	tristate "USB Attached SCSI"
> +	depends on USB && SCSI
> +	help
> +	  The USB Attached SCSI protocol is supported by some USB
> +	  storage devices.  It permits higher performance by supporting
> +	  multiple outstanding commands.
> +
> +	  If you don't know whether you have a UAS device, it is safe to
> +	  say 'Y' or 'M' here and the kernel will use the right driver.
> +
> +	  If you compile this driver as a module, it will be named uas.
> +
>  config USB_LIBUSUAL
>  	bool "The shared table of common (or usual) storage devices"
>  	depends on USB
> diff --git a/drivers/usb/storage/Makefile b/drivers/usb/storage/Makefile
> index ef7e5a8..0332aa5 100644
> --- a/drivers/usb/storage/Makefile
> +++ b/drivers/usb/storage/Makefile
> @@ -7,6 +7,7 @@
>  
>  EXTRA_CFLAGS	:= -Idrivers/scsi
>  
> +obj-$(CONFIG_USB_UAS)		+= uas.o
>  obj-$(CONFIG_USB_STORAGE)	+= usb-storage.o
>  
>  usb-storage-obj-$(CONFIG_USB_STORAGE_DEBUG)	+= debug.o
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> new file mode 100644
> index 0000000..7fd049b
> --- /dev/null
> +++ b/drivers/usb/storage/uas.c
> @@ -0,0 +1,751 @@
> +/*
> + * USB Attached SCSI
> + * Note that this is not the same as the USB Mass Storage driver
> + *
> + * Copyright Matthew Wilcox for Intel Corp, 2010
> + * Copyright Sarah Sharp for Intel Corp, 2010
> + *
> + * Distributed under the terms of the GNU GPL, version two.
> + */
> +
> +#include <linux/blkdev.h>
> +#include <linux/slab.h>
> +#include <linux/types.h>
> +#include <linux/usb.h>
> +#include <linux/usb/storage.h>
> +
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_dbg.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_device.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi_tcq.h>
> +
> +/* Common header for all IUs */
> +struct iu {
> +	__u8 iu_id;
> +	__u8 rsvd1;
> +	__be16 tag;
> +};
> +
> +enum {
> +	IU_ID_COMMAND		= 0x01,
> +	IU_ID_STATUS		= 0x03,
> +	IU_ID_RESPONSE		= 0x04,
> +	IU_ID_TASK_MGMT		= 0x05,
> +	IU_ID_READ_READY	= 0x06,
> +	IU_ID_WRITE_READY	= 0x07,
> +};
> +
> +struct command_iu {
> +	__u8 iu_id;
> +	__u8 rsvd1;
> +	__be16 tag;
> +	__u8 prio_attr;
> +	__u8 rsvd5;
> +	__u8 len;
> +	__u8 rsvd7;
> +	struct scsi_lun lun;
> +	__u8 cdb[16];	/* XXX: Overflow-checking tools may misunderstand */
> +};
> +
> +struct sense_iu {
> +	__u8 iu_id;
> +	__u8 rsvd1;
> +	__be16 tag;
> +	__be16 status_qual;
> +	__u8 status;
> +	__u8 service_response;
> +	__u8 rsvd8[6];
> +	__be16 len;
> +	__u8 sense[SCSI_SENSE_BUFFERSIZE];
> +};
> +
> +/*
> + * The r00-r01c specs define this version of the SENSE IU data structure.
> + * It's still in use by several different firmware releases.
> + */
> +struct sense_iu_old {
> +	__u8 iu_id;
> +	__u8 rsvd1;
> +	__be16 tag;
> +	__be16 len;
> +	__u8 status;
> +	__u8 service_response;
> +	__u8 sense[SCSI_SENSE_BUFFERSIZE];
> +};
> +
> +enum {
> +	CMD_PIPE_ID		= 1,
> +	STATUS_PIPE_ID		= 2,
> +	DATA_IN_PIPE_ID		= 3,
> +	DATA_OUT_PIPE_ID	= 4,
> +
> +	UAS_SIMPLE_TAG		= 0,
> +	UAS_HEAD_TAG		= 1,
> +	UAS_ORDERED_TAG		= 2,
> +	UAS_ACA			= 4,
> +};
> +
> +struct uas_dev_info {
> +	struct usb_interface *intf;
> +	struct usb_device *udev;
> +	int qdepth;
> +	unsigned cmd_pipe, status_pipe, data_in_pipe, data_out_pipe;
> +	unsigned use_streams:1;
> +	unsigned uas_sense_old:1;
> +};
> +
> +enum {
> +	ALLOC_SENSE_URB		= (1 << 0),
> +	SUBMIT_SENSE_URB	= (1 << 1),
> +	ALLOC_DATA_IN_URB	= (1 << 2),
> +	SUBMIT_DATA_IN_URB	= (1 << 3),
> +	ALLOC_DATA_OUT_URB	= (1 << 4),
> +	SUBMIT_DATA_OUT_URB	= (1 << 5),
> +	ALLOC_CMD_URB		= (1 << 6),
> +	SUBMIT_CMD_URB		= (1 << 7),
> +};
> +
> +/* Overrides scsi_pointer */
> +struct uas_cmd_info {
> +	unsigned int state;
> +	unsigned int stream;
> +	struct urb *cmd_urb;
> +	struct urb *sense_urb;
> +	struct urb *data_in_urb;
> +	struct urb *data_out_urb;
> +	struct list_head list;
> +};
> +
> +/* I hate forward declarations, but I actually have a loop */
> +static int uas_submit_urbs(struct scsi_cmnd *cmnd,
> +				struct uas_dev_info *devinfo, gfp_t gfp);
> +
> +static DEFINE_SPINLOCK(uas_work_lock);
> +static LIST_HEAD(uas_work_list);
> +
> +static void uas_do_work(struct work_struct *work)
> +{
> +	struct uas_cmd_info *cmdinfo;
> +	struct list_head list;
> +
> +	spin_lock_irq(&uas_work_lock);
> +	list_replace_init(&uas_work_list, &list);
> +	spin_unlock_irq(&uas_work_lock);
> +
> +	list_for_each_entry(cmdinfo, &list, list) {
> +		struct scsi_pointer *scp = (void *)cmdinfo;
> +		struct scsi_cmnd *cmnd = container_of(scp,
> +							struct scsi_cmnd, SCp);
> +		uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_KERNEL);

Deadlocky, use GFP_NOIO
> +	}
> +}
> +
> +static DECLARE_WORK(uas_work, uas_do_work);
> +
> +static void uas_sense(struct urb *urb, struct scsi_cmnd *cmnd)
> +{
> +	struct sense_iu *sense_iu = urb->transfer_buffer;
> +	struct scsi_device *sdev = cmnd->device;
> +
> +	if (urb->actual_length > 16) {
> +		unsigned len = be16_to_cpup(&sense_iu->len);
> +		if (len + 16 != urb->actual_length) {
> +			int newlen = min(len + 16, urb->actual_length) - 16;
> +			if (newlen < 0)
> +				newlen = 0;
> +			sdev_printk(KERN_INFO, sdev, "%s: urb length %d "
> +				"disagrees with IU sense data length %d, "
> +				"using %d bytes of sense data\n", __func__,
> +					urb->actual_length, len, newlen);
> +			len = newlen;
> +		}
> +		memcpy(cmnd->sense_buffer, sense_iu->sense, len);
> +	}
> +
> +	cmnd->result = sense_iu->status;
> +	if (sdev->current_cmnd)
> +		sdev->current_cmnd = NULL;

the condition is absolutely senseless

> +	cmnd->scsi_done(cmnd);
> +	usb_free_urb(urb);
> +}
> +
> +static void uas_sense_old(struct urb *urb, struct scsi_cmnd *cmnd)
> +{
> +	struct sense_iu_old *sense_iu = urb->transfer_buffer;
> +	struct scsi_device *sdev = cmnd->device;
> +
> +	if (urb->actual_length > 8) {
> +		unsigned len = be16_to_cpup(&sense_iu->len) - 2;
> +		if (len + 8 != urb->actual_length) {
> +			int newlen = min(len + 8, urb->actual_length) - 8;
> +			if (newlen < 0)
> +				newlen = 0;
> +			sdev_printk(KERN_INFO, sdev, "%s: urb length %d "
> +				"disagrees with IU sense data length %d, "
> +				"using %d bytes of sense data\n", __func__,
> +					urb->actual_length, len, newlen);
> +			len = newlen;
> +		}
> +		memcpy(cmnd->sense_buffer, sense_iu->sense, len);
> +	}
> +
> +	cmnd->result = sense_iu->status;
> +	if (sdev->current_cmnd)
> +		sdev->current_cmnd = NULL;
> +	cmnd->scsi_done(cmnd);
> +	usb_free_urb(urb);
> +}
> +
> +static void uas_xfer_data(struct urb *urb, struct scsi_cmnd *cmnd,
> +							unsigned direction)
> +{
> +	struct uas_cmd_info *cmdinfo = (void *)&cmnd->SCp;
> +	int err;
> +
> +	cmdinfo->state = direction | SUBMIT_SENSE_URB;
> +	err = uas_submit_urbs(cmnd, cmnd->device->hostdata, GFP_ATOMIC);
> +	if (err) {
> +		spin_lock(&uas_work_lock);
> +		list_add_tail(&cmdinfo->list, &uas_work_list);
> +		spin_unlock(&uas_work_lock);
> +		schedule_work(&uas_work);
> +	}
> +}
> +
> +static void uas_stat_cmplt(struct urb *urb)
> +{
> +	struct iu *iu = urb->transfer_buffer;
> +	struct scsi_device *sdev = urb->context;
> +	struct uas_dev_info *devinfo = sdev->hostdata;
> +	struct scsi_cmnd *cmnd;
> +	u16 tag;
> +
> +	if (urb->status) {
> +		dev_err(&urb->dev->dev, "URB BAD STATUS %d\n", urb->status);
> +		usb_free_urb(urb);
> +		return;
> +	}
> +
> +	tag = be16_to_cpup(&iu->tag) - 1;
> +	if (sdev->current_cmnd)
> +		cmnd = sdev->current_cmnd;
> +	else
> +		cmnd = scsi_find_tag(sdev, tag);
> +	if (!cmnd)
> +		return;

Where is the URB freed?

> +	switch (iu->iu_id) {
> +	case IU_ID_STATUS:
> +		if (urb->actual_length < 16)
> +			devinfo->uas_sense_old = 1;
> +		if (devinfo->uas_sense_old)
> +			uas_sense_old(urb, cmnd);
> +		else
> +			uas_sense(urb, cmnd);
> +		break;
> +	case IU_ID_READ_READY:
> +		uas_xfer_data(urb, cmnd, SUBMIT_DATA_IN_URB);
> +		break;
> +	case IU_ID_WRITE_READY:
> +		uas_xfer_data(urb, cmnd, SUBMIT_DATA_OUT_URB);
> +		break;
> +	default:
> +		scmd_printk(KERN_ERR, cmnd,
> +			"Bogus IU (%d) received on status pipe\n", iu->iu_id);
> +	}
> +}
> +

> +static int uas_pre_reset(struct usb_interface *intf)
> +{
> +/* XXX: Need to return 1 if it's not our device in error handling */
> +	return 0;
> +}

You should probably make sure that no further commands are
queued from this point on.

> +static int uas_post_reset(struct usb_interface *intf)
> +{
> +/* XXX: Need to return 1 if it's not our device in error handling */
> +	return 0;
> +}
> +
> +static void uas_disconnect(struct usb_interface *intf)
> +{
> +	struct usb_device *udev = interface_to_usbdev(intf);
> +	struct usb_host_endpoint *eps[3];
> +	struct Scsi_Host *shost = usb_get_intfdata(intf);
> +	struct uas_dev_info *devinfo = (void *)shost->hostdata[0];
> +
> +	scsi_remove_host(shost);
> +
> +	eps[0] = usb_pipe_endpoint(udev, devinfo->status_pipe);
> +	eps[1] = usb_pipe_endpoint(udev, devinfo->data_in_pipe);
> +	eps[2] = usb_pipe_endpoint(udev, devinfo->data_out_pipe);
> +	usb_free_streams(intf, eps, 3, GFP_KERNEL);

This implies that this can fail due to a lack of memory.
Then what?

	Regards
		Oliver
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
