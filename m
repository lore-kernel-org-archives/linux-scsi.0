From: Christoph Hellwig <hch@infradead.org>
Subject: Re: module: fix module_refcount() return when running in a module
 exit routine
Date: Fri, 23 Jan 2015 05:17:58 -0800
Message-ID: <20150123131758.GC8045@infradead.org>
References: <1421600146.2080.8.camel@HansenPartnership.com>
 <54BC93C3.7010808@hitachi.com>
 <878ugzco8c.fsf@rustcorp.com.au>
 <1421683701.2080.25.camel@HansenPartnership.com>
 <871tmqcmau.fsf@rustcorp.com.au>
 <1421774615.2080.88.camel@HansenPartnership.com>
 <20150122165018.GA27377@infradead.org>
 <1421946175.2093.1.camel@HansenPartnership.com>
 <87iofyurzc.fsf@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbbAWNSF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Jan 2015 08:18:05 -0500
Content-Disposition: inline
In-Reply-To: <87iofyurzc.fsf@rustcorp.com.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Jan 23, 2015 at 01:24:15PM +1030, Rusty Russell wrote:
> The correct fix is to turn try_module_get() into __module_get(), and
> always do the module_put().

Is this really safe?  __module_get sais it needs a non-zero refcount
to start with, but scsi_device_get is the only thing every incrementing
the refcount on the module pointer in the scsi host template, so
exactly that case can happen easily.  There's not assert actually
hardcoding the assumption, so I'm not sure if requirement the comment
really just is nice to have or a strong requirement.
