From: Andrew Vasquez <praka@users.sourceforge.net>
Subject: [PATCH] qla2xxx: sleep while IRQ disabled fix in eh_abort
Date: Wed, 31 Mar 2004 22:17:40 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040401061740.GA14121@praka.local.home>
References: <opr3u0ffo7l6e53g@us.ibm.com> <20040225134518.A4238@infradead.org> <opr3xta6gbl6e53g@us.ibm.com> <1079027038.2820.57.camel@mulgrave> <opr5qwiyw4l6e53g@us.ibm.com> <406B3FDA.9010507@pobox.com> <opr5q1enb6l6e53g@us.ibm.com> <1080776399.11299.63.camel@mulgrave>
Reply-To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="FL5UXtIhxfXey3p5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ms-smtp-03-qfe0.socal.rr.com ([66.75.162.135]:22410 "EHLO
	ms-smtp-03-eri0.socal.rr.com") by vger.kernel.org with ESMTP
	id S262712AbUDAGm5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 01:42:57 -0500
Received: from praka.san.rr.com (66-75-130-8.san.rr.com [66.75.130.8])
	by ms-smtp-03-eri0.socal.rr.com (8.12.10/8.12.7) with ESMTP id i316gsUL002476
	for <linux-scsi@vger.kernel.org>; Wed, 31 Mar 2004 22:42:54 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1080776399.11299.63.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, 31 Mar 2004, James Bottomley wrote:
> On Wed, 2004-03-31 at 18:12, Dave Boutcher wrote:
> > OK, two issues.  There are a bunch of SCSI LLDDs that use this same
> > logic in abort and reset handlers to wait for adapter events to
> > complete, so I think the logic is OK.  The issue of spin_lock_irq
> > vs spin_lock is a good one...and points out that there are a bunch
> > of LLDDs that are broke :-)  I'll resubmit without the _irq
> 
> Actually, no, with the irq is correct.  Wait_for_completion will sleep,
> and sleeping with interrupts disabled is wrong.
> 

Attached is a patch which fixes a problem in qla2xxx_eh_abort() where
we incorrect use spin_unlock() before calling qla2x00_abort_command()
- which can of course sleep.

Please apply.

Thanks,
Andrew Vasquez

--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sleep_fix_eh_abort_1.diff"

===== drivers/scsi/qla2xxx/qla_os.c 1.15 vs edited =====
--- 1.15/drivers/scsi/qla2xxx/qla_os.c	Mon Mar 22 01:13:23 2004
+++ edited/drivers/scsi/qla2xxx/qla_os.c	Wed Mar 31 22:07:14 2004
@@ -1227,7 +1227,7 @@
 			sp_get(ha, sp);
 
 			spin_unlock_irqrestore(&ha->hardware_lock, flags);
-			spin_unlock(ha->host->host_lock);
+			spin_unlock_irq(ha->host->host_lock);
 
 			if (qla2x00_abort_command(ha, sp)) {
 				DEBUG2(printk("qla2xxx_eh_abort: abort_command "

--FL5UXtIhxfXey3p5--
