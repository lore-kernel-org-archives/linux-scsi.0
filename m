From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] scsi: improved eh timeout handler
Date: Mon, 04 Nov 2013 16:43:41 +0100
Message-ID: <5277C0AD.4090307@suse.de>
References: <1383224573-113346-1-git-send-email-hare@suse.de>   <1383224573-113346-3-git-send-email-hare@suse.de>   <20131031154905.GA10451@infradead.org> <5277A2C1.6020407@suse.de>  <1383575122.2485.4.camel@dabdike> <5277B346.201@suse.de> <1383576617.2485.6.camel@dabdike>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020205090506090107060309"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56509 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791Ab3KDPnn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Nov 2013 10:43:43 -0500
In-Reply-To: <1383576617.2485.6.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

This is a multi-part message in MIME format.
--------------020205090506090107060309
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

On 11/04/2013 03:50 PM, James Bottomley wrote:
> On Mon, 2013-11-04 at 15:46 +0100, Hannes Reinecke wrote:
>> On 11/04/2013 03:25 PM, James Bottomley wrote:
>>> On Mon, 2013-11-04 at 14:36 +0100, Hannes Reinecke wrote:
>>>> On 10/31/2013 04:49 PM, Christoph Hellwig wrote:
>>>>> Looks reasonable to me, but a few minor nitpicks:
>>>>>
>>>>>> +	spin_lock_irqsave(sdev->host->host_lock, flags);
>>>>>> +	if (scsi_host_eh_past_deadline(sdev->host)) {
>>>>>
>>>>> I don't have the implementation of scsi_host_eh_past_deadline in my
>>>>> local tree, but do we really need the host lock for it?
>>>>>
>>>> Yes. The eh_deadline variable might be set from an interrupt context
>>>> or from userland, so we need to protect access to it.
>>>
>>> That's not really true.  on all our supported architectures 32 bit
>>> reads/writes are atomic, which means that if one CPU writes a word at
>>> the same time another reads one, the reader is guaranteed to see either
>>> the old or the new data.  Given the expense of lock cache line bouncing
>>> on the newer architectures, we really want to avoid a spinlock where
>>> possible.
>>>
>>> In this case, the problem with the implementation is that the writer
>>> might set eh_deadline to zero, but this is fixable in
>>> scsi_host_eh_past_deadline() by checking for zero before and after the
>>> time_before (for the zero to non-zero and non-zero to zero cases).
>>>
>> IE you mean something like that attached patch?
> 
> Yes (except that there should be a comment explaining why we do the read
> twice), I think the cost of the extra read check is much less than the
> spinlock on all of our platforms.
> 
So, this is what I've ended up with; sadly I had to use 'volatile'
here which checkpatch doesn't like.
I _could_ move eh_deadline to be atomic, that would avoid the
'volatile' setting. Feels like an overkill, though.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

--------------020205090506090107060309
Content-Type: text/x-patch;
 name="0003-scsi-Unlock-accesses-to-eh_deadline.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-scsi-Unlock-accesses-to-eh_deadline.patch"

>From 283f1b50e833fad969323531ccd0ce889a5e4044 Mon Sep 17 00:00:00 2001
From: Hannes Reinecke <hare@suse.de>
Date: Mon, 4 Nov 2013 16:23:36 +0100
Subject: [PATCH 3/5] scsi: Unlock accesses to eh_deadline

32bit accesses are guaranteed to be atomic, so we can remove
the spinlock when checking for eh_deadline. We only need to
make sure to catch any updates which might happened during
the call to time_before(); if so we just recheck with the
correct value.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_error.c | 54 +++++++++++++++--------------------------------
 1 file changed, 17 insertions(+), 37 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 7eecbb5..d122e89 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -91,13 +91,26 @@ EXPORT_SYMBOL_GPL(scsi_schedule_eh);
 
 static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 {
-	if (!shost->last_reset || !shost->eh_deadline)
-		return 0;
+	volatile int eh_deadline;
 
-	if (time_before(jiffies,
-			shost->last_reset + shost->eh_deadline))
+recheck:
+	eh_deadline = shost->eh_deadline;
+	if (!shost->last_reset || !eh_deadline)
 		return 0;
 
+	/*
+	 * 32bit accesses are guaranteed to be atomic
+	 * (on all supported architectures), so instead
+	 * of using a spinlock we can as well double check
+	 * if eh_deadline has been modified after the
+	 * time_before call; if so we need to recheck
+	 * with the correct values.
+	 */
+	if (time_before(jiffies, shost->last_reset + eh_deadline)) {
+		if (eh_deadline != shost->eh_deadline)
+			goto recheck;
+		return 0;
+	}
 	return 1;
 }
 
@@ -111,18 +124,14 @@ scmd_eh_abort_handler(struct work_struct *work)
 	struct scsi_cmnd *scmd =
 		container_of(work, struct scsi_cmnd, abort_work.work);
 	struct scsi_device *sdev = scmd->device;
-	unsigned long flags;
 	int rtn;
 
-	spin_lock_irqsave(sdev->host->host_lock, flags);
 	if (scsi_host_eh_past_deadline(sdev->host)) {
-		spin_unlock_irqrestore(sdev->host->host_lock, flags);
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "scmd %p eh timeout, not aborting\n",
 				    scmd));
 	} else {
-		spin_unlock_irqrestore(sdev->host->host_lock, flags);
 		SCSI_LOG_ERROR_RECOVERY(3,
 			scmd_printk(KERN_INFO, scmd,
 				    "aborting command %p\n", scmd));
@@ -1132,7 +1141,6 @@ int scsi_eh_get_sense(struct list_head *work_q,
 	struct scsi_cmnd *scmd, *next;
 	struct Scsi_Host *shost;
 	int rtn;
-	unsigned long flags;
 
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 		if ((scmd->eh_eflags & SCSI_EH_CANCEL_CMD) ||
@@ -1140,16 +1148,13 @@ int scsi_eh_get_sense(struct list_head *work_q,
 			continue;
 
 		shost = scmd->device->host;
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_host_eh_past_deadline(shost)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
 					    "skip %s, past eh deadline\n",
 					     __func__));
 			break;
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
 		SCSI_LOG_ERROR_RECOVERY(2, scmd_printk(KERN_INFO, scmd,
 						  "%s: requesting sense\n",
 						  current->comm));
@@ -1235,26 +1240,21 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
 	struct scsi_cmnd *scmd, *next;
 	struct scsi_device *sdev;
 	int finish_cmds;
-	unsigned long flags;
 
 	while (!list_empty(cmd_list)) {
 		scmd = list_entry(cmd_list->next, struct scsi_cmnd, eh_entry);
 		sdev = scmd->device;
 
 		if (!try_stu) {
-			spin_lock_irqsave(sdev->host->host_lock, flags);
 			if (scsi_host_eh_past_deadline(sdev->host)) {
 				/* Push items back onto work_q */
 				list_splice_init(cmd_list, work_q);
-				spin_unlock_irqrestore(sdev->host->host_lock,
-						       flags);
 				SCSI_LOG_ERROR_RECOVERY(3,
 					shost_printk(KERN_INFO, sdev->host,
 						     "skip %s, past eh deadline",
 						     __func__));
 				break;
 			}
-			spin_unlock_irqrestore(sdev->host->host_lock, flags);
 		}
 
 		finish_cmds = !scsi_device_online(scmd->device) ||
@@ -1295,15 +1295,12 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 	LIST_HEAD(check_list);
 	int rtn;
 	struct Scsi_Host *shost;
-	unsigned long flags;
 
 	list_for_each_entry_safe(scmd, next, work_q, eh_entry) {
 		if (!(scmd->eh_eflags & SCSI_EH_CANCEL_CMD))
 			continue;
 		shost = scmd->device->host;
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_host_eh_past_deadline(shost)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
 			list_splice_init(&check_list, work_q);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
@@ -1311,7 +1308,6 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 					     __func__));
 			return list_empty(work_q);
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting cmd:"
 						  "0x%p\n", current->comm,
 						  scmd));
