From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] drivers/scsi/st.c: add reference count and related fixes
Date: Wed, 06 Jul 2005 15:01:02 -0500
Message-ID: <42CC387E.7050800@us.ibm.com>
References: <92952AEF1F064042B6EF2522E0EEF437348354@EXNA.corp.stratus.com>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:19848 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S262334AbVGFUBF
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 6 Jul 2005 16:01:05 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e31.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j66K148D431054
	for <linux-scsi@vger.kernel.org>; Wed, 6 Jul 2005 16:01:04 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j66K13cC186394
	for <linux-scsi@vger.kernel.org>; Wed, 6 Jul 2005 14:01:04 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j66K13X8024944
	for <linux-scsi@vger.kernel.org>; Wed, 6 Jul 2005 14:01:03 -0600
In-Reply-To: <92952AEF1F064042B6EF2522E0EEF437348354@EXNA.corp.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Dailey, Nate" <Nate.Dailey@stratus.com>
Cc: Kai.Makisara@kolumbus.fi, linux-scsi@vger.kernel.org

Dailey, Nate wrote:
> These patches (against a 2.6.9 kernel, Redhat AS 4) for st add a
> reference count, and fix a few bugs I hit during testing (administrative
> removes and cable pulls with IO in progress).
> 
> The primary change is adding a kref to the Scsi_Tape structure, to avoid
> an oops when the tape drive is removed while open. This includes
> scsi_tape_get/put routines and scsi_tape_release, and changes to st_open
> and st_release. This is all based on the SCSI disk & CD reference
> counting code.

I've actually been working on a similar patch for mainline.

I'd be happy to send out my patch, which has the kref added to Scsi_Tape
and has been tested on current mainline. I haven't hit the additional
bugs you mentioned below, but am still testing different scenarios.

-Brian


> 
> 
> I hit some bugs while I was testing this code. Fixes for these are also
> included in the patch:
> 
> - When an IO gets a "dead device" error, we need to check the rq_status
> to determine if the request actually completed (scsi_wait_req does
> this)... else there's no notification to the caller that the IO failed.
> There are two changes for this, one in st_do_scsi and one in
> write_behind_check.
>   
> - When an async IO gets a "dead device" error, we're notified of the
> completion by the block layer (end_that_request_last), so last_SRpnt
> doesn't get set (as it would if the complete were done by
> st_sleep_done). So I changed how last_SRpnt is used to get around
> this... it's now set only for async IOs, just before the IO is issued
> (and nulled out when the IO comes back). 
> 
> 
> I also hit the following problem when I briefly tested on a SUSE kernel
> (it wasn't in the Redhat kernel I did most of my testing with, but it is
> in 2.6.12):
> 
> - In these kernels, we no longer get a "complete" from
> end_that_request_last when a device goes away and an IO is rejected. I
> therefore added to st_do_scsi (but it's commented in this patch) setting
> SRpnt->sr_request->end_io to blk_end_sync_rq, which will do the
> complete. Since blk_end_sync_rq nulls out rq->waiting, I changed
> st_do_scsi to wait on a local variable, and added a check for null in
> st_sleep_done (just in case).
> 
> 
> And just one more thing:
> 
> - I noticed that in 2.6.12, there is what appears to be a bogus use of
> last_SRpnt in st_chk_result (this doesn't exist in the kernels I tested
> with). This would cause problems if these patches are ported to 2.6.12,
> because of how I changed the use of last_SRpnt. Either my code has to
> change, or st_chk_result shouldn't use last_SRpnt.
> 
> 
> Anyway... as I said, these are against a 2.6.9 kernel (Redhat AS 4). If
> you're interested, I could port these changes to 2.6.12... can't promise
> I'll be able to test with that kernel, though.
> 
> Nate Dailey
> Stratus Technologies
> 
> 
> Signed-off-by: Nate Dailey <nate.dailey@stratus.com>


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
