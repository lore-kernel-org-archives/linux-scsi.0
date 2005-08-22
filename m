From: Joel Schopp <jschopp@austin.ibm.com>
Subject: Re: [patch] ibmvscsi timeout fix
Date: Mon, 22 Aug 2005 14:53:23 -0500
Message-ID: <430A2D33.2000308@austin.ibm.com>
References: <20050822193826.GA2455@cs.umn.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:59555 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S1750752AbVHVTxh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Aug 2005 15:53:37 -0400
In-Reply-To: <20050822193826.GA2455@cs.umn.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: boutcher@cs.umn.edu, Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, linuxppc64-dev@ozlabs.org, linux-kernel@vger.kernel.org

> This patch fixes a long term borkenness in
> ibmvscsi where we were using the wrong timeout
> field from the scsi command (and using the 
> wrong units.)  Now broken by the fact that the
> scsi_cmnd timeout field is gone entirely.
> This only worked before because all the SCSI
> targets assumed that 0 was default.

That was fast.  I report the error to you and get a patch next time I 
look at my mail.  This does fix the build break I saw in a 
2.6.13-rc6-mm1 defconfig on ppc64.

Adding Andrew Morton to the distribution list since somebody else is 
bound to notice that ppc64 -mm doesn't compile anymore.

Acked-by: Joel Schopp <jschopp@austin.ibm.com>

> 
> Signed-off-by: Dave Boutcher <boutcher@us.ibm.com>
> 
> --- linux-2.6.13-rc6-mm1-orig/drivers/scsi/ibmvscsi/ibmvscsi.c	2005-08-22 13:54:20.111955197 -0500
> +++ linux-2.6.13-rc6-mm1/drivers/scsi/ibmvscsi/ibmvscsi.c	2005-08-22 14:22:56.265042174 -0500
> @@ -594,7 +594,7 @@
>  	init_event_struct(evt_struct,
>  			  handle_cmd_rsp,
>  			  VIOSRP_SRP_FORMAT,
> -			  cmnd->timeout);
> +			  cmnd->timeout_per_command/HZ);
>  
>  	evt_struct->cmnd = cmnd;
>  	evt_struct->cmnd_done = done;
> 
> 

