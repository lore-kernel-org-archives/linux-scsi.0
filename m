From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: RE: [PATCH] Un-remove aacraid devices
Date: Wed, 23 May 2007 12:07:02 -0500
Message-ID: <1179940022.5569.7.camel@mulgrave.il.steeleye.com>
References: <465438AD.8000406@suse.de>
	 <AE4F746F2AECFC4DA4AADD66A1DFEF019E1B5C@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:37705 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757616AbXEWRHE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 May 2007 13:07:04 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF019E1B5C@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Wed, 2007-05-23 at 12:35 -0400, Salyzyn, Mark wrote:
> NAK
> 
> This will break all our management applications, and will not allow us to manipulate the array configurations from within Linux. This will also break online expansion of capacity.
> 
> This flag has been set from the beginning to allow partition tables, capacity and device locking to be changed without requiring an intervening reboot or needing the device to be taken offline. Fixed disk result in these pieces of information being cached.

I thought this problem had been solved since at least 2000 (when
LifeKeeper ran into the same issue) by sending the BLKRRPART ioctl to
the device ... whether removable or not, this forces a reread of all the
vital information (always providing nothing has the nodes open, of
course, we can't physically yank the information out of applications
using it).

If there's something BLKRRPART isn't doing we can probably fix it ...
that's certainly better than lying to the kernel about the devices.

James


