From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Fw: [Bugme-new] [Bug 4166] New: BUG: using smp_processor_id() in preemptible [00000001] code: nfsd/2783
Date: Mon, 7 Feb 2005 15:41:19 -0800
Message-ID: <20050207234119.GA13400@plap.qlogic.org>
References: <20050204134809.2d341367.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch02.qlogic.com ([198.70.193.200]:29786 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261322AbVBGXk7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2005 18:40:59 -0500
Content-Disposition: inline
In-Reply-To: <20050204134809.2d341367.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Fri, 04 Feb 2005, Andrew Morton wrote:

> It looks like qla2x00_queuecommand()'s use of smp_processor_id() is
> just a heuristic, in which case it should be sufficient to simply
> use _smp_processor_id() to quash the warning.
> 

Hmm, this was also reported by another customer on Friday -- hopefully
the attached patch can make it in by 2.6.11...

Hopeully once the dust settles with the transport stuffs, a bulk of
this code can be removed...

Thanks,
AV

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>

===== drivers/scsi/qla2xxx/qla_os.c 1.53 vs edited =====
--- 1.53/drivers/scsi/qla2xxx/qla_os.c	2004-12-08 22:15:37 -08:00
+++ edited/drivers/scsi/qla2xxx/qla_os.c	2005-02-07 16:03:51 -08:00
@@ -859,7 +859,7 @@
 	 * In all other cases we'll let an irq pick up our IO and submit it
 	 * to the controller to improve affinity.
 	 */
-	if (smp_processor_id() == ha->last_irq_cpu || was_empty)
+	if (_smp_processor_id() == ha->last_irq_cpu || was_empty)
 		qla2x00_next(ha);
 
 	spin_lock_irq(ha->host->host_lock);
