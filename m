From: Christoph Hellwig <hch@infradead.org>
Subject: Re: attempting task abort with block: remove artifical
 max_hw_sectors cap
Date: Wed, 7 Jan 2015 06:27:19 -0800
Message-ID: <20150107142719.GA10269@infradead.org>
References: <54ABC413.6090000@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:56964 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbbAGO1T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2015 09:27:19 -0500
Content-Disposition: inline
In-Reply-To: <54ABC413.6090000@profihost.ag>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Sreekanth Reddy <sreekanth.reddy@avagotech.com>

Hi Stefan,

On Tue, Jan 06, 2015 at 12:16:35PM +0100, Stefan Priebe - Profihost AG wrote:
> while testing 595b8ecd47e4dde64f704bf78d8c9b97e070ac67 ([PATCH] block:
> remove artifical max_hw_sectors cap), i came around a problem with some
> crucial m500 ssds direct attached.
> 
> With the patch applied, i see the following max_sectors_kb value:
> # cat /sys/block/sdi/queue/max_sectors_kb
> 16383
> 
> But this results in the following error messages (at random time - most
> probably at high load):
> 
> Write(10): 2a 00 04 f9 db f0 00 0c d8 00
> scsi target0:0:7: handle(0x000a), sas_address(0x4433221107000000), phy(7)
> scsi target0:0:7: enclosure_logical_id(0x5003048016aee700), slot(5)

Seems like I misdirected you to only linux-ide, as from this printk it
seems like the SSD is attached to a SAS HBA using the mpt2 or mpt3
drivers.

But 16383 kilobytes if 32766 sectors, which is still only half of what
ATA disks should support.  It would be interesting if other people
also see an issue with too large I/Os on a m500 SSD when attached to
an ATA controller.


> sd 0:0:7:0: task abort: SUCCESS scmd(ffff88018c6b4700)
> sd 0:0:7:0: attempting task abort! scmd(ffff8807a12e6800)
> sd 0:0:7:0: [sdh] CDB: Read(10): 28 00 15 d4 f9 60 00 00 10 00
> scsi target0:0:7: handle(0x000a), sas_address(0x4433221107000000), phy(7)
> scsi target0:0:7: enclosure_logical_id(0x5003048016aee700), slot(5)
> sd 0:0:7:0: task abort: SUCCESS scmd(ffff8807a12e6800)
> sd 0:0:7:0: attempting task abort! scmd(ffff88078d989800)
> sd 0:0:7:0: [sdh] CDB: Read(10): 28 00 15 aa d2 f9 00 00 20 00
> 
> Stefan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ide" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
---end quoted text---
