From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH v3] use dynamically allocated sense buffer
Date: Tue, 22 Jan 2008 13:21:47 +0900
Message-ID: <20080122132147F.fujita.tomonori@lab.ntt.co.jp>
References: <20080120164010.GC27250@parisc-linux.org>
	<20080121130858G.fujita.tomonori@lab.ntt.co.jp>
	<20080121043741.GF27250@parisc-linux.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama555.ecl.ntt.co.jp ([129.60.39.106]:53847 "EHLO
	tama555.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbYAVEWI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jan 2008 23:22:08 -0500
In-Reply-To: <20080121043741.GF27250@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, linux-scsi@vger.kernel.org, tomof@acm.org

On Sun, 20 Jan 2008 21:37:41 -0700
Matthew Wilcox <matthew@wil.cx> wrote:

> On Mon, Jan 21, 2008 at 01:08:58PM +0900, FUJITA Tomonori wrote:
> > On Sun, 20 Jan 2008 09:40:11 -0700
> > Matthew Wilcox <matthew@wil.cx> wrote:
> > > Longer-term, I want to allow low-level drivers to allocate the
> > > sense_buffer themselves so they can DMA directly into it (ie grown-up dma
> > > mapping, rather than this quaint x86 __GFP_DMA).  This patch doesn't get
> > 
> > Yeah, I think that the approach is one of candidates.
> > 
> > If we go with it, I think that the major issue is that LLDs don't know
> > when they can reclaim sense_buffer from scsi-ml; scsi-ml uses
> > sense_buffer after scmd->scsi_done.
> 
> The midlayer would call a function in the scsi_host_template to free the
> command.  The sense_buffer would be freed at the same time.

Yeah, it would work though I'm a bit concerned about adding another
phase to the scsi_cmnd interaction between the midlayer and LLDs.

Another possible option is that putting some sense_buffer information
to the host template and the midlayer allocates sense buffers for
LLDs. LLDs can ask for them when it's necessary. One disadvantage of
this is the many LLDs have sense buffer in their own data structure so
it's not fit well for these LLDs, I think.
