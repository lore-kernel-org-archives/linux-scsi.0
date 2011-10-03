From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 09/13] qla4xxx: Fixed device blocked issue on link up-down.
Date: Mon, 03 Oct 2011 16:01:30 -0500
Message-ID: <4E8A22AA.70500@cs.wisc.edu>
References: <1317662967-30110-1-git-send-email-vikas.chaudhary@qlogic.com> <1317662967-30110-10-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:34342 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756961Ab1JCU4U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Oct 2011 16:56:20 -0400
In-Reply-To: <1317662967-30110-10-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vikas.chaudhary@qlogic.com
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, lalit.chandivade@qlogic.com, ravi.anand@qlogic.com, Manish Rangankar <manish.rangankar@qlogic.com>

On 10/03/2011 12:29 PM, vikas.chaudhary@qlogic.com wrote:
> From: Manish Rangankar <manish.rangankar@qlogic.com>
> 
> Devices are getting blocked during continuous link up and down. Solution is,
> during relogin unblock the session before sending connection logged in event.
> 
> JIRA Key: UPSISCSI-138
> 
> Signed-off-by: Manish Rangankar <manish.rangankar@qlogic.com>
> Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> ---
>  drivers/scsi/qla4xxx/ql4_init.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
> index cc10bac..e07d99b 100644
> --- a/drivers/scsi/qla4xxx/ql4_init.c
> +++ b/drivers/scsi/qla4xxx/ql4_init.c
> @@ -900,6 +900,7 @@ int qla4xxx_process_ddb_changed(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
>  		switch (state) {
>  		case DDB_DS_SESSION_ACTIVE:
>  		case DDB_DS_DISCOVERY:
> +			iscsi_unblock_session(ddb_entry->sess);

Shouldn't this alreadu get done when start_conn callback is called?

Is the problem that start_conn is getting called when login is started
and not when we are actually logged in (when we get the logged in event
below)?

The start_conn callback use looks wrong right now for qla4xxx.
user/initiator.c:setup_offload_login_phase() will call it when we are
only in_login. It should only be called when we are logged_in, because
it will unlbock the devices, update the iscsi session state and could
start IO before the driver is ready.


>  			iscsi_conn_login_event(ddb_entry->conn,
>  					       ISCSI_CONN_STATE_LOGGED_IN);
>  			qla4xxx_update_session_conn_param(ha, ddb_entry);

