From: Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH] SCSI: Replace semaphore with completion
Date: Wed, 20 Oct 2004 21:31:39 +0200
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <1098300699.20821.68.camel@thomas>
Reply-To: tglx@linutronix.de
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S269007AbUJUGiz@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Ingo Molnar <mingo@elte.hu>, SCSI <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>
List-Id: linux-scsi@vger.kernel.org


Use completion instead of semaphore

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ingo Molnar <mingo@elte.hu>
---

 2.6.9-bk-041020-thomas/drivers/scsi/sym53c8xx_2/sym_glue.c |    8
++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/scsi/sym53c8xx_2/sym_glue.c~sym53c8xx
drivers/scsi/sym53c8xx_2/sym_glue.c
---
2.6.9-bk-041020/drivers/scsi/sym53c8xx_2/sym_glue.c~sym53c8xx	2004-10-20
16:04:34.000000000 +0200
+++
2.6.9-bk-041020-thomas/drivers/scsi/sym53c8xx_2/sym_glue.c	2004-10-20
16:04:50.000000000 +0200
@@ -135,7 +135,7 @@ m_addr_t __vtobus(m_pool_ident_t dev_dma
  *  It is allocated on the eh thread stack.
  */
 struct sym_eh_wait {
-	struct semaphore sem;
+	struct completion done;
 	struct timer_list timer;
 	void (*old_done)(struct scsi_cmnd *);
 	int to_do;
@@ -798,7 +798,7 @@ static void __sym_eh_done(struct scsi_cm
 
 	/* Wake up the eh thread if it wants to sleep */
 	if (ep->to_do == SYM_EH_DO_WAIT)
-		up(&ep->sem);
+		complete(&ep->done);
 }
 
 /*
@@ -858,7 +858,7 @@ prepare:
 	case SYM_EH_DO_IGNORE:
 		break;
 	case SYM_EH_DO_WAIT:
-		init_MUTEX_LOCKED(&ep->sem);
+		init_completion(&ep->done);
 		/* fall through */
 	case SYM_EH_DO_COMPLETE:
 		ep->old_done = cmd->scsi_done;
@@ -909,7 +909,7 @@ prepare:
 		ep->timed_out = 1;	/* Be pessimistic for once :) */
 		add_timer(&ep->timer);
 		spin_unlock_irq(np->s.host->host_lock);
-		down(&ep->sem);
+		wait_for_completion(&ep->done);
 		spin_lock_irq(np->s.host->host_lock);
 		if (ep->timed_out)
 			sts = -2;
_
