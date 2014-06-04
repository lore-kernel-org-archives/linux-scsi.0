From: Venkatesh Srinivas <venkateshs@google.com>
Subject: Re: [PATCH v3 5/6] virtio-scsi: fix various bad behavior on aborted requests
Date: Wed, 4 Jun 2014 10:29:21 -0700
Message-ID: <CAHdzE-8KoMrg_jSuj-F9c=HnapCiLCg9bKCifduTaxx-DAJZRw@mail.gmail.com>
References: <1401881699-1456-1-git-send-email-pbonzini@redhat.com>
	<1401881699-1456-6-git-send-email-pbonzini@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1401881699-1456-6-git-send-email-pbonzini@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de, JBottomley@parallels.com, stable@vger.kernel.org, Venkatesh Srinivas <vsrinivas@ops101.org>
List-Id: linux-scsi@vger.kernel.org

On 6/4/14, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Even though the virtio-scsi spec guarantees that all requests related
> to the TMF will have been completed by the time the TMF itself completes,
> the request queue's callback might not have run yet.  This causes requests
> to be completed more than once, and as a result triggers a variety of
> BUGs or oopses.
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index d66c4ee2c774..fda9fb358888 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -235,6 +235,16 @@ static void virtscsi_req_done(struct virtqueue *vq)
>  	virtscsi_vq_done(vscsi, req_vq, virtscsi_complete_cmd);
>  };
>
> +static void virtscsi_poll_requests(struct virtio_scsi *vscsi)
> +{
> +	int i, num_vqs;
> +
> +	num_vqs = vscsi->num_queues;
> +	for (i = 0; i < num_vqs; i++)
> +		virtscsi_vq_done(vscsi, &vscsi->req_vqs[i],
> +				 virtscsi_complete_cmd);
> +}
> +
>  static void virtscsi_complete_free(struct virtio_scsi *vscsi, void *buf)
>  {
>  	struct virtio_scsi_cmd *cmd = buf;
> @@ -579,6 +589,18 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi,
> struct virtio_scsi_cmd *cmd)
>  	    cmd->resp.tmf.response == VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
>  		ret = SUCCESS;
>
> +	/*
> +	 * The spec guarantees that all requests related to the TMF have
> +	 * been completed, but the callback might not have run yet if
> +	 * we're using independent interrupts (e.g. MSI).  Poll the
> +	 * virtqueues once.
> +	 *
> +	 * In the abort case, sc->scsi_done will do nothing, because
> +	 * the block layer must have detected a timeout and as a result
> +	 * REQ_ATOM_COMPLETE has been set.
> +	 */
> +	virtscsi_poll_requests(vscsi);

Do you really want to poll the request VQs for completions if the TMF
was rejected?

TMF ABORT may return FUNCTION REJECTED if the command to abort
completed before the device saw the TMF ABORT message, for example. In
such cases, this would
unnecessarily lengthen the EH path.

> +
>  out:
>  	mempool_free(cmd, virtscsi_cmd_pool);
>  	return ret;
> --
> 1.8.3.1

Thanks for looking into this,
-- vs;
