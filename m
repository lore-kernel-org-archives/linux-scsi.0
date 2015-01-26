From: Christoph Hellwig <hch@infradead.org>
Subject: Re: module: fix module_refcount() return when running in a module
 exit routine
Date: Mon, 26 Jan 2015 09:16:03 -0800
Message-ID: <20150126171603.GA32729@infradead.org>
References: <54BC93C3.7010808@hitachi.com>
 <878ugzco8c.fsf@rustcorp.com.au>
 <1421683701.2080.25.camel@HansenPartnership.com>
 <871tmqcmau.fsf@rustcorp.com.au>
 <1421774615.2080.88.camel@HansenPartnership.com>
 <20150122165018.GA27377@infradead.org>
 <1421946175.2093.1.camel@HansenPartnership.com>
 <87iofyurzc.fsf@rustcorp.com.au>
 <20150123131758.GC8045@infradead.org>
 <1422038567.2126.14.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:33028 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbbAZRQI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Jan 2015 12:16:08 -0500
Content-Disposition: inline
In-Reply-To: <1422038567.2126.14.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Rusty Russell <rusty@rustcorp.com.au>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Jan 23, 2015 at 10:42:47AM -0800, James Bottomley wrote:
> To that point, Rusty's patch just keeps the status quo in the new
> module_refcount() environment, so it's the quick bandaid.
> 
> I think the use case you're worrying about is what happens if someone
> tries to use a device after module removal begins executing but before
> the device has been deleted (say by opening it)?  We'll exit the device
> removal routines and then kill the module, because after the module code
> gets to ->exit(), nothing re-checks the module refcount, so the host
> module will get free'd while we're still using the device.
> 
> The fix for this seems to be to differentiate between special uses of
> scsi_get_device, which are allowed to get the device in the module exit
> routines and ordinary uses which aren't.  Something like this? (the
> patch isn't complete, but you get the idea).

Yes, that's exactly what I worry about.  But you're right, the patch
doesn't make anything worse compared to the 3.18 and earlier status quo.

So I think I'm fine with the __module_get patch (which I assume will go
through the module tree as well?), and I'll get back to my series to
unwind our bandaids back to the start for the proper fix.
