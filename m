From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: RE: pulling failover out of qla2xxx
Date: Fri, 16 Jan 2004 12:02:50 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B0598E34@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:27504 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S265841AbUAPUCf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Jan 2004 15:02:35 -0500
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI <linux-scsi@vger.kernel.org>, Arjan van de Ven <arjanv@redhat.com>

On Friday, January 16, 2004 4:07 AM, Christoph Hellwig wrote:
> > 	o Add initial ISP6312/ISP6322 definitions and checks during
> > 	  board configuration.
> 
> > 	o Add new 2300/2322 IPX and 6312/6322 FLX firmwares (3.02.20):
> > 	  - Remove 2300 TPX firmware from distribution.
> 
> Please add a frontend module per firmware variant instead of adding
> them to qla2300.ko - the whole point of these frontend modules is to
> avoid having to load unessecary firmware.
> 

One of the common complaints we've received from users of our HBA
products is that there are currently three _different_ drivers to
support the current line of ISP chips, ISP2100 - qla2100.o, ISP22XX -
qla2200.o, and ISP2300/2310/2312 - qla2300.o.

I originally mentioned this problem during early discussions with you
before you began the qla2xxx lib/isp split.  QLogic's directive then
and now is that from point-forward (ISP23XX), all future ISP chip
support would be added and exported in a single driver module rather
than the previous qlaABXX.o fashion.  Currently that module, while
perhaps incorrectly named, is qla2300.o.

I'll open up a request-for-response from the rest of the listers in
asking if parceling out qlaAB00.ko modules based on firmware types is
both practical and sensible from a user standpoint.  Especially
considering that many users aren't really concerned with the ISP chip
type on their QLAXXXX or OEM-BRANDED ABC host bus adapter.

Now from a development and maintenance standpoint, I can understand
the reluctance of having to accept a 100K file for each ISP type.
But, let me just say QLogic is looking into other ways of distributing
firmware images.  Finally, given the addition of some new binary-load
user->kernel space facilities (namely request_firmware()) the space
issue becomes moot.

> Else the update looks okay.

Thanks again for all your work at shaping the qla2xxx driver for
inclusion into 2.6.  I'd like to extend a personal thanks to you for
all your efforts, and, when I'm in the area of EU again, perhaps offer
to buy you a beer.

Thanks,
Andrew Vasquez
