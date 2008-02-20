From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi_scan: Convert GFP_ATOMIC to GFP_KERNEL
Date: Wed, 20 Feb 2008 13:45:37 -0600
Message-ID: <1203536737.3109.38.camel@localhost.localdomain>
References: <20080220181029.GC27736@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:58094 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757853AbYBTTpk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 20 Feb 2008 14:45:40 -0500
In-Reply-To: <20080220181029.GC27736@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org


On Wed, 2008-02-20 at 11:10 -0700, Matthew Wilcox wrote:
> There is no need to allocate this memory atomically.  There is no problem
> with sleeping during a bus scan, and it's actually causing problems
> for libata.

This bit is fine.

> Also remove the GFP_DMA flag.  If it's needed, the block layer will
> bounce-buffer it.

Just because the block layer is capable of doing it doesn't mean we
should automatically force it.  Bounce buffers are scarce resources, and
since we know they're required and we know that kmalloc allocates from
the top of its pools, and so will *always* require bouncing, doesn't it
make sense simply to save it the trouble?

James


