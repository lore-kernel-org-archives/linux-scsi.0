From: Christoph Hellwig <hch@lst.de>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b7).
Date: Tue, 9 Dec 2003 14:28:23 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031209132823.GA29642@lst.de>
References: <B179AE41C1147041AA1121F44614F0B060ED8F@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:12431 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S265795AbTLIN2f (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Dec 2003 08:28:35 -0500
Content-Disposition: inline
In-Reply-To: <B179AE41C1147041AA1121F44614F0B060ED8F@AVEXCH02.qlogic.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>, Linux-SCSI <linux-scsi@vger.kernel.org>

On Fri, Dec 05, 2003 at 05:15:14PM -0800, Andrew Vasquez wrote:
> On Friday, December 05, 2003 12:53 PM, Andrew Vasquez wrote:
> > All,
> > 
> > A new version of the 8.x series driver for Linux 2.6.x kernels has
> > been uploaded to SourceForge: 
> > 
> > 	http://sourceforge.net/projects/linux-qla2xxx/
> >
> 
> False start.  I've uploaded 8.00.00b8 to the SF site.  This driver
> instructs the mid-layer to perform its initial scan with
> scsi_scan_host().  During testing, I disable the scan.  Sorry for
> the confusion.

Second problem seems to be that the extras/ dir missed the executable
bit..

Here's some patches for you:

http://verein.lst.de/~hch/qla/QLA1-kconfig-b7

	use select for CONFIG_SCSI_QLA2XXX, shorten the name
	of the failover option, sanitize kconfig texts.

http://verein.lst.de/~hch/qla/QLA2-noioctl-b7

	make ioctl code optional.  this is a bit ugly because
	sometimes we use defines from exioct.h in non-ioctl
	related code.  Btw, is it just me or is the ioctl code
	never called actually?

http://verein.lst.de/~hch/qla/QLA3-down_timeout-b7

	use a common and simpler variant of the down with timeout
	scheme.  We should probably try to get a proper down_timeout
	as this one still is quite suboptimal..

http://verein.lst.de/~hch/qla/QLA4-module_param-b7

	use new-style module_param() everywhere (works also for
	the compiled-in case).  The paramter naming is quite
	inconsistant and you have global variables like Bind
	that might cause quite some trouble in the non-modular
	case.  You should probably switch to module_param_named
	to always use nice lower_case, descriptive names
	(without the ql2x prefix) and map them to variables with
	a driver-prefix.

http://verein.lst.de/~hch/qla/QLA5-dbg-b7

	Move some debug defines from qla_def.h to qla_dbg.h

http://verein.lst.de/~hch/qla/QLA6-kmem_zalloc-b7

	Use kmalloc directly instead of qla2xxx_kmem_zalloc and
	associated wrappers.

http://verein.lst.de/~hch/qla/QLA7-misc-b7

	Misc changes that don't affect generated code.

