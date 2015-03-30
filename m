From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH-v2 04/15] target: Move cmd->prot_op check into target_check_write_prot
Date: Mon, 30 Mar 2015 10:57:58 +0300
Message-ID: <55190206.90207@dev.mellanox.co.il>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com> <1427686104-14231-5-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427686104-14231-5-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 3/30/2015 6:28 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch moves the existing target_execute_cmd() check for
> cmd->prot_op into it's own function, so it's easier to add
> future support for WRITE STRIP.
>
> Cc: Martin Petersen <martin.petersen@oracle.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_transport.c | 31 ++++++++++++++++++++++---------
>   1 file changed, 22 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index aef989e..6a24151 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1738,6 +1738,25 @@ void __target_execute_cmd(struct se_cmd *cmd)
>   	}
>   }
>
> +static int target_check_write_prot(struct se_cmd *cmd)

This is not really a check routine, it actually does something with
the protection information. Maybe a better name would be
target_write_prot_action() or something in that form.

> +{
> +	/*
> +	 * Perform WRITE_INSERT of PI using software emulation when backend
> +	 * device has PI enabled, if the transport has not already generated
> +	 * PI using hardware WRITE_INSERT offload.
> +	 */
> +	switch (cmd->prot_op) {
> +	case TARGET_PROT_DOUT_INSERT:
> +		if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DOUT_INSERT))
> +			sbc_dif_generate(cmd);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
>   static bool target_handle_task_attr(struct se_cmd *cmd)
>   {
>   	struct se_device *dev = cmd->se_dev;
> @@ -1817,15 +1836,9 @@ void target_execute_cmd(struct se_cmd *cmd)
>   	cmd->t_state = TRANSPORT_PROCESSING;
>   	cmd->transport_state |= CMD_T_ACTIVE|CMD_T_BUSY|CMD_T_SENT;
>   	spin_unlock_irq(&cmd->t_state_lock);
> -	/*
> -	 * Perform WRITE_INSERT of PI using software emulation when backend
> -	 * device has PI enabled, if the transport has not already generated
> -	 * PI using hardware WRITE_INSERT offload.
> -	 */
> -	if (cmd->prot_op == TARGET_PROT_DOUT_INSERT) {
> -		if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DOUT_INSERT))
> -			sbc_dif_generate(cmd);
> -	}
> +
> +	if (target_check_write_prot(cmd))
> +		return;
>
>   	if (target_handle_task_attr(cmd)) {
>   		spin_lock_irq(&cmd->t_state_lock);
>
