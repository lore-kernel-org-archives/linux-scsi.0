From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Sun, 16 Aug 2009 10:06:00 -0400
Message-ID: <4A881248.2000907@rtr.ca>
References: <20090816004705.GA7347@infradead.org> <4A876255.10606@rtr.ca> <4A876CA9.20906@rtr.ca> <20090816022500.GA12392@infradead.org> <4A8802F3.6010908@rtr.ca> <4A8810C4.3050800@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <4A8810C4.3050800@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jens.axboe@oracle.com, IDE/ATA development list <linux-ide@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Mark Lord wrote:
..
> Slow, but presumably thorough.
> Subsequent runs were equally slow.
> 
> The problem is, it still issues TRIMs to the LLD one extent at a time.
> Compare this with doing it all in a single TRIM command
> with the wiper.sh script (filesystem unmounted):
> 
>     [~] time wiper.sh /dev/sdb3 --commit
>     
>     wiper.sh: Linux SATA SSD TRIM utility, version 1.9b, by Mark Lord.
>     Preparing for offline TRIM of free space on /dev/sdb3 (xfs 
> non-mounted).
>     This operation could destroy your data.  Are you sure (y/N)? y
>     Syncing disks..
>     Beginning TRIM operations..
>     Trimming 168 free extents encompassing 8793136 sectors (4294 MB)
>     Done.
>     
>     real    0m1.249s
>     user    0m0.110s
>     sys     0m0.063s
> 
> That includes the time for me to type 'y' and hit enter.  :)
..

For completeness, here's the same operation again,
except this time on the *mounted* xfs filesystem.
It won't be trimming quite as many blocks
(leaves 1% free space in reserve),
but otherwise is similar:

	[~] time wiper.sh /dev/sdb3 --commit
	
	wiper.sh: Linux SATA SSD TRIM utility, version 1.9b, by Mark Lord.
	Preparing for online TRIM of free space on /dev/sdb3 (xfs mounted read-write at /x).
	This operation could destroy your data.  Are you sure (y/N)? y
	Creating temporary file (4348405 KB)..
	Syncing disks..
	Beginning TRIM operations..
	Trimming 134 free extents encompassing 8696816 sectors (4246 MB)
	Removing temporary file..
	Syncing disks..
	Done.
	
	real    0m1.212s
	user    0m0.043s
	sys     0m0.053s

