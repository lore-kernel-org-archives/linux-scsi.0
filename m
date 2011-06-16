From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] target: Make transport_lookup_cmd_lun() locking IRQ-safe
Date: Thu, 16 Jun 2011 08:15:40 -0400
Message-ID: <20110616121540.GA20081@infradead.org>
References: <1308023045-5257-1-git-send-email-roland@kernel.org>
 <20110614081259.GA10379@infradead.org>
 <BANLkTin9U47ej2eR2ns7-=T-QHrRw=-t_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38067
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757719Ab1FPMPm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Jun 2011 08:15:42 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTin9U47ej2eR2ns7-=T-QHrRw=-t_Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Tue, Jun 14, 2011 at 08:58:57AM -0700, Roland Dreier wrote:
> Fair enough... however that seems like a much more major project,
> as eg the qla2xxx code does a fair bit from interrupt context.

Yes, just pointing out in which direction it should go eventually.

> 
> Also it seems even if we are running from thread context it would
> be legitimate for a target driver to do
> 
>     spin_lock_irq(&internal_target_lock);
>     ...
>     transport_lookup_cmd_lun();
>     ...
>     spin_unlock_irq
> 
> and so transport_lookup_cmd_lun() shouldn't be reenabling IRQs
> unconditionally.

Yes.  At that point we shouldn't require any irq locking, making life
even easier.

