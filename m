From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Tue, 11 Nov 2008 11:43:20 -0800 (PST)
Message-ID: <20081111194320.656FB108058@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750929AbYKKToS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Nov 2008 14:44:18 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mABJhlYo010150
	for <linux-scsi@vger.kernel.org>; Tue, 11 Nov 2008 11:43:48 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #36 from anonymous@kernel-bugs.osdl.org  2008-11-11 11:43 -------
Reply-To: michaelc@cs.wisc.edu

Mike Christie wrote:
> I can sort of replicate this now. Let me do some testing on the changes 
> and I will submit something in a minute.

I do not think I am replicating the original problem. The attached patch 
should fix the oops in James's splice use patch though.
Close possible infinite loop when devices are added back to the
starved list.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f5d3b96..fa45a1a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -567,15 +567,18 @@ static inline int scsi_host_is_busy(struct Scsi_Host
*shost)
  */
 static void scsi_run_queue(struct request_queue *q)
 {
-       struct scsi_device *starved_head = NULL, *sdev = q->queuedata;
+       struct scsi_device *sdev = q->queuedata;
        struct Scsi_Host *shost = sdev->host;
+       LIST_HEAD(starved_list);
        unsigned long flags;

        if (scsi_target(sdev)->single_lun)
                scsi_single_lun_run(sdev);

        spin_lock_irqsave(shost->host_lock, flags);
-       while (!list_empty(&shost->starved_list) && !scsi_host_is_busy(shost))
{
+       list_splice_init(&shost->starved_list, &starved_list);
+
+       while (!list_empty(&starved_list)) {
                int flagset;

                /*
@@ -588,24 +591,18 @@ static void scsi_run_queue(struct request_queue *q)
                 * scsi_request_fn must get the host_lock before checking
                 * or modifying starved_list or starved_entry.
                 */
-               sdev = list_entry(shost->starved_list.next,
-                                         struct scsi_device, starved_entry);
-               /*
-                * The *queue_ready functions can add a device back onto the
-                * starved list's tail, so we must check for a infinite loop.
-                */
-               if (sdev == starved_head)
+               if (scsi_host_is_busy(shost))
                        break;
-               if (!starved_head)
-                       starved_head = sdev;

+               sdev = list_entry(starved_list.next,
+                                 struct scsi_device, starved_entry);
+               list_del_init(&sdev->starved_entry);
                if (scsi_target_is_busy(scsi_target(sdev))) {
                        list_move_tail(&sdev->starved_entry,
                                       &shost->starved_list);
                        continue;
                }

-               list_del_init(&sdev->starved_entry);
                spin_unlock(shost->host_lock);

                spin_lock(sdev->request_queue->queue_lock);
@@ -621,6 +618,8 @@ static void scsi_run_queue(struct request_queue *q)

                spin_lock(shost->host_lock);
        }
+       /* put any unprocessed entries back */
+       list_splice(&starved_list, &shost->starved_list);
        spin_unlock_irqrestore(shost->host_lock, flags);

        blk_run_queue(q);


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
