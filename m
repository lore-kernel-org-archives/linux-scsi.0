From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: qla2xxx lock ordering question
Date: Fri, 28 Apr 2006 15:29:30 -0700
Message-ID: <20060428222930.GC18838@andrew-vasquezs-powerbook-g4-15.local>
References: <1145438524.3085.19.camel@laptopd505.fenrus.org> <20060420234606.GO8514@andrew-vasquezs-powerbook-g4-15.local> <1146127792.2894.24.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:18059 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1751787AbWD1W3c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Apr 2006 18:29:32 -0400
Content-Disposition: inline
In-Reply-To: <1146127792.2894.24.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: mingo@elte.hu, linux-scsi@vger.kernel.org

On Thu, 27 Apr 2006, Arjan van de Ven wrote:

> On Thu, 2006-04-20 at 16:46 -0700, Andrew Vasquez wrote:
> > On Wed, 19 Apr 2006, Arjan van de Ven wrote:
> > 
> > > a question about qla2xxx lock ordering since it trips up with Ingo's
> > > lock depenceny tool:
> > > 
> > > in qla2x00_mailbox_command() the code first grabs the mbx_reg_lock lock,
> > > then the hardware_lock. So far so good. But then...
> > > it drops the mbx_reg_lock, does stuff, and regrabs the mbx_reg_lock
> > > lock, while keeping the hardware_lock held!
> > > 
> > > This appears to be an AB-BA deadlock risk since for the second part you
> > > are taking the locks in the wrong order... or am I missing something
> > > here?
> > 
> > Actually the code is a bit convoluted, but I believe we are OK.  There
> > are two scenarios we need to consider:
> 
> 
> ok found the real culprits ;)
> 
> in qla2x00_reset_chip the driver first takes the hardware lock, and then
> later on takes the mbx lock.
> 
> In the mailbox_command code.. it goes the other way around.

Ahh yes... that is suspicious...

> Now I don't know if reset_chip can in theory race with the mailbox code,
> but I'd not be surprised since reset_chip is called in error recovery
> iirc...

ISP chip recovery (resulting in a subsequent call to
qla2x00_reset_chip()) can only take place from the DPC thread context
(that at least drops most of mailbox command initiators, since we are
single threaded).  But, we are still left with mid-layer
error-handling initiators of mailbox commands (abort, device reset and
loop reset).

Hmm...  we do have a small window there where we could race.  In going
through the locking hierarchy though, I'm not entirely convinced
taking the mbx_reg_lock while resetting is needed as it's only meant
to protect an HA's mbx_cmd_flags state; which is only set during
interrupt processing (after we've released the hardware_lock).  The
reset-chip code has also disabled interrupts, further reducing the
window...

I'll do some testing with the following patch which drops the
acquisition of mbx_reg_lock.  Baring any major objections locally,
I'll post a formal patch to ls next week.

BTW: cool tool.

Thanks,
Andrew Vasquez

---

diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 89a3fc0..7dc4067 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -519,20 +519,8 @@ qla2x00_reset_chip(scsi_qla_host_t *ha)
 
 	if (IS_QLA2100(ha) || IS_QLA2200(ha) || IS_QLA2300(ha)) {
 		for (cnt = 0; cnt < 30000; cnt++) {
-			if (!(test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags)))
-				spin_lock_irqsave(&ha->mbx_reg_lock, mbx_flags);
-
-			if (RD_MAILBOX_REG(ha, reg, 0) != MBS_BUSY) {
-				if (!(test_bit(ABORT_ISP_ACTIVE,
-				    &ha->dpc_flags)))
-					spin_unlock_irqrestore(
-					    &ha->mbx_reg_lock, mbx_flags);
+			if (RD_MAILBOX_REG(ha, reg, 0) != MBS_BUSY)
 				break;
-			}
-
-			if (!(test_bit(ABORT_ISP_ACTIVE, &ha->dpc_flags)))
-				spin_unlock_irqrestore(&ha->mbx_reg_lock,
-				    mbx_flags);
 
 			udelay(100);
 		}

> 

