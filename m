From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: end to end error recovery musings
Date: Mon, 26 Feb 2007 15:15:07 +0000
Message-ID: <20070226151507.13a1701e@lxorguk.ukuu.org.uk>
References: <45DEF6EF.3020509@emc.com>
	<45DF80C9.5080606@zytor.com>
	<20070224003723.GS10715@schatzie.adilger.int>
	<20070224023229.GB4380@thunk.org>
	<17890.28977.989203.938339@notabene.brown>
	<20070226132511.GB8154@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070226132511.GB8154@thunk.org>
Sender: linux-ide-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Cc: Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Ric Wheeler <ric@emc.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

> the new location.  I believe this should be always true, so presumably
> with all modern disk drives a write error should mean something very
> serious has happend. 

Not quite that simple.

If you write a block aligned size the same size as the physical media
block size maybe this is true. If you write a sector on a device with
physical sector size larger than logical block size (as allowed by say
ATA7) then it's less clear what happens. I don't know if the drive
firmware implements multiple "tails" in this case.

On a read error it is worth trying the other parts of the I/O.

Alan
