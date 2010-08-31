From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Open-FCoE] [RFC PATCH] scsi, fcoe, libfc: drop scsi host_lock
	use from fc_queuecommand
Date: Tue, 31 Aug 2010 16:56:25 -0700
Message-ID: <1283298985.32007.530.camel@haakon2.linux-iscsi.org>
References: <20100831225338.25102.59500.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp108.sbc.mail.gq1.yahoo.com ([67.195.14.111]:34784 "HELO
	smtp108.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751125Ab0IAAAO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2010 20:00:14 -0400
In-Reply-To: <20100831225338.25102.59500.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vasu Dev <vasu.dev@intel.com>
Cc: michaelc@cs.wisc.edu, devel@open-fcoe.org, linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>

On Tue, 2010-08-31 at 15:53 -0700, Vasu Dev wrote:
> Currently fc_queuecommand drops this lock very early on and then re-acquires
> this lock just before return, this re-acquired lock gets dropped immediately
> by its fast path caller scsi_dispatch_cmd, this re-acquire and then immediate
> drop on each IO hits performance especially with small size IOs on multi-core
> systems, this hit is significant about 25% with 512 bytes size IOs.
> 
> This lock is not needed in fc_queuecommand and calling fc_queuecommand
> without this lock held removes performance hit due to above described
> re-acquire and immediately dropping this lock on each IO.

Hi Vasu,

Very interesting numbers with small blocksizes and your patch.  I recall
trying to make a similar optimization patch myself in early 2.6.0 for
Linux/iSCSI initiators which still obtained struct Scsi_Host->host_lock
before calling struct scsi_host_template->queuecommand() in
drivers/scsi/scsi.c:scsi_dispatch_cmd(), but instead simply did not
attempt disable hard interrupts with spin_lock_irqsave().  I actually
run into some deadlocks way back then, and ended up giving up on the
patch and have not pursued the idea further since..

Anyways the idea is an interesting one for discussion, and it's
interesting to finally see the numbers on this.

I have comment on your patch below..

> 
> So this patch adds unlocked_qcmds flag to drop host_lock before
> calling only fc_queuecommand and no need to re-acquire and then drop
> this lock on each IO, this added flag drops this lock only if LLD wants
> as fcoe.ko does here, thus this change won't affect existing LLD since
> added unlocked_qcmds flag will be zero in those cases and their host
> lock uses would remain same after this patch.
> 
> I considered having this lock dropped inside fc_queuecommand using irq flags
> saved by its caller then return without re-acquiring this lock but that
> would make this lock usage asymmetric and passing saved irq flags was
> another issue with this approach, so RFC to seek any better possible fix
> for this or any issue with added unlocked_qcmds while not having
> fc_queuecommand under host_lock anymore. I'd appreciate any comments from
> Mike, Joe and folks on open-fcoe first before taking this patch to
> linux-scsi directly as suggested by Rob and Chris here.
> 
> I also did cable pull test in middle of IOs with this patch and I don't see
> any issue with that after this patch and some more testing is already done
> successfully with this patch.
> 
> Signed-off-by: Vasu Dev <vasu.dev@intel.com>
> ---
>  drivers/scsi/fcoe/fcoe.c    |    1 +
>  drivers/scsi/libfc/fc_fcp.c |   14 +++++---------
>  drivers/scsi/scsi.c         |    8 +++++++-
>  include/scsi/scsi_host.h    |    3 +++
>  4 files changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
> index 844d618..280a4df 100644
> --- a/drivers/scsi/fcoe/fcoe.c
> +++ b/drivers/scsi/fcoe/fcoe.c
> @@ -706,6 +706,7 @@ static int fcoe_shost_config(struct fc_lport *lport, struct device *dev)
>  	lport->host->max_id = FCOE_MAX_FCP_TARGET;
>  	lport->host->max_channel = 0;
>  	lport->host->max_cmd_len = FCOE_MAX_CMD_LEN;
> +	lport->host->unlocked_qcmds = 1;
>  
>  	if (lport->vport)
>  		lport->host->transportt = fcoe_vport_transport_template;
> diff --git a/drivers/scsi/libfc/fc_fcp.c b/drivers/scsi/libfc/fc_fcp.c
> index 43866e6..39b6bfa 100644
> --- a/drivers/scsi/libfc/fc_fcp.c
> +++ b/drivers/scsi/libfc/fc_fcp.c
> @@ -1751,8 +1751,7 @@ static inline int fc_fcp_lport_queue_ready(struct fc_lport *lport)
>   * @cmd:   The scsi_cmnd to be executed
>   * @done:  The callback function to be called when the scsi_cmnd is complete
>   *
> - * This is the i/o strategy routine, called by the SCSI layer. This routine
> - * is called with the host_lock held.
> + * This is the i/o strategy routine, called by the SCSI layer.
>   */
>  int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
>  {
> @@ -1770,9 +1769,8 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
>  	if (rval) {
>  		sc_cmd->result = rval;
>  		done(sc_cmd);
> -		return 0;
> +		return rc;
>  	}
> -	spin_unlock_irq(lport->host->host_lock);
>  
>  	if (!*(struct fc_remote_port **)rport->dd_data) {
>  		/*
> @@ -1781,7 +1779,7 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
>  		 */
>  		sc_cmd->result = DID_IMM_RETRY << 16;
>  		done(sc_cmd);
> -		goto out;
> +		return rc;
>  	}
>  
>  	rpriv = rport->dd_data;
> @@ -1790,13 +1788,13 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
>  		if (lport->qfull)
>  			fc_fcp_can_queue_ramp_down(lport);
>  		rc = SCSI_MLQUEUE_HOST_BUSY;
> -		goto out;
> +		return rc;
>  	}
>  
>  	fsp = fc_fcp_pkt_alloc(lport, GFP_ATOMIC);
>  	if (fsp == NULL) {
>  		rc = SCSI_MLQUEUE_HOST_BUSY;
> -		goto out;
> +		return rc;
>  	}
>  
>  	/*
> @@ -1848,8 +1846,6 @@ int fc_queuecommand(struct scsi_cmnd *sc_cmd, void (*done)(struct scsi_cmnd *))
>  		fc_fcp_pkt_release(fsp);
>  		rc = SCSI_MLQUEUE_HOST_BUSY;
>  	}
> -out:
> -	spin_lock_irq(lport->host->host_lock);
>  	return rc;
>  }
>  EXPORT_SYMBOL(fc_queuecommand);
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index ad0ed21..e7b9f3c 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -746,6 +746,9 @@ int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>  	 */
>  	scsi_cmd_get_serial(host, cmd); 
>  
> +	if (host->unlocked_qcmds)
> +		spin_unlock_irqrestore(host->host_lock, flags);
> +
>  	if (unlikely(host->shost_state == SHOST_DEL)) {
>  		cmd->result = (DID_NO_CONNECT << 16);
>  		scsi_done(cmd);

I don't think it's safe to call scsi_done() for the SHOST_DEL case here
with host->unlocked_qcmds=1 w/o holding host_lock, nor would it be safe
for the SCSI LLD itself using host->unlocked_qcmds=1 to call the
(*scsi_done)() being passed into sht->queuecommand() without
host->host_lock being held by either the SCSI ML or the SCSI LLD.

There may also be some other issues with doing this that are more
subtle..  Any comments on the possibility of doing this properly for
software initiators from the Linux/SCSI folks..?  Considering that
host_lock is always held for scsi_dispatch_cmd() -> scsi_done()
competion..?

Thanks!

--nab


