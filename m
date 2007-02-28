From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: end to end error recovery musings
Date: Wed, 28 Feb 2007 08:19:17 -0700
Message-ID: <664A4EBB07F29743873A87CF62C26D705D7112@NAMAIL4.ad.lsil.com>
References: <yq1r6sb7733.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:42290 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933127AbXB1PU1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Feb 2007 10:20:27 -0500
Content-class: urn:content-classes:message
In-Reply-To: <yq1r6sb7733.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Alan <alan@lxorguk.ukuu.org.uk>
Cc: ric@emc.com, Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>

On Tuesday, February 27, 2007 12:07 PM, Martin K. Petersen wrote: 
> 
> Not sure you're up-to-date on the T10 data integrity feature.
> Essentially it's an extension of the 520 byte sectors common in disk
> arrays.  For each 512 byte sector (or 4KB ditto) you get 8 bytes of
> protection data.  There's a 2 byte CRC (GUARD tag), a 2 byte
> user-defined tag (APP) and a 4-byte reference tag (REF).  Depending on
> how the drive is formatted, the REF tag usually needs to match the
> lower 32-bits of the target sector #.
> 

I from the scsi lld perspective, all we need 32 byte cdbs, and a
mechinism to pass the tags down from above.  It appears our driver to
firmware insterface is only providing the reference and application
tags. It seems the guard tag is not present, so I guess mpt fusion
controller firmware is setting it(I will have to check with others).   I
assume that for transfers greater than a sector, that the controller
firmware updates the tags for all the other sectors within the boundary.
I'm sure the flags probably tell whether EEDP is enabled or not.   I
will have to check if there are some manufacturing pages that say
whether the controller is capable of EEDP(as not all our controllers
support it).  


Here are the EEDP associated fields we provide in our scsi passthru, as
well as target assist.


u32 SecondaryReferenceTag
u16 SecondaryApplicationTag
u16 EEDPFlags
u16 ApplicationTagTranslationMask
u32 EEDPBlockSize
