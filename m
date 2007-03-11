From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH] make scsi_wait_scan always modular
Date: Sun, 11 Mar 2007 23:12:16 +0100 (CET)
Message-ID: <Pine.LNX.4.60.0703112305010.5942@poirot.grange>
References: <1173640604.3420.21.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.60.0703112141580.5942@poirot.grange>
 <1173647177.3420.24.camel@mulgrave.il.steeleye.com>
 <Pine.LNX.4.60.0703112210510.5942@poirot.grange>
 <1173648949.3420.29.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47906 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933559AbXCKWMN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 Mar 2007 18:12:13 -0400
In-Reply-To: <1173648949.3420.29.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Sun, 11 Mar 2007, James Bottomley wrote:

> scsi_wait_scan is designed to be a module that is loaded *after* you've
> loaded all HBA modules that doesn't return from module_init until the
> scans previously launched by the HBA module insertions are complete. 

sure

> In
> a monolithic kernel, this is done by the async scan infrastructure but
> in a modular kernel, you have to have some signal that you've finished
> loading the SCSI modules (which is what scsi_wait_scan is).

So, if now (before this patch) you build a monolithic kernel, 
scsi_wait_scan will be built in, scsi_complete_async_scans() will be 
called at late_initcall time, but it will be redundant because 

> In
> a monolithic kernel, this is done by the async scan infrastructure

so, it will just have no effect, right?

If so, then, of course it only makes sense as a module.

Thanks
Guennadi
---
Guennadi Liakhovetski
