From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] scsi: virtio_scsi: don't send sc payload with tmfs
Date: Wed, 27 Feb 2019 17:28:17 +0100
Message-ID: <a4ff6218-40c9-d232-0852-5a30e2c2eaab@redhat.com>
References: <1550403730-27876-1-git-send-email-felipe@nutanix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1550403730-27876-1-git-send-email-felipe@nutanix.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Felipe Franciosi <felipe@nutanix.com>, Stefan Hajnoczi <stefanha@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 27/02/19 17:10, Felipe Franciosi wrote:
> The virtio scsi spec defines struct virtio_scsi_ctrl_tmf as a set of
> device-readable records and a single device-writable response entry:
> 
>     struct virtio_scsi_ctrl_tmf
>     {
>         // Device-readable part
>         le32 type;
>         le32 subtype;
>         u8 lun[8];
>         le64 id;
>         // Device-writable part
>         u8 response;
>     }
> 
> The above should be organised as two descriptor entries (or potentially
> more if using VIRTIO_F_ANY_LAYOUT), but without any extra data after
> "le64 id" or after "u8 response".
> 
> The Linux driver doesn't respect that, with virtscsi_abort() and
> virtscsi_device_reset() setting cmd->sc before calling virtscsi_tmf().
> It results in the original scsi command payload (or writable buffers)
> added to the tmf.
> 
> This fixes the problem by leaving cmd->sc zeroed out, which makes
> virtscsi_kick_cmd() add the tmf to the control vq without any payload.

Indeed, all that the completion routine needs is cmd->comp, which is set
directly in virtscsi_tmf.

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Cc: stable@vger.kernel.org

> 
> Signed-off-by: Felipe Franciosi <felipe@nutanix.com>
> ---
>  drivers/scsi/virtio_scsi.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 772b976..464cba5 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -594,7 +594,6 @@ static int virtscsi_device_reset(struct scsi_cmnd *sc)
>  		return FAILED;
>  
>  	memset(cmd, 0, sizeof(*cmd));
> -	cmd->sc = sc;
>  	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
>  		.type = VIRTIO_SCSI_T_TMF,
>  		.subtype = cpu_to_virtio32(vscsi->vdev,
> @@ -653,7 +652,6 @@ static int virtscsi_abort(struct scsi_cmnd *sc)
>  		return FAILED;
>  
>  	memset(cmd, 0, sizeof(*cmd));
> -	cmd->sc = sc;
>  	cmd->req.tmf = (struct virtio_scsi_ctrl_tmf_req){
>  		.type = VIRTIO_SCSI_T_TMF,
>  		.subtype = VIRTIO_SCSI_T_TMF_ABORT_TASK,
> 
