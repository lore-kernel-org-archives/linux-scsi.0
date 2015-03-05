From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] ibmvfc: Fix a locking imbalance
Date: Thu, 05 Mar 2015 07:35:50 -0600
Message-ID: <54F85BB6.7030504@linux.vnet.ibm.com>
References: <54F6D85E.5060906@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37236 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbbCENf5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2015 08:35:57 -0500
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 5 Mar 2015 08:35:56 -0500
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id D0D12C90046
	for <linux-scsi@vger.kernel.org>; Thu,  5 Mar 2015 08:27:04 -0500 (EST)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t25DZsEl15270056
	for <linux-scsi@vger.kernel.org>; Thu, 5 Mar 2015 13:35:54 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t25DZrII019860
	for <linux-scsi@vger.kernel.org>; Thu, 5 Mar 2015 08:35:54 -0500
In-Reply-To: <54F6D85E.5060906@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <jbottomley@parallels.com>
Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 03/04/2015 04:03 AM, Bart Van Assche wrote:
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 057d277..b46257a 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -4722,6 +4722,8 @@ static void ibmvfc_rport_add_thread(struct work_struct *work)
>  					tgt_dbg(tgt, "Setting rport roles\n");
>  					fc_remote_port_rolechg(rport, tgt->ids.roles);
>  					put_device(&rport->dev);
> +				} else {
> +					spin_unlock_irqrestore(vhost->host->host_lock, flags);
>  				}
> 
>  				kref_put(&tgt->kref, ibmvfc_release_tgt);
> 

Nice catch. Thanks.

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


