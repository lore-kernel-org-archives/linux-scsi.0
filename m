From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] mvsas: Mainly add version info to run testing process.
Date: Thu, 28 Feb 2008 18:51:31 -0500
Message-ID: <47C74903.40409@garzik.org>
References: <20080227125025.GA7897@ubuntu.domain>	 <1204129357.3470.14.camel@localhost.localdomain> <6b2481670802271916y62aa0588w81de83c08c9f128c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:53126 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751258AbYB1Xvf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Feb 2008 18:51:35 -0500
In-Reply-To: <6b2481670802271916y62aa0588w81de83c08c9f128c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ke Wei <kewei.mv@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, qswang@marvell.com, jfeng@marvell.com, qzhao@marvell.com, lil@marvell.com, saeed.bishara@gmail.com, kewei@marvell.com

Ke Wei wrote:
> Yes,  the mvi->sas_addr array is in wire big endian format. And it
> will be written to two
> little-endian 32-bit registers after converting to little endian. So I
> think this is independent
> of system architecture.


BTW, just a reminder...  the values written by writel() [aka mw32, in 
mvsas] are converted by the API.

Thus, when writing to MMIO registers, you always pass in CPU-endian 
values, and mw32() will do the right thing regardless of platform.

Ditto for reading MMIO registers -- regardless of being on a big-endian 
or little-endian platform, the values returned are always in CPU-endian 
format.

So the typical cases where you must perform a conversion in the driver are

1) DMA memory.  You must use le32_to_cpu(), etc.  This is the most 
common case for endian conversions.

2) In rare cases, depending on your hardware, sometimes you must add a 
conversion even though you are reading data via readl() and writing via 
writel().  Often, this rare case occurs when reading data from EEPROM 
data-in registers, for example, where the EEPROM data is in big-endian 
format.

	Jeff


