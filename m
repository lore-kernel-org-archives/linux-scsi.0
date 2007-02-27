From: Alan <alan@lxorguk.ukuu.org.uk>
Subject: Re: end to end error recovery musings
Date: Tue, 27 Feb 2007 01:19:55 +0000
Message-ID: <20070227011955.151ba1cd@lxorguk.ukuu.org.uk>
References: <45DEF6EF.3020509@emc.com>
	<45DF80C9.5080606@zytor.com>
	<20070224003723.GS10715@schatzie.adilger.int>
	<20070224023229.GB4380@thunk.org>
	<17890.28977.989203.938339@notabene.brown>
	<20070226132511.GB8154@thunk.org>
	<45E3634E.9000505@garzik.org>
	<45E364F2.8090502@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45E364F2.8090502@emc.com>
Sender: linux-raid-owner@vger.kernel.org
To: ric@emc.com
Cc: Jeff Garzik <jeff@garzik.org>, Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

> One interesting counter example is a smaller write than a full page - say 512 
> bytes out of 4k.
> 
> If we need to do a read-modify-write and it just so happens that 1 of the 7 
> sectors we need to read is flaky, will this "look" like a write failure?

The current core kernel code can't handle propogating sub-page sized
errors up to the file system layers (there is nowhere in the page cache
to store 'part of this page is missing'). This is a long standing (four
year plus) problem with CD-RW support as well.

For ATA we can at least retrieve the true media sector size now, which
may be helpful at the physical layer but the page cache would need to
grow some brains to do anything with it.
