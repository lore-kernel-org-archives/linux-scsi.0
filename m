From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH][SCSI] enclosure & ses: modernize and add target power
 management
Date: Sun, 19 Feb 2012 10:02:50 -0600
Message-ID: <1329667370.2806.6.camel@dabdike.int.hansenpartnership.com>
References: <CAA9_cmcgqQx4WZaWoSM=mgBAHNNZ6Y1RgZ5OwjW11qrspOcR1A@mail.gmail.com>
	 <1321028069.21400.24.camel@nebulus.xyus.xyratex.com>
	 <4EBD948E.9000104@interlog.com>
	 <FC1F9E38C0703341A1A750524E2525A9018F9648@XYUS-EX22.xyus.xyratex.com>
	 <3789993A-8AA9-4FBF-BBC0-3DD1CF1898D0@xyratex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:51279 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753873Ab2BSQCw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 19 Feb 2012 11:02:52 -0500
In-Reply-To: <3789993A-8AA9-4FBF-BBC0-3DD1CF1898D0@xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@xyratex.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, dgilbert@interlog.com

On Thu, 2012-01-12 at 12:03 -0500, Mark Salyzyn wrote:
> Coincident repair of enclosure and ses device support. Fix problems
> with setting enclosure values careful to preserve other settings.
> Corrected fault setting as well. Modernize code. Add support for
> Device Power Management via a new r/w device_power node in sysfs and
> some internal interfaces to permit them to be called in the future by
> error recovery escalation. Enclosures that do not support individual
> power management will always return a status that the device has
> power.
> 
> The controversial adjustment in this patch is the support in the ses
> driver to punch-through error recovery, a specification requirement.
> Debate could be that scsi_error.c needs to export a scsi command
> queueing interface; also a controversial subject ...

Hmm, it is controversial, but I see where it's required.  It would be
nice to export the eh interfaces for this rather than clone them,
though.

> Future: Add target device power-cycle to error recovery escalation
> before considering hba reset (tested in a libsas skunkwork on a 2.6.32
> vintage kernel)

Did you actually test this?  It won't compile for me without the
following patch because of the lack of slab.h include and the argument
problems in ->queuecommand.

James

---

diff --git a/drivers/misc/enclosure.c b/drivers/misc/enclosure.c
index 287903b..06978f8 100644
--- a/drivers/misc/enclosure.c
+++ b/drivers/misc/enclosure.c
@@ -27,6 +27,7 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/slab.h>
 
 static LIST_HEAD(container_list);
 static DEFINE_MUTEX(container_list_lock);
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 27bc0ef..c31427b 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -170,9 +170,10 @@ static int ses_scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 
 	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
 	shost->eh_action = &done;
+	scmd->scsi_done = ses_scsi_eh_done;
 
 	spin_lock_irqsave(shost->host_lock, flags);
-	shost->hostt->queuecommand(scmd, ses_scsi_eh_done);
+	shost->hostt->queuecommand(shost, scmd);
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
 	timeleft = wait_for_completion_timeout(&done, timeout);


