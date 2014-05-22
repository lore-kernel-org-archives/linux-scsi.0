From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RESEND] scsi: Output error messages using structured
 printk in single line
Date: Thu, 22 May 2014 02:06:51 -0700
Message-ID: <20140522090651.GA14854@infradead.org>
References: <20140227041738.31316.14684.stgit@yunodevel>
 <1400638922.2481.18.camel@dabdike>
 <94D0CD8314A33A4D9D801C0FE68B402956F1CF5A@G4W3202.americas.hpqcorp.net>
 <537C4822.6000204@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59072 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbaEVJG7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 May 2014 05:06:59 -0400
Content-Disposition: inline
In-Reply-To: <537C4822.6000204@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>, Prarit Bhargava <prarit@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kay Sievers <kay@vrfy.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>, "yrl.pp-manager.tt@hitachi.com" <yrl.pp-manager.tt@hitachi.com>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

On Wed, May 21, 2014 at 08:30:58AM +0200, Hannes Reinecke wrote:
> While this works reasonably well for most things, printing out
> decoded sense with just one line (and not end up in massive switch()
> statements) is near impossible.
> 
> Plus you'll end up having to use a static buffer at one point, which
> again increases the stack size.
> 
> The alternative approach as discussed at LSF is to move scsi_logging
> over to tracing. There is already some coding for scsi tracing, but
> in most cases it just duplicates existing logging statements.
> So if we were to replace the entire scsi_logging infrastructure
> with scsi tracing most of the issues (like chopped-up CDBs) would
> be gone.
> Plus we would have a far better control about _what_ is being printed.
> 
> And yes, I do have some patches for that :-)

I think any detailed logging of sense codes, cdbs and co should move
to tracing.  In fact generally any non-defauly logging probably is
better off in the tracing subsystems, but there might be a few
exceptions.

