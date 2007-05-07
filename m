From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] fill in scsi_host_template module owner
Date: Mon, 07 May 2007 13:25:22 -0500
Message-ID: <463F6F12.2030002@cs.wisc.edu>
References: <200704301653.56687.okir@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:42346 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934484AbXEGSZi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 May 2007 14:25:38 -0400
In-Reply-To: <200704301653.56687.okir@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Kirch <okir@lst.de>
Cc: linux-scsi@vger.kernel.org

Olaf Kirch wrote:
> I recently ran into an oops that happens because you
> can shut down all of iSCSI even though you still have
> iSCSI targets mounted. It turned out that iscsi's
> scsi_host_template missed a THIS_MODULE, so
> reference counting wasn't done properly. Brief
> inspection showed that this seems to be a rather
> wide-spread problem. Here's a patch to address this.
> 

I did not see this in scsi-misc so I am not sure if it matters or you
need a ack or signed off for iscsi, but the iscsi and iser parts look ok

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

> Index: linux-2.6/drivers/scsi/iscsi_tcp.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/iscsi_tcp.c
> +++ linux-2.6/drivers/scsi/iscsi_tcp.c
> @@ -2133,6 +2133,7 @@ static void iscsi_tcp_session_destroy(st
>  }
>  
>  static struct scsi_host_template iscsi_sht = {
> +	.module			= THIS_MODULE,
>  	.name			= "iSCSI Initiator over TCP/IP",
>  	.queuecommand           = iscsi_queuecommand,
>  	.change_queue_depth	= iscsi_change_queue_depth,


> Index: linux-2.6/drivers/infiniband/ulp/iser/iscsi_iser.c
> ===================================================================
> --- linux-2.6.orig/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ linux-2.6/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -543,6 +543,7 @@ iscsi_iser_ep_disconnect(__u64 ep_handle
>  }
>  
>  static struct scsi_host_template iscsi_iser_sht = {
> +	.module                 = THIS_MODULE,
>  	.name                   = "iSCSI Initiator over iSER, v." DRV_VER,
>  	.queuecommand           = iscsi_queuecommand,
>  	.can_queue		= ISCSI_XMIT_CMDS_MAX - 1,
> 

