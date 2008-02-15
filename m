From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: aic94xx: failing on high load (another data point)
Date: Fri, 15 Feb 2008 09:28:43 -0600
Message-ID: <1203089323.3058.20.camel@localhost.localdomain>
References: <479FB3ED.3080401@hopnet.net>
	 <20080130091403.GA14887@alaris.suse.cz> <47A05896.40900@hopnet.net>
	 <20080130192947.GA21785@tree.beaverton.ibm.com>
	 <47B4682C.4020505@hopnet.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:55087 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751241AbYBOP2u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 10:28:50 -0500
In-Reply-To: <47B4682C.4020505@hopnet.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Keith Hopkins <vger@hopnet.net>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, Jan Sembera <jsembera@suse.cz>, linux-scsi@vger.kernel.org

On Fri, 2008-02-15 at 00:11 +0800, Keith Hopkins wrote:
> On 01/31/2008 03:29 AM, Darrick J. Wong wrote:
> > On Wed, Jan 30, 2008 at 06:59:34PM +0800, Keith Hopkins wrote:
> >> V28.  My controller functions well with a single drive (low-medium load).  Unfortunately, all attempts to get the mirrors in sync fail and usually hang the whole box.
> > 
> > Adaptec posted a V30 sequencer on their website; does that fix the
> > problems?
> > 
> > http://www.adaptec.com/en-US/speed/scsi/linux/aic94xx-seq-30-1_tar_gz.htm
> > 
> 
> I lost connectivity to the drive again, and had to reboot to recover
> the drive, so it seemed a good time to try out the V30 firmware.
> Unfortunately, it didn't work any better.  Details are in the
> attachment.

Well, I can offer some hope.  The errors you report:

> aic94xx: escb_tasklet_complete: REQ_TASK_ABORT, reason=0x6
> aic94xx: escb_tasklet_complete: Can't find task (tc=6) to abort!

Are requests by the sequencer to abort a task because of a protocol
error.  IBM did some extensive testing with seagate drives and found
that the protocol errors were genuine and the result of drive firmware
problems.  IBM released a version of seagate firmware (BA17) to correct
these.  Unfortunately, your drive identifies its firmware as S513 which
is likely OEM firmware from another vendor ... however, that vendor may
have an update which corrects the problem.

Of course, the other issue is this:

> aic94xx: escb_tasklet_complete: Can't find task (tc=6) to abort!

This is a bug in the driver.  It's not finding the task in the
outstanding list.  The problem seems to be that it's taking the task
from the escb which, by definition, is always NULL.  It should be taking
the task from the ascb it finds by looping over the pending queue.

If you're willing, could you try this patch which may correct the
problem?  It's sort of like falling off a cliff: if you never go near
the edge (i.e. you upgrade the drive fw) you never fall off;
alternatively, it would be nice if you could help me put up guard rails
just in case.

Thanks,

James

---
diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 0febad4..ab35050 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -458,13 +458,19 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 		tc_abort = le16_to_cpu(tc_abort);
 
 		list_for_each_entry_safe(a, b, &asd_ha->seq.pend_q, list) {
-			struct sas_task *task = ascb->uldd_task;
+			struct sas_task *task = a->uldd_task;
+
+			if (a->tc_index != tc_abort)
+				continue;
 
-			if (task && a->tc_index == tc_abort) {
+			if (task) {
 				failed_dev = task->dev;
 				sas_task_abort(task);
-				break;
+			} else {
+				ASD_DPRINTK("R_T_A for non TASK scb 0x%x\n",
+					    a->scb->header.opcode);
 			}
+			break;
 		}
 
 		if (!failed_dev) {
@@ -478,7 +484,7 @@ static void escb_tasklet_complete(struct asd_ascb *ascb,
 		 * that the EH will wake up and do something.
 		 */
 		list_for_each_entry_safe(a, b, &asd_ha->seq.pend_q, list) {
-			struct sas_task *task = ascb->uldd_task;
+			struct sas_task *task = a->uldd_task;
 
 			if (task &&
 			    task->dev == failed_dev &&


