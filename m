From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: impact of 4k sector size on the IO & FS stack
Date: Mon, 12 Mar 2007 12:24:24 +0000
Message-ID: <20070312122424.18ed86ce@lxorguk.ukuu.org.uk>
References: <45F48809.2060908@emc.com>
	<20070312000253.20eab1a3@lxorguk.ukuu.org.uk>
	<45F4A268.3000405@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <45F4A268.3000405@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Ric Wheeler <ric@emc.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel@vger.kernel.org, Linux-ide <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> First generation of 1K sector drives will continue to use the same 
> 512-byte ATA sector size you are familiar with.  A single 512-byte write 
> will cause the drive to perform a read-modify-write cycle.  This 
> configuration is physical 1K sector, logical 512b sector.

The problem case is "read-modify-screwup"

At that point we've trashed the block we were writing (a well studied
recovery case), and we've blasted some previously sane, totally
unrelated sector of data out of existance. Thats why we need to know
ideally if they are doing the write to a different physical block when
they do this, so that we don't lose the old data. My guess is they won't
as it'll be hard.
 
> A future configuration will change the logical ATA interface away from 
> 512-byte sectors to 1K or 4K.  Here, it is impossible to read a quantity 
> smaller than 1K or 4K, whatever the sector size is.

That one I'm not worried about - other than "guess how Redmond decide to
make partition tables work" that one is mostly easy (be fun to see how
many controllers simply can't cope with the command formats)

Alan
