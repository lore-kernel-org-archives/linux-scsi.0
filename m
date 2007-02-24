From: Theodore Tso <tytso@mit.edu>
Subject: Re: end to end error recovery musings
Date: Fri, 23 Feb 2007 21:32:29 -0500
Message-ID: <20070224023229.GB4380@thunk.org>
References: <45DEF6EF.3020509@emc.com> <45DF80C9.5080606@zytor.com> <20070224003723.GS10715@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070224003723.GS10715@schatzie.adilger.int>
Sender: linux-ide-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>, Ric Wheeler <ric@emc.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Neil Brown <neilb@suse.de>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Feb 23, 2007 at 05:37:23PM -0700, Andreas Dilger wrote:
> > Probably the only sane thing to do is to remember the bad sectors and 
> > avoid attempting reading them; that would mean marking "automatic" 
> > versus "explicitly requested" requests to determine whether or not to 
> > filter them against a list of discovered bad blocks.
> 
> And clearing this list when the sector is overwritten, as it will almost
> certainly be relocated at the disk level.  For that matter, a huge win
> would be to have the MD RAID layer rewrite only the bad sector (in hopes
> of the disk relocating it) instead of failing the whiole disk.  Otherwise,
> a few read errors on different disks in a RAID set can take the whole
> system offline.  Apologies if this is already done in recent kernels...

And having a way of making this list available to both the filesystem
and to a userspace utility, so they can more easily deal with doing a
forced rewrite of the bad sector, after determining which file is
involved and perhaps doing something intelligent (up to and including
automatically requesting a backup system to fetch a backup version of
the file, and if it can be determined that the file shouldn't have
been changed since the last backup, automatically fixing up the
corrupted data block :-).

						- Ted
