From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] virtio_scsi: fix memory leak on full queue condition.
Date: Fri, 09 Nov 2012 09:48:02 +0100
Message-ID: <509CC342.80700@redhat.com>
References: <1352368550-6694-1-git-send-email-digitaleric@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1352368550-6694-1-git-send-email-digitaleric@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Northup <digitaleric@google.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Il 08/11/2012 10:55, Eric Northup ha scritto:
> virtscsi_queuecommand was leaking memory when the virtio queue was full.
> 
> Tested: Guest operates correctly even with very small queue sizes, validated
> we're not leaking kmalloc-192 sized allocations anymore.
> 
> Signed-off-by: Eric Northup <digitaleric@google.com>
> ---
>  drivers/scsi/virtio_scsi.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 595af1a..dd8dc27 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -469,6 +469,8 @@ static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
>  			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
>  			      GFP_ATOMIC) >= 0)
>  		ret = 0;
> +	else
> +		mempool_free(cmd, virtscsi_cmd_pool);
>  
>  out:
>  	return ret;
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
