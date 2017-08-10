From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/2] virtio: Reduce BUG if total_sg > virtqueue size to
	WARN.
Date: Thu, 10 Aug 2017 18:47:32 +0200
Message-ID: <fb2effc1-4f5f-a4b5-b8c3-737c2e14a65c@redhat.com>
References: <20170810164035.19963-1-rjones@redhat.com>
	<20170810164035.19963-2-rjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20170810164035.19963-2-rjones@redhat.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: "Richard W.M. Jones" <rjones@redhat.com>, jejb@linux.vnet.ibm.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, mst@redhat.com, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

On 10/08/2017 18:40, Richard W.M. Jones wrote:
> If using indirect descriptors, you can make the total_sg as large as
> you want.  If not, BUG is too serious because the function later
> returns -ENOSPC.
> 
> Thanks Paolo Bonzini, Christoph Hellwig.
> 
> Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
> ---
>  drivers/virtio/virtio_ring.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 5e1b548828e6..27cbc1eab868 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -296,7 +296,6 @@ static inline int virtqueue_add(struct virtqueue *_vq,
>  	}
>  #endif
>  
> -	BUG_ON(total_sg > vq->vring.num);
>  	BUG_ON(total_sg == 0);
>  
>  	head = vq->free_head;
> @@ -305,8 +304,10 @@ static inline int virtqueue_add(struct virtqueue *_vq,
>  	 * buffers, then go indirect. FIXME: tune this threshold */
>  	if (vq->indirect && total_sg > 1 && vq->vq.num_free)
>  		desc = alloc_indirect(_vq, total_sg, gfp);
> -	else
> +	else {
>  		desc = NULL;
> +		WARN_ON_ONCE(total_sg > vq->vring.num && !vq->indirect);

So we get here only if vq->vq.num_free is zero.  In that case,
vq->indirect makes no difference for the appropriateness of the warning
(that is, it should never be issued for indirect descriptors).

> +	}
>  
>  	if (desc) {
>  		/* Use a single buffer which doesn't continue */
> 


Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
