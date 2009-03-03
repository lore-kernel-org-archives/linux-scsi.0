From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/11] mpt2sas: mpt2sas_base sources
Date: Tue, 3 Mar 2009 11:33:00 -0700
Message-ID: <20090303183300.GC20511@parisc-linux.org>
References: <20090225211224.GW16891@parisc-linux.org> <660360F4F2570145BD872F298951B17A7673CBAA@cosmail03.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:59173 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731AbZCCSdE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Mar 2009 13:33:04 -0500
Content-Disposition: inline
In-Reply-To: <660360F4F2570145BD872F298951B17A7673CBAA@cosmail03.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: Grant Grundler <grundler@google.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Feb 25, 2009 at 03:12:33PM -0700, Moore, Eric wrote:
> On Wednesday, February 25, 2009 2:12 PM, Matthew Wilcox wrote:
> > It's also worth considering a mode where each CPU gets its own
> > interrupt.  That lets us complete IOs on the CPU which submitted them
> > and can be a real performance win.
> 
> right, I was wondering if we could do that.   Perhaps we could discuss that further in how do to that.

It's something that's being worked on.  I'm not quite sure where we are
on it with the SCSI side.  From the PCI side, we're at a point where you
can request however many vectors you want and then assign them however
you want.  I think we need a higher-level API than that, but we're not
quite sure what it should look like yet (and I want to redesign the
lower-level API anyway, because it's horrible for drivers to use).

> > I'm somewhat puzzled that you request four MSI-X interrupts, then only
> > use one of them.  Why not just request one?
> 
> I wasn't sure if we pci_enable_msix would work when passed 1 in the 2nd parameter when we have 15 vectors available.

Yes, that works fine.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
