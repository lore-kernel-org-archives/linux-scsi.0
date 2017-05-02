From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] ibmvscsis: Do not send aborted task response
Date: Mon, 01 May 2017 21:19:06 -0700
Message-ID: <1493698746.23202.20.camel@haakon3.risingtidesystems.com>
References: <1491850368-7201-1-git-send-email-bryantly@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1491850368-7201-1-git-send-email-bryantly@linux.vnet.ibm.com>
Sender: stable-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Cc: Bart.VanAssche@sandisk.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Bryant & Co,

Apologies for the delayed follow up.

Comments below.

On Mon, 2017-04-10 at 13:52 -0500, Bryant G. Ly wrote:
> The driver is sending a response to the aborted task response
> along with LIO sending the tmr response.
> ibmvscsis_tgt does not send the response to the client until
> release_cmd time. The reason for this was because if we did it
> at queue_status time, then the client would be free to reuse the
> tag for that command, but we're still using the tag until the
> command is released at release_cmd time, so we chose to delay
> sending the response until then. That then caused this issue, because
> release_cmd is always called, even if queue_status is not.
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

Unless I'm mistaken, this should be a check for CMD_T_ABORTED &&
!CMD_T_TAS to avoid generating an explicit response + immediately free,
and not a check for CMD_T_TAS when a command still needs a explicit
response..

That is, CMD_T_TAS is the only scenario where target-core is supposed to
generate an explicit response of SAM_STAT_TASK_ABORTED, which means
h_send_crq() should be called for those se_cmd descriptors.

However for CMD_T_ABORTED w/o CMD_T_TAS scenarios (like TMR TASK_ABORT
for example) where target-core does not call ->queue_status(), this is
the case where ibmvscsis_send_messages() should be ignoring calls to
h_send_crq(), because se_cmd descriptors must not be generating response
after they have been aborted.

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

AFAICT, returning '0' here is correct to avoid generating an explicit
CHECK_CONDITION for non -EAGAIN or -ENOMEM return values.
