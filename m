From: Neil Brown <neilb@suse.de>
Subject: Re: end to end error recovery musings
Date: Mon, 26 Feb 2007 16:33:37 +1100
Message-ID: <17890.28977.989203.938339@notabene.brown>
References: <45DEF6EF.3020509@emc.com>
	<45DF80C9.5080606@zytor.com>
	<20070224003723.GS10715@schatzie.adilger.int>
	<20070224023229.GB4380@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: message from Theodore Tso on Friday February 23
Sender: linux-ide-owner@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ric Wheeler <ric@emc.com>, Linux-ide <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-raid@vger.kernel.org, Tejun Heo <htejun@gmail.com>, James Bottomley <James.Bottomley@SteelEye.com>, Mark Lord <mlord@pobox.com>, Neil Brown <neilb@suse.de>, Jens Axboe <jens.axboe@oracle.com>, "Clark, Nathan" <Clark_Nathan@emc.com>, "Singh, Arvinder" <Singh_Arvinder@emc.com>, "De Smet, Jochen" <DeSmet_Jochen@emc.com>, "Farmer, Matt" <Farmer_Matt@emc.com>, linux-fsdevel@vger.kernel.org, "Mizar, Sunita" <Mizar_Sunita@emc.com>
List-Id: linux-scsi@vger.kernel.org

On Friday February 23, tytso@mit.edu wrote:
> On Fri, Feb 23, 2007 at 05:37:23PM -0700, Andreas Dilger wrote:
> > > Probably the only sane thing to do is to remember the bad sectors and 
> > > avoid attempting reading them; that would mean marking "automatic" 
> > > versus "explicitly requested" requests to determine whether or not to 
> > > filter them against a list of discovered bad blocks.
> > 
> > And clearing this list when the sector is overwritten, as it will almost
> > certainly be relocated at the disk level.  For that matter, a huge win
> > would be to have the MD RAID layer rewrite only the bad sector (in hopes
> > of the disk relocating it) instead of failing the whiole disk.  Otherwise,
> > a few read errors on different disks in a RAID set can take the whole
> > system offline.  Apologies if this is already done in recent kernels...

Yes, current md does this.

> 
> And having a way of making this list available to both the filesystem
> and to a userspace utility, so they can more easily deal with doing a
> forced rewrite of the bad sector, after determining which file is
> involved and perhaps doing something intelligent (up to and including
> automatically requesting a backup system to fetch a backup version of
> the file, and if it can be determined that the file shouldn't have
> been changed since the last backup, automatically fixing up the
> corrupted data block :-).
> 
> 						- Ted

So we want a clear path for media read errors from the device up to
user-space.  Stacked devices (like md) would do appropriate mappings
maybe (for raid0/linear at least.  Other levels wouldn't tolerate
errors).
There would need to be a limit on the number of 'bad blocks' that is
recorded.  Maybe a mechanism to clear old bad  blocks from the list is
needed.

Maybe if generic make request gets a request for a block which
overlaps a 'bad-block' it returns an error immediately.

Do we want a path in the other direction to handle write errors?  The
file system could say "Don't worry to much if this block cannot be
written, just return an error and I will write it somewhere else"?
This might allow md not to fail a whole drive if there is a single
write error.
Or is that completely un-necessary as all modern devices do bad-block
relocation for us?
Is there any need for a bad-block-relocating layer in md or dm?

What about corrected-error counts?  Drives provide them with SMART.
The SCSI layer could provide some as well.  Md can do a similar thing
to some extent.  Where these are actually useful predictors of pending
failure is unclear, but there could be some value.
e.g. after a certain number of recovered errors raid5 could trigger a
background consistency check, or a filesystem could trigger a
background fsck should it support that.


Lots of interesting questions... not so many answers.

NeilBrown
