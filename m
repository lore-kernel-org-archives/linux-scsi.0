From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] iscsi-target: Fix CmdSN comparison (use cmd->cmd_sn
 instead of cmd->stat_sn)
Date: Thu, 10 Jan 2013 20:47:06 -0800
Message-ID: <1357879626.20882.18.camel@haakon2.linux-iscsi.org>
References: <1357587916-4870-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52475 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733Ab3AKErI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jan 2013 23:47:08 -0500
In-Reply-To: <1357587916-4870-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>, Ben Hutchings <ben@decadent.org.uk>

On Mon, 2013-01-07 at 11:45 -0800, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> Commit 64c13330a389 ("iscsi-target: Fix bug in handling of ExpStatSN
> ACK during u32 wrap-around") introduced a bug where we compare the
> wrong SN against our ExpCmdSN.
> 
> Reported-by: Ben Hutchings <ben@decadent.org.uk>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  drivers/target/iscsi/iscsi_target_erl2.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
> index 9ac4c151..ba6091b 100644
> --- a/drivers/target/iscsi/iscsi_target_erl2.c
> +++ b/drivers/target/iscsi/iscsi_target_erl2.c
> @@ -372,7 +372,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
>  		 * made generic here.
>  		 */
>  		if (!(cmd->cmd_flags & ICF_OOO_CMDSN) && !cmd->immediate_cmd &&
> -		     iscsi_sna_gte(cmd->stat_sn, conn->sess->exp_cmd_sn)) {
> +		     iscsi_sna_gte(cmd->cmd_sn, conn->sess->exp_cmd_sn)) {
>  			list_del(&cmd->i_conn_node);
>  			spin_unlock_bh(&conn->cmd_lock);
>  			iscsit_free_cmd(cmd);

Thanks for fixing this up.  Applied with another 'CC to stable for Ben &
Co. to pick this up..

--nab


