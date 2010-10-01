From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] qla2xxx: Drop srb reference before waiting for completion
Date: Fri, 01 Oct 2010 16:01:41 -0500
Message-ID: <4CA64C35.6010506@cs.wisc.edu>
References: <20101001121844.4ABF3353A8@ochil.suse.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010404030502080300050601"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:46907 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab0JAUzf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Oct 2010 16:55:35 -0400
In-Reply-To: <20101001121844.4ABF3353A8@ochil.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------010404030502080300050601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/01/2010 07:18 AM, Hannes Reinecke wrote:
>
> This patch fixes a regression introduced by commit
> 083a469db4ecf3b286a96b5b722c37fc1affe0be
>
> qla2xxx_eh_wait_on_command() is waiting for an srb to
> complete, which will never happen as the routine took
> a reference to the srb previously and will only drop it
> after this function. So every command abort will fail.
>
> Signed-off-by: Hannes Reinecke<hare@suse.de>
> Cc: Andrew Vasquez<andrew.vasquez@qlogic.com>
>
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 1e4bff6..0af7549 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -883,6 +883,9 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
>   	}
>   	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>
> +	if (got_ref)
> +		qla2x00_sp_compl(ha, sp);
> +

You can just get rid of got_ref, because if you just move the compl call 
up a little more you know that in that code path we always get a ref. 
And there is no need to hold the ref to where it is above.  See attached 
patch.

We did something similar for qla4xxx. Looks like qla4xxx has a race when 
it checks the CMD_SP validity and grabs a ref, but that is different story.

--------------010404030502080300050601
Content-Type: text/plain;
 name="qla2xxx-rm-got-ref.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="qla2xxx-rm-got-ref.patch"

diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index bdd53f0..6ea314f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -832,7 +832,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 	struct qla_hw_data *ha = vha->hw;
 	struct req_que *req = vha->req;
 	srb_t *spt;
-	int got_ref = 0;
 
 	fc_block_scsi_eh(cmd);
 
@@ -866,7 +865,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 
 		/* Get a reference to the sp and drop the lock.*/
 		sp_get(sp);
-		got_ref++;
 
 		spin_unlock_irqrestore(&ha->hardware_lock, flags);
 		if (ha->isp_ops->abort_command(sp)) {
@@ -879,6 +877,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 			wait = 1;
 		}
 		spin_lock_irqsave(&ha->hardware_lock, flags);
+		qla2x00_sp_compl(ha, sp);
 		break;
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
@@ -893,9 +892,6 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
 		}
 	}
 
-	if (got_ref)
-		qla2x00_sp_compl(ha, sp);
-
 	qla_printk(KERN_INFO, ha,
 	    "scsi(%ld:%d:%d): Abort command issued -- %d %lx %x.\n",
 	    vha->host_no, id, lun, wait, serial, ret);
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index acfc7d9..7921d76 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -470,7 +470,6 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
 	struct Scsi_Host *shost;
 	struct iscsi_cls_host *ihost;
 	unsigned long flags;
-	unsigned int id;
 
 	if (!iscsi_is_session_dev(dev))
 		return 0;
@@ -488,15 +487,14 @@ static int iscsi_user_scan_session(struct device *dev, void *data)
 		spin_unlock_irqrestore(&session->lock, flags);
 		goto user_scan_exit;
 	}
-	id = session->target_id;
 	spin_unlock_irqrestore(&session->lock, flags);
 
-	if (id != ISCSI_MAX_TARGET) {
+	if (session->target_id != ISCSI_MAX_TARGET) {
 		if ((scan_data->channel == SCAN_WILD_CARD ||
 		     scan_data->channel == 0) &&
 		    (scan_data->id == SCAN_WILD_CARD ||
-		     scan_data->id == id))
-			scsi_scan_target(&session->dev, 0, id,
+		     scan_data->id == session->target_id))
+			scsi_scan_target(&session->dev, 0, session->target_id,
 					 scan_data->lun, 1);
 	}
 
@@ -642,6 +640,7 @@ static void __iscsi_unblock_session(struct work_struct *work)
 void iscsi_unblock_session(struct iscsi_cls_session *session)
 {
 	queue_work(iscsi_eh_timer_workq, &session->unblock_work);
+	flush_work(&session->unblock_work);
 }
 EXPORT_SYMBOL_GPL(iscsi_unblock_session);
 
@@ -662,6 +661,10 @@ static void __iscsi_block_session(struct work_struct *work)
 		queue_delayed_work(iscsi_eh_timer_workq,
 				   &session->recovery_work,
 				   session->recovery_tmo * HZ);
+
+	queue_delayed_work(iscsi_eh_timer_workq,
+			   &session->dev_loss_work,
+			   session->recovery_tmo * HZ);
 }
 
 void iscsi_block_session(struct iscsi_cls_session *session)
@@ -1383,6 +1386,10 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 		sscanf(data, "%d", &value);
 		session->recovery_tmo = value;
 		break;
+	case ISCSI_PARAM_SESS_DEV_LOSS_TMO:
+		sscanf(data, "%d", &value);
+		session->dev_loss_tmo = value;
+		break;
 	default:
 		err = transport->set_param(conn, ev->u.set_param.param,
 					   data, ev->u.set_param.len);
@@ -1849,6 +1856,7 @@ static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO | S_IWUGO,		\
 			show_priv_session_##field,			\
 			store_priv_session_##field)
 iscsi_priv_session_rw_attr(recovery_tmo, "%d");
+iscsi_priv_session_rw_attr(dev_loss_tmo, "%d");
 
 /*
  * iSCSI host attrs
@@ -2071,6 +2079,7 @@ iscsi_register_transport(struct iscsi_transport *tt)
 	SETUP_SESSION_RD_ATTR(ifacename, ISCSI_IFACE_NAME);
 	SETUP_SESSION_RD_ATTR(initiatorname, ISCSI_INITIATOR_NAME);
 	SETUP_SESSION_RD_ATTR(targetalias, ISCSI_TARGET_ALIAS);
+	SETUP_PRIV_SESSION_RW_ATTR(dev_loss_tmo);
 	SETUP_PRIV_SESSION_RW_ATTR(recovery_tmo);
 	SETUP_PRIV_SESSION_RD_ATTR(state);
 

--------------010404030502080300050601--
