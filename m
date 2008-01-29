From: Andi Kleen <ak@suse.de>
Subject: Re: DMA mapping on SCSI device?
Date: Tue, 29 Jan 2008 05:28:00 +0100
Message-ID: <200801290528.00934.ak@suse.de>
References: <479E6E8C.2090501@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754906AbYA2E3c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jan 2008 23:29:32 -0500
In-Reply-To: <479E6E8C.2090501@shaw.ca>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-arch@vger.kernel.org, ide <linux-ide@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org


> The ideal solution would be to do mapping against a different struct
> device for each port, so that we could maintain the proper DMA mask for
> each of them at all times. However I'm not sure if that's possible.

I cannot imagine why it should be that difficult. The PCI subsystem
could over a pci_clone_device() or similar function.   For all complicated
purposes (sysfs etc)  the original device could be used, so it would
be hopefully not that difficult.

The alternative would be to add a new family of PCI mapping
functions that take an explicit mask. Disadvantage would be changing 
all architectures, but on the other hand the interface could be phase
in one by one (and nF4 primarily only works on x86 anyways) 

I suspect the later would be a little cleaner, although they don't
make much difference.

-Andi
