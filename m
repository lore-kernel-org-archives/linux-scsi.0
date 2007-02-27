From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: end to end error recovery musings
Date: Tue, 27 Feb 2007 19:02:36 +0000
Message-ID: <20070227190236.58323a40@lxorguk.ukuu.org.uk>
References: <664A4EBB07F29743873A87CF62C26D705D6DDB@NAMAIL4.ad.lsil.com>
	<yq14pp78rze.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47066 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751730AbXB0SCc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Feb 2007 13:02:32 -0500
In-Reply-To: <yq14pp78rze.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, ric@emc.com, Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>

> These features make the most sense in terms of WRITE.  Disks already
> have plenty of CRC on the data so if a READ fails on a regular drive
> we already know about it.

Don't bet on it. If you want to do this seriously you need an end to end
(media to host ram) checksum. We do see bizarre and quite evil things
happen to people occasionally because they rely on bus level protection -
both faulty network cards and faulty disk or controller RAM can cause very
bad things to happen in a critical environment and are very very hard to
detect and test for.

IDE has another hideously evil feature in this area. Command blocks are
sent by PIO cycles, and are therefore unprotected from corruption. So
while a data burst with corruption will error and retry and command which
corrupts the block number although very very much less likely (less bits
and much lower speed) will not be caught on a PATA system for read or for
write and will hit the wrong block.

With networking you can turn off hardware IP checksumming (and many
cluster people do) with disks we don't yet have a proper end to end
checksum to media system in the fs or block layers.

> It would be great if the app tag was more than 16 bits.  Ted mentioned
> that ideally he'd like to store the inode number in the app tag.  But
> as it stands there isn't room.

The lowest few bits are the most important with ext2/ext3 because you
normally lose a sector of inodes which means you've got dangly bits
associated with a sequence of inodes with the same upper bits. More
problematic is losing indirect blocks, and being able to keep some kind
of [inode low bits/block index] would help put stuff back together.

Alan
