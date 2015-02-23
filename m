From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [SCSI] ipr: Increase max concurrent oustanding commands
Date: Mon, 23 Feb 2015 08:29:52 -0600
Message-ID: <54EB3960.7010100@linux.vnet.ibm.com>
References: <20150223123230.GA7141@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42871 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbbBWOaA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Feb 2015 09:30:00 -0500
Received: from /spool/local
	by e7.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Mon, 23 Feb 2015 09:29:59 -0500
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 3172CC90058
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2015 09:21:06 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t1NETtgn22151378
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2015 14:29:55 GMT
Received: from d01av04.pok.ibm.com (localhost [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t1NETsYk023655
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2015 09:29:55 -0500
In-Reply-To: <20150223123230.GA7141@mwanda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 02/23/2015 06:32 AM, Dan Carpenter wrote:
> Hello Brian King,
> 
> This is a semi-automatic email about new static checker warnings.
> 
> The patch 89aad4283173: "[SCSI] ipr: Increase max concurrent
> oustanding commands" from Mar 14, 2012, leads to the following Smatch
> complaint:
> 
> drivers/scsi/ipr.c:9038 ipr_alloc_cmd_blks()
> 	 error: we previously assumed 'ioa_cfg->ipr_cmnd_list' could be null (see line 9037)
> 
> drivers/scsi/ipr.c
>   9036	
>   9037		if (!ioa_cfg->ipr_cmnd_list || !ioa_cfg->ipr_cmnd_list_dma) {
>                      ^^^^^^^^^^^^^^^^^^^^^^
> This can be NULL.
> 
>   9038			ipr_free_cmd_blks(ioa_cfg);
>                                           ^^^^^^^
> But we dereference it unconditionally inside the ipr_free_cmd_blks()
> function when we check: "if (ioa_cfg->ipr_cmnd_list[i])".  These kinds
> of magic free everything functions are almost always buggy but Smatch
> missed this bug initialy and I had to update it.  I'll push the Smatch
> change later this week.  It requires the cross function database to
> trigger this warning.

Thanks Dan. I'll queue up a fix for this one.

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


