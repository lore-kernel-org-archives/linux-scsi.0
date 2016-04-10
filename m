From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 01/16] iscsi-target: add callback to alloc and free PDU
Date: Sun, 10 Apr 2016 20:33:53 +0300
Message-ID: <570A8E81.8010007@grimberg.me>
References: <cover.1460204441.git.varun@chelsio.com>
 <674e8ae2dae3d6274dcb1abe6ddef253f6a71256.1460204441.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32956 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbcDJRd5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Apr 2016 13:33:57 -0400
In-Reply-To: <674e8ae2dae3d6274dcb1abe6ddef253f6a71256.1460204441.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com



On 09/04/16 16:11, Varun Prakash wrote:
> Add two callbacks to struct iscsit_transport -
>
> 1. void *(*iscsit_alloc_pdu)()
>     iscsi-target uses this callback for
>     iSCSI PDU allocation.
>
> 2. void (*iscsit_free_pdu)
>     iscsi-target uses this callback
>     to free an iSCSI PDU which was
>     allocated by iscsit_alloc_pdu().

Can you please explain why are you adding two different
callouts? Who (Chelsio T5) will need it, and why they can't
use the in-cmd pdu?

>
> Signed-off-by: Varun Prakash <varun@chelsio.com>
> ---
>   drivers/target/iscsi/iscsi_target.c    | 76 ++++++++++++++++++++++++++++------
>   include/target/iscsi/iscsi_transport.h |  2 +
>   2 files changed, 65 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 961202f..fdb33ba 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -499,6 +499,11 @@ static void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
>   	__iscsit_free_cmd(cmd, scsi_cmd, true);
>   }
>
> +static void *iscsit_alloc_pdu(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
> +{
> +	return cmd->pdu;
> +}
> +
>   static enum target_prot_op iscsit_get_sup_prot_ops(struct iscsi_conn *conn)
>   {
>   	return TARGET_PROT_NORMAL;
> @@ -519,6 +524,7 @@ static struct iscsit_transport iscsi_target_transport = {
>   	.iscsit_queue_data_in	= iscsit_queue_rsp,
>   	.iscsit_queue_status	= iscsit_queue_rsp,
>   	.iscsit_aborted_task	= iscsit_aborted_task,
> +	.iscsit_alloc_pdu	= iscsit_alloc_pdu,
>   	.iscsit_get_sup_prot_ops = iscsit_get_sup_prot_ops,
>   };
>
> @@ -2537,7 +2543,10 @@ static int iscsit_send_conn_drop_async_message(
>   	cmd->tx_size = ISCSI_HDR_LEN;
>   	cmd->iscsi_opcode = ISCSI_OP_ASYNC_EVENT;
>
> -	hdr			= (struct iscsi_async *) cmd->pdu;
> +	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
> +	if (unlikely(!hdr))
> +		return -ENOMEM;
> +
>   	hdr->opcode		= ISCSI_OP_ASYNC_EVENT;
>   	hdr->flags		= ISCSI_FLAG_CMD_FINAL;
>   	cmd->init_task_tag	= RESERVED_ITT;
> @@ -2630,7 +2639,7 @@ iscsit_build_datain_pdu(struct iscsi_cmd *cmd, struct iscsi_conn *conn,
>
>   static int iscsit_send_datain(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
>   {
> -	struct iscsi_data_rsp *hdr = (struct iscsi_data_rsp *)&cmd->pdu[0];
> +	struct iscsi_data_rsp *hdr;
>   	struct iscsi_datain datain;
>   	struct iscsi_datain_req *dr;
>   	struct kvec *iov;
> @@ -2675,6 +2684,10 @@ static int iscsit_send_datain(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
>   			set_statsn = true;
>   	}
>
> +	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
> +	if (unlikely(!hdr))
> +		return -ENOMEM;
> +
>   	iscsit_build_datain_pdu(cmd, conn, &datain, hdr, set_statsn);
>
>   	iov = &cmd->iov_data[0];
> @@ -2843,13 +2856,20 @@ EXPORT_SYMBOL(iscsit_build_logout_rsp);
>   static int
>   iscsit_send_logout(struct iscsi_cmd *cmd, struct iscsi_conn *conn)
>   {
> +	struct iscsi_logout_rsp *hdr;
>   	struct kvec *iov;
>   	int niov = 0, tx_size, rc;
>
> -	rc = iscsit_build_logout_rsp(cmd, conn,
> -			(struct iscsi_logout_rsp *)&cmd->pdu[0]);
> -	if (rc < 0)
> +	hdr = conn->conn_transport->iscsit_alloc_pdu(conn, cmd);
> +	if (unlikely(!hdr))
> +		return -ENOMEM;
> +
> +	rc = iscsit_build_logout_rsp(cmd, conn, hdr);
> +	if (rc < 0) {
> +		if (conn->conn_transport->iscsit_free_pdu)
> +			conn->conn_transport->iscsit_free_pdu(conn, cmd);

This creates a weird asymmetry where alloc is called unconditionally
while free is conditional, I'd say implement an empty free for iscsit.
Same for the rest of the code...

P.S. I didn't see any non-error path call to free_pdu, is that a
possible leak (for drivers that actually allocate a PDU)?

On another unrelated note, I'd be very happy if we lose the iscsit_
prefix from all the callouts, it clear to everyone that it iscsi, no
need for an explicit reminder...
