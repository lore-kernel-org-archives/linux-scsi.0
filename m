From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: Fw: [Bugme-new] [Bug 4166] New: BUG: using smp_processor_id() in preemptible [00000001] code: nfsd/2783
Date: Mon, 7 Feb 2005 16:08:30 -0800
Message-ID: <20050208000830.GA13631@plap.qlogic.org>
References: <20050204134809.2d341367.akpm@osdl.org> <20050207234119.GA13400@plap.qlogic.org> <20050207160056.0c50305e.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from avexch02.qlogic.com ([198.70.193.200]:4187 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261346AbVBHAIK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 7 Feb 2005 19:08:10 -0500
Content-Disposition: inline
In-Reply-To: <20050207160056.0c50305e.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

On Mon, 07 Feb 2005, Andrew Morton wrote:

> Andrew Vasquez <andrew.vasquez@qlogic.com> wrote:
> >
> > -	if (smp_processor_id() == ha->last_irq_cpu || was_empty)
> > +	if (_smp_processor_id() == ha->last_irq_cpu || was_empty)
> 
> Am I correct in assuming that if we are preempted, and if
> _smp_processor_id() returns the wrong number, the driver will continue to
> function correctly?  And that we simply missed a little optimisation
> opportunity?

Yes, the driver will continue to operate correctly.  Another
suggestion made was to explicitly disable/enable preemption around the
'if' statement.  The s/smp_processor_id/_smp_processor_id/ seemed like
the least intrusive option in the interim...

-- 
Andrew Vasquez
