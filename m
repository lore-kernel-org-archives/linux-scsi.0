From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: AS2105-based enclosure size issues with >2TB HDDs
Date: Mon, 25 Aug 2014 10:24:41 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1408251021560.1385-100000@iolanthe.rowland.org>
References: <1408972618.10300.35.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:34137 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932492AbaHYOYm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Aug 2014 10:24:42 -0400
In-Reply-To: <1408972618.10300.35.camel@linux-fkkt.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Alfredo Dal Ava Junior <alfredo.junior@eldorado.org.br>, "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>, linux-scsi@vger.kernel.org

On Mon, 25 Aug 2014, Oliver Neukum wrote:

> On Mon, 2014-08-25 at 10:58 +0000, Alfredo Dal Ava Junior wrote:
> 
> > - 1TB and 2TB: READ_CAPACITY_10 returns correct size value
> > - 3TB and 4TB: READ_CAPACITY_10 returns size in a 2TB modulus
> > 
> > If we fix capacity size by reporting (READ_CAPACITY_10 + MODULO_2TB), the result
> >  will be invalid when user plugs a <2TB HDD. An idea (bring by Oliver) is:
> 
> It is worse than that. Pretty soon a 4.7TB disk will also be plausible.
> 
> > first guess reading last sector using modulus result to check if size is valid.
> 
> It is necessary that a virgin disk also be handled correctly.
> We cannot use the partition table (besides it being a layering
> violation)
> 
> It would propose (in pseudo code)
> 
> if (read_capacity_16(device) < 0) {
> 	lower_limit = read_capacity_10(device);
> 	for (i = 1; i++; i < SANITY_LIMIT) {
> 		err = read_sector(device, lower_limit + i * 2TB-SAFETY);
> 		if (err == OUT_OF_RANGE)
> 			break;
> 	}
> 	if (i < SANITY_LIMIT)
> 		return (i - 1) * 2TB + lower_limit;
> 	else
> 		return ERROR;

Don't forget that lots of disks go crazy if you try to read from a 
nonexistent block, that is, one beyond the end of the disk.

IMO, this bug cannot be worked around in any reasonable manner.  The 
device simply cannot handle disks larger than 2 TB.

Alan Stern


