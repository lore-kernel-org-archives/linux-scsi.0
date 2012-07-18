From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Allow for target_submit_cmd() returning errors
Date: Tue, 17 Jul 2012 17:05:48 -0700
Message-ID: <1342569948.18004.541.camel@haakon2.linux-iscsi.org>
References: <1342568261-15616-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41064 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab2GRAFv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2012 20:05:51 -0400
In-Reply-To: <1342568261-15616-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Felipe Balbi <balbi@ti.com>, Andy Grover <agrover@redhat.com>, linux-usb <linux-usb@vger.kernel.org>

On Tue, 2012-07-17 at 23:37 +0000, Nicholas A. Bellinger wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> We want it to be possible for target_submit_cmd() to return errors up
> to its fabric module callers.  For now just update the prototype to
> return an int, and update all callers to handle non-zero return values
> as an error.
> 
> This is immediately useful for tcm_qla2xxx to fix a long-standing active
> I/O session shutdown race, but tcm_fc, usb-gadget, and sbp-target the
> fabric maintainers need to check + ACK that handling a target_submit_cmd()
> failure due to session shutdown does not introduce regressions
> 
> (nab: Respin against for-next after initial NACK + update docbook comment)
> 

<SNIP> + trimming CC to USB folks:

> index 02ace18..9ddf315 100644
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

Looking at this part again target_submit_cmd() has been moved ahead of
target_init_se_cmd() in the exception path, which ends up getting called
twice during a target_get_sess_cmd() failure..

It looks like usbg_cmd_work() + bot_cmd_work() will need some work if
they intends to use a non zero failure to signal exception here, without
invoking a CHECK_CONDITION and sense.  Actually, I'm not even sure
sending a CHECK_CONDITION here after the target_submit_cmd() is going to
work for other fabrics drivers, but it appears to work with usb-gadget.
(Sebastian..?)

So for the moment, lets fix the double se_cmd init and make things a
little easier to read..   Sebastian, please have a look and double check
that the (dir < 0) + target_submit_cmd() failures cases are both going
to work as expected whilst sending a CHECK_CONDITION response.

Thanks!

--nab

diff --git a/drivers/usb/gadget/tcm_usb_gadget.c b/drivers/usb/gadget/tcm_usb_gadget.c
index 9ddf315..5444866 100644
--- a/drivers/usb/gadget/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/tcm_usb_gadget.c
@@ -1060,19 +1060,25 @@ static void usbg_cmd_work(struct work_struct *work)
        tpg = cmd->fu->tpg;
        tv_nexus = tpg->tpg_nexus;
        dir = get_cmd_dir(cmd->cmd_buf);
-       if (dir < 0 ||
-           target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
-                             cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
-                             0, cmd->prio_attr, dir, TARGET_SCF_UNKNOWN_SIZE)) {
+       if (dir < 0) {
                transport_init_se_cmd(se_cmd,
                                tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
                                tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
                                cmd->prio_attr, cmd->sense_iu.sense);
-
-               transport_send_check_condition_and_sense(se_cmd,
-                               TCM_UNSUPPORTED_SCSI_OPCODE, 1);
-               usbg_cleanup_cmd(cmd);
+               goto out;
        }
+
+       if (target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
+                       cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
+                       0, cmd->prio_attr, dir, TARGET_SCF_UNKNOWN_SIZE) < 0)
+               goto out;
+
+       return;
+
+out:
+       transport_send_check_condition_and_sense(se_cmd,
+                       TCM_UNSUPPORTED_SCSI_OPCODE, 1);
+       usbg_cleanup_cmd(cmd);
 }
 
 static int usbg_submit_command(struct f_uas *fu,
@@ -1170,19 +1176,25 @@ static void bot_cmd_work(struct work_struct *work)
        tpg = cmd->fu->tpg;
        tv_nexus = tpg->tpg_nexus;
        dir = get_cmd_dir(cmd->cmd_buf);
-       if (dir < 0 ||
-           target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
-                             cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
-                             cmd->data_len, cmd->prio_attr, dir, 0)) {
+       if (dir < 0) {
                transport_init_se_cmd(se_cmd,
                                tv_nexus->tvn_se_sess->se_tpg->se_tpg_tfo,
                                tv_nexus->tvn_se_sess, cmd->data_len, DMA_NONE,
                                cmd->prio_attr, cmd->sense_iu.sense);
+               goto out;
+       }
+
+       if (target_submit_cmd(se_cmd, tv_nexus->tvn_se_sess,
+                       cmd->cmd_buf, cmd->sense_iu.sense, cmd->unpacked_lun,
+                       cmd->data_len, cmd->prio_attr, dir, 0) < 0)
+               goto out;
+
+       return;
 
-               transport_send_check_condition_and_sense(se_cmd,
+out:
+       transport_send_check_condition_and_sense(se_cmd,
                                TCM_UNSUPPORTED_SCSI_OPCODE, 1);
-               usbg_cleanup_cmd(cmd);
-       }
+       usbg_cleanup_cmd(cmd);
 }
 
 static int bot_submit_command(struct f_uas *fu,


