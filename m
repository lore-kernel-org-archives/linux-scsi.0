From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 29 May 2006 15:11:07 +0200
Message-ID: <1148908267.3291.82.camel@laptopd505.fenrus.org>
References: <20060511143352.GI12272@parisc-linux.org>
	 <20060518172258.GL1604@parisc-linux.org>
	 <20060529031915.GB23405@parisc-linux.org>
	 <447AB2F5.2000700@s5r6.in-berlin.de>
	 <20060529130515.GE23405@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:49346 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750766AbWE2NLJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 May 2006 09:11:09 -0400
In-Reply-To: <20060529130515.GE23405@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Mon, 2006-05-29 at 07:05 -0600, Matthew Wilcox wrote:
> On Mon, May 29, 2006 at 10:38:13AM +0200, Stefan Richter wrote:
> > Matthew Wilcox wrote:
> > > Add the scsi_mod.scan kernel parameter to determine how scsi busses
> > > are scanned.  "sync" is the current behaviour.  "none" punts scanning
> > > scsi busses to userspace.  "async" is the new default.
> > 
> > This parameter is only relevant with LLDDs which use scsi_scan_host, right?
> 
> Not entirely.  If you set it to "none", scsi_scan_target() also returns
> without doing anything.  If you use the scsi_prep_async_scan() and
> scsi_finish_async_scan() API, you can also use this infrastructure to
> make scanning sbp2 synchronised with other scsi hosts.  Then the setting
> of sync vs async also triggers old vs new behaviour.
> 
> > Furthermore, "sync|async" basically means "serialized|parallelized
> > across host adapters". Does it also mean "finishing before|after driver
> > initialization"? (With LLDDs which use scsi_scan_host.)
> 
> That's what scsi_complete_async_scans() is for.  If you have a built-in
> module, it will wait for the async scans to finish before we get as far
> as trying to mount root.

that sounds the wrong place, at least, I would expect the wait is needed
before starting the initramfs, since that is where some distros mount
their root (mount-by-label and I suspect many other cases will do it
from there, such as iscsi rootfs etc)


