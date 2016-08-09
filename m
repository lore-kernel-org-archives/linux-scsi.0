From: Andy Grover <agrover@redhat.com>
Subject: Re: [PATCH v3 03/13] iscsi-target: add void (*iscsit_get_rx_pdu)()
Date: Mon, 8 Aug 2016 20:19:41 -0700
Message-ID: <684b7d66-ee8b-a2fd-c949-1e449df1e8a1@redhat.com>
References: <cover.1461088672.git.varun@chelsio.com>
 <f993801e40717417bb752ddeb20765b25b092584.1461088672.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <f993801e40717417bb752ddeb20765b25b092584.1461088672.git.varun@chelsio.com>
Sender: target-devel-owner@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com
List-Id: linux-scsi@vger.kernel.org

Hi Varun,

On 04/19/2016 11:30 AM, Varun Prakash wrote:
> Add void (*iscsit_get_rx_pdu)() to
> struct iscsit_transport, iscsi-target
> uses this callback to receive and
> process Rx iSCSI PDUs.
>
> cxgbit.ko needs this callback to
> reuse iscsi-target Rx thread.
>
> Signed-off-by: Varun Prakash <varun@chelsio.com>
> Acked-by: Sagi Grimberg <sagi@grimberg.me>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 10 ++++++++++
>  drivers/target/iscsi/iscsi_target.c     | 10 ++--------
>  include/target/iscsi/iscsi_transport.h  |  1 +
>  3 files changed, 13 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index 411e446..9118d7c 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -3273,6 +3273,15 @@ static void isert_free_conn(struct iscsi_conn *conn)
>  	isert_put_conn(isert_conn);
>  }
>
> +static void isert_get_rx_pdu(struct iscsi_conn *conn)
> +{
> +	struct completion comp;
> +
> +	init_completion(&comp);
> +
> +	wait_for_completion_interruptible(&comp);
> +}
> +

Does this mean that the iser rx thread just does nothing and waits to 
receive a signal to exit?

If we don't set *iscsit_get_rx_pdu for iser, so the thread exits 
immediately from iscsi_target_rx_thread, would that be an ok change?

Thanks -- Regards -- Andy

>  static struct iscsit_transport iser_target_transport = {
>  	.name			= "IB/iSER",
>  	.transport_type		= ISCSI_INFINIBAND,
> @@ -3291,6 +3300,7 @@ static struct iscsit_transport iser_target_transport = {
>  	.iscsit_queue_data_in	= isert_put_datain,
>  	.iscsit_queue_status	= isert_put_response,
>  	.iscsit_aborted_task	= isert_aborted_task,
> +	.iscsit_get_rx_pdu	= isert_get_rx_pdu,
>  	.iscsit_get_sup_prot_ops = isert_get_sup_prot_ops,
>  };
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 0724c83..9fa9f0b 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -3951,14 +3951,8 @@ int iscsi_target_rx_thread(void *arg)
>  	if (rc < 0 || iscsi_target_check_conn_state(conn))
>  		return 0;
>
> -	if (conn->conn_transport->transport_type == ISCSI_INFINIBAND) {
> -		struct completion comp;
> -
> -		init_completion(&comp);
> -		rc = wait_for_completion_interruptible(&comp);
> -		if (rc < 0)
> -			goto transport_err;
> -
> +	if (conn->conn_transport->iscsit_get_rx_pdu) {
> +		conn->conn_transport->iscsit_get_rx_pdu(conn);
>  		goto transport_err;
>  	}
>
> diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
> index 3b0053e..ccc68a0 100644
> --- a/include/target/iscsi/iscsi_transport.h
> +++ b/include/target/iscsi/iscsi_transport.h
> @@ -25,6 +25,7 @@ struct iscsit_transport {
>  	int (*iscsit_xmit_pdu)(struct iscsi_conn *, struct iscsi_cmd *,
>  			       struct iscsi_datain_req *, const void *, u32);
>  	void (*iscsit_release_cmd)(struct iscsi_conn *, struct iscsi_cmd *);
> +	void (*iscsit_get_rx_pdu)(struct iscsi_conn *);
>  	enum target_prot_op (*iscsit_get_sup_prot_ops)(struct iscsi_conn *);
>  };
>
>
