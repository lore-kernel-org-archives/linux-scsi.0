From: Andrew Vasquez <praka@san.rr.com>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b2).
Date: Wed, 28 May 2003 23:19:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030529061913.GA27199@praka.local.home>
References: <20030519225728.GA17279@praka.local.home> <20030521173215.GA25137@praka.local.home> <20030521222635.GB21124@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from orngca-mls01.socal.rr.com ([66.75.160.16]:62198 "EHLO
	orngca-mls01.socal.rr.com") by vger.kernel.org with ESMTP
	id S261923AbTE2GMj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 29 May 2003 02:12:39 -0400
Received: from san.rr.com (66-75-128-22.san.rr.com [66.75.128.22])
	by orngca-mls01.socal.rr.com (8.11.4/8.11.3) with ESMTP id h4T6NGV25394
	for <linux-scsi@vger.kernel.org>; Wed, 28 May 2003 23:23:17 -0700 (PDT)
Received: from san.rr.com (localhost [127.0.0.1])
	by san.rr.com (8.12.3/8.12.3/SuSE Linux 0.6) with ESMTP id h4T6JDjW027340
	for <linux-scsi@vger.kernel.org>; Wed, 28 May 2003 23:19:13 -0700
Received: (from praka@localhost)
	by san.rr.com (8.12.3/8.12.3/Submit) id h4T6JDHJ027339
	for linux-scsi@vger.kernel.org; Wed, 28 May 2003 23:19:13 -0700
Content-Disposition: inline
In-Reply-To: <20030521222635.GB21124@krispykreme>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Thu, 22 May 2003, Anton Blanchard wrote:

> > +#if MEMORY_MAPPED_IO
> > +	/* Get memory mapped I/O address */
> > +	pci_read_config_dword(ha->pdev, PCI_BASE_ADDRESS_1, &mmapbase);
> 
> You really want to be using pci_resource_start(ha->pdev, 1) so it will
> work on architectures like ppc64 and sparc64.
> 

You're correct -- code updated in my tree.

> > +	mmapbase &= PCI_BASE_ADDRESS_MEM_MASK;
> > +
> > +	/* Find proper memory chunk for memory map I/O reg */
> > +	base = mmapbase & PAGE_MASK;
> > +	page_offset = mmapbase - base;
> 
> Is that correct?
> 

The 'mmapbase &= PCI_BASE_ADDRESS_MEM_MASK' does appear to be
incorrect, yet, I just have one question.  it seems several drivers
(i.e. sym53c8xx_2, aic7xxx) ensure the memory-mapped resource begins
on a page boundary before passing it onto ioremap().  Yet, in the code
for __ioremap(), (arch/i386/mm/ioremap.c) there is this small comment:

	/*
	 * NOTE! We need to allow non-page-aligned mappings too: we
	 * will obviously have to convert them into an offset in a
	 * page-aligned mapping, but the caller shouldn't need to know
	 * that small detail.
	 *
	 */

Is it safe to assume *all* platforms will handle this case internally,
or should drivers perform the pre-process?

BTW: appearantly none of my emails sent via my QLogic account have
made it to linux-[kernel|scsi] in the past week -- I'm working with IT
to solve the problem - please be patient with the response time lags.

Thanks,
Andrew Vasquez
