From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC v4 10/19] lpfc: Remove host_lock unlock() + lock() from
 lpfc_queuecommand()
Date: Tue, 28 Sep 2010 00:04:58 -0500
Message-ID: <4CA1777A.2050606@cs.wisc.edu>
References: <1285639612-7405-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1285639612-7405-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, James Bottomley <James.Bottomley@suse.de>, Jens Axboe <jaxboe@fusionio.com>, James Smart <james.smart@emulex.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>, Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>, "eata.c maintainer" <dario.ballabio@inwind.it>, Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>, pm8001 maintainer Jack Wang <jack_wang@usish.com>
List-Id: linux-scsi@vger.kernel.org

On 09/27/2010 09:06 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger<nab@linux-iscsi.org>
>
> This patch removes the now legacy host_lock unlock() + lock() optimization
> from lpfc_scsi.c:lpfc_queuecommand().  This also includes setting the
> SHT->unlocked_qcmd=1 for host_lock less lpfc lpfc_queuecommand() operation.
>
> Signed-off-by: Nicholas A. Bellinger<nab@linux-iscsi.org>
> ---
>   drivers/scsi/lpfc/lpfc_scsi.c |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
> index 2e51aa6..69fe31e 100644
> --- a/drivers/scsi/lpfc/lpfc_scsi.c
> +++ b/drivers/scsi/lpfc/lpfc_scsi.c
> @@ -3023,11 +3023,9 @@ lpfc_queuecommand(struct scsi_cmnd *cmnd, void (*done) (struct scsi_cmnd *))
>   		goto out_host_busy_free_buf;
>   	}
>   	if (phba->cfg_poll&  ENABLE_FCP_RING_POLLING) {
> -		spin_unlock(shost->host_lock);
>   		lpfc_sli_handle_fast_ring_event(phba,
>   			&phba->sli.ring[LPFC_FCP_RING], HA_R0RE_REQ);
>
> -		spin_lock(shost->host_lock);
>   		if (phba->cfg_poll&  DISABLE_FCP_RING_INT)
>   			lpfc_poll_rearm_timer(phba);
>   	}
> @@ -3723,6 +3721,7 @@ struct scsi_host_template lpfc_template = {
>   	.slave_destroy		= lpfc_slave_destroy,
>   	.scan_finished		= lpfc_scan_finished,
>   	.this_id		= -1,
> +	.unlocked_qcmd		= 1,
>   	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
>   	.cmd_per_lun		= LPFC_CMD_PER_LUN,
>   	.use_clustering		= ENABLE_CLUSTERING,
> @@ -3746,6 +3745,7 @@ struct scsi_host_template lpfc_vport_template = {
>   	.slave_destroy		= lpfc_slave_destroy,
>   	.scan_finished		= lpfc_scan_finished,
>   	.this_id		= -1,
> +	.unlocked_qcmd		= 1,
>   	.sg_tablesize		= LPFC_DEFAULT_SG_SEG_CNT,
>   	.cmd_per_lun		= LPFC_CMD_PER_LUN,
>   	.use_clustering		= ENABLE_CLUSTERING,

The FC class sets the rport state and bits with the host lock held. 
Drivers were then calling fc_remote_port_chkready from the queuecommand 
with the host lock held. If we remove the host lock from queuecommand is 
it possible that the on one proc the fc class calls fc_remote_port_add 
to re-add a rport, this sets the rport state to online, it unblocks the 
devices, but then on some other processor we start calling queuecommand 
and see that the rport is not online (maybe blocked with 
FC_RPORT_FAST_FAIL_TIMEDOUT set) and so we end up failing the IO?
