From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 1/6] virtio-scsi.h: Add virtio_scsi_cmd_req_pi +
 VIRTIO_SCSI_F_T10_PI bits
Date: Mon, 7 Apr 2014 12:55:05 +0300
Message-ID: <20140407095505.GA14432@redhat.com>
References: <1396819929-29687-1-git-send-email-nab@daterainc.com>
 <1396819929-29687-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755132AbaDGJyj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Apr 2014 05:54:39 -0400
Content-Disposition: inline
In-Reply-To: <1396819929-29687-2-git-send-email-nab@daterainc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@dev.mellanox.co.il>

On Sun, Apr 06, 2014 at 09:32:04PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds a virtio_scsi_cmd_req_pi header as recommened by
> Paolo that contains do_pi_niov + di_pi_niov elements used for
> signaling when protection information buffers are expected to
> preceed the data buffers.
> 
> Also add new VIRTIO_SCSI_F_T10_PI feature bit to be used to signal
> host support.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Sagi Grimberg <sagig@dev.mellanox.co.il>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  include/linux/virtio_scsi.h |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/virtio_scsi.h b/include/linux/virtio_scsi.h
> index 4195b97..590d249 100644
> --- a/include/linux/virtio_scsi.h
> +++ b/include/linux/virtio_scsi.h
> @@ -35,11 +35,23 @@ struct virtio_scsi_cmd_req {
>  	u8 lun[8];		/* Logical Unit Number */
>  	u64 tag;		/* Command identifier */
>  	u8 task_attr;		/* Task attribute */
> -	u8 prio;
> +	u8 prio;		/* SAM command priority field */
>  	u8 crn;
>  	u8 cdb[VIRTIO_SCSI_CDB_SIZE];
>  } __packed;
>  
> +/* SCSI command request, followed by protection information */
> +struct virtio_scsi_cmd_req_pi {
> +	u8 lun[8];		/* Logical Unit Number */
> +	u64 tag;		/* Command identifier */
> +	u8 task_attr;		/* Task attribute */
> +	u8 prio;		/* SAM command priority field */
> +	u8 crn;

Hmm if we stick a reserved byte here, following fields will be
naturally aligned and we'd be able to get rid of __packed
instruction (which often causes gcc to generate worse code).

> +	u16 do_pi_niov;		/* DataOUT PI Number of iovecs */
> +	u16 di_pi_niov;		/* DataIN PI Number of iovecs */

So this looks like a somewhat problematic interface to me in that
it talks in terms of iovecs not bytes.
So this perpetuates the assumption that header is in a separate
iov from data (and protection is separate from data).
Arguably virtio doesn't work in terms of iovecs on the guest side so
this naming looks strange.
Further host side, get_vq_descs can in theory split a buffer to multiple
iovecs if it crosses the boundary of a memory region.

One solution is to use byte lengths here, but this does require
that vhost scsi gets rid of layout assumptions generally.
Not sure that's practical for -rc1.

Another is to do it like virtio-net does for RX, link two buffers
using the first one for data and the second one for protection.


> +	u8 cdb[VIRTIO_SCSI_CDB_SIZE];
> +} __packed;
> +
>  /* Response, followed by sense data and data-in */
>  struct virtio_scsi_cmd_resp {
>  	u32 sense_len;		/* Sense data length */
> @@ -97,6 +109,7 @@ struct virtio_scsi_config {
>  #define VIRTIO_SCSI_F_INOUT                    0
>  #define VIRTIO_SCSI_F_HOTPLUG                  1
>  #define VIRTIO_SCSI_F_CHANGE                   2
> +#define VIRTIO_SCSI_F_T10_PI		       3
>  
>  /* Response codes */
>  #define VIRTIO_SCSI_S_OK                       0
> -- 
> 1.7.10.4
