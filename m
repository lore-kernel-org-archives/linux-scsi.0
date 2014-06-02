From: Sony John-N <Sony.John-N@Emulex.Com>
Subject: RE: [PATCH 7/8] be2iscsi: Fix processing cqe for cxn whose endpoint
 is freed
Date: Mon, 2 Jun 2014 05:52:16 +0000
Message-ID: <0eb11761-3b46-44d0-b35a-16d121fe1df4@CMEXHTCAS2.ad.emulex.com>
References: <1399340492-2136-1-git-send-email-jkallickal@emulex.com>
 <1399340492-2136-7-git-send-email-jkallickal@emulex.com>
 <536AB13E.6080906@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:29999 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFBFwW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 01:52:22 -0400
In-Reply-To: <536AB13E.6080906@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Jay Kallickal <jayamohank@gmail.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>, Minh Duc Tran <MinhDuc.Tran@Emulex.Com>



-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Thursday, May 08, 2014 3:49 AM
To: Jay Kallickal
Cc: jbottomley@parallels.com; linux-scsi@vger.kernel.org; Jayamohan Kallickal; Minh Duc Tran; Sony John-N
Subject: Re: [PATCH 7/8] be2iscsi: Fix processing cqe for cxn whose endpoint is freed

On 05/05/2014 08:41 PM, Jay Kallickal wrote:
> From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> 
>  During heavy IO in multipath environment with many active sessions  
> and port-bouncing happening, there is a race condition because of  
> which beiscsi_prcess_cqe() gets called for a connection whose  
> endpoint is freed.
> 
>  Checking endpoint reference for a connection before processing in  
> beiscsi_process_cq().
> 
> Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
> Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
> Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> ---
>  drivers/scsi/be2iscsi/be_main.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/drivers/scsi/be2iscsi/be_main.c 
> b/drivers/scsi/be2iscsi/be_main.c index dccda6c..5a7022f 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -2110,6 +2110,16 @@ static unsigned int beiscsi_process_cq(struct 
> be_eq_obj *pbe_eq)
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

> It looks like if that race is possible then we could also free the ep while you are accessing right? I think you would need to get a ref to the ep.
We will pull out this patch from this release. This is a very corner case and requires changes to be done in the IO path of the driver.  We will redo the patch and submit in our next release.
Please pull-in all the other patches in this set expect this particular one "[PATCH 7/8] be2iscsi: Fix processing cqe for cxn whose endpoint is freed".

> What command/function tells the card to stop sending the driver events/notifications/ios for that connection? Is it beiscsi_close_conn or mgmt_invalidate_connection?
Mgmt_invalidate_connection tell card to stop sending events to the driver for a particular connection.


