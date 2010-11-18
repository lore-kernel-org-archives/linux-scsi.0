From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 06/16] BNX2I: Added code to handle the binding of an existing
 connection
Date: Wed, 17 Nov 2010 21:24:53 -0600
Message-ID: <4CE49C85.2070109@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1289430297-30221-7-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:45281 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850Ab0KRDRC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 22:17:02 -0500
In-Reply-To: <1289430297-30221-7-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 11/10/2010 05:04 PM, Eddie Wai wrote:
> This is the case when iscsid gets re-launched due to features like
> iSCSI boot which requires the daemon to re-launch due to
> pivot root.  If the code detected the connection had an existing
> endpoint, the old endpoint must get cleaned up.
>
> Signed-off-by: Eddie Wai<eddie.wai@broadcom.com>
> Acked-by: Anil Veerabhadrappa<anilgv@broadcom.com>
> ---
>   drivers/scsi/bnx2i/bnx2i_iscsi.c |    7 +++++++
>   1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> index 823e4fa..3b65c64 100644
> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
> @@ -1410,6 +1410,13 @@ static int bnx2i_conn_bind(struct iscsi_cls_session *cls_session,
>   				  hba->netdev->name);
>   		return -EEXIST;
>   	}
> +	if (bnx2i_conn->ep) {
> +		printk(KERN_ALERT "bnx2i: Binding to an existing endpoint "
> +			"detected.  Disconnecting the old...\n");
> +		mutex_lock(&hba->net_dev_lock);
> +		bnx2i_hw_ep_disconnect(bnx2i_conn->ep);
> +		mutex_unlock(&hba->net_dev_lock);
> +	}
>   	bnx2i_ep->conn = bnx2i_conn;
>   	bnx2i_conn->ep = bnx2i_ep;
>   	bnx2i_conn->iscsi_conn_cid = bnx2i_ep->ep_iscsi_cid;

Don't you still leak what bnx2i_free_ep frees?

In userspace you should have iscsid/iscsi_sync_session match the iscsi 
endpoint with the iscsi conn and set transport_ep_handle. ep_disconnect 
will then get called like normal to clean up the old connection.
