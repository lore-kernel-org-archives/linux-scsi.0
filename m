From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: vmw_pscsi: Fix use-after-free in
 pvscsi_queue_lck()
Date: Wed, 19 Jun 2019 11:13:16 -0400
Message-ID: <a05c420e46d995a2397c46d416eaeb627c94ea11.camel@redhat.com>
References: <20190619070541.30070-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190619070541.30070-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
To: Jan Kara <jack@suse.cz>, Jim Gill <jgill@vmware.com>
Cc: VMware PV-Drivers <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, 2019-06-19 at 09:05 +0200, Jan Kara wrote:
> Once we unlock adapter->hw_lock in pvscsi_queue_lck() nothing prevents just
> queued scsi_cmnd from completing and freeing the request. Thus cmd->cmnd[0]
> dereference can dereference already freed request leading to kernel crashes or
> other issues (which one of our customers observed). Store cmd->cmnd[0] in a
> local variable before unlocking adapter->hw_lock to fix the issue.
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  drivers/scsi/vmw_pvscsi.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/vmw_pvscsi.c b/drivers/scsi/vmw_pvscsi.c
> index ecee4b3ff073..377b07b2feeb 100644
> --- a/drivers/scsi/vmw_pvscsi.c
> +++ b/drivers/scsi/vmw_pvscsi.c
> @@ -763,6 +763,7 @@ static int pvscsi_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
>  	struct pvscsi_adapter *adapter = shost_priv(host);
>  	struct pvscsi_ctx *ctx;
>  	unsigned long flags;
> +	unsigned char op;
>  
>  	spin_lock_irqsave(&adapter->hw_lock, flags);
>  
> @@ -775,13 +776,14 @@ static int pvscsi_queue_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd
>  	}
>  
>  	cmd->scsi_done = done;
> +	op = cmd->cmnd[0];
>  
>  	dev_dbg(&cmd->device->sdev_gendev,
> -		"queued cmd %p, ctx %p, op=%x\n", cmd, ctx, cmd->cmnd[0]);
> +		"queued cmd %p, ctx %p, op=%x\n", cmd, ctx, op);
>  
>  	spin_unlock_irqrestore(&adapter->hw_lock, flags);
>  
> -	pvscsi_kick_io(adapter, cmd->cmnd[0]);
> +	pvscsi_kick_io(adapter, op);
>  
>  	return 0;
>  }

Reviewed-by: Ewan D. Milne <emilne@redhat.com>
