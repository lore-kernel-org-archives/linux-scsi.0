From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] scsi: qla2xxx: Off by one in qlt_ctio_to_cmd()
Date: Tue, 11 Jul 2017 02:14:12 -0700
Message-ID: <1499764452.28145.49.camel@haakon3.daterainc.com>
References: <20170710084739.tjj7juaex7cb7xs5@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:44769 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752386AbdGKJON (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2017 05:14:13 -0400
In-Reply-To: <20170710084739.tjj7juaex7cb7xs5@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: qla2xxx-upstream@qlogic.com, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org

On Mon, 2017-07-10 at 11:47 +0300, Dan Carpenter wrote:
> There are "req->num_outstanding_cmds" elements in the
> req->outstanding_cmds[] array so the > here should be >=.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 6e4794367e0b..ecd1a95511f9 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -3728,7 +3728,7 @@ static struct qla_tgt_cmd *qlt_ctio_to_cmd(struct scsi_qla_host *vha,
>  	h &= QLA_CMD_HANDLE_MASK;
>  
>  	if (h != QLA_TGT_NULL_HANDLE) {
> -		if (unlikely(h > req->num_outstanding_cmds)) {
> +		if (unlikely(h >= req->num_outstanding_cmds)) {
>  			ql_dbg(ql_dbg_tgt, vha, 0xe052,
>  			    "qla_target(%d): Wrong handle %x received\n",
>  			    vha->vp_idx, handle);

Nice catch.

Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>
