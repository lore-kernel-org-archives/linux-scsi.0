From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/1] cciss: kconfig patch to make cciss dependent onscsi for SG_IO ioctl
Date: Fri, 13 Apr 2007 14:21:07 +0100
Message-ID: <20070413132107.GA3702@infradead.org>
References: <20070412212741.GA10654@beardog.cca.cpqcorp.net> <1176415635.3711.25.camel@mulgrave.il.steeleye.com> <558F4D473FD7FE419B019232BF2D37B40B2472@G3W0634.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:48919 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559AbXDMNVY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Apr 2007 09:21:24 -0400
Content-Disposition: inline
In-Reply-To: <558F4D473FD7FE419B019232BF2D37B40B2472@G3W0634.americas.hpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Cameron, Steve" <Steve.Cameron@hp.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>, akpm@linux-foundation.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Fri, Apr 13, 2007 at 01:58:41PM +0100, Cameron, Steve wrote:
> 
> Well, with SCSI turned off, it didn't compile:
> 
> 
> drivers/block/cciss.c: In function `cciss_ioctl':
> drivers/block/cciss.c:1180: error: `SCSI_IOCTL_GET_IDLUN' undeclared (first use in this function)
> drivers/block/cciss.c:1180: error: (Each undeclared identifier is reported only once
> drivers/block/cciss.c:1180: error: for each function it appears in.)
> drivers/block/cciss.c:1181: error: `SCSI_IOCTL_GET_BUS_NUMBER' undeclared (first use in this function)

The two are defined in scsi/scsi.h unconditionally.  Make sure to add
an unconditional include of that header to your driver, apparently you're
only picking it up by accident when CONFIG_SCSI is enabled.

