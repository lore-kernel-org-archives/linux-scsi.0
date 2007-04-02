From: Maneesh Soni <maneesh@in.ibm.com>
Subject: Re: [RFD driver-core] Lifetime problems of the current driver model
Date: Mon, 2 Apr 2007 17:40:53 +0530
Message-ID: <20070402121053.GA8450@in.ibm.com>
References: <460CDBA6.5030608@gmail.com> <1175257751.3760.19.camel@mulgrave.il.steeleye.com> <460D12B8.6050101@gmail.com> <1175278774.3760.44.camel@mulgrave.il.steeleye.com> <20070401195943.GA29627@htj.dyndns.org>
Reply-To: maneesh@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070401195943.GA29627@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, gregkh@suse.de, hugh@veritas.com, cornelia.huck@de.ibm.com, dmitry.torokhov@gmail.com, oneukum@suse.de, rpurdie@rpsys.net, Jeff Garzik <jgarzik@pobox.com>, lkml <linux-kernel@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Apr 02, 2007 at 04:59:43AM +0900, Tejun Heo wrote:
> Hello, James, Greg.
> 
> On Fri, Mar 30, 2007 at 01:19:34PM -0500, James Bottomley wrote:
> > That's sort of what I was reaching for too ... it just looks to me that
> > all the sysfs glue is in kobject, so they make a good candidate for the
> > pure sysfs objects.  Whatever we do, there has to be breakable cross
> > linking between the driver's tree and the sysfs representation ... of
> > course, nasty things like ksets get in the way of considering the
> > objects as separate, sigh.
> 
> The dependency between kobject and sysfs doesn't seem to be that
> tight.  I managed to break them such that sysfs can disconnect from
> its kobject on deletion _without_ changing sysfs/kobject API.
> 
> > > This way the sysfs reference counting can be put completely out of
> > > picture without impacting the rest of code.  Handling symlink and
> > > suicidal attributes might need some extra attention but I think they can
> > > be done.
> > 
> > True ... but you'll also have to implement something within sysfs to do
> > refcounting ... it needs to know how long to keep its nodes around.
> 
> sysfs_dirent already had reference counter and plays that role quite
> nicely.
> 
> Okay, here's preliminary patch.  I've tested it very lightly so it's
> likely to contain bugs and definitely needs to be splitted.
> 
> Dependencies between sysfs/kobject objects are clearer now and I think
> I got the locking and referencing correct.  This patch immediately
> fixes 'sysfs attr grabbing the wrong kobject and module' problem -
> sysfs and module lifetimes are unrelated now.  We can drop
> half-working attr->owner.
> 
> * A sysfs node no longer hold reference to its kobject.  It just
>   attaches itself to the kobject on creation and detaches on deletion.
> 

Earlier only sysfs leaf nodes held ref to kobject that is also 
only during open/close for regular files and in create/follow/destroy
symlinks.

> * For a dir node, sysfs_dirent no longer directly points to kobject.
>   It points to sysfs_dir which contains pointer to kobject and a rwsem
>   to protect it.
> 
> * An open file doesn't hold a reference to kobject.  It holds a
>   reference to sysfs_dirent.  kobject pointer is verified and
>   show/store are performed with rwsem read-locked.  Deletion
>   disconnects the sysfs from its kobject while the rwsem is
>   write-locked.  This mechanism replaces buffer orphaning and kobject
>   validation during open.
> 
> * attr ops is determined on sysfs node creation not on open.  This is
>   a step toward making kobject opaque in sysfs.
> 
> * bin files are handled similarly but mmap makes the open file hold
>   reference to the kobject till it's closed.  Any better ideas?
> > * symlink is reimplemented in terms of sysfs_dirents instead of
>   kobjects.  sysfs_dirent->s_parent is added and each sysfs_dirent
>   holds reference to its parent.  Currently walking up the tree
>   requires read locking and unlocking sysfs_dir at each level.  This
>   can be removed if name is added to sysfs_dirent.
> 
> * As kobject can be disconnected anytime and sysfs code still needs to
>   look follow dentry link in kobject, kobject->dentry is protected by
>   dcache_lock.  Once kobject becomes opaque to sysfs, this hack can go
>   away.  All in all, making kobject completely opaque in sysfs isn't
>   too far away after this patch although it would require mass code
>   update.
> 
> What do you think about this approach?  If it's acceptable, I'll test
> further and split the patch into logical steps to get it reviewed
> better.
> 

It does complicate a lot in sysfs code. The code is already quite fragile
considering the races (akpm is facing a couple of them, and which I am 
still working on) from VFS/dentry/inode angle. The previous rework of
sysfs was to make dentries/inodes corresponding to sysfs leaf nodes
reclaimable, i.e. looking at sysfs from VFS angle and IIUC you are 
looking at it from the driver layer to solve races between module/driver-
layer/sysfs, which is a valid purpose.

Following are the few rules in short to take care
1. directory dentries are pinned
2. regular files and symlink dentries are reclaimable
3. sysfs_dirent tree is protected using the parent inode's (ie directory 
   dentry's inode) i_mutex
4. sysfs rename is protected using a semaphore, sysfs_rename_sem also.
5. sysfs_dirent starts with refcount of 1 at the time of creation, refcount
   is incremented/decremented when a dentry is attached or detached. So, the
   refcount at the max can be 2. 
6. symlink creation pins the target kobject, so that the corresponding dentry
   is also pinned and removal releases the kobject.

There were few more additions like sysfs poll and shadow directory support,
for which respective authors can review and I can review the VFS related
changes but please split the patches as you like but one possible way
could be as chunks dealing with changes related to

1. data structure changes
2. creation/removal of directories
3. creation/removal of files
4. creation/removal of symlinks
5. open/read/write/close of a file

As far as testing is considered, doing insmod/rmmod in a tight loop in
parallel with working (find, open/read/writhe/close/ file) on /sys, 
makes a good enough testcase to hit races.

Thanks
Manesh

--
Maneesh Soni
Linux Technology Center,
IBM India Systems and Technology Lab, 
Bangalore, India
