From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Sysfs attribute file for max_sectors
Date: 06 Jan 2004 13:47:54 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073418475.2047.82.camel@mulgrave>
References: <Pine.LNX.4.44L0.0401061427230.6168-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:62358 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264940AbUAFTsE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 6 Jan 2004 14:48:04 -0500
In-Reply-To: <Pine.LNX.4.44L0.0401061427230.6168-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@one-eyed-alien.net>

On Tue, 2004-01-06 at 13:31, Alan Stern wrote:
> I was going to have a store() routine that would accept any value greater
> than 0 and <= the value in the host template (or SCSI_DEFAULT_MAX_SECTORS
> if the host template value is 0 -- that's what scsi_host_alloc() does).  
> If this is writeable only by root, would that be acceptable for all SCSI
> devices?

Not really.  For most drivers, the max_sectors is a driver table
parameter and the user shouldn't be changing it.

The value can be acceptably exported read only in scsi_sysfs.c;  then,
you could use the attribute overriding code to make this read/write for
usb-storage only.

James


