From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] virtio_scsi: Implement 'native LUN' feature
Date: Fri, 15 Dec 2017 19:17:50 +0100
Message-ID: <8b0a2527-7fe1-1475-49e4-0f34c753baaf@linux.vnet.ibm.com>
References: <1513246316-56019-1-git-send-email-hare@suse.de>
 <1513246316-56019-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49968 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755851AbdLOSR5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Dec 2017 13:17:57 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vBFIGwjZ131308
        for <linux-scsi@vger.kernel.org>; Fri, 15 Dec 2017 13:17:57 -0500
Received: from e06smtp10.uk.ibm.com (e06smtp10.uk.ibm.com [195.75.94.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2evhkqdbtv-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 15 Dec 2017 13:17:56 -0500
Received: from localhost
        by e06smtp10.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Fri, 15 Dec 2017 18:17:54 -0000
In-Reply-To: <1513246316-56019-4-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

Just a few very early view-only review comments.
Haven't run the code.

On 12/14/2017 11:11 AM, Hannes Reinecke wrote:
> The 'native LUN' feature allows virtio-scsi to pass in the LUN
> numbers from the underlying storage directly, without having
> to modify the LUN number itself.
> It works by shifting the existing LUN number down by 8 bytes,
> and add the virtio-specific 8-byte LUN steering header.
> With that virtio doesn't have to mangle the LUN number, allowing
> us to pass the 'real' LUN number to the guest.

I only see shifts by 16 bits in the code below which would be 2 bytes.
I had a quick look at the corresponding qemu code which looked the same 
to me.
What's the relation to 8 byte shifting, which would be 64 bit shift and 
thus odd for a 64 bit LUN, mentioned in the description here?

If the code keeps the LUN level 1 and 2 (dropping level 3 and 4) and I 
just don't understand it, it would be fine, I guess.

> Of course, we do cut off the last 8 bytes of the 'real' LUN number,
> but I'm not aware of any array utilizing that, so the impact should
> be negligible.

Why did we do v3.17 commit 9cb78c16f5da ("scsi: use 64-bit LUNs")? ;-)

> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   drivers/scsi/virtio_scsi.c       | 62 ++++++++++++++++++++++++++++++----------
>   include/uapi/linux/virtio_scsi.h |  1 +
>   2 files changed, 48 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index f925fbd..63c2c85 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -356,8 +356,12 @@ static void virtscsi_handle_transport_reset(struct virtio_scsi *vscsi,
>   	struct scsi_device *sdev;
>   	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
>   	unsigned int target = event->lun[1];
> -	unsigned int lun = (event->lun[2] << 8) | event->lun[3];
> +	u64 lun;
> 
> +	if (virtio_has_feature(vscsi->vdev, VIRTIO_SCSI_F_NATIVE_LUN))
> +		lun = scsilun_to_int((struct scsi_lun *)event->lun) >> 16;
> +	else
> +		lun = (event->lun[2] << 8) | event->lun[3];


> @@ -524,10 +532,16 @@ static void virtio_scsi_init_hdr(struct virtio_device *vdev,
>   				 int target_id,
>   				 struct scsi_cmnd *sc)
>   {
> -	cmd->lun[0] = 1;
> -	cmd->lun[1] = target_id;
> -	cmd->lun[2] = (sc->device->lun >> 8) | 0x40;
> -	cmd->lun[3] = sc->device->lun & 0xff;
> +	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_NATIVE_LUN)) {
> +		u64 lun = sc->device->lun << 16;
> +		lun |= ((u64)1 << 8) | (u64)target_id;
> +		int_to_scsilun(lun, (struct scsi_lun *)&cmd->lun);
> +	} else {
> +		cmd->lun[0] = 1;
> +		cmd->lun[1] = target_id;
> +		cmd->lun[2] = (sc->device->lun >> 8) | 0x40;
> +		cmd->lun[3] = sc->device->lun & 0xff;
> +	}

Above 2 patterns seem to repeat. Have helper functions (similar to 
int_to_scsilun()) now that it's more than just 4 lines of filling in the 
virtio lun?

> @@ -851,10 +871,18 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
>   		.subtype = VIRTIO_SCSI_T_TMF_ABORT_TASK,

>   		.lun[0] = 1,
>   		.lun[1] = target_id,

drop those 2 superfluous lines, too?

> -		.lun[2] = (sc->device->lun >> 8) | 0x40,
> -		.lun[3] = sc->device->lun & 0xff,
>   		.tag = cpu_to_virtio64(vscsi->vdev, (unsigned long)sc),
>   	};
> +	if (virtio_has_feature(vscsi->vdev, VIRTIO_SCSI_F_NATIVE_LUN)) {
> +		u64 lun = sc->device->lun << 16;
> +		lun |= ((u64)1 << 8) | (u64)target_id;
> +		int_to_scsilun(lun, (struct scsi_lun *)&cmd->req.tmf.lun);
> +	} else {
> +		cmd->req.tmf.lun[0] = 1;
> +		cmd->req.tmf.lun[1] = target_id;
> +		cmd->req.tmf.lun[2] = (sc->device->lun >> 8) | 0x40;
> +		cmd->req.tmf.lun[3] = sc->device->lun & 0xff;
> +	}

>   	return virtscsi_tmf(vscsi, cmd);
>   }
> 
> @@ -1429,7 +1457,10 @@ static int virtscsi_probe(struct virtio_device *vdev)
>   	/* LUNs > 256 are reported with format 1, so they go in the range
>   	 * 16640-32767.
>   	 */

Above old comment now only seems to apply to the then case of the 
following if statement, not to the else case.

> -	shost->max_lun = virtscsi_config_get(vdev, max_lun) + 1 + 0x4000;
> +	if (!virtio_has_feature(vdev, VIRTIO_SCSI_F_NATIVE_LUN))
> +		shost->max_lun = virtscsi_config_get(vdev, max_lun) + 1 + 0x4000;
> +	else
> +		shost->max_lun = (u64)-1;
>   	shost->max_id = num_targets;
>   	shost->max_channel = 0;
>   	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;


-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
