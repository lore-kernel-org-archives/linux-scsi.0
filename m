From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v3] use dynamically allocated sense buffer
Date: Sun, 20 Jan 2008 09:40:11 -0700
Message-ID: <20080120164010.GC27250@parisc-linux.org>
References: <20080116133217D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:48190 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754283AbYATQkM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Jan 2008 11:40:12 -0500
Content-Disposition: inline
In-Reply-To: <20080116133217D.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, linux-scsi@vger.kernel.org, tomof@acm.org

On Wed, Jan 16, 2008 at 01:32:17PM +0900, FUJITA Tomonori wrote:
> This removes static array sense_buffer in scsi_cmnd and uses
> dynamically allocated sense_buffer (with GFP_DMA).
> 
> The reason for doing this is that some architectures need cacheline
> aligned buffer for DMA:
> 
> http://lkml.org/lkml/2007/11/19/2
> 
> The problems are that scsi_eh_prep_cmnd puts scsi_cmnd::sense_buffer
> to sglist and some LLDs directly DMA to scsi_cmnd::sense_buffer. It's
> necessary to DMA to scsi_cmnd::sense_buffer safely. This patch solves
> these issues.
> 
> __scsi_get_command allocates sense_buffer via kmem_cache_alloc and
> attaches it to a scsi_cmnd so everything just work as before.

I think this is fine for the moment.

Longer-term, I want to allow low-level drivers to allocate the
sense_buffer themselves so they can DMA directly into it (ie grown-up dma
mapping, rather than this quaint x86 __GFP_DMA).  This patch doesn't get
us any closer to that, but it doesn't get us further away from it either.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
