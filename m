From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 3/3] iser-target: Handle special case for logout during
 connection failure
Date: Sun, 22 Mar 2015 18:06:48 +0200
Message-ID: <550EE898.70209@dev.mellanox.co.il>
References: <1426918564-22581-1-git-send-email-nab@daterainc.com> <1426918564-22581-4-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1426918564-22581-4-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Slava Shwartsman <valyushash@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 3/21/2015 8:16 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch adds special case handling during ISCSI_OP_LOGIN_RSP ib_wr
> failure, where isert_cq_comp_err() is responsible for calling the
> remaining isert_response_completion() -> isert_do_control_comp() ->
> iscsit_logout_post_handler() to drop the last iscsi_conn reference.
>
> It fixes a bug where iscsit_logout_post_handler() would not be called
> if the outgoing ISCSI_OP_LOGIN_RSP failed during iscsi_conn ib_wr
> descriptor cleanup.
>
> Reported-by: Sagi Grimberg <sagig@mellanox.com>
> Reported-by: Slava Shwartsman <valyushash@gmail.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/infiniband/ulp/isert/ib_isert.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index 075b19c..ff0d436 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -1996,10 +1996,20 @@ isert_cq_comp_err(struct isert_conn *isert_conn, struct ib_wc *wc)
>
>   		desc = (struct iser_tx_desc *)(uintptr_t)wc->wr_id;
>   		isert_cmd = desc->isert_cmd;
> -		if (!isert_cmd)
> +		if (!isert_cmd) {
>   			isert_unmap_tx_desc(desc, ib_dev);
> -		else
> -			isert_completion_put(desc, isert_cmd, ib_dev, true);
> +		} else {
> +			struct isert_device *device = isert_conn->conn_device;
> +			struct iscsi_conn *conn = isert_conn->conn;
> +			struct iscsi_cmd *cmd = isert_cmd->iscsi_cmd;
> +
> +			if (cmd->i_state == ISTATE_SEND_LOGOUTRSP &&
> +			    conn->conn_state == TARG_CONN_STATE_IN_LOGOUT)
> +				isert_response_completion(desc, isert_cmd, isert_conn,
> +							  device->ib_device);
> +			else
> +				isert_completion_put(desc, isert_cmd, ib_dev, true);
> +		}
>   	} else {
>   		isert_conn->post_recv_buf_count--;
>   		if (!isert_conn->post_recv_buf_count)
>

Hey Nic,

Not sure if calling a full logout handler for error completion makes the
most sense here. if this is an error completion it means we are
either in session teardown or just about to start it. So simply
completing conn_logout_comp might be sufficient.

Anyways it might make sense to actually see this type of race happening
before adding this code.

I think this is better off as a standalone patch.

Sagi.
