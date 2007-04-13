From: "Cameron, Steve" <Steve.Cameron@hp.com>
Subject: RE: [PATCH 1/1] cciss: kconfig patch to make cciss dependent onscsi for SG_IO ioctl
Date: Fri, 13 Apr 2007 14:22:31 +0100
Message-ID: <558F4D473FD7FE419B019232BF2D37B40B2473@G3W0634.americas.hpqcorp.net>
References: <20070412212741.GA10654@beardog.cca.cpqcorp.net> <1176415635.3711.25.camel@mulgrave.il.steeleye.com> <558F4D473FD7FE419B019232BF2D37B40B2472@G3W0634.americas.hpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ccerelbas01.cce.hp.com ([161.114.21.104]:55869 "EHLO
	ccerelbas01.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbXDMNWq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Apr 2007 09:22:46 -0400
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Cameron, Steve" <Steve.Cameron@hp.com>, James Bottomley <James.Bottomley@SteelEye.com>, "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: akpm@linux-foundation.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org



Hmm, now that I look again, those ioctls it's complaining
about are ones for which we just return ENOTTY, so I guess 
we don't really need them listed explicitly, and if they
weren't, the Kconfig patch would be unnecessary.

-- steve

-----Original Message-----
From: Cameron, Steve
Sent: Fri 4/13/2007 7:58 AM
To: James Bottomley; Mike Miller (OS Dev)
Cc: akpm@linux-foundation.org; jens.axboe@oracle.com; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: RE: [PATCH 1/1] cciss: kconfig patch to make cciss dependent onscsi for SG_IO ioctl
 

Well, with SCSI turned off, it didn't compile:


drivers/block/cciss.c: In function `cciss_ioctl':
drivers/block/cciss.c:1180: error: `SCSI_IOCTL_GET_IDLUN' undeclared (first use in this function)
drivers/block/cciss.c:1180: error: (Each undeclared identifier is reported only once
drivers/block/cciss.c:1180: error: for each function it appears in.)
drivers/block/cciss.c:1181: error: `SCSI_IOCTL_GET_BUS_NUMBER' undeclared (first use in this function)
make[2]: *** [drivers/block/cciss.o] Error 1
make[1]: *** [drivers/block] Error 2
make: *** [drivers] Error 2

-- steve


-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com]
Sent: Thu 4/12/2007 5:07 PM
To: Mike Miller (OS Dev)
Cc: akpm@linux-foundation.org; jens.axboe@oracle.com; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; Cameron, Steve
Subject: Re: [PATCH 1/1] cciss: kconfig patch to make cciss dependent onscsi for SG_IO ioctl
 
On Thu, 2007-04-12 at 16:27 -0500, Mike Miller (OS Dev) wrote:
> This kconfig patch makes cciss dependent on scsi for the new SG_IO ioctl we just
> added. If cciss is built into the kernel it makes sures that scsi is also statically
> linked. If scsi is a module then cciss will also be built as a module. Please consider
> this for inclusion.

Erm, I don't think this is necessary: SG_IO is a property of the block
layer, not SCSI (as in it will work without SCSI even present).  SCSI
has a special driver: the sg driver that has its own implementation of
SG_IO, but that's the only connection.

James




