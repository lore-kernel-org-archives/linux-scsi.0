From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: still BUG's for smp_processor_id() on interrupt
Date: Tue, 8 Feb 2005 22:44:35 -0800
Message-ID: <20050209064435.GA4897@plap.qlogic.org>
References: <20050209010929.GA2933@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch02.qlogic.com ([198.70.193.200]:18289 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261623AbVBIGoN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Feb 2005 01:44:13 -0500
Content-Disposition: inline
In-Reply-To: <20050209010929.GA2933@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@osdl.org>

On Tue, 08 Feb 2005, Patrick Mansfield wrote:

> I'm still getting lots of BUG's for the smp_processor_id, but via the
> interrupt function.
> 

It's during the driver's init-time polling for interrupts...

> I am running the latest bk, it has your patch to qla_os.c:
> 
> [elm3b79 qla2xxx]$ grep smp_proc qla_os.c
>         if (_smp_processor_id() == ha->last_irq_cpu || was_empty)
> 
> I'm running on a NUMAQ (sometimes has funky latencies). There are no
> errors for simple IO (dd if=/dev/sda of=/dev/null bs=64k). There are about
> 40 disk drives attached.
> 

Argg -- that was careless...  Again, the smp_processor_id() is used
only as a heuristic.  The attached patch should quash the noise.

Thanks.

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com> 

===== drivers/scsi/qla2xxx/qla_isr.c 1.23 vs edited =====
--- 1.23/drivers/scsi/qla2xxx/qla_isr.c	2005-02-04 10:24:27 -08:00
+++ edited/drivers/scsi/qla2xxx/qla_isr.c	2005-02-08 22:41:08 -08:00
@@ -91,7 +91,7 @@
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	ha->last_irq_cpu = smp_processor_id();
+	ha->last_irq_cpu = _smp_processor_id();
 	ha->total_isr_cnt++;
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
@@ -200,7 +200,7 @@
 	}
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
-	ha->last_irq_cpu = smp_processor_id();
+	ha->last_irq_cpu = _smp_processor_id();
 	ha->total_isr_cnt++;
 
 	if (test_bit(MBX_INTR_WAIT, &ha->mbx_cmd_flags) &&
