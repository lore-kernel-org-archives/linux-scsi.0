From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 03/11] scsi: Add IRQ_DISABLE_SCSI_QCMD wrapper
Date: Wed, 17 Nov 2010 17:27:52 -0500
Message-ID: <20101117222752.GA26760@infradead.org>
References: <1290032322-4899-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45901 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610Ab0KQW2E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 17:28:04 -0500
Content-Disposition: inline
In-Reply-To: <1290032322-4899-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>

On Wed, Nov 17, 2010 at 02:18:42PM -0800, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds a IRQ_DISABLE_SCSI_QCMD() wrapper macro used by LLDs
> that can now run in host_lock less mode, but still need interrupts disabled
> using local_irq_save() before calling their lld_queuecommand() dispatcher.
> 
> jgarzik says this method is in fact slower than doing a spin_lock_irqsave() on
> internal lib_lld_queuecommand() callers (as is done in libiscsi and libata)
> but is still needed by the majority of lock_less LLDs.

It's not an overly helpful macro.  There's no reason a driver should
ever disable irqs on it's own without actually taking a lock.  Please
invest the additional couple of minutes and do a proper conversion.

