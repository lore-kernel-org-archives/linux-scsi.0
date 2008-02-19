From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH] aic94xx: Don't free ABORT_TASK SCBs that are timed out
	(Was: Re: aic94xx: failing on high load)
Date: Tue, 19 Feb 2008 10:44:00 -0800
Message-ID: <20080219184359.GA5414@tree.beaverton.ibm.com>
References: <479FB3ED.3080401@hopnet.net> <20080130091403.GA14887@alaris.suse.cz> <47A05896.40900@hopnet.net> <20080130192947.GA21785@tree.beaverton.ibm.com> <47B4682C.4020505@hopnet.net> <1203089323.3058.20.camel@localhost.localdomain> <47B9958A.8080104@hopnet.net> <1203438140.3103.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:44240 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbYBSSoE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Feb 2008 13:44:04 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m1JIi1xh019640
	for <linux-scsi@vger.kernel.org>; Tue, 19 Feb 2008 13:44:01 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m1JIi1G2231948
	for <linux-scsi@vger.kernel.org>; Tue, 19 Feb 2008 13:44:01 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m1JIi05w013268
	for <linux-scsi@vger.kernel.org>; Tue, 19 Feb 2008 13:44:01 -0500
Content-Disposition: inline
In-Reply-To: <1203438140.3103.24.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Keith Hopkins <vger@hopnet.net>, Jan Sembera <jsembera@suse.cz>, linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>, Peter Bogdanovic <pbog@us.ibm.com>, Gilbert Wu <Gilbert_Wu@adaptec.com>

If we send an ABORT_TASK ascb that doesn't return within the timeout period,
we should not free that ascb because the sequencer is still holding onto it.
Hopefully it will fix what James Bottomley describes below:

On Tue, Feb 19, 2008 at 10:22:20AM -0600, James Bottomley wrote:

> Unfortunately, there's a bug in TMF timeout handling in the driver, it
> leaves the sequencer entry pending, but frees the ascb.  If the
> sequencer ever picks this up it will get very confused, as it does a
> while down in the trace:
> 
> > aic94xx: BUG:sequencer:dl:no ascb?!
> > aic94xx: BUG:sequencer:dl:no ascb?!
> 
> That's where the sequencer adds an ascb to the done list that we've
> already freed.  From this point on confusion reigns and the error
> handler eventually offlines the device.
> 
> I'll see if I can come up with patches to fix this ... or at least
> mitigate the problems it causes.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/aic94xx/aic94xx_tmf.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_tmf.c b/drivers/scsi/aic94xx/aic94xx_tmf.c
index b52124f..4b24bd3 100644
--- a/drivers/scsi/aic94xx/aic94xx_tmf.c
+++ b/drivers/scsi/aic94xx/aic94xx_tmf.c
@@ -463,7 +463,7 @@ int asd_abort_task(struct sas_task *task)
 						       AIC94XX_SCB_TIMEOUT);
 		spin_lock_irqsave(&task->task_state_lock, flags);
 		if (leftover < 1)
-			res = TMF_RESP_FUNC_FAILED;
+			goto out_not_reported;
 		if (task->task_state_flags & SAS_TASK_STATE_DONE)
 			res = TMF_RESP_FUNC_COMPLETE;
 		spin_unlock_irqrestore(&task->task_state_lock, flags);
@@ -487,6 +487,11 @@ out:
 	asd_ascb_free(ascb);
 	ASD_DPRINTK("task 0x%p aborted, res: 0x%x\n", task, res);
 	return res;
+
+out_not_reported:
+	spin_unlock_irqrestore(&task->task_state_lock, flags);
+	ASD_DPRINTK("task 0x%p aborted? but not reported.\n", task);
+	return res;
 }
 
 /**
