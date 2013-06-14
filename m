From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] tcm_qla2xxx: Fix residual for underrun commands that
 fail
Date: Fri, 14 Jun 2013 14:10:07 -0700
Message-ID: <1371244207.15314.110.camel@haakon3.risingtidesystems.com>
References: <1370451257-20892-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36075 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752372Ab3FNVGM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Jun 2013 17:06:12 -0400
In-Reply-To: <1370451257-20892-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-driver@qlogic.com, Roland Dreier <roland@purestorage.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>

Hi Roland,

On Wed, 2013-06-05 at 09:54 -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> Suppose an initiator sends a DATA IN command with an allocation length
> shorter than the FC transfer length -- we get a target message like
> 
>     TARGET_CORE[qla2xxx]: Expected Transfer Length: 256 does not match SCSI CDB Length: 0 for SAM Opcode: 0x12
> 
> In that case, the target core adjusts the data_length and sets
> se_cmd->residual_count for the underrun.  But now suppose that command
> fails and we end up in tcm_qla2xxx_queue_status() -- that function
> unconditionally overwrites residual_count with the already adjusted
> data_length, and the initiator will burp with a message like
> 
>     qla2xxx [0000:00:06.0]-301d:0: Dropped frame(s) detected (0x100 of 0x100 bytes).
> 
> Fix this by adding on to the existing underflow residual count instead.
> 
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---

Apologies for the delay, finally catching up on the backlog..

Applied to target-pending/master, with a CC' to stable.

Also including QLogic folks on the CC'.

Thanks!

--nab

>  drivers/scsi/qla2xxx/tcm_qla2xxx.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 7a3870f..66b0b26 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -688,8 +688,12 @@ static int tcm_qla2xxx_queue_status(struct se_cmd *se_cmd)
>  		 * For FCP_READ with CHECK_CONDITION status, clear cmd->bufflen
>  		 * for qla_tgt_xmit_response LLD code
>  		 */
> +		if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT) {
> +			se_cmd->se_cmd_flags &= ~SCF_OVERFLOW_BIT;
> +			se_cmd->residual_count = 0;
> +		}
>  		se_cmd->se_cmd_flags |= SCF_UNDERFLOW_BIT;
> -		se_cmd->residual_count = se_cmd->data_length;
> +		se_cmd->residual_count += se_cmd->data_length;
>  
>  		cmd->bufflen = 0;
>  	}


