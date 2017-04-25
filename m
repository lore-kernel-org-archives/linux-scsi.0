From: Tyrel Datwyler <turtle.in.the.kernel@gmail.com>
Subject: Re: [PATCH] ibmvscsis: Do not send aborted task response
Date: Tue, 25 Apr 2017 13:18:40 -0700
Message-ID: <fb013771-cbbd-cd80-f9c6-f3975a099f52@gmail.com>
References: <1491850368-7201-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1491850368-7201-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, nab@linux-iscsi.org, Bart.VanAssche@sandisk.com
Cc: seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 04/10/2017 11:52 AM, Bryant G. Ly wrote:
> The driver is sending a response to the aborted task response
> along with LIO sending the tmr response.

I think this could be better worded. Something like the driver is sending a response to
the actual ***scsi op*** that was aborted by an abort task TM, while LIO is sending a
response to the abort task TM.

> ibmvscsis_tgt does not send the response to the client until
> release_cmd time. The reason for this was because if we did it
> at queue_status time, then the client would be free to reuse the
> tag for that command, but we're still using the tag until the
> command is released at release_cmd time, so we chose to delay
> sending the response until then. That then caused this issue, because
> release_cmd is always called, even if queue_status is not.

The above portion of the commit message is little convoluted in my opinion, and a bit hard
to follow. Otherwise,

Reviewed-by: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

> 
> SCSI spec says that the initiator that sends the abort task
> TM NEVER gets a response to the aborted op and with the current
> code it will send a response. Thus this fix will remove that response
> if the TAS bit is set.
> 
> Cc: <stable@vger.kernel.org> # v4.8+
> Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
> ---
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 60 +++++++++++++++++++++-----------
>  1 file changed, 40 insertions(+), 20 deletions(-)
> 
> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> index 4bb5635..f75948a 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -1758,33 +1758,42 @@ static void ibmvscsis_send_messages(struct scsi_info *vscsi)
>  
>  	if (!(vscsi->flags & RESPONSE_Q_DOWN)) {
>  		list_for_each_entry_safe(cmd, nxt, &vscsi->waiting_rsp, list) {
> -			iue = cmd->iue;
> +			/*
> +			 * If Task Abort Status Bit is set, then dont send a
> +			 * response.
> +			 */
> +			if (cmd->se_cmd.transport_state & CMD_T_TAS) {
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
>  			}
>  		}
>  
> @@ -3581,9 +3590,20 @@ static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
>  {
>  	struct ibmvscsis_cmd *cmd = container_of(se_cmd, struct ibmvscsis_cmd,
>  						 se_cmd);
> +	struct scsi_info *vscsi = cmd->adapter;
>  	struct iu_entry *iue = cmd->iue;
>  	int rc;
>  
> +	/*
> +	 * If CLIENT_FAILED OR RESPONSE_Q_DOWN, then just return success
> +	 * since LIO can't do anything about it, and we dont want to
> +	 * attempt an srp_transfer_data.
> +	 */
> +	if ((vscsi->flags & (CLIENT_FAILED | RESPONSE_Q_DOWN))) {
> +		pr_err("write_pending failed since: %d\n", vscsi->flags);
> +		return 0;
> +	}
> +
>  	rc = srp_transfer_data(cmd, &vio_iu(iue)->srp.cmd, ibmvscsis_rdma,
>  			       1, 1);
>  	if (rc) {
> 
