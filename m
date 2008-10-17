From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct
	kobject source.
Date: Fri, 17 Oct 2008 13:10:17 -0700
Message-ID: <20081017201017.GA10613@kroah.com>
References: <1224226555.5556.279.camel@haakon2.linux-iscsi.org> <20081017074453.GA4850@kroah.com> <1224231739.5556.303.camel@haakon2.linux-iscsi.org> <20081017173959.GC2221@kroah.com> <1224271173.5556.349.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1224271173.5556.349.camel@haakon2.linux-iscsi.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Joel Becker <joel.becker@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 17, 2008 at 12:19:33PM -0700, Nicholas A. Bellinger wrote:
> On Fri, 2008-10-17 at 10:39 -0700, Greg KH wrote:
> > On Fri, Oct 17, 2008 at 01:22:18AM -0700, Nicholas A. Bellinger wrote:
> > > On Fri, 2008-10-17 at 00:44 -0700, Greg KH wrote:
> > > > On Thu, Oct 16, 2008 at 11:55:55PM -0700, Nicholas A. Bellinger wrote:
> > > > > Hi Joel, Greg and Co,
> > > > > 
> > > > > Here is the the first working code for allowing configfs to handle
> > > > > symlinks from sysfs struct kobject based code.  Here is the commit:
> > > > > passing struct kobject into generic target_core_mod subsystem plugins
> > > > > for locating struct block_device and struct scsi_device..  
> > > > 
> > > > Um, no.
> > > > 
> > > > You are trying to create symlinks dynamically across superblocks and
> > > > mount points?  As one of your #warning states, this isn't possible to do
> > > > correctly, nor is it even a good idea.
> > > > 
> > > > So I'd have to reject this patch, sorry.
> > > > 
> > > > What is the problem you are attempting to solve here?
> > > > 
> > > 
> > > So, the generic target_core_mod engine that lives
> > > under /sys/kernel/config/target/core needs a method to locate struct
> > > block_device and struct scsi_device for access via bio_submit() and
> > > scsi_execute_() respectively.
> > 
> > Then just pass the "name" of the block device into a configfs file,
> > nothing more is needed, right?
> > 
> 
> What are the preferred methods for accessing struct block_device and
> struct scsi_device from "name"..?

call "find_by_name" for a type (this would be block type) and get the
return value?  Can't remember the actual function call, but it's obvious
if you look at device.h.

> > > Originally, target_core_mod used key echoed through configfs attributes
> > > like so:
> > > 
> > > export TARGET=/sys/kernel/config/target/core/
> > > 
> > > # Create $STORAGE_OBJECT of type Linux/BLOCK in generic target_core_mod
> > > mkdir -p $TARGET/iblock_0/lvm_test0
> > > # OLD METHOD to reference struct block_device
> > > echo iblock_major=254,iblock_minor=2 > $TARGET/iblock_0/lvm_test0/control
> > > echo 1 > $TARGET/iblock_0/lvm_test0/enable
> > > # NEW METHOD using sysfs ->configfs symlinks to reference struct block_device
> > > ln -s /sys/block/dm-2 $TARGET/iblock_0/lvm_test0/dm-2
> > 
> > No, you can't do a symlink across superblocks and expect it to work like
> > you are thinking internally.
> > 
> 
> <nod>  As I am coding configfs_follow_symlink() to work with sysfs
> source symlinks I am starting to see that.. :-)  I am still going to
> hack on it for a bit and see if I can get it running so that it works..

Even if you get it "to work", it's not going to be able to be accepted,
sorry.

thanks,

greg k-h
