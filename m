From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/3] pci: New PCI-E reset API
Date: Thu, 1 Feb 2007 12:12:35 -0700
Message-ID: <20070201191235.GQ7585@parisc-linux.org>
References: <11703510202911-patch-mail.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38150 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422941AbXBATMi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Feb 2007 14:12:38 -0500
Content-Disposition: inline
In-Reply-To: <11703510202911-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: gregkh@suse.de, linux-pci@atrey.karlin.mff.cuni.cz, paulus@samba.org, linuxppc-dev@ozlabs.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, hch@lst.de

On Thu, Feb 01, 2007 at 11:30:21AM -0600, Brian King wrote:
> Adds a new API which can be used to issue various types
> of PCI-E reset, including PCI-E warm reset and PCI-E hot reset.
> This is needed for an ipr PCI-E adapter which does not properly
> implement BIST. Running BIST on this adapter results in PCI-E
> errors. The only reliable reset mechanism that exists on this
> hardware is PCI Fundamental reset (warm reset). Since driving
> this type of reset is architecture unique, this provides the
> necessary hooks for architectures to add this support.

A few points ...

 - When doing a warm reset, you reset the entire device not just the
   function (== pci_dev) that gets passed in.  How happy are drivers for
   the other functions going to be about this?

 - You've missed the requirement:

"To allow components to perform internal initialization, system software
must wait for at least 100 ms from the end of a Conventional Reset of one
or more devices before it is permitted to issue Configuration Requests
to those devices."

   To fix this, we need to call pci_block_user_cfg_access() before
   calling the pcibios function, then msleep(100) after calling it, then
   call pci_unblock_user_cfg_access().

 - There's no attempt to support either cold or function-level reset in
   this patch.

I suspect the Right Way of handling hot/warm/cold reset is going to be
some kind of integration with error handling.  This driver understands
about slots being different from functions, and has the ability to
notify drivers of other functions that a reset is happening.

To a certain extent, what's going on with IPR here *is* an error
condition, it's just that we can recover from it with a warm reset
rather than a hot reset.

