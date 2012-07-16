From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 4/7] target: Allow for target_submit_cmd() returning
 errors
Date: Mon, 16 Jul 2012 16:00:05 -0700
Message-ID: <1342479605.18004.302.camel@haakon2.linux-iscsi.org>
References: <1342461882-5848-1-git-send-email-roland@kernel.org>
	 <1342461882-5848-5-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1342461882-5848-5-git-send-email-roland@kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>, Arun Easi <arun.easi@qlogic.com>, Chris Boot <bootc@bootc.net>, Stefan Richter <stefanr@s5r6.in-berlin.de>, Mark Rustad <mark.d.rustad@intel.com>, "Signed-off-by: Sebastian Andrzej Siewior" <bigeasy@linutronix.de>, Felipe Balbi <balbi@ti.com>, Andy Grover <agrover@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2012-07-16 at 11:04 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> We want it to be possible for target_submit_cmd() to return errors up
> to its fabric module callers.  For now just update the prototype to
> return an int, and update all callers to handle non-zero return values
> as an error.
> 

Mmmm.  The original target_submit_cmd() code had been propagating up a
return value, but then we decided (via Agrover's patch) that it made
more sense for target_submit_cmd() to always handle exceptions via
normal TFO callbacks, and not have the fabric worry about the return
here..

Also, I'm not sure if the error paths that this patch now accesses after
target_submit_cmd() failure are going to deal with different types of
target_submit_cmd() failures correctly.

So NACK for the moment, as I don't really see why this is necessary in
the first place..?

> Cc: Chad Dupuis <chad.dupuis@qlogic.com>
> Cc: Arun Easi <arun.easi@qlogic.com>
> Cc: Chris Boot <bootc@bootc.net>
> Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: Mark Rustad <mark.d.rustad@intel.com>
> Cc: Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: Felipe Balbi <balbi@ti.com>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    7 +++----
>  drivers/target/sbp/sbp_target.c        |    8 +++++---
>  drivers/target/target_core_transport.c |    9 +++++----
>  drivers/target/tcm_fc/tfc_cmd.c        |    8 +++++---
>  drivers/usb/gadget/tcm_usb_gadget.c    |   20 ++++++++------------
>  include/target/target_core_fabric.h    |    2 +-
>  6 files changed, 27 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 3cb2b97..7db7ca7 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -599,10 +599,9 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
>  		return -EINVAL;
>  	}
>  
> -	target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
> -				cmd->unpacked_lun, data_length, fcp_task_attr,
> -				data_dir, flags);
> -	return 0;
> +	return target_submit_cmd(se_cmd, se_sess, cdb, &cmd->sense_buffer[0],
> +				 cmd->unpacked_lun, data_length, fcp_task_attr,
> +				 data_dir, flags);
>  }
>  
>  static void tcm_qla2xxx_do_rsp(struct work_struct *work)
> diff --git a/drivers/target/sbp/sbp_target.c b/drivers/target/sbp/sbp_target.c
> index 2425ca4..fb75d05 100644
> --- a/drivers/target/sbp/sbp_target.c
> +++ b/drivers/target/sbp/sbp_target.c
> @@ -1235,9 +1235,11 @@ static void sbp_handle_command(struct sbp_target_request *req)
>  	pr_debug("sbp_handle_command ORB:0x%llx unpacked_lun:%d data_len:%d data_dir:%d\n",
>  			req->orb_pointer, unpacked_lun, data_length, data_dir);
>  
> -	target_submit_cmd(&req->se_cmd, sess->se_sess, req->cmd_buf,
> -			req->sense_buf, unpacked_lun, data_length,
> -			MSG_SIMPLE_TAG, data_dir, 0);
> +	if (target_submit_cmd(&req->se_cmd, sess->se_sess, req->cmd_buf,
> +			      req->sense_buf, unpacked_lun, data_length,
> +			      MSG_SIMPLE_TAG, data_dir, 0))
> +		goto err;
> +
>  	return;
>  
>  err:
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 82e40e1..34ca821 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1544,7 +1544,7 @@ EXPORT_SYMBOL(transport_handle_cdb_direct);
>   * This may only be called from process context, and also currently
>   * assumes internal allocation of fabric payload buffer by target-core.
>   **/
> -void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
> +int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
>  		unsigned char *cdb, unsigned char *sense, u32 unpacked_lun,
>  		u32 data_length, int task_attr, int data_dir, int flags)
>  {
> @@ -1583,7 +1583,7 @@ void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
>  		transport_send_check_condition_and_sense(se_cmd,
>  				se_cmd->scsi_sense_reason, 0);
>  		target_put_sess_cmd(se_sess, se_cmd);
> -		return;
> +		return 0;
>  	}
>  	/*
>  	 * Sanitize CDBs via transport_generic_cmd_sequencer() and
> @@ -1592,7 +1592,7 @@ void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
>  	rc = target_setup_cmd_from_cdb(se_cmd, cdb);
>  	if (rc != 0) {
>  		transport_generic_request_failure(se_cmd);
> -		return;
> +		return 0;
>  	}
>  
>  	/*
> @@ -1608,7 +1608,8 @@ void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
>  	 * when fabric has filled the incoming buffer.
>  	 */
>  	transport_handle_cdb_direct(se_cmd);
> -	return;
> +
> +	return 0;
>  }
>  EXPORT_SYMBOL(target_submit_cmd);
>  
> diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
> index f03fb97..c7c90aa 100644
> --- a/drivers/target/tcm_fc/tfc_cmd.c
> +++ b/drivers/target/tcm_fc/tfc_cmd.c
> @@ -541,9 +541,11 @@ static void ft_send_work(struct work_struct *work)
>  	 * Use a single se_cmd->cmd_kref as we expect to release se_cmd
>  	 * directly from ft_check_stop_free callback in response path.
>  	 */
> -	target_submit_cmd(&cmd->se_cmd, cmd->sess->se_sess, fcp->fc_cdb,
> -			&cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
> -			ntohl(fcp->fc_dl), task_attr, data_dir, 0);
> +	if (target_submit_cmd(&cmd->se_cmd, cmd->sess->se_sess, fcp->fc_cdb,
> +			      &cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
> +			      ntohl(fcp->fc_dl), task_attr, data_dir, 0))
> +		goto err;
> +
>  	pr_debug("r_ctl %x alloc target_submit_cmd\n", fh->fh_r_ctl);
>  	return;
>  
> diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
> index c46439c..53aafd2 100644
> --- a/drivers/usb/gadget/tcm_usb_gadget.c
> +++ b/drivers/usb/gadget/tcm_usb_gadget.c
> @@ -1060,7 +1060,10 @@ static void usbg_cmd_work(struct work_struct *work)
>  	tpg = cmd->fu->tpg;
>  	tv_nexus = tpg->tpg_nexus;
>  	dir = get_cmd_dir(cmd->cmd_buf);
> -	if (dir < 0) {
> +	if (dir < 0 ||
> +	    target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
> +			      cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
> +			      0, cmd->prio_attr, dir, TARGET_SCF_UNKNOWN_SIZE)) {
>  		transport_init_se_cmd(se_cmd,
>  				tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
>  				tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
> @@ -1069,12 +1072,7 @@ static void usbg_cmd_work(struct work_struct *work)
>  		transport_send_check_condition_and_sense(se_cmd,
>  				TCM_UNSUPPORTED_SCSI_OPCODE, 1);
>  		usbg_cleanup_cmd(cmd);
> -		return;
>  	}
> -
> -	target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
> -			cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
> -			0, cmd->prio_attr, dir, TARGET_SCF_UNKNOWN_SIZE);
>  }
>  
>  static int usbg_submit_command(struct f_uas *fu,
> @@ -1172,7 +1170,10 @@ static void bot_cmd_work(struct work_struct *work)
>  	tpg = cmd->fu->tpg;
>  	tv_nexus = tpg->tpg_nexus;
>  	dir = get_cmd_dir(cmd->cmd_buf);
> -	if (dir < 0) {
> +	if (dir < 0 ||
> +	    target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
> +			      cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
> +			      cmd->data_len, cmd->prio_attr, dir, 0)) {
>  		transport_init_se_cmd(se_cmd,
>  				tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
>  				tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
> @@ -1181,12 +1182,7 @@ static void bot_cmd_work(struct work_struct *work)
>  		transport_send_check_condition_and_sense(se_cmd,
>  				TCM_UNSUPPORTED_SCSI_OPCODE, 1);
>  		usbg_cleanup_cmd(cmd);
> -		return;
>  	}
> -
> -	target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
> -			cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
> -			cmd->data_len, cmd->prio_attr, dir, 0);
>  }
>  
>  static int bot_submit_command(struct f_uas *fu,
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index 1e68882..4f8e515 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -108,7 +108,7 @@ void	transport_init_se_cmd(struct se_cmd *, struct target_core_fabric_ops *,
>  		struct se_session *, u32, int, int, unsigned char *);
>  int	transport_lookup_cmd_lun(struct se_cmd *, u32);
>  int	target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
> -void	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
> +int	target_submit_cmd(struct se_cmd *, struct se_session *, unsigned char *,
>  		unsigned char *, u32, u32, int, int, int);
>  int	target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
>  		unsigned char *sense, u32 unpacked_lun,
