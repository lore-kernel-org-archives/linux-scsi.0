From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 1/3] SCSI: Make cmd_serial_number an atomic
Date: Sun, 03 Apr 2011 15:54:01 -0400
Message-ID: <1301860442.2631.43.camel@mulgrave.site>
References: <20110401202051.GL4183@linux.intel.com>
	 <20110402133643.GB18990@infradead.org>
	 <20110402210240.GD7286@parisc-linux.org>
	 <20110403110057.GC3872@infradead.org>
	 <20110403131543.GF7286@parisc-linux.org>
	 <20110403133306.GA22172@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50713 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303Ab1DCTyI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 3 Apr 2011 15:54:08 -0400
In-Reply-To: <20110403133306.GA22172@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

On Sun, 2011-04-03 at 09:33 -0400, Christoph Hellwig wrote:
> On Sun, Apr 03, 2011 at 07:15:43AM -0600, Matthew Wilcox wrote:
> > Hm, yeah, it looks like it's only used for checking whether the command
> > we're aborting is the same command we're using to do the aborts.  In
> > which case, can't we simply do this?  Eric?
> 
> A similar question also applies for the old fusion driver.  There it
> even compares the serial number with one taken from the same scsi_cmnd
> in the same function.  If we could reuse a scsi_cmnd while in the
> ->eh_abort handler for fusion it would have to seriously mess up it's
> locking and lifetime rules.

Well, I think there's method in the madness for the old driver.  What it
seems to worry about is that the command gets reissued after the abort
because the abort routine sleeps.  If the reissue occurred, the same
command could be on the active list with a different serial number.

The theory is currently bogus because we halt all activity on the host
while error handler porcessing is active and the reissue won't occur
until after the abort routine returns.  Although if we did running error
handling, problems like this would arise ...

The new code seems to be an incorrect extract from the old code, so both
can currently go.

James


