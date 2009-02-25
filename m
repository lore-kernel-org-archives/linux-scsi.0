From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 1/11] mpt2sas: mpt2sas_base sources
Date: Wed, 25 Feb 2009 15:12:33 -0700
Message-ID: <660360F4F2570145BD872F298951B17A7673CBAA@cosmail03.lsi.com>
References: <20090225211224.GW16891@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og107.obsmtp.com ([64.18.2.167]:49239 "EHLO
	exprod7og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbZBYWNG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Feb 2009 17:13:06 -0500
In-Reply-To: <20090225211224.GW16891@parisc-linux.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Grant Grundler <grundler@google.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wednesday, February 25, 2009 2:12 PM, Matthew Wilcox wrote:
are visible before sending out the writel().
> > 
> > I'm doing is a 64bit write to pcie memory. On some systems 
> this is broken out to two 32bit writes.  So I put the barrier 
> there to insure the entire 64bits was written out to the 
> ReplyPostHostIndex register before another write was done.   
> Um, you're doing a writel(), not a writeq(), so you're doing a 32-bit
> write.  Also, PCI writes can't be reordered, so you don't 
> need a wmb() here.

my mistake, I meant 32bit write.   I was thinking about another place where I do 64bit writeq.

> 
> It's also worth considering a mode where each CPU gets its own
> interrupt.  That lets us complete IOs on the CPU which submitted them
> and can be a real performance win.

right, I was wondering if we could do that.   Perhaps we could discuss that further in how do to that.

> 
> I'm somewhat puzzled that you request four MSI-X interrupts, then only
> use one of them.  Why not just request one?
> 

I wasn't sure if we pci_enable_msix would work when passed 1 in the 2nd parameter when we have 15 vectors available.

> 
> Are there any currently shipping products using this chip?  
> It'd be nice
> to get hold of some.  Also, is there any documentation 
> available to the
> public (or under NDA) on programming this hardware?
> 

We have not released the production version of the chip yet.   You could contact the LSI/Intel FAE rep.   If you don't already have that, let me know.