From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct
	kobject source.
Date: Fri, 17 Oct 2008 12:19:33 -0700
Message-ID: <1224271173.5556.349.camel@haakon2.linux-iscsi.org>
References: <1224226555.5556.279.camel@haakon2.linux-iscsi.org>
	 <20081017074453.GA4850@kroah.com>
	 <1224231739.5556.303.camel@haakon2.linux-iscsi.org>
	 <20081017173959.GC2221@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:25119 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755045AbYJQTTj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2008 15:19:39 -0400
In-Reply-To: <20081017173959.GC2221@kroah.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Joel Becker <joel.becker@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>

On Fri, 2008-10-17 at 10:39 -0700, Greg KH wrote:
> On Fri, Oct 17, 2008 at 01:22:18AM -0700, Nicholas A. Bellinger wrote:
> > On Fri, 2008-10-17 at 00:44 -0700, Greg KH wrote:
> > > On Thu, Oct 16, 2008 at 11:55:55PM -0700, Nicholas A. Bellinger wrote:
> > > > Hi Joel, Greg and Co,
> > > > 
> > > > Here is the the first working code for allowing configfs to handle
> > > > symlinks from sysfs struct kobject based code.  Here is the commit:
> > > > passing struct kobject into generic target_core_mod subsystem plugins
> > > > for locating struct block_device and struct scsi_device..  
> > > 
> > > Um, no.
> > > 
> > > You are trying to create symlinks dynamically across superblocks and
> > > mount points?  As one of your #warning states, this isn't possible to do
> > > correctly, nor is it even a good idea.
> > > 
> > > So I'd have to reject this patch, sorry.
> > > 
> > > What is the problem you are attempting to solve here?
> > > 
> > 
> > So, the generic target_core_mod engine that lives
> > under /sys/kernel/config/target/core needs a method to locate struct
> > block_device and struct scsi_device for access via bio_submit() and
> > scsi_execute_() respectively.
> 
> Then just pass the "name" of the block device into a configfs file,
> nothing more is needed, right?
> 

What are the preferred methods for accessing struct block_device and
struct scsi_device from "name"..?

> > Originally, target_core_mod used key echoed through configfs attributes
> > like so:
> > 
> > export TARGET=/sys/kernel/config/target/core/
> > 
> > # Create $STORAGE_OBJECT of type Linux/BLOCK in generic target_core_mod
> > mkdir -p $TARGET/iblock_0/lvm_test0
> > # OLD METHOD to reference struct block_device
> > echo iblock_major=254,iblock_minor=2 > $TARGET/iblock_0/lvm_test0/control
> > echo 1 > $TARGET/iblock_0/lvm_test0/enable
> > # NEW METHOD using sysfs ->configfs symlinks to reference struct block_device
> > ln -s /sys/block/dm-2 $TARGET/iblock_0/lvm_test0/dm-2
> 
> No, you can't do a symlink across superblocks and expect it to work like
> you are thinking internally.
> 

<nod>  As I am coding configfs_follow_symlink() to work with sysfs
source symlinks I am starting to see that.. :-)  I am still going to
hack on it for a bit and see if I can get it running so that it works..

> > The other point is that since configfs is based on sysfs code, it only
> > makes sense to provide a API through configfs to take advantage of
> > kernel data structures that can be referenced using wrappers to
> > container_of() in include/linux/ in a common way.
> 
> No, just because configfs looks like sysfs internally, does not mean
> they are related in any manner.  We have been down this argument many
> times in the past, please don't bring it up again, it has no bearing on
> this at all.
> 

Well, the goal is to use as much existing infrastructure as possible for
the generic target_core_mod when referencing Linux $STORAGE_OBJECTs, be
they struct scsi_device, struct block_device or struct file.. :-)

Having *SOME* type of communication between sysfs and configfs so that
those kernel data structures mentioned above can be accessed through
configfs still does seem like it could be useful..

Thanks for your comments,

--nab


