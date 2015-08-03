From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: blk-mq vs kmemleak
Date: Mon, 3 Aug 2015 16:34:32 +0100
Message-ID: <20150803153432.GA11772@e104818-lin.cambridge.arm.com>
References: <20150703161137.GA10438@codemonkey.org.uk>
 <5596C080.4050009@sandisk.com>
 <20150707103323.GA13228@e104818-lin.cambridge.arm.com>
 <559BDB49.70209@sandisk.com>
 <20150708081740.GA3374@infradead.org>
 <55BC14AE.3090200@sandisk.com>
 <20150803104309.GB4033@e104818-lin.cambridge.arm.com>
 <20150803133327.GA3390@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from eu-smtp-delivery-143.mimecast.com ([146.101.78.143]:40266 "EHLO
	eu-smtp-delivery-143.mimecast.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754435AbbHCPef convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Aug 2015 11:34:35 -0400
In-Reply-To: <20150803133327.GA3390@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Dave Jones <davej@codemonkey.org.uk>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, Aug 03, 2015 at 02:33:27PM +0100, Christoph Hellwig wrote:
> On Mon, Aug 03, 2015 at 11:43:09AM +0100, Catalin Marinas wrote:
> > The simplest would be to add a kmemleak_not_leak() annotation in
> > scsi_init_request(), though you would hide real leaks (if any).
> > 
> > A better way could be to inform kmemleak of these pages, something like
> > below (compile-tested only):
> 
> Both versions sound reasonable to me, but I'd prefer the second one if
> it works.

I don't currently have a system where scsi_init_request() is used. But I
hacked loop_init_request (and added a loop_exit_request) to allocate a
dummy structure. Without this patch, I indeed get a few hundred kmemleak
reports which disappear once I apply it.

-- 
Catalin

