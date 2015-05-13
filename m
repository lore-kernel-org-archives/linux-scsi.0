From: Brian King <brking@linux.vnet.ibm.com>
Subject: blk_requeue_request BUG_ON
Date: Wed, 13 May 2015 17:54:18 -0500
Message-ID: <5553D61A.9080502@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e38.co.us.ibm.com ([32.97.110.159]:57338 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934426AbbEMWyV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2015 18:54:21 -0400
Received: from /spool/local
	by e38.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Wed, 13 May 2015 16:54:21 -0600
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 988541FF001E
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2015 16:45:29 -0600 (MDT)
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4DMqDjw27000886
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2015 15:52:13 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4DMsIfo023701
	for <linux-scsi@vger.kernel.org>; Wed, 13 May 2015 16:54:18 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Hannes Reinecke <hare@suse.de>, lnx1138@linux.vnet.ibm.com

I've been chasing a BUG_ON in blk_requeue_request which seems to occur
in scenarios where we are seeing lots of SCSI aborts. As I've been digging
through the completion paths and abort paths, I've noticed if the following
sequence occurs, we are likely to hit this issue:

1. scsi_cmd times out, async abort issued
2. LLDD aborts command, LLDD calls scsi_done for the aborted command from interrupt handler
   when aborted command comes back
3. If result of the aborted command is something like DID_ERROR and we allow retries,
   then in scsi_done processing, we'll call scsi_queue_insert which then calls blk_requeue_request
4. Returning from the LLDD's eh_abort handler, scsi_error sees the abort was successful,
   and then calls scsi_queue_insert for the aborted command, which also calls blk_requeue_request
   where we hit the BUG_ON because the command has been queued again.

This is occurring for the non blk_rq_tagged case, for reference, so blk_requeue_request
doesn't call blk_queue_end_tag which might cause this to not be hit...

Should a LLDD NOT call scsi_done for commands it aborts? We've seen the issue above on
both ibmvfc and mpt2sas, but I know there are other LLDDs that call scsi_done in this case,
but just do it before eh_abort returns. Or is it expected the LLDD will only ever return DID_ABORT
on the aborted command, which looks like it might prevent this issue as well, however, that seems
racy and then we'd also need to add some memory barriers around the checking / setting of scmd->eh_eflags
I would think.

Or am I missing something and headed down the wrong path?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


