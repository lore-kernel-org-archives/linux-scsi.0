From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] scsi: improved eh timeout handler
Date: Mon, 04 Nov 2013 15:46:30 +0100
Message-ID: <5277B346.201@suse.de>
References: <1383224573-113346-1-git-send-email-hare@suse.de>  <1383224573-113346-3-git-send-email-hare@suse.de>  <20131031154905.GA10451@infradead.org> <5277A2C1.6020407@suse.de> <1383575122.2485.4.camel@dabdike>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090100020109050500060206"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632Ab3KDOqg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Nov 2013 09:46:36 -0500
In-Reply-To: <1383575122.2485.4.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

This is a multi-part message in MIME format.
--------------090100020109050500060206
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit

On 11/04/2013 03:25 PM, James Bottomley wrote:
> On Mon, 2013-11-04 at 14:36 +0100, Hannes Reinecke wrote:
>> On 10/31/2013 04:49 PM, Christoph Hellwig wrote:
>>> Looks reasonable to me, but a few minor nitpicks:
>>>
>>>> +	spin_lock_irqsave(sdev->host->host_lock, flags);
>>>> +	if (scsi_host_eh_past_deadline(sdev->host)) {
>>>
>>> I don't have the implementation of scsi_host_eh_past_deadline in my
>>> local tree, but do we really need the host lock for it?
>>>
>> Yes. The eh_deadline variable might be set from an interrupt context
>> or from userland, so we need to protect access to it.
> 
> That's not really true.  on all our supported architectures 32 bit
> reads/writes are atomic, which means that if one CPU writes a word at
> the same time another reads one, the reader is guaranteed to see either
> the old or the new data.  Given the expense of lock cache line bouncing
> on the newer architectures, we really want to avoid a spinlock where
> possible.
> 
> In this case, the problem with the implementation is that the writer
> might set eh_deadline to zero, but this is fixable in
> scsi_host_eh_past_deadline() by checking for zero before and after the
> time_before (for the zero to non-zero and non-zero to zero cases).
> 
IE you mean something like that attached patch?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)

--------------090100020109050500060206
Content-Type: text/x-patch;
 name="tmp-eh-unlock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="tmp-eh-unlock.patch"

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 6a137fa..8abf7ba 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -94,8 +94,10 @@ static int scsi_host_eh_past_deadline(struct Scsi_Host *shost)
 	if (!shost->last_reset || !shost->eh_deadline)
 		return 0;
 
+	/* Double check eh_deadline to catch atomic updates */
 	if (time_before(jiffies,
-			shost->last_reset + shost->eh_deadline))
+			shost->last_reset + shost->eh_deadline) &&
+	    shost->eh_deadline)
 		return 0;
 
 	return 1;
@@ -114,15 +116,12 @@ scmd_eh_abort_handler(struct work_struct *work)
 	unsigned long flags;
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
@@ -1140,16 +1139,13 @@ int scsi_eh_get_sense(struct list_head *work_q,
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
@@ -1242,19 +1238,15 @@ static int scsi_eh_test_devices(struct list_head *cmd_list,
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
@@ -1301,9 +1293,7 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 		if (!(scmd->eh_eflags & SCSI_EH_CANCEL_CMD))
 			continue;
 		shost = scmd->device->host;
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_host_eh_past_deadline(shost)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
 			list_splice_init(&check_list, work_q);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
@@ -1311,7 +1301,6 @@ static int scsi_eh_abort_cmds(struct list_head *work_q,
 					     __func__));
 			return list_empty(work_q);
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
 		SCSI_LOG_ERROR_RECOVERY(3, printk("%s: aborting cmd:"
 						  "0x%p\n", current->comm,
 						  scmd));
@@ -1378,16 +1367,13 @@ static int scsi_eh_stu(struct Scsi_Host *shost,
 	unsigned long flags;
 
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
@@ -1445,16 +1431,13 @@ static int scsi_eh_bus_device_reset(struct Scsi_Host *shost,
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
@@ -1517,9 +1500,7 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 		unsigned int id;
 		unsigned long flags;
 
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_host_eh_past_deadline(shost)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
 			/* push back on work queue for further processing */
 			list_splice_init(&check_list, work_q);
 			list_splice_init(&tmp_list, work_q);
@@ -1529,7 +1510,6 @@ static int scsi_eh_target_reset(struct Scsi_Host *shost,
 					     __func__));
 			return list_empty(work_q);
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
 
 		scmd = list_entry(tmp_list.next, struct scsi_cmnd, eh_entry);
 		id = scmd_id(scmd);
@@ -1584,9 +1564,7 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 	 */
 
 	for (channel = 0; channel <= shost->max_channel; channel++) {
-		spin_lock_irqsave(shost->host_lock, flags);
 		if (scsi_host_eh_past_deadline(shost)) {
-			spin_unlock_irqrestore(shost->host_lock, flags);
 			list_splice_init(&check_list, work_q);
 			SCSI_LOG_ERROR_RECOVERY(3,
 				shost_printk(KERN_INFO, shost,
@@ -1594,7 +1572,6 @@ static int scsi_eh_bus_reset(struct Scsi_Host *shost,
 					     __func__));
 			return list_empty(work_q);
 		}
-		spin_unlock_irqrestore(shost->host_lock, flags);
 
 		chan_scmd = NULL;
 		list_for_each_entry(scmd, work_q, eh_entry) {

--------------090100020109050500060206--
