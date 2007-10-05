From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 16/17] sym53c8xx: Remove pci_dev pointer from sym_shcb
Date: Fri, 05 Oct 2007 17:07:39 -0400
Message-ID: <4706A79B.5060305@garzik.org>
References: <11916141143747-git-send-email-matthew@wil.cx> <11916141151125-git-send-email-matthew@wil.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:36828 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762212AbXJEVHk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Oct 2007 17:07:40 -0400
In-Reply-To: <11916141151125-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Matthew Wilcox wrote:
> This structure is accessed by the device; the fewer Linux things in it,
> the better.  Using the pci_dev pointer from the hostdata requires a lot
> of changes:
> 
>  - Pass Scsi_Host to a lot of routines which currently take a sym_hcb.
>  - Set the Scsi_Host as the pci drvdata (instead of the sym_hcb)
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>

Obviously this is a judgement call on your part... but did you at least 
consider passing sym_hcb for all cases instead?

This is a common driver decisions, and many authors choose to store a 
pointer to the kernel struct (Scsi_Host in this case) in their adapter 
private structure, since it is often _far_ more common to pass the 
driver-private struct in arguments.

It doesn't make much sense to do the additional indirection IFF the 
majority of the routine actually want the driver-private structure.

I ACK the patch either way...


