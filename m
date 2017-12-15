From: Steffen Maier <maier@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] virtio-scsi: implement target rescan
Date: Fri, 15 Dec 2017 18:54:25 +0100
Message-ID: <0340d1fd-d0d2-b7d2-b573-321d8abbac77@linux.vnet.ibm.com>
References: <1513246316-56019-1-git-send-email-hare@suse.de>
 <1513246316-56019-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755409AbdLORzF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Dec 2017 12:55:05 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id vBFHsnJv090479
        for <linux-scsi@vger.kernel.org>; Fri, 15 Dec 2017 12:55:04 -0500
Received: from e06smtp12.uk.ibm.com (e06smtp12.uk.ibm.com [195.75.94.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2evg44hxdv-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 15 Dec 2017 12:55:01 -0500
Received: from localhost
        by e06smtp12.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <maier@linux.vnet.ibm.com>;
        Fri, 15 Dec 2017 17:54:30 -0000
In-Reply-To: <1513246316-56019-2-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>


On 12/14/2017 11:11 AM, Hannes Reinecke wrote:
> Implement the 'rescan' virtio-scsi feature. Rescanning works by
> sending a 'rescan' virtio-scsi command with the next requested
> target id to the backend. The backend will respond with the next
> used target id or '-1' if no more targets are found.
> This avoids scanning all possible targets.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>   drivers/scsi/virtio_scsi.c       | 239 ++++++++++++++++++++++++++++++++++++++-
>   include/uapi/linux/virtio_scsi.h |  15 +++
>   2 files changed, 250 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 7c28e8d..a561e90 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c

> +static void virtscsi_rescan_work(struct work_struct *work)
> +{

> +	if (target_id == -1) {
> +		shost_printk(KERN_INFO, sh, "rescan: terminated\n");
> +		spin_unlock_irq(&vscsi->rescan_lock);
> +		return;
> +	}
> +	spin_unlock_irq(&vscsi->rescan_lock);
> +
> +	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
> +	if (!cmd) {
> +		shost_printk(KERN_INFO, sh, "rescan: no memory\n");
> +		goto scan_host;
> +	}
> +	shost_printk(KERN_INFO, sh, "rescan: next target %d\n", target_id);

> +		shost_printk(KERN_INFO, sh,
> +			     "rescan: no more targets\n");

> +	shost_printk(KERN_INFO, sh, "rescan: scan host\n");
> +	scsi_scan_host(sh);
> +}
> +
> +static void virtscsi_scan_host(struct virtio_scsi *vscsi)
> +{
> +	struct Scsi_Host *sh = virtio_scsi_host(vscsi->vdev);
> +	int ret;
> +	struct virtio_scsi_cmd *cmd;
> +	DECLARE_COMPLETION_ONSTACK(comp);
> +
> +	cmd = mempool_alloc(virtscsi_cmd_pool, GFP_NOIO);
> +	if (!cmd) {
> +		shost_printk(KERN_INFO, sh, "rescan: no memory\n");

If shost_printk does not add any info about calling function, this 
cannot be distinguished from a message with the same format string above 
in virtscsi_rescan_work()?

> +		return;
> +	}
> +	shost_printk(KERN_INFO, sh, "rescan: scan host\n");

dito


> +static void virtscsi_scan_start(struct Scsi_Host *sh)
> +{
> +	struct virtio_scsi *vscsi = shost_priv(sh);
> +
> +	virtscsi_scan_host(vscsi);
> +	spin_lock_irq(&vscsi->rescan_lock);
> +	if (vscsi->next_target_id != -1) {
> +		shost_printk(KERN_INFO, sh, "rescan: already running\n");
> +		spin_unlock_irq(&vscsi->rescan_lock);
> +		return;
> +	}
> +	vscsi->next_target_id = 0;
> +	shost_printk(KERN_INFO, sh, "rescan: start\n");
> +	spin_unlock_irq(&vscsi->rescan_lock);
> +	queue_work(system_freezable_wq, &vscsi->rescan_work);
> +}
> +
> +int virtscsi_scan_finished(struct Scsi_Host *sh, unsigned long time)

> +	shost_printk(KERN_INFO, sh, "rescan: %s finished\n",
> +		     ret ? "" : "not");
> +	return ret;
> +}


-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
