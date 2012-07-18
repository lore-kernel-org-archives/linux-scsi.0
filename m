From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [RFC-v3 3/4] vhost: Add vhost_scsi specific defines
Date: Wed, 18 Jul 2012 16:05:18 +0300
Message-ID: <20120718130518.GB5589@redhat.com>
References: <1342573172-17421-1-git-send-email-nab@linux-iscsi.org>
 <1342573172-17421-4-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1342573172-17421-4-git-send-email-nab@linux-iscsi.org>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, kvm-devel <kvm@vger.kernel.org>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>, Zhi Yong Wu <wuzhy@cn.ibm.com>, Anthony Liguori <aliguori@linux.vnet.ibm.com>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@risingtidesystems.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jul 18, 2012 at 12:59:31AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@risingtidesystems.com>
> 
> This patch adds the initial vhost_scsi_ioctl() callers for VHOST_SCSI_SET_ENDPOINT
> and VHOST_SCSI_CLEAR_ENDPOINT respectively, and also adds struct vhost_vring_target
> that is used by tcm_vhost code when locating target ports during qemu setup.
> 
> Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> Cc: Zhi Yong Wu <wuzhy@cn.ibm.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>,
> Signed-off-by: Nicholas A. Bellinger <nab@risingtidesystems.com>
> ---
>  include/linux/vhost.h |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/vhost.h b/include/linux/vhost.h
> index e847f1e..33b313b 100644
> --- a/include/linux/vhost.h
> +++ b/include/linux/vhost.h
> @@ -24,7 +24,11 @@ struct vhost_vring_state {
>  struct vhost_vring_file {
>  	unsigned int index;
>  	int fd; /* Pass -1 to unbind from file. */
> +};
>  
> +struct vhost_vring_target {

Can this be renamed vhost_scsi_target?

> +	unsigned char vhost_wwpn[224];

224? I am guessing ISCSI_NAME_LEN from include/scsi/iscsi_proto.h?
Unfortunately we can't include iscsi_proto.h here as it
is not exported to users. But let's add a comment for now.

> +	unsigned short vhost_tpgt;
>  };
>  
>  struct vhost_vring_addr {
> @@ -121,6 +125,11 @@ struct vhost_memory {
>   * device.  This can be used to stop the ring (e.g. for migration). */
>  #define VHOST_NET_SET_BACKEND _IOW(VHOST_VIRTIO, 0x30, struct vhost_vring_file)
>  
> +/* VHOST_SCSI specific defines */
> +
> +#define VHOST_SCSI_SET_ENDPOINT _IOW(VHOST_VIRTIO, 0x40, struct vhost_vring_target)
> +#define VHOST_SCSI_CLEAR_ENDPOINT _IOW(VHOST_VIRTIO, 0x41, struct vhost_vring_target)
> +
>  /* Feature bits */
>  /* Log all write descriptors. Can be changed while device is active. */

Can these go into appropriate ifdef CONFIG_TCP_VHOST please?

>  #define VHOST_F_LOG_ALL 26
> -- 
> 1.7.2.5
