From: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH-v3 1/9] vhost/scsi: Convert completion path to use
 copy_to_iser
Date: Tue, 3 Feb 2015 11:24:05 +0200
Message-ID: <20150203092405.GH2830@redhat.com>
References: <1422945003-24538-1-git-send-email-nab@daterainc.com>
 <1422945003-24538-2-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1422945003-24538-2-git-send-email-nab@daterainc.com>
Sender: kvm-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org



On Tue, Feb 03, 2015 at 06:29:55AM +0000, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> Required for ANY_LAYOUT support when the incoming virtio-scsi response
> header + fixed size sense buffer payload may span more than a single
> iovec entry.
> 
> This changes existing code to save cmd->tvc_resp_iov instead of the
> first single iovec base pointer from &vq->iov[out].

Typo in subject: should be copy_to_iter.

> v3 changes:
>   - Convert memcpy_toiovecend -> copy_to_iser usage

This belongs after ---

> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>  drivers/vhost/scsi.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 01c01cb..1ad5b0f 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -72,6 +72,8 @@ struct tcm_vhost_cmd {
>  	int tvc_vq_desc;
>  	/* virtio-scsi initiator task attribute */
>  	int tvc_task_attr;
> +	/* virtio-scsi response incoming iovecs */
> +	int tvc_in_iovs;
>  	/* virtio-scsi initiator data direction */
>  	enum dma_data_direction tvc_data_direction;
>  	/* Expected data transfer length from virtio-scsi header */
> @@ -87,8 +89,8 @@ struct tcm_vhost_cmd {
>  	struct scatterlist *tvc_sgl;
>  	struct scatterlist *tvc_prot_sgl;
>  	struct page **tvc_upages;
> -	/* Pointer to response */
> -	struct virtio_scsi_cmd_resp __user *tvc_resp;
> +	/* Pointer to response header iovec */
> +	struct iovec *tvc_resp_iov;
>  	/* Pointer to vhost_scsi for our device */
>  	struct vhost_scsi *tvc_vhost;
>  	/* Pointer to vhost_virtqueue for the cmd */
> @@ -682,6 +684,7 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
>  	struct tcm_vhost_cmd *cmd;
>  	struct llist_node *llnode;
>  	struct se_cmd *se_cmd;
> +	struct iov_iter iov_iter;
>  	int ret, vq;
>  
>  	bitmap_zero(signal, VHOST_SCSI_MAX_VQ);
> @@ -703,8 +706,11 @@ static void vhost_scsi_complete_cmd_work(struct vhost_work *work)
>  						 se_cmd->scsi_sense_length);
>  		memcpy(v_rsp.sense, cmd->tvc_sense_buf,
>  		       se_cmd->scsi_sense_length);
> -		ret = copy_to_user(cmd->tvc_resp, &v_rsp, sizeof(v_rsp));
> -		if (likely(ret == 0)) {
> +
> +		iov_iter_init(&iov_iter, WRITE, cmd->tvc_resp_iov,
> +			      cmd->tvc_in_iovs, sizeof(v_rsp));
> +		ret = copy_to_iter(&v_rsp, sizeof(v_rsp), &iov_iter);
> +		if (likely(ret == sizeof(v_rsp))) {
>  			struct vhost_scsi_virtqueue *q;
>  			vhost_add_used(cmd->tvc_vq, cmd->tvc_vq_desc, 0);
>  			q = container_of(cmd->tvc_vq, struct vhost_scsi_virtqueue, vq);
> @@ -1159,7 +1165,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>  
>  		cmd->tvc_vhost = vs;
>  		cmd->tvc_vq = vq;
> -		cmd->tvc_resp = vq->iov[out].iov_base;
> +		cmd->tvc_resp_iov = &vq->iov[out];
> +		cmd->tvc_in_iovs = in;
>  
>  		pr_debug("vhost_scsi got command opcode: %#02x, lun: %d\n",
>  			cmd->tvc_cdb[0], cmd->tvc_lun);
> -- 
> 1.9.1
