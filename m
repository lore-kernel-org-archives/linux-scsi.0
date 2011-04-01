From: Madhu Iyengar <madhu.iyengar@qlogic.com>
Subject: RE: [PATCH 3/3] qla2xxx: Run queuecommand outside the host_lock
Date: Fri, 1 Apr 2011 14:33:08 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA8728A7B1A4F@AVEXMB1.qlogic.org>
References: <20110401202209.GN4183@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:38702 "EHLO
	TX2EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab1DAVdO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Apr 2011 17:33:14 -0400
In-Reply-To: <20110401202209.GN4183@linux.intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Madhu Iyengar <madhu.iyengar@qlogic.com>

Mathew,

We submitted the host_lock related changes earlier, and the changes were accepted and went into the 2.6.38-rc6 (or round-about that timeframe) upstream kernel.

Here's the patch in that sequence we submitted earlier (which is now in the upstream/scsi stream):
http://marc.info/?l=linux-scsi&m=129850384318495&w=2

Cheers,
Madhu

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Matthew Wilcox
> Sent: Friday, April 01, 2011 1:22 PM
> To: linux-scsi@vger.kernel.org
> Subject: [PATCH 3/3] qla2xxx: Run queuecommand outside the host_lock
>
>
> The qla2xxx driver still uses the host_lock, but only to protect against
> some rare events like rport deletion.
>
> Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
>
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index f27724d..61340e1 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -506,7 +506,7 @@ qla24xx_fw_version_str(struct scsi_qla_host *vha, char
> *str)
>
>  static inline srb_t *
>  qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t *fcport,
> -    struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
> +    struct scsi_cmnd *cmd)
>  {
>       srb_t *sp;
>       struct qla_hw_data *ha = vha->hw;
> @@ -520,16 +520,15 @@ qla2x00_get_new_sp(scsi_qla_host_t *vha, fc_port_t
> *fcport,
>       sp->cmd = cmd;
>       sp->flags = 0;
>       CMD_SP(cmd) = (void *)sp;
> -     cmd->scsi_done = done;
>       sp->ctx = NULL;
>
>       return sp;
>  }
>
>  static int
> -qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void (*done)(struct
> scsi_cmnd *))
> +qla2xxx_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
>  {
> -     scsi_qla_host_t *vha = shost_priv(cmd->device->host);
> +     scsi_qla_host_t *vha = shost_priv(shost);
>       fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata;
>       struct fc_rport *rport = starget_to_rport(scsi_target(cmd->device));
>       struct qla_hw_data *ha = vha->hw;
> @@ -537,7 +536,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void
> (*done)(struct scsi_cmnd *)
>       srb_t *sp;
>       int rval;
>
> -     spin_unlock_irq(vha->host->host_lock);
>       if (ha->flags.eeh_busy) {
>               if (ha->flags.pci_channel_io_perm_failure)
>                       cmd->result = DID_NO_CONNECT << 16;
> @@ -569,7 +567,7 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void
> (*done)(struct scsi_cmnd *)
>               goto qc24_target_busy;
>       }
>
> -     sp = qla2x00_get_new_sp(base_vha, fcport, cmd, done);
> +     sp = qla2x00_get_new_sp(base_vha, fcport, cmd);
>       if (!sp)
>               goto qc24_host_busy_lock;
>
> @@ -577,8 +575,6 @@ qla2xxx_queuecommand_lck(struct scsi_cmnd *cmd, void
> (*done)(struct scsi_cmnd *)
>       if (rval != QLA_SUCCESS)
>               goto qc24_host_busy_free_sp;
>
> -     spin_lock_irq(vha->host->host_lock);
> -
>       return 0;
>
>  qc24_host_busy_free_sp:
> @@ -586,23 +582,17 @@ qc24_host_busy_free_sp:
>       mempool_free(sp, ha->srb_mempool);
>
>  qc24_host_busy_lock:
> -     spin_lock_irq(vha->host->host_lock);
>       return SCSI_MLQUEUE_HOST_BUSY;
>
>  qc24_target_busy:
> -     spin_lock_irq(vha->host->host_lock);
>       return SCSI_MLQUEUE_TARGET_BUSY;
>
>  qc24_fail_command:
> -     spin_lock_irq(vha->host->host_lock);
> -     done(cmd);
> +     cmd->scsi_done(cmd);
>
>       return 0;
>  }
>
> -static DEF_SCSI_QCMD(qla2xxx_queuecommand)
> -
> -
>  /*
>   * qla2x00_eh_wait_on_command
>   *    Waits for the command to be returned by the Firmware for some
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

