From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 15/17] sym53c8xx: Make interrupt handler capable of returning
 IRQ_NONE
Date: Fri, 05 Oct 2007 17:04:56 -0400
Message-ID: <4706A6F8.4@garzik.org>
References: <11916141143747-git-send-email-matthew@wil.cx> <11916141153280-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:36805 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbXJEVE6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Oct 2007 17:04:58 -0400
In-Reply-To: <11916141153280-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> Make sym_interrupt return an irqreturn_t instead of void, and take a
> Scsi_Host instead of a sym_hcb.  Pass the Scsi_Host to the interrupt
> handler instead of the sym_hcb.  Rename the host_data to sym_data.
> Keep a pci_dev pointer in the sym_data.  Rename the Scsi_Host from
> instance to shost.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

ACK

Additionally, consider checking for istat==0xffffffff and returning 
IRQ_NONE, like most other drivers.  This handles the window during 
hot-unplug where you wind up reading a hardware register after the 
hardware is gone, but before the driver has been notified of unplug. 
The normal behavior of hardware for this case is to return all 1's upon 
PCI device fault/unplug.

Presuming you don't have fancy-shmancy PCI error reporting hw :)



