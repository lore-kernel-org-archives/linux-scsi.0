From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/3] SCSI: Make cmd_serial_number an atomic
Date: Sun, 3 Apr 2011 09:33:06 -0400
Message-ID: <20110403133306.GA22172@infradead.org>
References: <20110401202051.GL4183@linux.intel.com>
 <20110402133643.GB18990@infradead.org>
 <20110402210240.GD7286@parisc-linux.org>
 <20110403110057.GC3872@infradead.org>
 <20110403131543.GF7286@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:34989 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab1DCNdJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 3 Apr 2011 09:33:09 -0400
Content-Disposition: inline
In-Reply-To: <20110403131543.GF7286@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <willy@linux.intel.com>, linux-scsi@vger.kernel.org, "Moore, Eric" <Eric.Moore@lsi.com>

On Sun, Apr 03, 2011 at 07:15:43AM -0600, Matthew Wilcox wrote:
> Hm, yeah, it looks like it's only used for checking whether the command
> we're aborting is the same command we're using to do the aborts.  In
> which case, can't we simply do this?  Eric?

A similar question also applies for the old fusion driver.  There it
even compares the serial number with one taken from the same scsi_cmnd
in the same function.  If we could reuse a scsi_cmnd while in the
->eh_abort handler for fusion it would have to seriously mess up it's
locking and lifetime rules.

