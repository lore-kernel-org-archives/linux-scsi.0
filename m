From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 03/11] scsi: Add IRQ_DISABLE_SCSI_QCMD wrapper
Date: Wed, 17 Nov 2010 14:29:30 -0800
Message-ID: <1290032970.31890.61.camel@haakon2.linux-iscsi.org>
References: <1290032322-4899-1-git-send-email-nab@linux-iscsi.org>
	 <20101117222752.GA26760@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:42478 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935512Ab0KQWex (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Nov 2010 17:34:53 -0500
In-Reply-To: <20101117222752.GA26760@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@suse.de>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Tejun Heo <tj@kernel.org>, Mike Anderson <andmike@linux.vnet.ibm.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>

On Wed, 2010-11-17 at 17:27 -0500, Christoph Hellwig wrote:
> On Wed, Nov 17, 2010 at 02:18:42PM -0800, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds a IRQ_DISABLE_SCSI_QCMD() wrapper macro used by LLDs
> > that can now run in host_lock less mode, but still need interrupts disabled
> > using local_irq_save() before calling their lld_queuecommand() dispatcher.
> > 
> > jgarzik says this method is in fact slower than doing a spin_lock_irqsave() on
> > internal lib_lld_queuecommand() callers (as is done in libiscsi and libata)
> > but is still needed by the majority of lock_less LLDs.
> 
> It's not an overly helpful macro.  There's no reason a driver should
> ever disable irqs on it's own without actually taking a lock.  Please
> invest the additional couple of minutes and do a proper conversion.
> 

Hmmm, this is following jgarzik's recommendation for LLDs that we could
not immediately identify a internal spin_lock to disable interrupts
upon.  (eg: not libiscsi and libata).

--nab


