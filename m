From: Andreas Dilger <adilger@clusterfs.com>
Subject: Re: end to end error recovery musings
Date: Fri, 23 Feb 2007 17:37:23 -0700
Message-ID: <20070224003723.GS10715@schatzie.adilger.int>
References: <45DEF6EF.3020509@emc.com> <45DF80C9.5080606@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45DF80C9.5080606@zytor.com>
Sender: linux-ide-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ric Wheeler <ric@emc.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Neil Brown <neilb@suse.de>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

On Feb 23, 2007  16:03 -0800, H. Peter Anvin wrote:
> Ric Wheeler wrote:
> >   (1) read-ahead often means that we will  retry every bad sector at 
> >least twice from the file system level. The first time, the fs read 
> >ahead request triggers a speculative read that includes the bad sector 
> >(triggering the error handling mechanisms) right before the real 
> >application triggers a read does the same thing.  Not sure what the 
> >answer is here since read-ahead is obviously a huge win in the normal case.
> 
> Probably the only sane thing to do is to remember the bad sectors and 
> avoid attempting reading them; that would mean marking "automatic" 
> versus "explicitly requested" requests to determine whether or not to 
> filter them against a list of discovered bad blocks.

And clearing this list when the sector is overwritten, as it will almost
certainly be relocated at the disk level.  For that matter, a huge win
would be to have the MD RAID layer rewrite only the bad sector (in hopes
of the disk relocating it) instead of failing the whiole disk.  Otherwise,
a few read errors on different disks in a RAID set can take the whole
system offline.  Apologies if this is already done in recent kernels...

Cheers, Andreas
--
Andreas Dilger
Principal Software Engineer
Cluster File Systems, Inc.

