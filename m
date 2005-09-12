From: Jack Byer <ojbyer@usa.net>
Subject: Re: Fw: legacy megaraid driver bug in mm-series
Date: Mon, 12 Sep 2005 19:48:10 -0400
Message-ID: <432613BA.5060606@usa.net>
References: <20050907025258.35100c34.akpm@osdl.org>	<20050908143547.GA9741@infradead.org> <20050909165817.1a8ad251.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 69.37.187.190.adsl.snet.net ([69.37.187.190]:1497 "EHLO
	copper.fuckthenavy.net") by vger.kernel.org with ESMTP
	id S932366AbVILXs1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Sep 2005 19:48:27 -0400
In-Reply-To: <20050909165817.1a8ad251.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> Christoph Hellwig <hch@infradead.org> wrote:
> 
>>On Wed, Sep 07, 2005 at 02:52:58AM -0700, Andrew Morton wrote:
>>
>>>
>>>Begin forwarded message:
>>
>>This looks preyyu much like a breakage because we're now always sending
>>S/G list down the scsi layer.
>>
>>The patch below brings over code to handle that case from the megaraid_mbox
>>driver.  It's still wrong for the case someone sends a MODE_SENSE from
>>highmem userspace, but it should at least boot with the patch applied.
>>
> 
> 
> Jack, have you had a chance to test this?
> 
> Thanks.
> 
Sorry, I spent the weekend whitewater rafting :)  I will be able to test
this patch on Wednesday. Which kernel versions should I apply this patch to?




> 
>>Index: scsi-misc-2.6/drivers/scsi/megaraid.c
>>===================================================================
>>--- scsi-misc-2.6.orig/drivers/scsi/megaraid.c	2005-08-13 13:53:52.000000000 +0200
>>+++ scsi-misc-2.6/drivers/scsi/megaraid.c	2005-09-08 16:34:06.000000000 +0200
>>@@ -621,8 +621,6 @@
>> 	if(islogical) {
>> 		switch (cmd->cmnd[0]) {
>> 		case TEST_UNIT_READY:
>>-			memset(cmd->request_buffer, 0, cmd->request_bufflen);
>>-
>> #if MEGA_HAVE_CLUSTERING
>> 			/*
>> 			 * Do we support clustering and is the support enabled
>>@@ -653,7 +651,19 @@
>> #endif
>> 
>> 		case MODE_SENSE:
>>-			memset(cmd->request_buffer, 0, cmd->cmnd[4]);
>>+			if (cmd->use_sg) {
>>+				struct scatterlist	*sgl;
>>+				caddr_t			vaddr;
>>+
>>+				sgl = (struct scatterlist *)cmd->request_buffer;
>>+				vaddr = (caddr_t)
>>+					(page_address((&sgl[0])->page)
>>+					+ (&sgl[0])->offset);
>>+
>>+				memset(vaddr, 0, cmd->cmnd[4]);
>>+			} else {
>>+				memset(cmd->request_buffer, 0, cmd->cmnd[4]);
>>+			}
>> 			cmd->result = (DID_OK << 16);
>> 			cmd->scsi_done(cmd);
>> 			return NULL;
> 
> 

