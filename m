From: Andy Grover <agrover-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 04/11] iscsi-target: Add per transport iscsi_cmd alloc/free
Date: Fri, 22 Mar 2013 10:23:32 -0700
Message-ID: <514C9394.7000501@redhat.com>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org> <1362707116-31406-5-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1362707116-31406-5-git-send-email-nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alexander Nezhinsky <alexandern-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 03/07/2013 05:45 PM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
>
> This patch converts struct iscsi_cmd memory allocation + free to use
> ->iscsit_alloc_cmd() + ->iscsit_free_cmd() iscsit_transport API caller,
> and export iscsit_allocate_cmd() + iscsit_free_cmd() symbols
>
> Also update iscsit_free_cmd() to include a final ->iscsit_unmap_cmd()
> API call.
>
> Signed-off-by: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
> ---
>   drivers/target/iscsi/iscsi_target.c      |    2 +
>   drivers/target/iscsi/iscsi_target_util.c |   34 ++++++++++++++++++++++++++---
>   drivers/target/iscsi/iscsi_target_util.h |    2 +
>   3 files changed, 34 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 4dc1c9b..9cd7b7b 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -488,6 +488,8 @@ static struct iscsit_transport iscsi_target_transport = {
>   	.iscsit_setup_np	= iscsit_setup_np,
>   	.iscsit_accept_np	= iscsit_accept_np,
>   	.iscsit_free_np		= iscsit_free_np,
> +	.iscsit_alloc_cmd	= iscsit_alloc_cmd,
> +	.iscsit_free_cmd	= iscsit_cache_free_cmd,
>   	.iscsit_get_login_rx	= iscsit_get_login_rx,
>   	.iscsit_put_login_tx	= iscsit_put_login_tx,
>   };
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 4cf1e7f..4a86034 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -149,6 +149,17 @@ void iscsit_free_r2ts_from_list(struct iscsi_cmd *cmd)
>   	spin_unlock_bh(&cmd->r2t_lock);
>   }
>
> +struct iscsi_cmd *iscsit_alloc_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
> +{
> +	struct iscsi_cmd *cmd;
> +
> +	cmd = kmem_cache_zalloc(lio_cmd_cache, gfp_mask);
> +	if (!cmd)
> +		return NULL;
> +
> +	return cmd;
> +}
> +
>   /*
>    * May be called from software interrupt (timer) context for allocating
>    * iSCSI NopINs.
> @@ -157,13 +168,12 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
>   {
>   	struct iscsi_cmd *cmd;
>
> -	cmd = kmem_cache_zalloc(lio_cmd_cache, gfp_mask);
> +	cmd = conn->conn_transport->iscsit_alloc_cmd(conn, gfp_mask);
>   	if (!cmd) {
>   		pr_err("Unable to allocate memory for struct iscsi_cmd.\n");
>   		return NULL;
>   	}
> -
> -	cmd->conn	= conn;
> +	cmd->conn = conn;
>   	INIT_LIST_HEAD(&cmd->i_conn_node);
>   	INIT_LIST_HEAD(&cmd->datain_list);
>   	INIT_LIST_HEAD(&cmd->cmd_r2t_list);
> @@ -176,6 +186,7 @@ struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *conn, gfp_t gfp_mask)
>
>   	return cmd;
>   }
> +EXPORT_SYMBOL(iscsit_allocate_cmd);
>
>   struct iscsi_seq *iscsit_get_seq_holder_for_datain(
>   	struct iscsi_cmd *cmd,
> @@ -661,6 +672,11 @@ void iscsit_free_queue_reqs_for_conn(struct iscsi_conn *conn)
>   	spin_unlock_bh(&conn->response_queue_lock);
>   }
>
> +void iscsit_cache_free_cmd(struct iscsi_cmd *cmd)

Caching is an implementation detail, rename to iscsit_free_cmd()?

> +{
> +	kmem_cache_free(lio_cmd_cache, cmd);
> +}
> +
>   void iscsit_release_cmd(struct iscsi_cmd *cmd)
>   {
>   	struct iscsi_conn *conn = cmd->conn;
> @@ -679,17 +695,26 @@ void iscsit_release_cmd(struct iscsi_cmd *cmd)
>   		iscsit_remove_cmd_from_response_queue(cmd, conn);
>   	}
>
> -	kmem_cache_free(lio_cmd_cache, cmd);
> +	conn->conn_transport->iscsit_free_cmd(cmd);
>   }
>
>   void iscsit_free_cmd(struct iscsi_cmd *cmd)
>   {
> +	struct iscsi_conn *conn = cmd->conn;
>   	/*
>   	 * Determine if a struct se_cmd is associated with
>   	 * this struct iscsi_cmd.
>   	 */
>   	switch (cmd->iscsi_opcode) {
>   	case ISCSI_OP_SCSI_CMD:
> +		if (cmd->data_direction == DMA_TO_DEVICE)
> +			iscsit_stop_dataout_timer(cmd);
> +
> +		if (conn->conn_transport->iscsit_unmap_cmd)
> +			conn->conn_transport->iscsit_unmap_cmd(cmd, conn);

Don't check, just call it?

-- Andy

> +		/*
> +		 * Fallthrough
> +		 */
>   	case ISCSI_OP_SCSI_TMFUNC:
>   		transport_generic_free_cmd(&cmd->se_cmd, 1);
>   		break;
> @@ -709,6 +734,7 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd)
>   		break;
>   	}
>   }
> +EXPORT_SYMBOL(iscsit_free_cmd);
>
>   int iscsit_check_session_usage_count(struct iscsi_session *sess)
>   {
> diff --git a/drivers/target/iscsi/iscsi_target_util.h b/drivers/target/iscsi/iscsi_target_util.h
> index 894d0f8..854ce89 100644
> --- a/drivers/target/iscsi/iscsi_target_util.h
> +++ b/drivers/target/iscsi/iscsi_target_util.h
> @@ -8,6 +8,7 @@ extern struct iscsi_r2t *iscsit_get_r2t_for_eos(struct iscsi_cmd *, u32, u32);
>   extern struct iscsi_r2t *iscsit_get_r2t_from_list(struct iscsi_cmd *);
>   extern void iscsit_free_r2t(struct iscsi_r2t *, struct iscsi_cmd *);
>   extern void iscsit_free_r2ts_from_list(struct iscsi_cmd *);
> +extern struct iscsi_cmd *iscsit_alloc_cmd(struct iscsi_conn *, gfp_t);
>   extern struct iscsi_cmd *iscsit_allocate_cmd(struct iscsi_conn *, gfp_t);
>   extern struct iscsi_seq *iscsit_get_seq_holder_for_datain(struct iscsi_cmd *, u32);
>   extern struct iscsi_seq *iscsit_get_seq_holder_for_r2t(struct iscsi_cmd *);
> @@ -27,6 +28,7 @@ extern struct iscsi_queue_req *iscsit_get_cmd_from_response_queue(struct iscsi_c
>   extern void iscsit_remove_cmd_from_tx_queues(struct iscsi_cmd *, struct iscsi_conn *);
>   extern bool iscsit_conn_all_queues_empty(struct iscsi_conn *);
>   extern void iscsit_free_queue_reqs_for_conn(struct iscsi_conn *);
> +extern void iscsit_cache_free_cmd(struct iscsi_cmd *);
>   extern void iscsit_release_cmd(struct iscsi_cmd *);
>   extern void iscsit_free_cmd(struct iscsi_cmd *);
>   extern int iscsit_check_session_usage_count(struct iscsi_session *);
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
