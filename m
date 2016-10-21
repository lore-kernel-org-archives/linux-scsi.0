From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 2/6] target: fix potential race window in
 target_sess_cmd_list_waiting()
Date: Fri, 21 Oct 2016 01:19:22 -0700
Message-ID: <1477037962.8490.163.camel@haakon3.risingtidesystems.com>
References: <1471856051-87398-1-git-send-email-hare@suse.de>
         <1471856051-87398-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:47029 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754310AbcJUITY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2016 04:19:24 -0400
In-Reply-To: <1471856051-87398-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>, Hannes Reinecke <hare@suse.com>

On Mon, 2016-08-22 at 10:54 +0200, Hannes Reinecke wrote:
> target_sess_cmd_list_waiting() might hit on a condition where
> the kref for the command is already 0, but the destructor has
> not been called yet (or is stuck in waiting for a spin lock).
> Rather than leaving the command on the list we should explicitly
> remove it to avoid race issues later on.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  drivers/target/target_core_transport.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 2e1a6d8..ce136f0 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2547,8 +2547,8 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
>  	 * fabric acknowledgement that requires two target_put_sess_cmd()
>  	 * invocations before se_cmd descriptor release.
>  	 */
> -	if (ack_kref)
> -		kref_get(&se_cmd->cmd_kref);
> +	if (ack_kref && !kref_get_unless_zero(&se_cmd->cmd_kref))
> +		return -EINVAL;
>  

Makes sense.

Applying the following version to target-pending/master atop pending
SCF_ACK_KREF regression bug-fix.

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9ebbf94..ad6fb3f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2535,7 +2535,9 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
         * invocations before se_cmd descriptor release.
         */
        if (ack_kref) {
-               kref_get(&se_cmd->cmd_kref);
+               if (!kref_get_unless_zero(&se_cmd->cmd_kref))
+                       return -EINVAL;
+
                se_cmd->se_cmd_flags |= SCF_ACK_KREF;
        }
 
>  	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>  	if (se_sess->sess_tearing_down) {
> @@ -2627,7 +2627,7 @@ EXPORT_SYMBOL(target_put_sess_cmd);
>   */
>  void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
>  {
> -	struct se_cmd *se_cmd;
> +	struct se_cmd *se_cmd, *tmp_cmd;
>  	unsigned long flags;
>  	int rc;
>  
> @@ -2639,7 +2639,8 @@ void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
>  	se_sess->sess_tearing_down = 1;
>  	list_splice_init(&se_sess->sess_cmd_list, &se_sess->sess_wait_list);
>  
> -	list_for_each_entry(se_cmd, &se_sess->sess_wait_list, se_cmd_list) {
> +	list_for_each_entry_safe(se_cmd, tmp_cmd,
> +				 &se_sess->sess_wait_list, se_cmd_list) {
>  		rc = kref_get_unless_zero(&se_cmd->cmd_kref);
>  		if (rc) {
>  			spin_lock(&se_cmd->t_state_lock);
> @@ -2648,7 +2649,8 @@ void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
>  				se_cmd->transport_state |= CMD_T_FABRIC_STOP;
>  			}
>  			spin_unlock(&se_cmd->t_state_lock);
> -		}
> +		} else
> +			list_del_init(&se_cmd->se_cmd_list);
>  	}
>  
>  	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);

