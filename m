From: Fam Zheng <famz@redhat.com>
Subject: Re: [PATCH] virtio_scsi: Reject commands when virtqueue is broken
Date: Thu, 12 Jan 2017 11:11:59 +0800
Message-ID: <20170112031159.GD26504@lemon>
References: <1484172122-18882-1-git-send-email-farman@linux.vnet.ibm.com>
 <1484172122-18882-2-git-send-email-farman@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39016 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750698AbdALDMF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 11 Jan 2017 22:12:05 -0500
Content-Disposition: inline
In-Reply-To: <1484172122-18882-2-git-send-email-farman@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Farman <farman@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com

On Wed, 01/11 17:02, Eric Farman wrote:
> In the case of a graceful set of detaches, where the virtio-scsi-ccw
> disk is removed from the guest prior to the controller, the guest
> behaves quite normally.  Specifically, the detach gets us into
> sd_sync_cache to issue a Synchronize Cache(10) command, which
> immediately fails (and is retried a couple of times) because the
> device has been removed.  Later, the removal of the controller
> sees two CRWs presented, but there's no further indication of the
> removal from the guest viewpoint.
> 
>  [   17.217458] sd 0:0:0:0: [sda] Synchronizing SCSI cache
>  [   17.219257] sd 0:0:0:0: [sda] Synchronize Cache(10) failed: Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
>  [   21.449400] crw_info : CRW reports slct=0, oflw=0, chn=1, rsc=3, anc=0, erc=4, rsid=2
>  [   21.449406] crw_info : CRW reports slct=0, oflw=0, chn=0, rsc=3, anc=0, erc=4, rsid=0
> 
> However, on s390, the SCSI disks can be removed "by surprise" when
> an entire controller (host) is removed and all associated disks
> are removed via the loop in scsi_forget_host.  The same call to
> sd_sync_cache is made, but because the controller has already
> been removed, the Synchronize Cache(10) command is neither issued
> (and then failed) nor rejected.
> 
> That the I/O isn't returned means the guest cannot have other devices
> added nor removed, and other tasks (such as shutdown or reboot) issued
> by the guest will not complete either.  The virtio ring has already
> been marked as broken (via virtio_break_device in virtio_ccw_remove),
> but we still attempt to queue the command only to have it remain there.
> The calling sequence provides a bit of distinction for us:
> 
>   virtscsi_queuecommand()
>    -> virtscsi_kick_cmd()
>     -> virtscsi_add_cmd()
>      -> virtqueue_add_sgs()
>       -> virtqueue_add()
>          if success
>            return 0
>          elseif vq->broken or vring_mapping_error()
>            return -EIO
>          else
>            return -ENOSPC
> 
> A return of ENOSPC is generally a temporary condition, so returning
> "host busy" from virtscsi_queuecommand makes sense here, to have it
> redriven in a moment or two.  But the EIO return code is more of a
> permanent error and so it would be wise to return the I/O itself and
> allow the calling thread to finish gracefully.  The result is these
> four kernel messages in the guest (the fourth one does not occur
> prior to this patch):
> 
>  [   22.921562] crw_info : CRW reports slct=0, oflw=0, chn=1, rsc=3, anc=0, erc=4, rsid=2
>  [   22.921580] crw_info : CRW reports slct=0, oflw=0, chn=0, rsc=3, anc=0, erc=4, rsid=0
>  [   22.921978] sd 0:0:0:0: [sda] Synchronizing SCSI cache
>  [   22.921993] sd 0:0:0:0: [sda] Synchronize Cache(10) failed: Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK
> 
> I opted to fill in the same response data that is returned from the
> more graceful device detach, where the disk device is removed prior
> to the controller device.
> 
> Signed-off-by: Eric Farman <farman@linux.vnet.ibm.com>
> ---
>  drivers/scsi/virtio_scsi.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index ec91bd0..78d50ca 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -535,6 +535,7 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
>  	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
>  	struct virtio_scsi_cmd *cmd = scsi_cmd_priv(sc);
>  	int req_size;
> +	int ret;
>  
>  	BUG_ON(scsi_sg_count(sc) > shost->sg_tablesize);
>  
> @@ -562,8 +563,13 @@ static int virtscsi_queuecommand(struct virtio_scsi *vscsi,
>  		req_size = sizeof(cmd->req.cmd);
>  	}
>  
> -	if (virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd)) != 0)
> +	ret = virtscsi_kick_cmd(req_vq, cmd, req_size, sizeof(cmd->resp.cmd));
> +	if (ret == -EIO) {
> +		cmd->resp.cmd.response = VIRTIO_SCSI_S_BAD_TARGET;
> +		virtscsi_complete_cmd(vscsi, cmd);

Is this safe? Calling virtscsi_complete_cmd requires vq_lock but we don't seem
to have it here.

Fam

> +	} else if (ret != 0) {
>  		return SCSI_MLQUEUE_HOST_BUSY;
> +	}
>  	return 0;
>  }
