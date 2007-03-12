From: Jeff Garzik <jeff@garzik.org>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Sun, 11 Mar 2007 20:44:24 -0400
Message-ID: <45F4A268.3000405@garzik.org>
References: <45F48809.2060908@emc.com> <20070312000253.20eab1a3@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20070312000253.20eab1a3@lxorguk.ukuu.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ric Wheeler <ric@emc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Alan Cox wrote:
> I would be interested to know what the disk vendors intend to use as
> their strategy when (with ATA) they have a 512 byte write from an older
> file system/setup into a 4K block. The case where errors magically appear

Well, you have logical and physical sector size changes.

First generation of 1K sector drives will continue to use the same 
512-byte ATA sector size you are familiar with.  A single 512-byte write 
will cause the drive to perform a read-modify-write cycle.  This 
configuration is physical 1K sector, logical 512b sector.

A future configuration will change the logical ATA interface away from 
512-byte sectors to 1K or 4K.  Here, it is impossible to read a quantity 
smaller than 1K or 4K, whatever the sector size is.

	Jeff


