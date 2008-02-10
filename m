From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: scsi/arm/fas216.c compile error
Date: Sun, 10 Feb 2008 08:20:24 -0600
Message-ID: <1202653224.3136.20.camel@localhost.localdomain>
References: <20080209000413.GE6505@cs181133002.pp.htv.fi>
	 <47AEF6FD.8080801@panasas.com>
	 <20080210135851.GB25703@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:53898 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001AbYBJOU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Feb 2008 09:20:27 -0500
In-Reply-To: <20080210135851.GB25703@flint.arm.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Adrian Bunk <adrian.bunk@movial.fi>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org


On Sun, 2008-02-10 at 13:58 +0000, Russell King wrote:
> On Sun, Feb 10, 2008 at 03:07:09PM +0200, Boaz Harrosh wrote:
> > It's in mainline 84ac86ca8c6787f9efff28bc04b1b65fe0a5c310
> >   [SCSI] arm: convert to accessors and !use_sg cleanup
> > 
> > Thanks for checking. This patch was in scsi-pending tree since forever, And we were unable
> > to get a responsive maintainer to ACK on them. until the breakage cause went into mainline
> > we finally managed a Tested-by:.
> > 
> > I guess sometimes people are so busy, you need a bulldozer to shove 20 minutes into they're
> > schedule.
> 
> Oh, I was ill for most of December, particularly at the time that you
> sent the patch, and by the time I recovered, it was buried in my mailbox.
> 
> Suggest you have some consideration for others who might not be able to
> do your beg and call at the immediate moment that you want it, and
> consider that their email management skills may not be as l33t as yours.

OK, sorry about this, it's a bit of a cockup all around.  The patch that
fixes this problem is still in SCSI pending largely because it's patch
description:

    [SCSI] fas216: Use scsi_eh API for REQUEST_SENSE invocation

Doesn't lead one to think it might be build critical, so I concentrated
on getting the other arm patch out.

Russell, could you give it a quick test, and I'll put it in with a
tested-by tag?

Thanks,

James

---

From: Boaz Harrosh <bharrosh@panasas.com>
Date: Mon, 10 Sep 2007 22:39:11 +0300
Subject: [SCSI] fas216: Use scsi_eh API for REQUEST_SENSE invocation

  - Use new scsi_eh_prep/restor_cmnd() for synchronous
    REQUEST_SENSE invocation.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---
 drivers/scsi/arm/fas216.c |   16 +++-------------
 drivers/scsi/arm/fas216.h |    3 +++
 2 files changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/arm/fas216.c b/drivers/scsi/arm/fas216.c
index fb5f202..a715632 100644
--- a/drivers/scsi/arm/fas216.c
+++ b/drivers/scsi/arm/fas216.c
@@ -2018,6 +2018,7 @@ static void fas216_rq_sns_done(FAS216_Info *info, struct scsi_cmnd *SCpnt,
 	 * the upper layers to process.  This would have been set
 	 * correctly by fas216_std_done.
 	 */
+	scsi_eh_restore_cmnd(SCpnt, &info->ses);
 	SCpnt->scsi_done(SCpnt);
 }
 
@@ -2103,23 +2104,12 @@ request_sense:
 	if (SCpnt->cmnd[0] == REQUEST_SENSE)
 		goto done;
 
+	scsi_eh_prep_cmnd(SCpnt, &info->ses, NULL, 0, ~0);
 	fas216_log_target(info, LOG_CONNECT, SCpnt->device->id,
 			  "requesting sense");
-	memset(SCpnt->cmnd, 0, sizeof (SCpnt->cmnd));
-	SCpnt->cmnd[0] = REQUEST_SENSE;
-	SCpnt->cmnd[1] = SCpnt->device->lun << 5;
-	SCpnt->cmnd[4] = sizeof(SCpnt->sense_buffer);
-	SCpnt->cmd_len = COMMAND_SIZE(SCpnt->cmnd[0]);
-	SCpnt->SCp.buffer = NULL;
-	SCpnt->SCp.buffers_residual = 0;
-	SCpnt->SCp.ptr = (char *)SCpnt->sense_buffer;
-	SCpnt->SCp.this_residual = sizeof(SCpnt->sense_buffer);
-	SCpnt->SCp.phase = sizeof(SCpnt->sense_buffer);
+	init_SCp(SCpnt);
 	SCpnt->SCp.Message = 0;
 	SCpnt->SCp.Status = 0;
-	SCpnt->request_bufflen = sizeof(SCpnt->sense_buffer);
-	SCpnt->sc_data_direction = DMA_FROM_DEVICE;
-	SCpnt->use_sg = 0;
 	SCpnt->tag = 0;
 	SCpnt->host_scribble = (void *)fas216_rq_sns_done;
 
diff --git a/drivers/scsi/arm/fas216.h b/drivers/scsi/arm/fas216.h
index 00e5f05..3e73e26 100644
--- a/drivers/scsi/arm/fas216.h
+++ b/drivers/scsi/arm/fas216.h
@@ -16,6 +16,8 @@
 #define NO_IRQ 255
 #endif
 
+#include <scsi/scsi_eh.h>
+
 #include "queue.h"
 #include "msgqueue.h"
 
@@ -311,6 +313,7 @@ typedef struct {
 
 	/* miscellaneous */
 	int			internal_done;		/* flag to indicate request done */
+	struct scsi_eh_save	*ses;		/* holds request sense restore info */
 	unsigned long		magic_end;
 } FAS216_Info;
 
-- 
1.5.3.8



