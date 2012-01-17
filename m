From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target, iscsi: Fix up a few assignments
Date: Mon, 16 Jan 2012 18:30:01 -0800
Message-ID: <1326767401.3600.41.camel@haakon2.linux-iscsi.org>
References: <alpine.LNX.2.00.1201151929400.13069@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36486 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab2AQCaD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Jan 2012 21:30:03 -0500
In-Reply-To: <alpine.LNX.2.00.1201151929400.13069@swampdragon.chaosbits.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Grover <agrover@redhat.com>, Dan Carpenter <error27@gmail.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@lst.de>

On Sun, 2012-01-15 at 19:33 +0100, Jesper Juhl wrote:
> A statement such as
>   struct iscsi_node_attrib *na = na = iscsit_tpg_get_node_attrib(sess);
> has undefined behaviour since there are two assignments to 'na', strictly 
> speaking (the order in which side-effects from the assignments take place 
> is undefined since there's no intervening sequence point), and it looks 
> unintentional in any case.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/target/iscsi/iscsi_target_erl1.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
>  compile tested only.
> 
> diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
> index 101b1be..af18cb8 100644
> --- a/drivers/target/iscsi/iscsi_target_erl1.c
> +++ b/drivers/target/iscsi/iscsi_target_erl1.c
> @@ -1238,7 +1238,7 @@ void iscsit_mod_dataout_timer(struct iscsi_cmd *cmd)
>  {
>  	struct iscsi_conn *conn = cmd->conn;
>  	struct iscsi_session *sess = conn->sess;
> -	struct iscsi_node_attrib *na = na = iscsit_tpg_get_node_attrib(sess);
> +	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
>  
>  	spin_lock_bh(&cmd->dataout_timeout_lock);
>  	if (!(cmd->dataout_timer_flags & ISCSI_TF_RUNNING)) {
> @@ -1261,7 +1261,7 @@ void iscsit_start_dataout_timer(
>  	struct iscsi_conn *conn)
>  {
>  	struct iscsi_session *sess = conn->sess;
> -	struct iscsi_node_attrib *na = na = iscsit_tpg_get_node_attrib(sess);
> +	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
>  
>  	if (cmd->dataout_timer_flags & ISCSI_TF_RUNNING)
>  		return;
> -- 

Copy and paste error.  :(

Applied to lio-core, and thanks for catching this Jesper!


