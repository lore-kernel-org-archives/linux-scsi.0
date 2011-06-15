From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] target: Make transport_lookup_cmd_lun() locking
	IRQ-safe
Date: Wed, 15 Jun 2011 09:58:41 -0700
Message-ID: <1308157121.20109.23.camel@haakon2.linux-iscsi.org>
References: <1308023045-5257-1-git-send-email-roland@kernel.org>
	 <20110614081259.GA10379@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41170 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461Ab1FORH0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jun 2011 13:07:26 -0400
In-Reply-To: <20110614081259.GA10379@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Roland Dreier <roland@kernel.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Tue, 2011-06-14 at 04:12 -0400, Christoph Hellwig wrote:
> On Mon, Jun 13, 2011 at 08:44:05PM -0700, Roland Dreier wrote:
> > From: Roland Dreier <roland@purestorage.com>
> > 
> > transport_lookup_cmd_lun() may be called from interrupt context (eg
> > tcm_loop_allocate_core_cmd() calls it, and it has a comment that says,
> > "Can be called from interrupt context"), so it needs to use
> > spin_lock_irqsave() instead of spin_lock_irq() to avoid enabling
> > interrupts at the wrong time.
> > 
> > (And indeed the last set of lock operations, on lun_cmd_lock, were
> > already using spin_lock_irqsave(), so we just need to fix the other
> > two locks we take)
> 
> It currently is, but I think we'd better be off stopping to call it from
> IRQ context.  Soon after we offload the work to thread context anyway.
> By moving the point of offloading a little earlier we can simply the
> calling conventions a lot, and keep the amount of code that needs
> IRQ-safe locking minimal.
> 

The thing here is that the new descriptor can't be offloaded into thread
context for TFO->new_cmd_map() processing until the se_cmd->se_dev
assignment has occured, because we don't know which backend it's
destined for.

So, I think we at least need this patch..

--nab


