From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [RFC 18/34] iscsi-target: call complete on conn_logout_comp
Date: Mon, 15 Feb 2016 19:07:19 +0200
Message-ID: <56C205C7.9000503@dev.mellanox.co.il>
References: <767baf547e8db884caddee17a62da36c4023f8f7.1455467089.git.varun@chelsio.com>
 <f98923031c5958e73ce1ac13a5fc7f68ba19391f.1455467089.git.varun@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33993 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096AbcBORHX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2016 12:07:23 -0500
Received: by mail-wm0-f41.google.com with SMTP id b205so75961294wmb.1
        for <linux-scsi@vger.kernel.org>; Mon, 15 Feb 2016 09:07:22 -0800 (PST)
In-Reply-To: <f98923031c5958e73ce1ac13a5fc7f68ba19391f.1455467089.git.varun@chelsio.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Varun Prakash <varun@chelsio.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com



On 14/02/2016 19:42, Varun Prakash wrote:
> ISCSI_TCP_CXGB4 driver waits on conn_logout_comp as
> ISCSI_TCP driver so call complete if transport type
> is ISCSI_TCP_CXGB4.
>
> Signed-off-by: Varun Prakash <varun@chelsio.com>
> ---
>   drivers/target/iscsi/iscsi_target.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 8bf3cfb..858f6e4 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4265,16 +4265,18 @@ int iscsit_close_connection(
>   	pr_debug("Closing iSCSI connection CID %hu on SID:"
>   		" %u\n", conn->cid, sess->sid);
>   	/*
> -	 * Always up conn_logout_comp for the traditional TCP case just in case
> -	 * the RX Thread in iscsi_target_rx_opcode() is sleeping and the logout
> -	 * response never got sent because the connection failed.
> +	 * Always up conn_logout_comp for the traditional TCP and TCP_CXGB4
> +	 * case just in case the RX Thread in iscsi_target_rx_opcode() is
> +	 * sleeping and the logout response never got sent because the
> +	 * connection failed.
>   	 *
>   	 * However for iser-target, isert_wait4logout() is using conn_logout_comp
>   	 * to signal logout response TX interrupt completion.  Go ahead and skip
>   	 * this for iser since isert_rx_opcode() does not wait on logout failure,
>   	 * and to avoid iscsi_conn pointer dereference in iser-target code.
>   	 */
> -	if (conn->conn_transport->transport_type == ISCSI_TCP)
> +	if ((conn->conn_transport->transport_type == ISCSI_TCP) ||
> +	    (conn->conn_transport->transport_type == ISCSI_TCP_CXGB4))
>   		complete(&conn->conn_logout_comp);

IMO, this is an indication that this condition is a bandage in the first
place...

While this is unrelated to the patch set, we should look into the iscsi
termination sequences more closely and look if we can dispatch some
logic to the drivers in places they defer. It will make the code much
less complicated.
