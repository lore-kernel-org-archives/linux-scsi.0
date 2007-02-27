From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: end to end error recovery musings
Date: Tue, 27 Feb 2007 14:07:12 -0500
Message-ID: <yq1r6sb7733.fsf@sermon.lab.mkp.net>
References: <664A4EBB07F29743873A87CF62C26D705D6DDB@NAMAIL4.ad.lsil.com>
	<yq14pp78rze.fsf@sermon.lab.mkp.net>
	<20070227190236.58323a40@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:13371 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbXB0TJG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Feb 2007 14:09:06 -0500
In-Reply-To: <20070227190236.58323a40@lxorguk.ukuu.org.uk> (alan@lxorguk.ukuu.org.uk's message of "Tue, 27 Feb 2007 19:02:36 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Moore, Eric" <Eric.Moore@lsi.com>, ric@emc.com, Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>

>>>>> "Alan" == Alan  <alan@lxorguk.ukuu.org.uk> writes:

>> These features make the most sense in terms of WRITE.  Disks
>> already have plenty of CRC on the data so if a READ fails on a
>> regular drive we already know about it.

Alan> Don't bet on it. 

This is why I mentioned that I want to expose the protection data to
the host.  As written, DIF only protects the path between initiator
and target.

See below...


Alan> If you want to do this seriously you need an end to end (media
Alan> to host ram) checksum. We do see bizarre and quite evil things
Alan> happen to people occasionally because they rely on bus level
Alan> protection - both faulty network cards and faulty disk or
Alan> controller RAM can cause very bad things to happen in a critical
Alan> environment and are very very hard to detect and test for.

Not sure you're up-to-date on the T10 data integrity feature.
Essentially it's an extension of the 520 byte sectors common in disk
arrays.  For each 512 byte sector (or 4KB ditto) you get 8 bytes of
protection data.  There's a 2 byte CRC (GUARD tag), a 2 byte
user-defined tag (APP) and a 4-byte reference tag (REF).  Depending on
how the drive is formatted, the REF tag usually needs to match the
lower 32-bits of the target sector #.

For each sector coming in the disk firmware verifies that the CRC and
the reference tags are in accordance with the contents of the sector
and the CDB start sector + offset.  If they don't match the drive will
reject the request.

If an HBA is capable of exposing the protection tuples to the host we
can precalculate the checksum and the LBA when submitting a WRITE.  My
current proposal involves passing them down in two separate buffers to
minimize the risk of in-memory corruption (Besides, it would suck if
you had to interleave data and protection data.  The scatterlists
would become long and twisted).

And that's when the READ case becomes interesting.  Because then the
fs can verify that the checksum of the in-buffer matches of the GUARD
tag.  In that case we'll know there's been no corruption in the
middle.

And of course this also opens up using the APP field to tag sector
contents.

-- 
Martin K. Petersen	Oracle Linux Engineering
