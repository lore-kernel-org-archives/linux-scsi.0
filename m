From: Ric Wheeler <ric@emc.com>
Subject: Re: end to end error recovery musings
Date: Tue, 27 Feb 2007 13:51:39 -0500
Message-ID: <45E47DBB.4050002@emc.com>
References: <664A4EBB07F29743873A87CF62C26D705D6DDB@NAMAIL4.ad.lsil.com> <yq14pp78rze.fsf@sermon.lab.mkp.net>
Reply-To: ric@emc.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <yq14pp78rze.fsf@sermon.lab.mkp.net>
Sender: linux-ide-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, Alan <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

Martin K. Petersen wrote:
>>>>>> "Eric" == Moore, Eric <Eric.Moore@lsi.com> writes:
> 
> Eric> Martin K. Petersen on Data Intergrity Feature, which is also
> Eric> called EEDP(End to End Data Protection), which he presented some
> Eric> ideas/suggestions of adding an API in linux for this.  
> 
> T10 DIF is interesting for a few things: 
> 
>  - Ensuring that the data integrity is preserved when writing a buffer
>    to disk
> 
>  - Ensuring that the write ends up on the right hardware sector
> 
> These features make the most sense in terms of WRITE.  Disks already
> have plenty of CRC on the data so if a READ fails on a regular drive
> we already know about it.

There are paths through a read that could still benefit from the extra 
data integrity.  The CRC gets validated on the physical sector, but we 
don't have the same level of strict data checking once it is read into 
the disk's write cache or being transferred out of cache on the way to 
the transport...

> 
> We can, however, leverage DIF with my proposal to expose the
> protection data to host memory.  This will allow us to verify the data
> integrity information before passing it to the filesystem or
> application.  We can say "this is really the information the disk
> sent. It hasn't been mangled along the way".
> 
> And by using the APP tag we can mark a sector as - say - metadata or
> data to ease putting the recovery puzzle back together.
> 
> It would be great if the app tag was more than 16 bits.  Ted mentioned
> that ideally he'd like to store the inode number in the app tag.  But
> as it stands there isn't room.
> 
> In any case this is all slightly orthogonal to Ric's original post
> about finding the right persistence heuristics in the error handling
> path...
> 

Still all a very relevant discussion - I agree that we could really use 
more than just 16 bits...

ric

