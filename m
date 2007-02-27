From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: end to end error recovery musings
Date: Tue, 27 Feb 2007 11:39:41 -0700
Message-ID: <20070227183941.GS10715@schatzie.adilger.int>
References: <664A4EBB07F29743873A87CF62C26D705D6DDB@NAMAIL4.ad.lsil.com> <yq14pp78rze.fsf@sermon.lab.mkp.net> <20070227190236.58323a40@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.clusterfs.com ([206.168.112.78]:47383 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbXB0Sjo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Feb 2007 13:39:44 -0500
Content-Disposition: inline
In-Reply-To: <20070227190236.58323a40@lxorguk.ukuu.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Moore, Eric" <Eric.Moore@lsi.com>, ric@emc.com, Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>

On Feb 27, 2007  19:02 +0000, Alan wrote:
> > It would be great if the app tag was more than 16 bits.  Ted mentioned
> > that ideally he'd like to store the inode number in the app tag.  But
> > as it stands there isn't room.
> 
> The lowest few bits are the most important with ext2/ext3 because you
> normally lose a sector of inodes which means you've got dangly bits
> associated with a sequence of inodes with the same upper bits. More
> problematic is losing indirect blocks, and being able to keep some kind
> of [inode low bits/block index] would help put stuff back together.

In the ext4 extents format there is the ability (not implemented yet)
to add some extra information into the extent index blocks (previously
referred to as the ext3_extent_tail).  This is planned to be a checksum
of the index block, and a back-pointer to the inode which is using this
extent block.

This allows online detection of corrupt index blocks, and also detection
of an index block that is written to the wrong location.  There is as
yet no plan that I'm aware of to have in-filesystem checksums of the
extent data.

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

