From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Wed,  5 Nov 2008 07:25:40 -0800 (PST)
Message-ID: <20081105152540.EAD3C11D10C@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52962 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751390AbYKEP0L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2008 10:26:11 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA5FPfLq017475
	for <linux-scsi@vger.kernel.org>; Wed, 5 Nov 2008 07:25:42 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #19 from anonymous@kernel-bugs.osdl.org  2008-11-05 07:25 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Tue, 2008-11-04 at 20:01 -0800, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=11898
> 
> 
> 
> 
> 
> ------- Comment #15 from alex.shi@intel.com  2008-11-04 20:01 -------
> the fix is right. and "sdev == starved_head" does not need according code
> context. so the following patch works too.
> 
> --- scsi_lib.c.orig     2008-11-04 13:07:16.000000000 -0800
> +++ scsi_lib.c  2008-11-04 13:07:38.000000000 -0800
> @@ -607,6 +607,8 @@
>                 spin_unlock(sdev->request_queue->queue_lock);
> 
>                 spin_lock(shost->host_lock);
> +               if (list_empty(&sdev->starved_entry) ) 
> +                       starved_head = NULL; 
>         }
>         spin_unlock_irqrestore(shost->host_lock, flags);

Actually, no.  The correct patch is below.

The reason for doing it like this is so that if someone slices the loop
apart again (which is how this crept in) they won't get a continue or
something which allows this to happen.

It shouldn't be conditional on the starved list (or anything else)
because it's probably a register and should happen at the same point as
the list deletion but before we drop the problem lock (because once we
drop that lock we'll need to recompute starvation).

James

---

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f5d3b96..f9a531f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -606,6 +606,7 @@ static void scsi_run_queue(struct request_queue *q)
                }

                list_del_init(&sdev->starved_entry);
+               starved_entry = NULL;
                spin_unlock(shost->host_lock);

                spin_lock(sdev->request_queue->queue_lock);


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
