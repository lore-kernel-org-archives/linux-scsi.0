From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 07/12] qla2xxx: Convert to host_lock less w/ interrupts
	disabled externally
Date: Mon, 20 Dec 2010 01:23:53 -0800
Message-ID: <1292837033.20840.39.camel@haakon2.linux-iscsi.org>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
	 <1292793727-31957-8-git-send-email-nab@linux-iscsi.org>
	 <20101219231114.GI1263@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56744 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810Ab0LTJaD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Dec 2010 04:30:03 -0500
In-Reply-To: <20101219231114.GI1263@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Douglas Gilbert <dgilbert@interlog.com>, adam radford <aradford@gmail.com>, Kashyap Desai <Kashyap.Desai@lsi.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>

On Sun, 2010-12-19 at 16:11 -0700, Matthew Wilcox wrote:
> On Sun, Dec 19, 2010 at 01:22:02PM -0800, Nicholas A. Bellinger wrote:
> > This patch converts qla2xxx to run in host_lock less mode with the new
> > IRQ_DISABLE_SCSI_QCMD() that disables interrupts while calling ->queuecommand()
> > dispatch.  It also drops the legacy host_lock unlock optimization.
> 
> I'm not sure this is the right direction to go.  Now that Jeff's done
> the pushdown and put in the compatibility macros, I don't think it makes
> sense to do another partial transition on each driver.  Much better to
> take our time, analyse each driver thoroughly, and kill the DEF_SCSI_QCMD
> in each driver without introducing IRQ_DISABLE_SCSI_QCMD.
> 
> In particular for this driver, it explicitly re-enables interrupts,
> so it's pretty easy to do a full conversion.  Compile-tested only.
> 
> Convert qla2xxx driver to run without the shost lock
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Ok, this patch is functioning with LTP disktest I/O using .37-rc6
initiator side lock_less operation.

This has been added as an incremental patch for lock_less-LLDs-for-38-v3
here:

commit 355798dc3d97a0f07b14d1f3891ecca1802c9094
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Mon Dec 20 01:24:12 2010 -0800

    qla2xxx: Convert qla2xxx driver to run without the shost lock
    
    This patch converts qla2xxx LLD code to run in fully lock-less mode
    and removes IRQ_DISABLE_SCSI_QCMD usage.  This also includes a handful
    of cleanups for cmd->scsi_done assignment removal from qla2x00_get_new_sp()
    and renames one goto of the exception patch with the '_lock' suffix in
    qla2xxx_queuecommand().
    
    So far this patch has been lightly tested with basic I/O functionality on
    bare-metal x86_64 .37-rc6 using ISP-2532 8 Gb/sec HW.
    
    Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
    Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Thanks!

--nab

> 
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 2c0876c..b44d986 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -513,7 +513,7 @@ qla24xx_fw_version_str(struct scsi_qla_host *vha, char *str)
>  
>  static inline srb_t *
>  qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
> -    struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
> +    struct scsi_cmnd *cmd)
>  {
>  	srb_t *sp;
>  	struct qla_hw_data *ha = vha->hw;
> @@ -527,16 +527,15 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
>  	sp->cmd = cmd;
>  	sp->flags = 0;
>  	CMD_SP(cmd) = (void *)sp;
> -	cmd->scsi_done = done;
>  	sp->ctx = NULL;
>  
>  	return sp;
>  }
>  
>  static int
> -qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
> +qla2xxx_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
>  {
> -	scsi_qla_host_t *vha = shost_priv(cmd->device->host);
> +	scsi_qla_host_t *vha = shost_priv(shost);
>  	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
>  	struct fc_rport *rport = starget_to_rport(scsi_target(cmd->device));
>  	struct qla_hw_data *ha = vha->hw;
> @@ -544,7 +543,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)
>  	srb_t *sp;
>  	int rval;
>  
> -	spin_unlock_irq(vha->host->host_lock);
>  	if (ha->flags.eeh_busy) {
>  		if (ha->flags.pci_channel_io_perm_failure)
>  			cmd->result = DID_NO_CONNECT << 16;
> @@ -577,39 +575,32 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)
>  		goto qc24_target_busy;
>  	}
>  
> -	sp = qla2x00_get_new_sp(base_vha, fcport, cmd, done);
> +	sp = qla2x00_get_new_sp(base_vha, fcport, cmd);
>  	if (!sp)
> -		goto qc24_host_busy_lock;
> +		goto qc24_host_busy;
>  
>  	rval = ha->isp_ops->start_scsi(sp);
>  	if (rval != QLA_SUCCESS)
>  		goto qc24_host_busy_free_sp;
>  
> -	spin_lock_irq(vha->host->host_lock);
> -
>  	return 0;
>  
>  qc24_host_busy_free_sp:
>  	qla2x00_sp_free_dma(sp);
>  	mempool_free(sp, ha->srb_mempool);
>  
> -qc24_host_busy_lock:
> -	spin_lock_irq(vha->host->host_lock);
> +qc24_host_busy:
>  	return SCSI_MLQUEUE_HOST_BUSY;
>  
>  qc24_target_busy:
> -	spin_lock_irq(vha->host->host_lock);
>  	return SCSI_MLQUEUE_TARGET_BUSY;
>  
>  qc24_fail_command:
> -	spin_lock_irq(vha->host->host_lock);
> -	done(cmd);
> +	cmd->scsi_done(cmd);
>  
>  	return 0;
>  }
>  
> -static DEF_SCSI_QCMD(qla2xxx_queuecommand)
> -
>  
>  /*
>   * qla2x00_eh_wait_on_command
> 

