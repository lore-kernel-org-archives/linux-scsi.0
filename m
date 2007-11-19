From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: SCSI breakage on non-cache coherent architectures
Date: Mon, 19 Nov 2007 05:32:40 -0700
Message-ID: <20071119123240.GA12494@parisc-linux.org>
References: <1195450523.7022.37.camel@pasglop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:49617 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbXKSMcn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2007 07:32:43 -0500
Content-Disposition: inline
In-Reply-To: <1195450523.7022.37.camel@pasglop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Russell King <rmk@arm.linux.org.uk>

On Mon, Nov 19, 2007 at 04:35:23PM +1100, Benjamin Herrenschmidt wrote:
> The other one I'm hitting now is that the SCSI layer nowadays embeds the

'nowadays'?  It has always been so.

> sense_buffer inside the scsi_cmnd structure without any kind of
> alignment whatsoever. I've been hitting irregulary is a crash on SCSI command
> completion that seems to be related to corruption of the "request"
> pointer in struct scsi_cmnd and I think it might be the cause.
> I'm now trying to setup a proper repro-case.

What other drivers do is DMA to their own allocation and then memcpy to
the sense buffer.

There is a movement to allocate the sense data as its own sg list, but
I don't think that patch has even been posted yet.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
