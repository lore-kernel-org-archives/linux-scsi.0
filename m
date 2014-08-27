From: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH 3/5]: ipr: kexec boot speed improvements
Date: Wed, 27 Aug 2014 14:06:30 +1000
Message-ID: <20140827140630.1f0ee455@kryten>
References: <53D6B2A4.4010102@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:54910 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbaH0EGb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Aug 2014 00:06:31 -0400
In-Reply-To: <53D6B2A4.4010102@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>, kexec@lists.infradead.org

Hi Brian,

> Currently when performing a kexec boot with an ipr adapter,
> the adapter gets shutdown completely, flushing all write
> cache, as well as performing a full hardware reset of the card
> during the shutdown phase of the old kernel. This forces
> the new kernel to then wait for the adapter firmware to
> reinitialize, which slows down kexec boot. There is no
> need to do all of this on the newer ipr adapters, since they
> support the ability to cancel outstanding error buffers.
> 
> This patch adds a special case for kexec boot to simply
> cancel these outstanding error buffers, and as long as
> there is no other I/O outstanding to the adapter, which
> there shouldn't be, place the adapter into a state
> where it has no memory of any DMA addresses from the old
> kernel, then disable the device. This significantly
> speeds up kexec boot, particularly in configurations with
> multiple ipr adapters.
> 
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---

This reduces boot time on my box from 80 seconds to 34 seconds. ppc64
kernel developers (who boot boxes continually) thank you!

Tested-by: Anton Blanchard <anton@samba.org>

Anton
