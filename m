From: Jeff Garzik <jeff@garzik.org>
Subject: Re: disable TCQ?
Date: Thu, 28 Jun 2007 06:09:02 -0400
Message-ID: <468388BE.6040809@garzik.org>
References: <46836F15.2040208@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47723 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753530AbXF1KJH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jun 2007 06:09:07 -0400
In-Reply-To: <46836F15.2040208@msgid.tls.msk.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-scsi@vger.kernel.org

Michael Tokarev wrote:
> /sys/block/sdX/device/queue_depth file is read-write with
> libsata, but is read-only with SCSI controllers  (at least
> with the ones we have -- mostly aic7xxx or mptsas).
> 
> Googling for "disable tcq" gives results about {dis,en}abling
> TCQ at boot time, and also mentions ipr (which we don't have).
> 
> Is there an option to control TCQ at runtime?

You have found the correct sysfs file -- but read/write access to it 
requires the SCSI driver to implement the ->change_queue_depth() hook.

'grep -w' will show that not too many drivers have implemented this yet, 
mostly the newer ones.  For older drivers, poke around and see if there 
is a driver-specific module option or somesuch.

	Jeff


