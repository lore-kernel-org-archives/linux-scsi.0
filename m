From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/7] BNX2I: Separated the hardware's cleanup procedure
 from ep_disconnect
Date: Wed, 30 Jun 2010 00:53:37 -0500
Message-ID: <4C2ADBE1.2020204@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1277516372-469-2-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36233 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab0F3Fuu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jun 2010 01:50:50 -0400
In-Reply-To: <1277516372-469-2-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 06/25/2010 08:39 PM, Eddie Wai wrote:
> +/**
> + * bnx2i_ep_disconnect - executes TCP connection teardown process
> + * @ep:		TCP connection (iscsi endpoint) handle
> + *
> + * executes  TCP connection teardown process
> + */
> +static void bnx2i_ep_disconnect(struct iscsi_endpoint *ep)
> +{
> +	struct bnx2i_endpoint *bnx2i_ep;
> +	struct bnx2i_conn *bnx2i_conn = NULL;
> +	struct iscsi_conn *conn = NULL;
> +	struct bnx2i_hba *hba;
> +
> +	bnx2i_ep = ep->dd_data;
> +
> +	/* driver should not attempt connection cleanup until TCP_CONNECT
> +	 * completes either successfully or fails. Timeout is 9-secs, so
> +	 * wait for it to complete
> +	 */
> +	while ((bnx2i_ep->state == EP_STATE_CONNECT_START)&&
> +		!time_after(jiffies, bnx2i_ep->timestamp + (12 * HZ)))
> +		msleep(250);
> +
> +	if (bnx2i_ep->conn) {
> +		bnx2i_conn = bnx2i_ep->conn;
> +		conn = bnx2i_conn->cls_conn->dd_data;
> +		iscsi_suspend_queue(conn);
> +	}
> +	hba = bnx2i_ep->hba;
> +	if (!hba)
> +		goto out;


Here you have a ep, so if you goto out you will not release it. Need to 
call iscsi_destroy_endpoint at least. Can you hit this "if" even?
