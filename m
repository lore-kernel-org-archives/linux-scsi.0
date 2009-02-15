From: Ingo Molnar <mingo@elte.hu>
Subject: Re: scsi: aic7xxx hang since v2.6.28-rc1 ...
Date: Sun, 15 Feb 2009 12:58:23 +0100
Message-ID: <20090215115823.GB19464@elte.hu>
References: <20090215114446.GA19464@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:48012 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbZBOL7b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Feb 2009 06:59:31 -0500
Content-Disposition: inline
In-Reply-To: <20090215114446.GA19464@elte.hu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Here's an SCSI regression i tracked down recently. I'll follow up with
> more info.

I sent this to James Bottomley about a month ago, who suggested that the
bug looks similar to problems caused by:

 | commit b60af5b0adf0da24c673598c8d3fb4d4189a15ce
 | Author: Alan Stern <stern@rowland.harvard.edu>
 | Date:   Mon Nov 3 15:56:47 2008 -0500
 |
 |     [SCSI] simplify scsi_io_completion()

I could not revert that patch because it had a lot of followup dependencies,
but by experimentation i figured out the following string of gradual reverts
to scsi_lib.c [the revert commits can be found in tip:out-of-tree]:

 813104e: Revert "[SCSI] simplify scsi_io_completion()"
 84db545: Revert "[SCSI] Fix uninitialized variable error in scsi_io_completion"
 0eb6038: Revert "[SCSI] Fix error handling for DIF/DIX"
 3cd94dd: Revert "[SCSI] scsi_lib: don't decrement busy counters when inserting commands"
 c27aed5: Revert "[SCSI] scsi_lib: fix DID_RESET status problems"

These reverts solved the problem and the box has not locked up in the SCSI irq 
completion code since then. The code has not had any changes upstream since i
did the reverts, so the bug is still relevant as of .29-rc5.

( James suggested i send this bugreport to this list too, so that it does not
  get single-threaded on him as he is busy with other things - so more suggestions
  are welcome. I can try proposed fix patches. James suggested the patch below
  and i dont think it will show us much more than what we already know: that we
  are looping in scsi_run_queue(). )

	Ingo

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 940dc32..5919dd0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -593,6 +593,7 @@ static void scsi_run_queue(struct request_queue *q)
 	struct Scsi_Host *shost = sdev->host;
 	LIST_HEAD(starved_list);
 	unsigned long flags;
+	int count = 0;
 
 	if (scsi_target(sdev)->single_lun)
 		scsi_single_lun_run(sdev);
@@ -603,6 +604,8 @@ static void scsi_run_queue(struct request_queue *q)
 	while (!list_empty(&starved_list)) {
 		int flagset;
 
+		BUG_ON(count++ > 1000);
+
 		/*
 		 * As long as shost is accepting commands and we have
 		 * starved queues, call blk_run_queue. scsi_request_fn

