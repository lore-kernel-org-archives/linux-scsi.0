From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Warning: sym53c8xx calls dma_free_coherent() with irqs disabled
Date: Tue, 22 Jan 2008 12:17:02 -0700
Message-ID: <20080122191702.GN27250@parisc-linux.org>
References: <4796339D.2010506@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43722 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752806AbYAVTRE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Jan 2008 14:17:04 -0500
Content-Disposition: inline
In-Reply-To: <4796339D.2010506@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jan 22, 2008 at 01:19:09PM -0500, Tony Battersby wrote:
> When unloading, sym53c8xx calls dma_free_coherent() while holding a
> spinlock (sym53c8xx_lock) with irqs disabled, which produces the
> following warning with 2.6.24:

Ugh.  I'm slightly torn.  On the one hand, it's probably possible to
fix sym_malloc.  On the other hand, it's really long past time that
sym2 dropped its custom allocator and started using dma pools.

I'll take a look at converting to dma pools once I've got half a dozen
other projects that're higher priority out of the way ;-(

In any case thanks for the report.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
