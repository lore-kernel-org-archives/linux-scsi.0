From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH v3] use dynamically allocated sense buffer
Date: Sun, 20 Jan 2008 21:37:41 -0700
Message-ID: <20080121043741.GF27250@parisc-linux.org>
References: <20080116133217D.fujita.tomonori@lab.ntt.co.jp> <20080120164010.GC27250@parisc-linux.org> <20080121130858G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41527 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756916AbYAUEhm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Jan 2008 23:37:42 -0500
Content-Disposition: inline
In-Reply-To: <20080121130858G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@HansenPartnership.com, bharrosh@panasas.com, linux-scsi@vger.kernel.org, tomof@acm.org

On Mon, Jan 21, 2008 at 01:08:58PM +0900, FUJITA Tomonori wrote:
> On Sun, 20 Jan 2008 09:40:11 -0700
> Matthew Wilcox <matthew@wil.cx> wrote:
> > Longer-term, I want to allow low-level drivers to allocate the
> > sense_buffer themselves so they can DMA directly into it (ie grown-up dma
> > mapping, rather than this quaint x86 __GFP_DMA).  This patch doesn't get
> 
> Yeah, I think that the approach is one of candidates.
> 
> If we go with it, I think that the major issue is that LLDs don't know
> when they can reclaim sense_buffer from scsi-ml; scsi-ml uses
> sense_buffer after scmd->scsi_done.

The midlayer would call a function in the scsi_host_template to free the
command.  The sense_buffer would be freed at the same time.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
