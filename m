From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: end to end error recovery musings
Date: Tue, 27 Feb 2007 11:50:29 -0500
Message-ID: <yq14pp78rze.fsf@sermon.lab.mkp.net>
References: <664A4EBB07F29743873A87CF62C26D705D6DDB@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <664A4EBB07F29743873A87CF62C26D705D6DDB@NAMAIL4.ad.lsil.com> (Eric Moore's message of "Mon, 26 Feb 2007 18:10:57 -0700")
Sender: linux-ide-owner@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: ric@emc.com, Alan <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Eric" == Moore, Eric <Eric.Moore@lsi.com> writes:

Eric> Martin K. Petersen on Data Intergrity Feature, which is also
Eric> called EEDP(End to End Data Protection), which he presented some
Eric> ideas/suggestions of adding an API in linux for this.  

T10 DIF is interesting for a few things: 

 - Ensuring that the data integrity is preserved when writing a buffer
   to disk

 - Ensuring that the write ends up on the right hardware sector

These features make the most sense in terms of WRITE.  Disks already
have plenty of CRC on the data so if a READ fails on a regular drive
we already know about it.

We can, however, leverage DIF with my proposal to expose the
protection data to host memory.  This will allow us to verify the data
integrity information before passing it to the filesystem or
application.  We can say "this is really the information the disk
sent. It hasn't been mangled along the way".

And by using the APP tag we can mark a sector as - say - metadata or
data to ease putting the recovery puzzle back together.

It would be great if the app tag was more than 16 bits.  Ted mentioned
that ideally he'd like to store the inode number in the app tag.  But
as it stands there isn't room.

In any case this is all slightly orthogonal to Ric's original post
about finding the right persistence heuristics in the error handling
path...

-- 
Martin K. Petersen	Oracle Linux Engineering

