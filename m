From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] vhost/scsi: Fix incorrect usage of get_user_pages_fast
	write parameter
Date: Mon, 28 Oct 2013 14:41:13 +0200
Message-ID: <20131028124113.GB19131@redhat.com>
References: <1382724436-28478-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
Content-Disposition: inline
In-Reply-To: <1382724436-28478-1-git-send-email-nab@linux-iscsi.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: kvm-devel <kvm@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, Stefan Hajnoczi <stefanha@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 25, 2013 at 06:07:16PM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch addresses a long-standing bug where the get_user_pages_fast()
> write parameter used for setting the underlying page table entry permission
> bits was incorrectly set to write=1 for data_direction=DMA_TO_DEVICE, and
> passed into get_user_pages_fast() via vhost_scsi_map_iov_to_sgl().
> 
> However, this parameter is intended to signal WRITEs to pinned userspace
> PTEs for the virtio-scsi DMA_FROM_DEVICE -> READ payload case, and *not*
> for the virtio-scsi DMA_TO_DEVICE -> WRITE payload case.
> 
> This bug would manifest itself as random process segmentation faults on
> KVM host after repeated vhost starts + stops and/or with lots of vhost
> endpoints + LUNs.
> 
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Asias He <asias@redhat.com>
> Cc: <stable@vger.kernel.org> # 3.6+
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/vhost/scsi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index ce5221f..e663921 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1056,7 +1056,7 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>  		if (data_direction != DMA_NONE) {
>  			ret = vhost_scsi_map_iov_to_sgl(cmd,
>  					&vq->iov[data_first], data_num,
> -					data_direction == DMA_TO_DEVICE);
> +					data_direction == DMA_FROM_DEVICE);
>  			if (unlikely(ret)) {
>  				vq_err(vq, "Failed to map iov to sgl\n");
>  				goto err_free;
> -- 
> 1.7.2.5
