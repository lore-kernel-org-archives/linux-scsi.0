From: "Grant Grundler" <grundler@google.com>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Thu, 5 Jun 2008 22:48:13 -0700
Message-ID: <da824cf30806052248h3ac4ff21ocada15c376b399af@mail.gmail.com>
References: <20080605235322L.fujita.tomonori@lab.ntt.co.jp>
	 <da824cf30806051134u4fb8d419p2ba2dafcb1ba33a7@mail.gmail.com>
	 <1212692488.4241.8.camel@localhost.localdomain>
	 <20080606133955B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.33.17]:57317 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbYFFFsX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jun 2008 01:48:23 -0400
Received: from zps37.corp.google.com (zps37.corp.google.com [172.25.146.37])
	by smtp-out.google.com with ESMTP id m565mHJN002690
	for <linux-scsi@vger.kernel.org>; Fri, 6 Jun 2008 06:48:18 +0100
Received: from wf-out-1314.google.com (wfg24.prod.google.com [10.142.7.24])
	by zps37.corp.google.com with ESMTP id m565mHkf025594
	for <linux-scsi@vger.kernel.org>; Thu, 5 Jun 2008 22:48:17 -0700
Received: by wf-out-1314.google.com with SMTP id 24so836344wfg.2
        for <linux-scsi@vger.kernel.org>; Thu, 05 Jun 2008 22:48:17 -0700 (PDT)
In-Reply-To: <20080606133955B.fujita.tomonori@lab.ntt.co.jp>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, mgross@linux.intel.com, linux-scsi@vger.kernel.org, Alex Williamson <alex.williamson@hp.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>

On Thu, Jun 5, 2008 at 9:44 PM, FUJITA Tomonori
<fujita.tomonori@lab.ntt.co.jp> wrote:
...
> The current Intel IOMMU scheme is a bit unbalanced. It invalidates the
> translation table every time dma_unmap_* is called, but it does the
> batching of the TLB flushes. But it's what the most of Linux's IOMMU
> code does.
>
> I think that only PARISC (and IA64, of course) IOMMUs do the batching
> of invalidating the translation table entries.

1/2 correct. PARISC and IA64 could be the same in this regard but are not.
See where sba_mark_invalid() is called in the respective sba_iommu.c.
PARISC invalidates the IO Pdir entry immediately but batches the
IO TLB shootdown and resource "free". IA64 could (and probably should)
do the same. Added Alex Williamson and Bjorn Helgaas to CC list.
Not an urgent issue though unless they are doing perf measurements
with SSDs or other block device with equivalent IOPS.

Since parisc-linux is unlikely to ever run VM's and the IOMMU has a
very limited number of IO TLB entries (8 or 16 about), I'm thinking the
batching is a waste of time and parisc should follow SPARC behavior.
I'll chat more with jejb/kyle/willy about it sometime.

thanks,
grant
