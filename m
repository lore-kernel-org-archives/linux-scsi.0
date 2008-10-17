From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH] [ConfigFS]: Allow symbolic links from a SysFS struct
	kobject source.
Date: Fri, 17 Oct 2008 12:02:07 -0700
Message-ID: <1224270127.5556.331.camel@haakon2.linux-iscsi.org>
References: <1224226555.5556.279.camel@haakon2.linux-iscsi.org>
	 <20081017074453.GA4850@kroah.com>
	 <1224231739.5556.303.camel@haakon2.linux-iscsi.org>
	 <20081017113252.GV15064@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:47209 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754812AbYJQTCK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2008 15:02:10 -0400
In-Reply-To: <20081017113252.GV15064@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Greg KH <greg@kroah.com>, Joel Becker <joel.becker@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Alan Stern <stern@rowland.harvard.edu>, Andrew Morton <akpm@osdl.org>, Christoph Hellwig <hch@infradead.org>

On Fri, 2008-10-17 at 05:32 -0600, Matthew Wilcox wrote:
> On Fri, Oct 17, 2008 at 01:22:18AM -0700, Nicholas A. Bellinger wrote:
> > This of course means that non TYPE_DISK of struct scsi_device would need
> > to appear under /sys/ to be referenced using the symlink method..  I
> > know that drivers/scsi/sr.c currently does not show up under /sys..
> 
> Hmm?
> 
> $ ls -l /sys/block/sr0/
> total 0
> lrwxrwxrwx 1 root root    0 2008-10-17 07:30 bdi -> ../../class/bdi/11:0
> -r--r--r-- 1 root root 4096 2008-10-17 07:30 capability
> -r--r--r-- 1 root root 4096 2008-10-17 07:30 dev
> lrwxrwxrwx 1 root root    0 2008-10-17 07:30 device -> ../../devices/pci0000:00/0000:00:1f.1/host3/target3:0:0/3:0:0:0
> drwxr-xr-x 2 root root    0 2008-10-17 07:30 holders
> drwxr-xr-x 2 root root    0 2008-10-17 07:30 power
> drwxr-xr-x 3 root root    0 2008-10-17 07:30 queue
> -r--r--r-- 1 root root 4096 2008-10-17 07:30 range
> -r--r--r-- 1 root root 4096 2008-10-17 07:30 removable
> -r--r--r-- 1 root root 4096 2008-10-17 07:30 ro
> -r--r--r-- 1 root root 4096 2008-10-17 07:30 size
> drwxr-xr-x 2 root root    0 2008-10-17 07:30 slaves
> -r--r--r-- 1 root root 4096 2008-10-17 07:30 stat
> lrwxrwxrwx 1 root root    0 2008-10-17 07:30 subsystem -> ../../block
> -rw-r--r-- 1 root root 4096 2008-10-17 07:30 uevent
> 

Oh good, I guess I missed that this has been added a while ago for
TYPE_CDROM.  I had been looking at trying to change something with sr0 a
while back, I think it was an incorrectly set max_sectors on the
Playstation3, but I could not find the was to do this with TYPE_CDROM as
is possible with TYPE_DISK.

So now that those two work, what about other SCSI device types that
appear as character devices?  The most obvious ones that come to mind
are TYPE_MEDIUM_CHANGER and TYPE_TAPE.  As they do not appear
under /sys/block, to enable the SCSI passthrough for target_core_mod
using symlinks from sysfs -> configfs using the patch, the sysfs source
needs to point to struct device..  For example, with the current code,
the export of sr0 would now look like:

# Enable sr0 for DVD target passthrough access
mkdir $TARGET/core/pscsi_0/dvd_rom
ln -s /sys/block/sr0/device $TARGET/core/pscsi_0/dvd_rom/dvd_passthrough

So what about for TYPE_TYPE..?  I am guessing you would need to grab the
struct device (to reference the struct scsi_device by struct kobject
using the configfs patch) through /sys/class/$SCSI_HCTL/device, for the
SCSI passthrough case, right..?

# Also enable a SCSI tape for target passthrough access..?
mkdir $TARGET/core/pscsi_1/my_superturbotapearray
ln -s /sys/class/1:0:0:0/device $TARGET/core/pscsi_1/my_superturbotapearray/tape_passthrough

# MEDIUM_CHANGER too..?
mkdir $TARGET/core/pscsi_1/my_superturbomc
ln -s /sys/class/1:0:1:0/device $TARGET/core/pscsi_1/my_superturbomc/mc_passthrough

I don't have real MEDIUM_CHANGER onsite, so if anyone wanted to test
this with my current patches in lio-core-2.6.git please let me know.
I will try hooking up my old SCSI tape drive this weekend and see if
TYPE_TAPE works. :-)

The idea is through the change to allow sysfs source symlinks (the patch
still needs to handle follow_link() correctly) to pass any struct
kobject through the configfs struct config_item_operations API while
calling kobject_get() and kobject_put() to protect/release the reference
to struct kobject inside of fs/configfs/symlink.c.

--nab

