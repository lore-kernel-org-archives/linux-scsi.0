From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: mpt2sas DMA mask
Date: Wed, 13 May 2015 08:10:27 +1000
Message-ID: <1431468627.20218.64.camel@kernel.crashing.org>
References: <555279A8.6060906@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:36227 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904AbbELWKk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 May 2015 18:10:40 -0400
In-Reply-To: <555279A8.6060906@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, linux-scsi <linux-scsi@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>

On Tue, 2015-05-12 at 17:07 -0500, Brian King wrote:
> The mpt2sas driver was changed late last year in that it now requests a 64 bit DMA
> mask, then requests a 32 bit coherent DMA mask, then later requests a 64 bit coherent
> DMA mask. This was 5fb1bf8aaa832e1e9ca3198de7bbecb8eff7db9c. This breaks 64 bit DMA
> support for mpt2sas on Power and we always fall back to using 32 bit DMA. Looking
> at the commit log, it looks like this was an intentional change.
> 
> Ben - you had a patch set you had posted to the list back in Feb of this year, but it
> doesn't look like it got merged. 

Right, it was broken, we can't do that unfortunately. It's a hard
problem to fix.

> https://lists.ozlabs.org/pipermail/linuxppc-dev/2015-February/125087.html
> 
> This would fix the issue I'm seeing on mpt2sas. Do you plan to dust that patch set
> off and upstream it? Were there issues with it that still need to be resolved?

No that patch doesn't actually work.

What we need is essentially a new set of DMA ops that can route an
individual map request via the iommu or the bypass window depending on
what mask applies.

Ben.


