From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 1/1] ipr: Fix for adapter shutdown issue
Date: Wed, 15 Jun 2005 10:47:38 -0500
Message-ID: <1118850458.5045.34.camel@mulgrave>
References: <200506151515.j5FFFNQA020480@d01av01.pok.ibm.com>
	 <1118849292.5045.27.camel@mulgrave>  <42B04A9C.7050503@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:20904 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261190AbVFOPrk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2005 11:47:40 -0400
In-Reply-To: <42B04A9C.7050503@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, haren@us.ibm.com

On Wed, 2005-06-15 at 10:34 -0500, Brian King wrote:
> For scsi disks attached to an ipr adapter, the SYNCHRONIZE_CACHE command
> gets sent to the disk and works just like when attached to any other
> HBA. The ipr disk array devices, however, do not support the SYNC_CACHE command,
> nor do they support the caching mode page, so SYNC_CACHE never gets sent.
> So, the shutdown hook is needed to flush the adapter's battery backed write
> cache for all attached disk arrays on system shutdown.

Well, that means you have a whole lot more trouble in 2.6.12 than simply
failing to flush a cache on shutdown.  The barrier code now uses cache
synchronization commands, so if you crash the on-disk image will not be
what a journalling filesystem expects.  As long as the battery keeps the
information alive in the cache, I assume this corrects itself when ipr
next powers up, but if you trusted this, you wouldn't be fussing about
the shutdown cache flush, now would you?

James