@@ -1375,19 +1371,15 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 {
 	struct scsi_cmnd *scmd, *stu_scmd, *next;
 	struct scsi_device *sdev;
-	unsigned long flags;
 
 	shost_for_each_device(sdev, shost) {
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_host_eh_past_deadline(shost)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
 					    "skip %s, past eh deadline\n",
 					     __func__));
 			break;
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
 		stu_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry)
 			if (scmd->device == sdev && SCSI_SENSE_VALID(scmd) &&
@@ -1441,20 +1433,16 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
 {
 	struct scsi_cmnd *scmd, *bdr_scmd, *next;
 	struct scsi_device *sdev;
-	unsigned long flags;
 	int rtn;
 
 	shost_for_each_device(sdev, shost) {
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_host_eh_past_deadline(shost)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
 					    "skip %s, past eh deadline\n",
 					     __func__));
 			break;
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
 		bdr_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry)
 			if (scmd->device == sdev) {
@@ -1515,11 +1503,8 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 		struct scsi_cmnd *next, *scmd;
 		int rtn;
 		unsigned int id;
-		unsigned long flags;
 
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_host_eh_past_deadline(shost)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
 			/* push back on work queue for further processing */
 			list_splice_init(&check_list, work_q);
 			list_splice_init(&tmp_list, work_q);
@@ -1529,7 +1514,6 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 					     __func__));
 			return list_empty(work_q);
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
 
 		scmd = list_entry(tmp_list.next, struct scsi_cmnd, eh_entry);
 		id = scmd_id(scmd);
@@ -1574,7 +1558,6 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 	LIST_HEAD(check_list);
 	unsigned int channel;
 	int rtn;
-	unsigned long flags;
 
 	/*
 	 * we really want to loop over the various channels, and do this on
@@ -1584,9 +1567,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 	 */
 
 	for (channel = 0; channel <= shost->max_channel; channel++) {
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_host_eh_past_deadline(shost)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
 			list_splice_init(&check_list, work_q);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
@@ -1594,7 +1575,6 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 					     __func__));
 			return list_empty(work_q);
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
 
 		chan_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry) {
-- 
1.7.12.4


--------------020205090506090107060309--
