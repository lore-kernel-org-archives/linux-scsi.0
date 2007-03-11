From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] make scsi_wait_scan always modular
Date: Sun, 11 Mar 2007 16:35:49 -0500
Message-ID: <1173648949.3420.29.camel@mulgrave.il.steeleye.com>
References: <1173640604.3420.21.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.60.0703112141580.5942@poirot.grange>
	 <1173647177.3420.24.camel@mulgrave.il.steeleye.com>
	 <Pine.LNX.4.60.0703112210510.5942@poirot.grange>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:56837 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932690AbXCKVfw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Mar 2007 17:35:52 -0400
In-Reply-To: <Pine.LNX.4.60.0703112210510.5942@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 2007-03-11 at 22:17 +0100, Guennadi Liakhovetski wrote:
> On Sun, 11 Mar 2007, James Bottomley wrote:
> > On Sun, 2007-03-11 at 21:56 +0100, Guennadi Liakhovetski wrote:
> > > Which means, with this change you cannot build a kernel without module 
> > > support but with scsi_wait_scan, which was possible before. Don't know if 
> > > anybody would ever want to do this though...
> > 
> > I'll do something about that if you can tell me how one might use
> > scsi_wait_scan without module support in the kernel ...
> 
> I won't:-) Just from the comment at the top of the patch I didn't get the 
> impression that this indeed was its intended result. Building statically 
> with scsi_wait_scan would mean that you might allow async scan, but then 
> some time at late_initcall() time you want a sync point. Could this ever 
> be desired? If not, just ignore my comment.

scsi_wait_scan is designed to be a module that is loaded *after* you've
loaded all HBA modules that doesn't return from module_init until the
scans previously launched by the HBA module insertions are complete.  In
a monolithic kernel, this is done by the async scan infrastructure but
in a modular kernel, you have to have some signal that you've finished
loading the SCSI modules (which is what scsi_wait_scan is).

So, if you build a kernel without module support, ipso facto you have no
SCSI modules to load and therefore you can't have a use for
scsi_wait_scan.

James


