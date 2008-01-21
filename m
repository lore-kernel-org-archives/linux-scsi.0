From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v3] use dynamically allocated sense buffer
Date: Mon, 21 Jan 2008 13:08:58 +0900
Message-ID: <20080121130858G.fujita.tomonori@lab.ntt.co.jp>
References: <20080116133217D.fujita.tomonori@lab.ntt.co.jp>
	<20080120164010.GC27250@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama50.ecl.ntt.co.jp ([129.60.39.147]:47016 "EHLO
	tama50.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756448AbYAUEJO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Jan 2008 23:09:14 -0500
In-Reply-To: <20080120164010.GC27250@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, linux-scsi@vger.kernel.org, tomof@acm.org

On Sun, 20 Jan 2008 09:40:11 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Wed, Jan 16, 2008 at 01:32:17PM +0900, FUJITA Tomonori wrote:
> > This removes static array sense_buffer in scsi_cmnd and uses
> > dynamically allocated sense_buffer (with GFP_DMA).
> > 
> > The reason for doing this is that some architectures need cacheline
> > aligned buffer for DMA:
> > 
> > http://lkml.org/lkml/2007/11/19/2
> > 
> > The problems are that scsi_eh_prep_cmnd puts scsi_cmnd::sense_buffer
> > to sglist and some LLDs directly DMA to scsi_cmnd::sense_buffer. It's
> > necessary to DMA to scsi_cmnd::sense_buffer safely. This patch solves
> > these issues.
> > 
> > __scsi_get_command allocates sense_buffer via kmem_cache_alloc and
> > attaches it to a scsi_cmnd so everything just work as before.
> 
> I think this is fine for the moment.
> 
> Longer-term, I want to allow low-level drivers to allocate the
> sense_buffer themselves so they can DMA directly into it (ie grown-up dma
> mapping, rather than this quaint x86 __GFP_DMA).  This patch doesn't get

Yeah, I think that the approach is one of candidates.

If we go with it, I think that the major issue is that LLDs don't know
when they can reclaim sense_buffer from scsi-ml; scsi-ml uses
sense_buffer after scmd->scsi_done.


> us any closer to that, but it doesn't get us further away from it either.
