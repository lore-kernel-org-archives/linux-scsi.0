From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] target: Make transport_lookup_cmd_lun() locking IRQ-safe
Date: Thu, 16 Jun 2011 08:18:54 -0400
Message-ID: <20110616121854.GB20081@infradead.org>
References: <1308023045-5257-1-git-send-email-roland@kernel.org>
 <20110614081259.GA10379@infradead.org>
 <1308157121.20109.23.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:35528
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756986Ab1FPMS4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2011 08:18:56 -0400
Content-Disposition: inline
In-Reply-To: <1308157121.20109.23.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Roland Dreier <roland@kernel.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Wed, Jun 15, 2011 at 09:58:41AM -0700, Nicholas A. Bellinger wrote:
> > It currently is, but I think we'd better be off stopping to call it from
> > IRQ context.  Soon after we offload the work to thread context anyway.
> > By moving the point of offloading a little earlier we can simply the
> > calling conventions a lot, and keep the amount of code that needs
> > IRQ-safe locking minimal.
> > 
> 
> The thing here is that the new descriptor can't be offloaded into thread
> context for TFO->new_cmd_map() processing until the se_cmd->se_dev
> assignment has occured, because we don't know which backend it's
> destined for.

The actual backend is pretty irrelevant.  What matters with the current
code is which se_dev it is for, but once switched to the concurrency
managed workqueues that becomes irrelevant, too.

