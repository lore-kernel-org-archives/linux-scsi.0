From: Alan Cox <alan@redhat.com>
Subject: Re: [PATCH] [29/82] x86_64: Rename IOMMU option, fix help and mark option embedded.
Date: Sat, 24 Jun 2006 19:14:33 -0400
Message-ID: <20060624231433.GA24862@devserv.devel.redhat.com>
References: <449C852C.mailCZT11F9YB@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:60082 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751165AbWFXXOm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Jun 2006 19:14:42 -0400
Content-Disposition: inline
In-Reply-To: <449C852C.mailCZT11F9YB@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andi Kleen <ak@suse.de>
Cc: torvalds@osdl.org, discuss@x86-64.org, akpm@osdl.org, markh@osdl.org, alan@redhat.com, linux-scsi@vger.kernel.org

On Sat, Jun 24, 2006 at 02:19:56AM +0200, Andi Kleen wrote:
> To my astonishment I discovered the aacraid driver tests this
> symbol directly. This looks quite broken to me - it's an internal
> implementation detail of the PCI DMA API. Can the maintainer
> please clarify what this test was intended to do? 

Shouldn't be to your astonishment, you were involved in the process

Older aacraid hardware cannot address the 3-4GB range where the iommu
remaps pages. As the PCI DMA implementation for the x86-64 is flawed and
doesn't support any nice way to deal with this via swiotlb instead the
driver handles it internally.

Yeah its ugly, but its old hw and its a one off that can do without tangling
the core code. At least thats what you decided last time around ;)

