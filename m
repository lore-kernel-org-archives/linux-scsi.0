From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v3 1/2] virtio-scsi: first version
Date: Mon, 19 Dec 2011 09:17:29 -0500
Message-ID: <4EEF4779.2060905@interlog.com>
References: <1324296188-3426-1-git-send-email-pbonzini@redhat.com> <1324296188-3426-2-git-send-email-pbonzini@redhat.com> <4EEF2C86.6010003@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:46382 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab1LSORj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Dec 2011 09:17:39 -0500
In-Reply-To: <4EEF2C86.6010003@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>

On 11-12-19 07:22 AM, Hannes Reinecke wrote:
> On 12/19/2011 01:03 PM, Paolo Bonzini wrote:
>> The virtio-scsi HBA is the basis of an alternative storage stack
>> for QEMU-based virtual machines (including KVM).  Compared to
>> virtio-blk it is more scalable, because it supports many LUNs
>> on a single PCI slot), more powerful (it more easily supports
>> passthrough of host devices to the guest) and more easily
>> extensible (new SCSI features implemented by QEMU should not
>> require updating the driver in the guest).
>>
>> Signed-off-by: Paolo Bonzini<pbonzini@redhat.com>
>> ---
>>          v2->v3: added mempool, formatting fixes
>>
>> 	v1->v2: use dbg_dev, sdev_printk, scmd_printk
>>             - renamed lock to vq_lock
>>             - renamed cmd_vq to req_vq (and other similar changes)
>>             - fixed missing break in VIRTIO_SCSI_S_UNDERRUN
>>             - added VIRTIO_SCSI_S_BUSY
>>             - removed unused argument from virtscsi_map_cmd
>>             - fixed two tabs that had slipped in
>>             - moved max_sectors and cmd_per_lun from template to config space
>>             - __attribute__((packed)) ->  __packed
>>
>>   drivers/scsi/Kconfig        |    8 +
>>   drivers/scsi/Makefile       |    1 +
>>   drivers/scsi/virtio_scsi.c  |  497 +++++++++++++++++++++++++++++++++++++++++++
>>   include/linux/virtio_scsi.h |  112 +++++++++++
>>   include/linux/virtio_ids.h  |    1 +
>>   5 files changed, 519 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/scsi/virtio_scsi.c
>>   create mode 100644 include/linux/virtio_scsi.h
>>
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 06ea3bc..3ab6ad7 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -1902,6 +1902,14 @@ config SCSI_BFA_FC
>>   	  To compile this driver as a module, choose M here. The module will
>>   	  be called bfa.
>>
>> +config SCSI_VIRTIO
>> +	tristate "virtio-scsi support (EXPERIMENTAL)"
>> +	depends on EXPERIMENTAL&&  VIRTIO
>> +	help
>> +          This is the virtual HBA driver for virtio.  If the kernel will
>> +          be used in a virtual machine, say Y or M.
>> +
>> +
>>   endif # SCSI_LOWLEVEL
>>
>>   source "drivers/scsi/pcmcia/Kconfig"
>> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
>> index 2b88749..351b28b 100644
>> --- a/drivers/scsi/Makefile
>> +++ b/drivers/scsi/Makefile
>> @@ -141,6 +141,7 @@ obj-$(CONFIG_SCSI_CXGB4_ISCSI)	+= libiscsi.o libiscsi_tcp.o cxgbi/
>>   obj-$(CONFIG_SCSI_BNX2_ISCSI)	+= libiscsi.o bnx2i/
>>   obj-$(CONFIG_BE2ISCSI)		+= libiscsi.o be2iscsi/
>>   obj-$(CONFIG_SCSI_PMCRAID)	+= pmcraid.o
>> +obj-$(CONFIG_SCSI_VIRTIO)	+= virtio_scsi.o
>>   obj-$(CONFIG_VMWARE_PVSCSI)	+= vmw_pvscsi.o
>>
>>   obj-$(CONFIG_ARM)		+= arm/
>> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
>> new file mode 100644
>> index 0000000..cf8732f
>> --- /dev/null
>> +++ b/drivers/scsi/virtio_scsi.c
>> @@ -0,0 +1,497 @@
>> +/*
>> + * Virtio SCSI HBA driver
>> + *
>> + * Copyright IBM Corp. 2010
>> + * Copyright Red Hat, Inc. 2011
>> + *
>> + * Authors:
>> + *  Stefan Hajnoczi<stefanha@linux.vnet.ibm.com>
>> + *  Paolo Bonzini<pbonzini@redhat.com>
>> + *
>> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
>> + * See the COPYING file in the top-level directory.
>> + *
>> + */
>> +
>> +#include<linux/module.h>
>> +#include<linux/slab.h>
>> +#include<linux/mempool.h>
>> +#include<linux/virtio.h>
>> +#include<linux/virtio_ids.h>
>> +#include<linux/virtio_config.h>
>> +#include<linux/virtio_scsi.h>
>> +#include<scsi/scsi_host.h>
>> +#include<scsi/scsi_device.h>
>> +#include<scsi/scsi_cmnd.h>
>> +
>> +#define VIRTIO_SCSI_MEMPOOL_SZ 64
>> +
>> +/* Command queue element */
>> +struct virtio_scsi_cmd {
>> +	struct scsi_cmnd *sc;
>> +	union {
>> +		struct virtio_scsi_cmd_req       cmd;
>> +		struct virtio_scsi_ctrl_tmf_req  tmf;
>> +		struct virtio_scsi_ctrl_an_req   an;
>> +	} req;
>> +	union {
>> +		struct virtio_scsi_cmd_resp      cmd;
>> +		struct virtio_scsi_ctrl_tmf_resp tmf;
>> +		struct virtio_scsi_ctrl_an_resp  an;
>> +		struct virtio_scsi_event         evt;
>> +	} resp;
>> +} ____cacheline_aligned_in_smp;
>> +
>> +/* Driver instance state */
>> +struct virtio_scsi {
>> +	/* Protects ctrl_vq, req_vq and sg[] */
>> +	spinlock_t vq_lock;
>> +
>> +	struct virtio_device *vdev;
>> +	struct virtqueue *ctrl_vq;
>> +	struct virtqueue *event_vq;
>> +	struct virtqueue *req_vq;
>> +
>> +	/* For sglist construction when adding commands to the virtqueue.  */
>> +	struct scatterlist sg[];
>> +};
>> +
>> +static struct kmem_cache *virtscsi_cmd_cache;
>> +static mempool_t *virtscsi_cmd_pool;
>> +
>> +static inline struct Scsi_Host *virtio_scsi_host(struct virtio_device *vdev)
>> +{
>> +	return vdev->priv;
>> +}
>> +
>> +static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
>> +{
>> +	if (!resid)
>> +		return;
>> +
>> +	if (!scsi_bidi_cmnd(sc)) {
>> +		scsi_set_resid(sc, resid);
>> +		return;
>> +	}
>> +
>> +	scsi_in(sc)->resid = min(resid, scsi_in(sc)->length);
>> +	scsi_out(sc)->resid = resid - scsi_in(sc)->resid;
>> +}
>> +
>> +/**
>> + * virtscsi_complete_cmd - finish a scsi_cmd and invoke scsi_done
>> + *
>> + * Called with vq_lock held.
>> + */
>> +static void virtscsi_complete_cmd(void *buf)
>> +{
>> +	struct virtio_scsi_cmd *cmd = buf;
>> +	struct scsi_cmnd *sc = cmd->sc;
>> +	struct virtio_scsi_cmd_resp *resp =&cmd->resp.cmd;
>> +
>> +	dev_dbg(&sc->device->sdev_gendev,
>> +		"cmd %p response %u status %#02x sense_len %u\n",
>> +		sc, resp->response, resp->status, resp->sense_len);
>> +
>> +	sc->result = resp->status;
>> +	virtscsi_compute_resid(sc, resp->resid);
>> +	switch (resp->response) {
>> +	case VIRTIO_SCSI_S_OK:
>> +		set_host_byte(sc, DID_OK);
>> +		break;
>> +	case VIRTIO_SCSI_S_UNDERRUN:
>> +		set_host_byte(sc, DID_ERROR);
>> +		break;
> Hmm. Not sure this is correct.
> UNDERRUN could be a valid state, eg it is quite common to send
> an INQUIRY with a length of 255 bytes. And only evaluate the
> bytes which are actually send back.
> For those cases you'd be incurring an UNDERRUN, but it's not
> actually an error, just sloppy programming.

Sloppy? In many situations with variable length
descriptors (e.g. Device Identification VPD page) the only way
of knowing what length will be placed in the data-in buffer
is to do a "short" INQUIRY. For example read the first 4 bytes just
to pick up the length field, then using that length to do a
second INQUIRY with the length field set to what is expected.
Simpler to do a single INQUIRY and request 252 bytes; any
initiator (HBA) that flags that underrun as an error is broken.
BTW 252 not 255. (t10.org prefers modulo 4 lengths, less pain
for some transports).

> So returning DID_ERROR here doesn't look correct.

Agreed.

OVERRUN is a more interesting case.

Doug Gilbert

