From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/4] BNX2I: Added the use of kthreads to handle SCSI cmd
 completion
Date: Tue, 21 Jun 2011 21:54:24 -0500
Message-ID: <4E015960.2070101@cs.wisc.edu>
References: <Eddie Wai <eddie.wai@broadcom.com> <1308674994-4694-2-git-send-email-eddie.wai@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54774 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737Ab1FVCyf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Jun 2011 22:54:35 -0400
In-Reply-To: <1308674994-4694-2-git-send-email-eddie.wai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eddie Wai <eddie.wai@broadcom.com>
Cc: James Bottomley <JBottomley@novell.com>, open-iscsi <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Ben Li <benli@broadcom.com>

On 06/21/2011 11:49 AM, Eddie Wai wrote:
> This patch breaks the SCSI cmd completion into two parts:
> 1. The bh will allocate and queued work to the cmd specific CPU IO
> completion kthread.  The CPU for the cmd is recorded in task_xmit.
> 
> 2. The CPU specific IO completion kthread will call the scsi_cmd_resp
> routine to do the actual cmd completion.


I think you should use blkio poll. Modify it so it does what you want.
But I think since other drivers are getting in without converting then
that can wait.


>  struct bnx2i_cmd {
>  	struct iscsi_hdr hdr;
> @@ -215,6 +222,7 @@ struct bnx2i_cmd {
>  	struct io_bdt io_tbl;
>  	dma_addr_t bd_tbl_dma;
>  	struct bnx2i_cmd_request req;
> +	u32 cpu;


You can just use scsi_cmnd->request->cpu
