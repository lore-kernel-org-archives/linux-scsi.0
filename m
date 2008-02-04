From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: RE: [PATCH 02/12] qla4xxx: have qla4xxx directly call iscsi recovery functions
Date: Mon, 4 Feb 2008 10:21:38 -0800
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC070120BF1E@AVEXCH1.qlogic.org>
References: <1201808215968-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:5655 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753988AbYBDSVj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 13:21:39 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1201808215968-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org

 

Mike Christie wrote:
> 
> Qla4xxx can just call the iscsi recovery functions directly.
> There is no need for userspace to do this for qla4xxx, because
> we do not use the mutex to iterate over devices anymore and 
> iscsi_block
> /unblock_session can be called from interrupt context or the 
> dpc thread.
> And having userspace do this just creates uneeded headaches 
> for qla4xxx root
> situations where the session may experience problems. For example
> during the kernel shutdown the scsi layer wants to send sync 
> caches, but at
> this time userspace is not up (iscsid is not running), so we cannot
> recover from the problem.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/qla4xxx/ql4_init.c |    1 +
>  drivers/scsi/qla4xxx/ql4_os.c   |   40 
> +++-----------------------------------
>  2 files changed, 5 insertions(+), 36 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_init.c 
> b/drivers/scsi/qla4xxx/ql4_init.c
> index cbe0a17..03e66cb 100644
> --- a/drivers/scsi/qla4xxx/ql4_init.c
> +++ b/drivers/scsi/qla4xxx/ql4_init.c
> @@ -1306,6 +1306,7 @@ int qla4xxx_process_ddb_changed(struct 
> scsi_qla_host *ha,
>  		atomic_set(&ddb_entry->relogin_timer, 0);
>  		clear_bit(DF_RELOGIN, &ddb_entry->flags);
>  		clear_bit(DF_NO_RELOGIN, &ddb_entry->flags);
> +		iscsi_unblock_session(ddb_entry->sess);
>  		iscsi_session_event(ddb_entry->sess,
>  				    ISCSI_KEVENT_CREATE_SESSION);
>  		/*
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c 
> b/drivers/scsi/qla4xxx/ql4_os.c
> index 2e2b9fe..a87fb9f 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -63,8 +63,6 @@ static int qla4xxx_sess_get_param(struct 
> iscsi_cls_session *sess,
>  				  enum iscsi_param param, char *buf);
>  static int qla4xxx_host_get_param(struct Scsi_Host *shost,
>  				  enum iscsi_host_param param, 
> char *buf);
> -static void qla4xxx_conn_stop(struct iscsi_cls_conn *conn, int flag);
> -static int qla4xxx_conn_start(struct iscsi_cls_conn *conn);
>  static void qla4xxx_recovery_timedout(struct 
> iscsi_cls_session *session);
>  
>  /*
> @@ -116,8 +114,6 @@ static struct iscsi_transport 
> qla4xxx_iscsi_transport = {
>  	.get_conn_param		= qla4xxx_conn_get_param,
>  	.get_session_param	= qla4xxx_sess_get_param,
>  	.get_host_param		= qla4xxx_host_get_param,
> -	.start_conn		= qla4xxx_conn_start,
> -	.stop_conn		= qla4xxx_conn_stop,
>  	.session_recovery_timedout = qla4xxx_recovery_timedout,
>  };
>  
> @@ -140,38 +136,6 @@ static void 
> qla4xxx_recovery_timedout(struct iscsi_cls_session *session)
>  	queue_work(ha->dpc_thread, &ha->dpc_work);
>  }
>  
> -static int qla4xxx_conn_start(struct iscsi_cls_conn *conn)
> -{
> -	struct iscsi_cls_session *session;
> -	struct ddb_entry *ddb_entry;
> -
> -	session = iscsi_dev_to_session(conn->dev.parent);
> -	ddb_entry = session->dd_data;
> -
> -	DEBUG2(printk("scsi%ld: %s: index [%d] starting conn\n",
> -		      ddb_entry->ha->host_no, __func__,
> -		      ddb_entry->fw_ddb_index));
> -	iscsi_unblock_session(session);
> -	return 0;
> -}
> -
> -static void qla4xxx_conn_stop(struct iscsi_cls_conn *conn, int flag)
> -{
> -	struct iscsi_cls_session *session;
> -	struct ddb_entry *ddb_entry;
> -
> -	session = iscsi_dev_to_session(conn->dev.parent);
> -	ddb_entry = session->dd_data;
> -
> -	DEBUG2(printk("scsi%ld: %s: index [%d] stopping conn\n",
> -		      ddb_entry->ha->host_no, __func__,
> -		      ddb_entry->fw_ddb_index));
> -	if (flag == STOP_CONN_RECOVER)
> -		iscsi_block_session(session);
> -	else
> -		printk(KERN_ERR "iscsi: invalid stop flag %d\n", flag);
> -}
> -
>  static int qla4xxx_host_get_param(struct Scsi_Host *shost,
>  				  enum iscsi_host_param param, 
> char *buf)
>  {
> @@ -308,6 +272,9 @@ int qla4xxx_add_sess(struct ddb_entry *ddb_entry)
>  		DEBUG2(printk(KERN_ERR "Could not add connection.\n"));
>  		return -ENOMEM;
>  	}
> +
> +	/* finally ready to go */
> +	iscsi_unblock_session(ddb_entry->sess);
>  	return 0;
>  }
>  
> @@ -364,6 +331,7 @@ void qla4xxx_mark_device_missing(struct 
> scsi_qla_host *ha,
>  	DEBUG3(printk("scsi%d:%d:%d: index [%d] marked MISSING\n",
>  		      ha->host_no, ddb_entry->bus, ddb_entry->target,
>  		      ddb_entry->fw_ddb_index));
> +	iscsi_block_session(ddb_entry->sess);
>  	iscsi_conn_error(ddb_entry->conn, ISCSI_ERR_CONN_FAILED);
>  }
Acked by David Somayajulu <david.somayajulu@qlogic.com>
 
