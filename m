From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] IB/iser: Add Discovery support
Date: Fri, 09 Aug 2013 12:46:20 -0500
Message-ID: <52052AEC.6090005@cs.wisc.edu>
References: <1375958669-28050-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41566 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758486Ab3HIRuS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Aug 2013 13:50:18 -0400
In-Reply-To: <1375958669-28050-1-git-send-email-ogerlitz@mellanox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, roland@kernel.org, monis@mellanox.com, roid@mellanox.com

On 08/08/2013 05:44 AM, Or Gerlitz wrote:
> To run discovery over iSER we need to advertize the CAP_TEXT_NEGO capability
> towards user space. Also need to make sure the login RX buffer is posted when
> SendTargets TEXT PDUs are sent. For that end, we use a setting of the
> ISCSI_PARAM_DISCOVERY_SESS iscsi param as an indication that this is
> discovery session.
> 
> Signed-off-by: Or Gerlitz <ogerlitz@mellanox.com>
> ---
> 
> Hi James, 
> 
> I submit this patch through your tree since it depends on the below iscsi
> patches (which are acknowledged by Mike) who are targted to 3.12
> 
> Or.
> 
> [PATCH V2 1/4] scsi_transport_iscsi: Exporting new attrs for iscsi session and connection in sysfs
> http://marc.info/?l=linux-scsi&m=137267405429329&w=2
> 
> [PATCH V2 2/4] libiscsi: Exporting new attrs for iscsi session and connection in sysfs
> http://marc.info/?l=linux-scsi&m=137267405529330&w=2
> 
>  drivers/infiniband/ulp/iser/iscsi_iser.c     |    3 ++-
>  drivers/infiniband/ulp/iser/iser_initiator.c |   11 ++++++++++-
>  drivers/scsi/libiscsi.c                      |    5 +++++
>  3 files changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 2e84ef8..1ec78bd 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -672,6 +672,7 @@ static umode_t iser_attr_is_visible(int param_type, int param)
>  		case ISCSI_PARAM_TGT_RESET_TMO:
>  		case ISCSI_PARAM_IFACE_NAME:
>  		case ISCSI_PARAM_INITIATOR_NAME:
> +		case ISCSI_PARAM_DISCOVERY_SESS:
>  			return S_IRUGO;
>  		default:
>  			return 0;
> @@ -701,7 +702,7 @@ static struct scsi_host_template iscsi_iser_sht = {
>  static struct iscsi_transport iscsi_iser_transport = {
>  	.owner                  = THIS_MODULE,
>  	.name                   = "iser",
> -	.caps                   = CAP_RECOVERY_L0 | CAP_MULTI_R2T,
> +	.caps                   = CAP_RECOVERY_L0 | CAP_MULTI_R2T | CAP_TEXT_NEGO,
>  	/* session management */
>  	.create_session         = iscsi_iser_session_create,
>  	.destroy_session        = iscsi_iser_session_destroy,
> diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
> index b6d81a8..b31fa1d 100644
> --- a/drivers/infiniband/ulp/iser/iser_initiator.c
> +++ b/drivers/infiniband/ulp/iser/iser_initiator.c
> @@ -234,6 +234,7 @@ void iser_free_rx_descriptors(struct iser_conn *ib_conn)
>  static int iser_post_rx_bufs(struct iscsi_conn *conn, struct iscsi_hdr *req)
>  {
>  	struct iscsi_iser_conn *iser_conn = conn->dd_data;
> +	struct iscsi_session *session = conn->session;
>  
>  	iser_dbg("req op %x flags %x\n", req->opcode, req->flags);
>  	/* check if this is the last login - going to full feature phase */
> @@ -248,7 +249,13 @@ static int iser_post_rx_bufs(struct iscsi_conn *conn, struct iscsi_hdr *req)
>  	WARN_ON(iser_conn->ib_conn->post_recv_buf_count != 1);
>  	WARN_ON(atomic_read(&iser_conn->ib_conn->post_send_buf_count) != 0);
>  
> -	iser_dbg("Initially post: %d\n", ISER_MIN_POSTED_RX);
> +	if (session->discovery_sess) {
> +		iser_info("Discovery session, re-using login RX buffer\n");
> +		return 0;
> +	} else
> +		iser_info("Normal session, posting batch of RX %d buffers\n",
> +			  ISER_MIN_POSTED_RX);
> +
>  	/* Initial post receive buffers */
>  	if (iser_post_recvm(iser_conn->ib_conn, ISER_MIN_POSTED_RX))
>  		return -ENOMEM;
> @@ -425,6 +432,8 @@ int iser_send_control(struct iscsi_conn *conn,
>  	}
>  
>  	if (task == conn->login_task) {
> +		iser_dbg("op %x dsl %lx, posting login rx buffer\n",
> +			 task->hdr->opcode, data_seg_len);
>  		err = iser_post_recvl(iser_conn->ib_conn);
>  		if (err)
>  			goto send_control_error;
> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
> index 86153e0..f17a692 100644
> --- a/drivers/scsi/libiscsi.c
> +++ b/drivers/scsi/libiscsi.c
> @@ -3170,6 +3170,7 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
>  {
>  	struct iscsi_conn *conn = cls_conn->dd_data;
>  	struct iscsi_session *session = conn->session;
> +	int val;
>  
>  	switch(param) {
>  	case ISCSI_PARAM_FAST_ABORT:
> @@ -3264,6 +3265,10 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
>  	case ISCSI_PARAM_DISCOVERY_PARENT_TYPE:
>  		return iscsi_switch_str_param(&session->discovery_parent_type,
>  					      buf);
> +	case ISCSI_PARAM_DISCOVERY_SESS:
> +		sscanf(buf, "%d", &val);
> +		session->discovery_sess = !!val;
> +		break;
>  	default:
>  		return -ENOSYS;
>  	}
> 

Patch looks ok.

Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>
