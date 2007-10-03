From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 21/21] advansys: Changes to work on parisc
Date: Wed, 03 Oct 2007 10:45:20 -0400
Message-ID: <4703AB00.4050509@garzik.org>
References: <11913765421743-git-send-email-matthew@wil.cx> <11913765432770-git-send-email-matthew@wil.cx> <4702F7B2.7080600@garzik.org> <20071003021545.GD12049@parisc-linux.org> <4702FE4D.4030603@garzik.org> <20071003080559.GA10081@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:35523 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753133AbXJCOp2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 10:45:28 -0400
In-Reply-To: <20071003080559.GA10081@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>

Christoph Hellwig wrote:
> On Tue, Oct 02, 2007 at 10:28:29PM -0400, Jeff Garzik wrote:
>> Incorrect.  That is highly platform specific, with many using unsigned 
>> long, since the [non-x86] platform is generally pointing to a special 
>> memory region rather than directly using an x86-like instruction.
> 
> For port I/O we _do_ use int everywhere.

ioport_map() disagrees with you.
request_region disagrees with you.
release_region disagrees with you.
ia64 disagrees with you.
alpha disagrees with you.
sparc64 disagrees with you.
sh disagrees with you.
serial driver disagrees with you.
pcmcia disagrees with you.
net driver history disagrees with you.

It should also be self-evident from READING THE ARCH CODE that a 64-bit 
arch is allowed to fill in a 64-bit address in an IORESOURCE_IO struct 
resource.

Thus, unsigned long is the least common demoninator.

unsigned long is the ONLY way to guarantee portability.

Not all port I/O is hardcoded legacy ISA addresses.

	Jeff


