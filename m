From: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Resolved a performance issue in interrupt
 handler
Date: Tue, 9 Jun 2009 14:40:44 -0700 (PDT)
Message-ID: <alpine.OSX.1.00.0906091436120.4405@ac-mac.local>
References: <alpine.OSX.1.00.0906091107470.3891@ac-mac.local>  <1244575944.12321.58.camel@mulgrave.site>  <19C9538E-B7B2-4924-859F-37E56660D95E@qlogic.com> <1244580029.12321.138.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:46278 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbZFIVky (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2009 17:40:54 -0400
In-Reply-To: <1244580029.12321.138.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Anirban Chakraborty <anirban.chakraborty@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "douglas.w.styner@intel.com" <douglas.w.styner@intel.com>



On Tue, 9 Jun 2009, James Bottomley wrote:

> On Tue, 2009-06-09 at 13:34 -0700, Anirban Chakraborty wrote:
> > On Jun 9, 2009, at 12:32 PM, James Bottomley wrote:
> > 
> > > On Tue, 2009-06-09 at 11:42 -0700, Anirban Chakraborty wrote:
> > >> Reverted back a change from spin_lock to spin_lock_irq* that was  
> > >> causing
> > >> the cycle times to go up.
> > >> The patch is based on scsi-misc-2.6.
> > >
> > > Some more explanation of this would be greatly appreciated.  The cause
> > > looks to be that holding off interrupts in the isr could potentially
> > > reduce latency (caused by taking a different interrupt while holding  
> > > the
> > > hardware lock) and increase the chance of coalescing (by holding off
> > > interrupts).  However, if that's the case, possibly using an
> > > IRQF_DISABLED isr rather than going back to spin_lock_irqsave()  
> > > would be
> > > a better fix?
> > The primary cause is, as you mentioned, the contention for the  
> > hardware lock in the isr.
> > I'll check it with IRQF_DISABLED too. However, I was wondering if  
> > there is any additional savings if we use IRQF_DISABLED vs. using the  
> > spin_lock_irqsave. In the former case, probably we'd enter the isr  
> > with interrupts disabled and in the latter case it would be done upon  
> > entering the isr.
> 
> It depends what the root cause is ... if it's really latency introduced
> by other interrupts, then IRQF_DISABLED might be the better course.  If
> it's purely interrupt problems in the spin locked critical sections,
> then spin_lock_irq might be the better solution ... what would be useful
> is to have the test rig at intel which turned up the problem see what
> happens to the results for each case.
> 
> James

I have attached the patch with IRQF_DISABLED. In my setup, I didn't find any 
significant difference in performance numbers between IRQF_DISABLED and 
spin_lock_irqsave. It would be interesting to see the numbers from Douglas's 
rig.
Doug, could you please run it once more with this patch and let us know the 
numbers vs. the one you already tested with spin_lock_irqsave earlier.
Thanks much,
Anirban

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index c8d0a17..d07bd97 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1991,7 +1991,7 @@ skip_msix:
 skip_msi:
 
 	ret = request_irq(ha->pdev->irq, ha->isp_ops->intr_handler,
-	    IRQF_SHARED, QLA2XXX_DRIVER_NAME, rsp);
+	    IRQF_DISABLED, QLA2XXX_DRIVER_NAME, rsp);
 	if (ret) {
 		qla_printk(KERN_WARNING, ha,
 		    "Failed to reserve interrupt %d already in use.\n",
