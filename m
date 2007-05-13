From: Dave Jones <davej@redhat.com>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Sun, 13 May 2007 12:28:48 -0400
Message-ID: <20070513162848.GD27604@redhat.com>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain> <20070513160608.GA29024@redhat.com> <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:54707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758939AbXEMQ2v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 May 2007 12:28:51 -0400
Content-Disposition: inline
In-Reply-To: <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Sun, May 13, 2007 at 11:10:55AM -0500, James Bottomley wrote:

 > > diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
 > > index e62d23f..0f6c370 100644
 > > --- a/drivers/scsi/Kconfig
 > > +++ b/drivers/scsi/Kconfig
 > > @@ -244,7 +244,7 @@ config SCSI_SCAN_ASYNC
 > >  config SCSI_WAIT_SCAN
 > >  	tristate
 > >  	default m
 > > -	depends on SCSI
 > > +	depends on SCSI_SCAN_ASYNC
 > 
 > No.  SCSI_SCAN_ASYNC is a bool ... if you depend on it, you'll force the
 > wait scan to be built in, which isn't the idea at all.

hmm?

with my change...

$ make defconfig
$ grep SCSI_SCAN_ASYNC .config
# CONFIG_SCSI_SCAN_ASYNC is not set
$ grep SCSI_WAIT_SCAN .config

<edit .config to remove the CONFIG_SCSI_SCAN_ASYNC line>
$ make oldconfig
<answer 'y' for CONFIG_SCSI_SCAN_ASYNC>

$ grep SCSI_SCAN_ASYNC .config
CONFIG_SCSI_SCAN_ASYNC=y
$ grep SCSI_WAIT_SCAN .config
CONFIG_SCSI_WAIT_SCAN=m


	Dave

-- 
http://www.codemonkey.org.uk
