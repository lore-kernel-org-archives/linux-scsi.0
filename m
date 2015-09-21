From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 15/30] cxlflash: Fix location of setting resid
Date: Mon, 21 Sep 2015 13:28:30 -0500
Message-ID: <56004C4E.4050004@linux.vnet.ibm.com>
References: <1442438635-49044-1-git-send-email-mrochs@linux.vnet.ibm.com>
 <1442439027-49780-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:52437 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753224AbbIUS2k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2015 14:28:40 -0400
Received: from /spool/local
	by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 21 Sep 2015 12:28:39 -0600
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
	by d03dlp02.boulder.ibm.com (Postfix) with ESMTP id 11F723E40048
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 12:28:37 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t8LISaJR50003984
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 11:28:36 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t8LISY1Y015660
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2015 12:28:36 -0600
In-Reply-To: <1442439027-49780-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Ian Munsie <imunsie@au1.ibm.com>, Daniel Axtens <dja@ozlabs.au.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: Michael Neuling <mikey@neuling.org>, linuxppc-dev@lists.ozlabs.org, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>

On 09/16/2015 04:30 PM, Matthew R. Ochs wrote:
> @@ -158,8 +160,7 @@ static void process_cmd_err(struct afu_cmd *cmd, struct scsi_cmnd *scp)
>  				/* If the SISL_RC_FLAGS_OVERRUN flag was set,
>  				 * then we will handle this error else where.
>  				 * If not then we must handle it here.
> -				 * This is probably an AFU bug. We will
> -				 * attempt a retry to see if that resolves it.
> +				 * This is probably an AFU bug.

I would tend to agree with this statement. ioasa->resid should be zero in an overrun case.

>  				 */
>  				scp->result = (DID_ERROR << 16);
>  			}

Reviewed-by: Brian King <brking@linux.vnet.ibm.com>


-- 
Brian King
Power Linux I/O
IBM Linux Technology Center

