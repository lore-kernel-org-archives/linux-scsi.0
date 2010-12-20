From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 02/12] scsi: Add IRQ_DISABLE_SCSI_QCMD wrapper
Date: Mon, 20 Dec 2010 11:48:20 +0100
Message-ID: <20101220104820.GA2752@lst.de>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org> <1292793727-31957-3-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1292793727-31957-3-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@suse.de>, Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Mike Anderson <andmike@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>, Vasu Dev <vasu.dev@linux.intel.com>, Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>, Ravi Anand <ravi.anand@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Joe Eykholt <jeykholt@cisco.com>, James Smart <james.smart@emulex.com>, Douglas Gilbert <dgilbert@interlog.com>, adam radford <aradford@gmail.com>, Kashyap Desai <Kashyap.Desai@lsi.com>, MPTFusionLinux <DL-MPTFusionLinux@lsi.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 19, 2010 at 01:21:57PM -0800, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
> 
> This patch adds a IRQ_DISABLE_SCSI_QCMD() wrapper macro used by LLDs
> that can now run in host_lock less mode, but still need interrupts disabled
> using local_irq_save() before calling their lld_queuecommand() dispatcher.
> 
> jgarzik says this method is in fact slower than doing a spin_lock_irqsave() on
> internal lib_lld_queuecommand() callers (as is done in libiscsi and libata)
> but is still needed by the majority of lock_less LLDs.

As mentioned before, please don't add more macro obsfucation - The
initial one Jeff added was ok for the quick transition and avoiding to
have two methods, but any additional one is not helpful.

In addition there's really no reason to every use this one.  There is
not reason to disable local irqs in a driver without taking a spinlock.
