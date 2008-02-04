From: "David Somayajulu" <david.somayajulu@qlogic.com>
Subject: RE: [PATCH 03/12] qla4xxx: have qla4xxx use iscsi class session state check ready
Date: Mon, 4 Feb 2008 10:19:49 -0800
Message-ID: <0BB3E5E7462EEA4295BC02D49691DC070120BF1C@AVEXCH1.qlogic.org>
References: <1201808215955-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:5152 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbYBDSTu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 13:19:50 -0500
Content-class: urn:content-classes:message
In-Reply-To: <1201808215955-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org


Mike Christie wrote :
> This has qla4xxx use the iscsi class's check ready function
> in the queue command function, so all iscsi drivers return the
> same error value for common problems.
> 
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> ---
>  drivers/scsi/qla4xxx/ql4_os.c |   12 ++++++++++++
>  1 files changed, 12 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/qla4xxx/ql4_os.c 
> b/drivers/scsi/qla4xxx/ql4_os.c
> index a87fb9f..437d169 100644
> --- a/drivers/scsi/qla4xxx/ql4_os.c
> +++ b/drivers/scsi/qla4xxx/ql4_os.c
> @@ -398,9 +398,21 @@ static int qla4xxx_queuecommand(struct 
> scsi_cmnd *cmd,
>  {
>  	struct scsi_qla_host *ha = to_qla_host(cmd->device->host);
>  	struct ddb_entry *ddb_entry = cmd->device->hostdata;
> +	struct iscsi_cls_session *sess = ddb_entry->sess;
>  	struct srb *srb;
>  	int rval;
>  
> +	if (!sess) {
> +		cmd->result = DID_IMM_RETRY << 16;
> +		goto qc_fail_command;
> +	}
> +
> +	rval = iscsi_session_chkready(sess);
> +	if (rval) {
> +		cmd->result = rval;
> +		goto qc_fail_command;
> +	}
> +
>  	if (atomic_read(&ddb_entry->state) != DDB_STATE_ONLINE) {
>  		if (atomic_read(&ddb_entry->state) == DDB_STATE_DEAD) {
>  			cmd->result = DID_NO_CONNECT << 16;
> -- 
> 1.5.2.1
Acked by David Somayajulu <david.somayajulu@qlogic.com>
