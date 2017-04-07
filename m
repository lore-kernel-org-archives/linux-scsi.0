From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvscsis: Do not send aborted task response
Date: Fri, 7 Apr 2017 10:56:14 -0500
Message-ID: <2ee98003-a3a1-d465-5a4c-864b51c53bf6@linux.vnet.ibm.com>
References: <1491580154-30489-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1491580154-30489-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 4/7/17 10:49 AM, Bryant G. Ly wrote:
> The driver is sending a response to the aborted task response
> along with LIO sending the tmr response. SCSI spec says
> that the initiator that sends the abort task TM NEVER gets a
> response to the aborted op and with the current code it will
> send a response. Thus this fix will remove that response if the
> op is aborted.
>
> Cc: <stable@vger.kernel.org> # v4.8+
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> ---
>   drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 60 +++++++++++++++++++++-----------
>   drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h |  1 +
>   2 files changed, 40 insertions(+), 21 deletions(-)
>
> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> index 4bb5635..8e2733f 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -1169,6 +1169,7 @@ static struct ibmvscsis_cmd *ibmvscsis_get_free_cmd(struct scsi_info *vscsi)
>   		cmd = list_first_entry_or_null(&vscsi->free_cmd,
>   					       struct ibmvscsis_cmd, list);
>   		if (cmd) {
> +			cmd->flags &= ~(CMD_ABORTED);
>   			list_del(&cmd->list);
>   			cmd->iue = iue;
>   			cmd->type = UNSET_TYPE;
> @@ -1758,33 +1759,41 @@ static void ibmvscsis_send_messages(struct scsi_info *vscsi)
>
>   	if (!(vscsi->flags & RESPONSE_Q_DOWN)) {
>   		list_for_each_entry_safe(cmd, nxt, &vscsi->waiting_rsp, list) {
> -			iue = cmd->iue;
> +			/*
> +			 * If an Abort flag is set then dont send response
> +			 */
> +			if (cmd->flags & CMD_ABORTED) {
> +				list_del(&cmd->list);
> +				ibmvscsis_free_cmd_resources(vscsi, cmd);
> +			} else {
> +				iue = cmd->iue;
>
> -			crq->valid = VALID_CMD_RESP_EL;
> -			crq->format = cmd->rsp.format;
> +				crq->valid = VALID_CMD_RESP_EL;
> +				crq->format = cmd->rsp.format;
>
> -			if (cmd->flags & CMD_FAST_FAIL)
> -				crq->status = VIOSRP_ADAPTER_FAIL;
> +				if (cmd->flags & CMD_FAST_FAIL)
> +					crq->status = VIOSRP_ADAPTER_FAIL;
>
> -			crq->IU_length = cpu_to_be16(cmd->rsp.len);
> +				crq->IU_length = cpu_to_be16(cmd->rsp.len);
>
> -			rc = h_send_crq(vscsi->dma_dev->unit_address,
> -					be64_to_cpu(msg_hi),
> -					be64_to_cpu(cmd->rsp.tag));
> +				rc = h_send_crq(vscsi->dma_dev->unit_address,
> +						be64_to_cpu(msg_hi),
> +						be64_to_cpu(cmd->rsp.tag));
>
> -			pr_debug("send_messages: cmd %p, tag 0x%llx, rc %ld\n",
> -				 cmd, be64_to_cpu(cmd->rsp.tag), rc);
> +				pr_debug("send_messages: cmd %p, tag 0x%llx, rc %ld\n",
> +					 cmd, be64_to_cpu(cmd->rsp.tag), rc);
>
> -			/* if all ok free up the command element resources */
> -			if (rc == H_SUCCESS) {
> -				/* some movement has occurred */
> -				vscsi->rsp_q_timer.timer_pops = 0;
> -				list_del(&cmd->list);
> +				/* if all ok free up the command element resources */
> +				if (rc == H_SUCCESS) {
> +					/* some movement has occurred */
> +					vscsi->rsp_q_timer.timer_pops = 0;
> +					list_del(&cmd->list);
>
> -				ibmvscsis_free_cmd_resources(vscsi, cmd);
> -			} else {
> -				srp_snd_msg_failed(vscsi, rc);
> -				break;
> +					ibmvscsis_free_cmd_resources(vscsi, cmd);
> +				} else {
> +					srp_snd_msg_failed(vscsi, rc);
> +					break;
> +				}
>   			}
>   		}
>
> @@ -3581,9 +3590,15 @@ static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
>   {
>   	struct ibmvscsis_cmd *cmd = container_of(se_cmd, struct ibmvscsis_cmd,
>   						 se_cmd);
> +	struct scsi_info *vscsi = cmd->adapter;
>   	struct iu_entry *iue = cmd->iue;
>   	int rc;
>
> +	if ((vscsi->flags & (CLIENT_FAILED | RESPONSE_Q_DOWN))) {
> +		pr_err("write_pending failed since: %d\n", vscsi->flags);
> +		return -EIO;
> +	}
> +
>   	rc = srp_transfer_data(cmd, &vio_iu(iue)->srp.cmd, ibmvscsis_rdma,
>   			       1, 1);
>   	if (rc) {

One question I had for you Nick was whether I should just return success if CLIENT_FAILED or RSP Q DOWN.
I know LIO wants EAGAIN or ENONEM on write pending return codes, but in this case LIO prob doesn't care.
It would produce less noise/warning if I were to just do success, what do you think?

-Bryant
