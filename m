From: Robert Jennings <rcj@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] ibmvfc: Properly set cancel flags when cancelling
 abort
Date: Tue, 16 Apr 2013 15:24:19 -0500
Message-ID: <20130416202419.GF3230@linux.vnet.ibm.com>
References: <201304121325.r3CDPFe4024986@d01av05.pok.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:48906 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767Ab3DPUY0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Apr 2013 16:24:26 -0400
Received: from /spool/local
	by e23smtp04.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <rcj@linux.vnet.ibm.com>;
	Wed, 17 Apr 2013 06:12:52 +1000
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [9.190.235.21])
	by d23dlp02.au.ibm.com (Postfix) with ESMTP id 753B12BB0023
	for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2013 06:24:21 +1000 (EST)
Received: from d23av02.au.ibm.com (d23av02.au.ibm.com [9.190.235.138])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id r3GKOFs763963326
	for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2013 06:24:15 +1000
Received: from d23av02.au.ibm.com (loopback [127.0.0.1])
	by d23av02.au.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id r3GKOK6W007898
	for <linux-scsi@vger.kernel.org>; Wed, 17 Apr 2013 06:24:21 +1000
Content-Disposition: inline
In-Reply-To: <201304121325.r3CDPFe4024986@d01av05.pok.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com

* Brian King (brking@linux.vnet.ibm.com) wrote:
> 
> The flags on a cancel operation are intended to indicate what,
> if any, TMF will follow the cancel request. This fixes a case
> where we were incorrectly setting the abort task set flag on
> the cancel flag when we were cancelling an abort task set.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Acked-by: Robert Jennings <rcj@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ibmvscsi/ibmvfc.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff -puN drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_cancel_flags drivers/scsi/ibmvscsi/ibmvfc.c
> --- linux-2.6/drivers/scsi/ibmvscsi/ibmvfc.c~ibmvfc_abort_cancel_flags	2013-01-22 07:44:23.000000000 -0600
> +++ linux-2.6-bjking1/drivers/scsi/ibmvscsi/ibmvfc.c	2013-01-22 07:44:56.000000000 -0600
> @@ -2327,7 +2327,7 @@ static int ibmvfc_abort_task_set(struct
>  	timeout = wait_for_completion_timeout(&evt->comp, timeout);
> 
>  	if (!timeout) {
> -		rc = ibmvfc_cancel_all(sdev, IBMVFC_TMF_ABORT_TASK_SET);
> +		rc = ibmvfc_cancel_all(sdev, 0);
>  		if (!rc) {
>  			rc = ibmvfc_wait_for_ops(vhost, sdev->hostdata, ibmvfc_match_key);
>  			if (rc == SUCCESS)
> _

