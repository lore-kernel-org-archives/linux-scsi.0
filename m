From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] virtio-scsi: Add vdrv->scan for post
 VIRTIO_CONFIG_S_DRIVER_OK LUN scanning
Date: Wed, 11 Jul 2012 19:37:36 +0100
Message-ID: <1342031856.3522.41.camel@dabdike.int.hansenpartnership.com>
References: <1341605705-13114-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1341605705-13114-1-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2012-07-06 at 20:15 +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch changes virtio-scsi to use a new virtio_driver->scan() callback
> so that scsi_scan_host() can be properly invoked once virtio_dev_probe() has
> set add_status(dev, VIRTIO_CONFIG_S_DRIVER_OK) to signal active virtio-ring
> operation, instead of from within virtscsi_probe().
> 
> This fixes a bug where SCSI LUN scanning for both virtio-scsi-raw and
> virtio-scsi/tcm_vhost setups was happening before VIRTIO_CONFIG_S_DRIVER_OK
> had been set, causing VIRTIO_SCSI_S_BAD_TARGET to occur.  This fixes a bug
> with virtio-scsi/tcm_vhost where LUN scan was not detecting LUNs.
> 
> Tested with virtio-scsi-raw + virtio-scsi/tcm_vhost w/ IBLOCK on 3.5-rc2 code.
> 
> Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> Cc: Zhi Yong Wu <wuzhy@cn.ibm.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/scsi/virtio_scsi.c |   15 ++++++++++++---
>  drivers/virtio/virtio.c    |    5 ++++-
>  include/linux/virtio.h     |    1 +
>  3 files changed, 17 insertions(+), 4 deletions(-)

This doesn't apply:

patching file drivers/scsi/virtio_scsi.c
Hunk #1 succeeded at 677 (offset 196 lines).
Hunk #2 FAILED at 494.
Hunk #3 succeeded at 736 (offset 198 lines).
1 out of 3 hunks FAILED -- saving rejects to file
drivers/scsi/virtio_scsi.c.rej

could you respin against scsi-misc head?

Thanks,

James
