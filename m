From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 11898] mke2fs hang on AIC79 device.
Date: Wed, 05 Nov 2008 10:24:51 -0500
Message-ID: <1225898691.4703.32.camel@localhost.localdomain>
References: <20081105040154.9690A108048@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48007 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954AbYKEPZD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2008 10:25:03 -0500
In-Reply-To: <20081105040154.9690A108048@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org

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
+		starved_entry = NULL;
 		spin_unlock(shost->host_lock);
 
 		spin_lock(sdev->request_queue->queue_lock);


