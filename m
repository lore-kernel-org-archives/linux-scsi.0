From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: [PATCH 1/4] BNX2I: Added the use of kthreads to handle SCSI
 cmd completion
Date: Tue, 21 Jun 2011 23:46:28 -0700
Message-ID: <1308725189.3778.40.camel@ltirv-waie-lx1>
References: <Eddie Wai <eddie.wai@broadcom.com>
 <1308674994-4694-2-git-send-email-eddie.wai@broadcom.com>
 <4E015960.2070101@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2594 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751784Ab1FVGqs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Jun 2011 02:46:48 -0400
In-Reply-To: <4E015960.2070101@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>
Cc: James Bottomley <JBottomley@novell.com>, linux-scsi <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>, Anil Veerabhadrappa <anilgv@broadcom.com>, Benjamin Li <benli@broadcom.com>


On Tue, 2011-06-21 at 19:54 -0700, Mike Christie wrote:
> On 06/21/2011 11:49 AM, Eddie Wai wrote:
> > This patch breaks the SCSI cmd completion into two parts:
> > 1. The bh will allocate and queued work to the cmd specific CPU IO
> > completion kthread.  The CPU for the cmd is recorded in task_xmit.
> > 
> > 2. The CPU specific IO completion kthread will call the scsi_cmd_resp
> > routine to do the actual cmd completion.
> 
> 
> I think you should use blkio poll. Modify it so it does what you want.
> But I think since other drivers are getting in without converting then
> that can wait.
Noted.  I will revisit this later then.
> 
> 
> >  struct bnx2i_cmd {
> >  	struct iscsi_hdr hdr;
> > @@ -215,6 +222,7 @@ struct bnx2i_cmd {
> >  	struct io_bdt io_tbl;
> >  	dma_addr_t bd_tbl_dma;
> >  	struct bnx2i_cmd_request req;
> > +	u32 cpu;
> 
> 
> You can just use scsi_cmnd->request->cpu
Ok, I'll make the change to use this instead of grabbing the cpu
explicitly in our driver.
> 


