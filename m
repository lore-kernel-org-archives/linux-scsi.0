From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] correct SCSI_WAIT_SCAN selection for non-modular SCSI_SCAN_ASYNC builds.
Date: Tue, 20 Mar 2007 12:19:40 -0700
Message-ID: <20070320191940.GB23330@dmccrory-d810.qlogic.org>
References: <20070320185632.GB22866@dmccrory-d810.qlogic.org> <1174417867.3522.35.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch1.qlogic.com ([198.70.193.115]:10297 "EHLO
	avexch1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934038AbXCTTTu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Mar 2007 15:19:50 -0400
Content-Disposition: inline
In-Reply-To: <1174417867.3522.35.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Linux SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 20 Mar 2007, James Bottomley wrote:

> On Tue, 2007-03-20 at 11:56 -0700, Andrew Vasquez wrote:
> > Commit 840c2835a1c867281d27158378a9d34f593a7664 ([SCSI] make
> > scsi_wait_scan always modular) broke configurations where
> > SCSI_SCAN_ASYNC is selected for non-modular builds.
> > 
> > Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> > ---
> > 
> > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> > index f3bc0f4..eb25abe 100644
> > --- a/drivers/scsi/Kconfig
> > +++ b/drivers/scsi/Kconfig
> > @@ -226,6 +226,7 @@ config SCSI_LOGGING
> >  config SCSI_SCAN_ASYNC
> >  	bool "Asynchronous SCSI scanning"
> >  	depends on SCSI
> > +	select SCSI_WAIT_SCAN
> 
> This can't really be right.  Async scan is always compiled in, so the
> module is always required ... this parameter just determines what the
> boot time default is, but it can be overridden by the kernel command
> line.
> 
> What's the actual problem you're trying to fix?

SCSI_SCAN_ASYNC was compiled non-modularly before merging the latest
scsi-misc-2.6.git tree.  After the merge, and a rebuild of the kernel,
was getting 'unknown symbol' failures during link as SCSI_WAIT_SCAN
was now forced to be built as a module.  'select'ion of SCSI_WAIT_SCAN
based on SCSI_SCAN_SYNC (a consumer) appeared to be the most natural
way to address the problem.
