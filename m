From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: What "tarnsport attributes" are really for?
Date: 30 Aug 2004 09:59:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1093874370.2036.12.camel@mulgrave>
References: <1093842055.9886.57.camel@sipan.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:17368 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S268088AbUH3N7h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Aug 2004 09:59:37 -0400
In-Reply-To: <1093842055.9886.57.camel@sipan.org>
List-Id: linux-scsi@vger.kernel.org
To: Sergey Panov <sipan@sipan.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2004-08-30 at 01:00, Sergey Panov wrote:
> Hello,
> I searched and read all threads about "transport attributes" I could
> find in linux-scsi archive, but real design goals of this API still is
> not clear. Is it supposed to be:
> 
> 1) way to store and expose to admin (via syfs) specifics of the
> underlying transport layer (such as FC, iSCSI, SPI, ...).
> 
> 2) way to store transport specific per-device (per LUN) attributes.
> 
> 3) way to access transport specific per-device (per LUN) attributes
> stored in the driver.

Well, it's not really supposed to be any of them.  The goal is to create
a library that encapsulates the service delivery subsystem (transport)
part of SAM.  The ideal is not to have a transport API between the
mid-layer and the transport classes but instead have the transport class
provide autonomous services to the drivers, but I still don't know if
this is possible.  It's a class because it exposes the additional
transport attributes to the user via sysfs.

The FC transport class is pretty vestigial at the moment, if you want to
see the capabilities of doing this, look at the SPI one.here we've been
moving the fairly complex DV code out of the drivers and into the
transport class.

James

