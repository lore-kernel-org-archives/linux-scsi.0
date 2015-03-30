From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH-v2 05/15] target: Add internal WRITE_STRIP support
Date: Mon, 30 Mar 2015 11:01:25 +0300
Message-ID: <551902D5.9030202@dev.mellanox.co.il>
References: <1427686104-14231-1-git-send-email-nab@daterainc.com> <1427686104-14231-6-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1427686104-14231-6-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On 3/30/2015 6:28 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch adds WRITE_STRIP support in target_check_write_prot() that
> invokes sbc_dif_verify_write() for checking T10-PI metadata before
> submitting the I/O to a backend driver.
>
> Upon verify failure, the specific sense code is propigated up the
> failure path up to transport_generic_request_failure().
>
> Also, update sbc_dif_verify_write() to only perform the subsequent
> protection metadata copy when a valid *sg is passed.
>
> Cc: Martin Petersen <martin.petersen@oracle.com>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_sbc.c       |  3 +++
>   drivers/target/target_core_transport.c | 16 ++++++++++++++++
>   2 files changed, 19 insertions(+)
>
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 68373c9..ea23b9c 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -1342,6 +1342,9 @@ sbc_dif_verify_write(struct se_cmd *cmd, sector_t start, unsigned int sectors,
>   		kunmap_atomic(paddr);
>   		kunmap_atomic(daddr);
>   	}
> +	if (!sg)
> +		return 0;
> +
>   	sbc_dif_copy_prot(cmd, sectors, false, sg, sg_off);
>
>   	return 0;
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 6a24151..51b62bd 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1740,6 +1740,7 @@ void __target_execute_cmd(struct se_cmd *cmd)
>
>   static int target_check_write_prot(struct se_cmd *cmd)
>   {
> +	u32 sectors;
>   	/*
>   	 * Perform WRITE_INSERT of PI using software emulation when backend
>   	 * device has PI enabled, if the transport has not already generated
> @@ -1750,6 +1751,21 @@ static int target_check_write_prot(struct se_cmd *cmd)
>   		if (!(cmd->se_sess->sup_prot_ops & TARGET_PROT_DOUT_INSERT))
>   			sbc_dif_generate(cmd);
>   		break;
> +	case TARGET_PROT_DOUT_STRIP:
> +		if (cmd->se_sess->sup_prot_ops & TARGET_PROT_DOUT_STRIP)
> +			break;
> +
> +		sectors = cmd->data_length / cmd->se_dev->dev_attrib.block_size;

Better to use data_length >> ilog2(block_size) and avoiding div in the
IO path.

> +		cmd->pi_err = sbc_dif_verify_write(cmd, cmd->t_task_lba,
> +						   sectors, 0, NULL, 0);
> +		if (cmd->pi_err) {

unlikely()

> +			spin_lock_irq(&cmd->t_state_lock);
> +			cmd->transport_state &= ~CMD_T_BUSY|CMD_T_SENT;
> +			spin_unlock_irq(&cmd->t_state_lock);
> +			transport_generic_request_failure(cmd, cmd->pi_err);
> +			return -1;
> +		}
> +		break;
>   	default:
>   		break;
>   	}
>
