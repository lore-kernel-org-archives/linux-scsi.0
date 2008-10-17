From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct
	kobject source.
Date: Fri, 17 Oct 2008 01:22:18 -0700
Message-ID: <1224231739.5556.303.camel@haakon2.linux-iscsi.org>
References: <1224226555.5556.279.camel@haakon2.linux-iscsi.org>
	 <20081017074453.GA4850@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20081017074453.GA4850@kroah.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: Joel Becker <joel.becker@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2008-10-17 at 00:44 -0700, Greg KH wrote:
> On Thu, Oct 16, 2008 at 11:55:55PM -0700, Nicholas A. Bellinger wrote:
> > Hi Joel, Greg and Co,
> > 
> > Here is the the first working code for allowing configfs to handle
> > symlinks from sysfs struct kobject based code.  Here is the commit:
> > passing struct kobject into generic target_core_mod subsystem plugins
> > for locating struct block_device and struct scsi_device..  
> 
> Um, no.
> 
> You are trying to create symlinks dynamically across superblocks and
> mount points?  As one of your #warning states, this isn't possible to do
> correctly, nor is it even a good idea.
> 
> So I'd have to reject this patch, sorry.
> 
> What is the problem you are attempting to solve here?
> 

So, the generic target_core_mod engine that lives
under /sys/kernel/config/target/core needs a method to locate struct
block_device and struct scsi_device for access via bio_submit() and
scsi_execute_() respectively.

Originally, target_core_mod used key echoed through configfs attributes
like so:

export TARGET=/sys/kernel/config/target/core/

# Create $STORAGE_OBJECT of type Linux/BLOCK in generic target_core_mod
mkdir -p $TARGET/iblock_0/lvm_test0
# OLD METHOD to reference struct block_device
echo iblock_major=254,iblock_minor=2 > $TARGET/iblock_0/lvm_test0/control
echo 1 > $TARGET/iblock_0/lvm_test0/enable
# NEW METHOD using sysfs ->configfs symlinks to reference struct block_device
ln -s /sys/block/dm-2 $TARGET/iblock_0/lvm_test0/dm-2

# Create $STORAGE_OBJET of type Linux/SCSI in generic target_core_mod
mkdir -p $TARGET/pscsi_0/sdd
# OLD METHOD to reference struct scsi_device
echo scsi_channel_id=0,scsi_target_id=3,scsi_lun_id=0 > $TARGET/pscsi_0/sdd/control
echo 1 > $TARGET/pscsi_0/sdd/enable
# NEW METHOD using sysfs -> configfs symlinks to reference struct scsi_device
ln -s /sys/block/sdd/device $TARGET/pscsi_0/sdd/passthrough

This of course means that non TYPE_DISK of struct scsi_device would need
to appear under /sys/ to be referenced using the symlink method..  I
know that drivers/scsi/sr.c currently does not show up under /sys..

Anyways, the idea is that its *ONLY* this special case for struct
kobject as symlink source to struct config_item as symlink destination
through the config struct config_item_operations API..  For the generic
target_core_mod engine case, it seems like a good method to reference
block and scsi related data structures for struct devices that folks
want to use for target export across one or more $FABRIC modules (iSCSI,
SAS, FC, PSCSI, etc)..

I am more than happy to change the patch if there is a better way to get
the same functionality for target_core_mod  I would really not prefer
having to do targetfs, when configfs + sysfs symlinks seems to work in
my first few hours of testing, unless there is something huge that I am
missing..?.

The other point is that since configfs is based on sysfs code, it only
makes sense to provide a API through configfs to take advantage of
kernel data structures that can be referenced using wrappers to
container_of() in include/linux/ in a common way.

--nab

> thanks,
> 
> greg k-h
> 

