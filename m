From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] target: Make transport_lookup_cmd_lun() locking IRQ-safe
Date: Tue, 14 Jun 2011 04:12:59 -0400
Message-ID: <20110614081259.GA10379@infradead.org>
References: <1308023045-5257-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:41819
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886Ab1FNINC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Jun 2011 04:13:02 -0400
Content-Disposition: inline
In-Reply-To: <1308023045-5257-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Mon, Jun 13, 2011 at 08:44:05PM -0700, Roland Dreier wrote:
> From: Roland Dreier <roland@purestorage.com>
> 
> transport_lookup_cmd_lun() may be called from interrupt context (eg
> tcm_loop_allocate_core_cmd() calls it, and it has a comment that says,
> "Can be called from interrupt context"), so it needs to use
> spin_lock_irqsave() instead of spin_lock_irq() to avoid enabling
> interrupts at the wrong time.
> 
> (And indeed the last set of lock operations, on lun_cmd_lock, were
> already using spin_lock_irqsave(), so we just need to fix the other
> two locks we take)

It currently is, but I think we'd better be off stopping to call it from
IRQ context.  Soon after we offload the work to thread context anyway.
By moving the point of offloading a little earlier we can simply the
calling conventions a lot, and keep the amount of code that needs
IRQ-safe locking minimal.

