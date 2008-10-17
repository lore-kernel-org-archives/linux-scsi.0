From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct
	kobject source.
Date: Fri, 17 Oct 2008 10:39:59 -0700
Message-ID: <20081017173959.GC2221@kroah.com>
References: <1224226555.5556.279.camel@haakon2.linux-iscsi.org> <20081017074453.GA4850@kroah.com> <1224231739.5556.303.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:38521 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754748AbYJQSsn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2008 14:48:43 -0400
Content-Disposition: inline
In-Reply-To: <1224231739.5556.303.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Joel Becker <joel.becker@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>

On Fri, Oct 17, 2008 at 01:22:18AM -0700, Nicholas A. Bellinger wrote:
> On Fri, 2008-10-17 at 00:44 -0700, Greg KH wrote:
> > On Thu, Oct 16, 2008 at 11:55:55PM -0700, Nicholas A. Bellinger wrote:
> > > Hi Joel, Greg and Co,
> > > 
> > > Here is the the first working code for allowing configfs to handle
> > > symlinks from sysfs struct kobject based code.  Here is the commit:
> > > passing struct kobject into generic target_core_mod subsystem plugins
> > > for locating struct block_device and struct scsi_device..  
> > 
> > Um, no.
> > 
> > You are trying to create symlinks dynamically across superblocks and
> > mount points?  As one of your #warning states, this isn't possible to do
> > correctly, nor is it even a good idea.
> > 
> > So I'd have to reject this patch, sorry.
> > 
> > What is the problem you are attempting to solve here?
> > 
> 
> So, the generic target_core_mod engine that lives
> under /sys/kernel/config/target/core needs a method to locate struct
> block_device and struct scsi_device for access via bio_submit() and
> scsi_execute_() respectively.

Then just pass the "name" of the block device into a configfs file,
nothing more is needed, right?

> Originally, target_core_mod used key echoed through configfs attributes
> like so:
> 
> export TARGET=/sys/kernel/config/target/core/
> 
> # Create $STORAGE_OBJECT of type Linux/BLOCK in generic target_core_mod
> mkdir -p $TARGET/iblock_0/lvm_test0
> # OLD METHOD to reference struct block_device
> echo iblock_major=254,iblock_minor=2 > $TARGET/iblock_0/lvm_test0/control
> echo 1 > $TARGET/iblock_0/lvm_test0/enable
> # NEW METHOD using sysfs ->configfs symlinks to reference struct block_device
> ln -s /sys/block/dm-2 $TARGET/iblock_0/lvm_test0/dm-2

No, you can't do a symlink across superblocks and expect it to work like
you are thinking internally.

> The other point is that since configfs is based on sysfs code, it only
> makes sense to provide a API through configfs to take advantage of
> kernel data structures that can be referenced using wrappers to
> container_of() in include/linux/ in a common way.

No, just because configfs looks like sysfs internally, does not mean
they are related in any manner.  We have been down this argument many
times in the past, please don't bring it up again, it has no bearing on
this at all.

thanks,

greg k-h
