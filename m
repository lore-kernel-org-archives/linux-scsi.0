From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 7/8] be2iscsi: Fix processing cqe for cxn whose endpoint
 is freed
Date: Wed, 07 May 2014 17:18:38 -0500
Message-ID: <536AB13E.6080906@cs.wisc.edu>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com> <1399340492-2136-7-git-send-email-jkallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:37273 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbaEGWSv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 May 2014 18:18:51 -0400
In-Reply-To: <1399340492-2136-7-git-send-email-jkallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jay Kallickal <jayamohank@gmail.com>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Minh Tran <minhduc.tran@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

On 05/05/2014 08:41 PM, Jay Kallickal wrote:
> From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> 
>  During heavy IO in multipath environment with many active sessions
>  and port-bouncing happening, there is a race condition because of
>  which beiscsi_prcess_cqe() gets called for a connection whose
>  endpoint is freed.
> 
>  Checking endpoint reference for a connection before processing in
>  beiscsi_process_cq().
> 
> Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index dccda6c..5a7022f 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -2110,6 +2110,16 @@ static unsigned int beiscsi_process_cq(struct be_eq_obj *pbe_eq)
>  
>  		cri_index = BE_GET_CRI_FROM_CID(cid);
>  		ep = phba->ep_array[cri_index];
> +		if (unlikely(ep == NULL)) {
> +			/* connection has already been freed
> +			 * just move on to next one
> +			 */
> +			beiscsi_log(phba, KERN_WARNING,
> +				    BEISCSI_LOG_INIT,
> +				    "BM_%d : proc cqe of disconn ep: cid %d\n",
> +				    cid);
> +			goto proc_next_cqe;
> +		}
>  		beiscsi_ep = ep->dd_data;
>  		beiscsi_conn = beiscsi_ep->conn;
>  

It looks like if that race is possible then we could also free the ep
while you are accessing right? I think you would need to get a ref to
the ep.

What command/function tells the card to stop sending the driver
events/notifications/ios for that connection? Is it beiscsi_close_conn
or mgmt_invalidate_connection?
