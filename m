From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: ConfigFS + Target Mode Engine API discussion
Date: Thu, 11 Sep 2008 01:58:49 -0700
Message-ID: <1221123529.27831.343.camel@haakon2.linux-iscsi.org>
References: <1221087547.27831.165.camel@haakon2.linux-iscsi.org>
	 <20080910233107.GC23864@mail.oracle.com>
	 <1221097366.27831.216.camel@haakon2.linux-iscsi.org>
	 <20080911021331.GA12902@mail.oracle.com>
	 <1221107358.27831.289.camel@haakon2.linux-iscsi.org>
	 <20080911063846.GB16583@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:43653 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752698AbYIKI6v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2008 04:58:51 -0400
In-Reply-To: <20080911063846.GB16583@mail.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Becker <Joel.Becker@oracle.com>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, SCST-Devel <scst-devel@lists.sourceforge.net>

On Wed, 2008-09-10 at 23:38 -0700, Joel Becker wrote:
> On Wed, Sep 10, 2008 at 09:29:18PM -0700, Nicholas A. Bellinger wrote:
> > On Wed, 2008-09-10 at 19:13 -0700, Joel Becker wrote:
> > > On Wed, Sep 10, 2008 at 06:42:46PM -0700, Nicholas A. Bellinger wrote:
> > > > So I am thinking about the following question:  What would be the
> > > > preferred method for calling ct_group_ops->make_group() in order to
> > > > create the $CONFIGFS/target/$FABRIC struct config_item directly from
> > > > target_fabric_configfs_register() call?  From there, the config group
> > > > hanging off $CONFIGFS/target/$FABRIC will be fabric dependent and
> > > > providing their own groups, items, depends, from the passed *fabric_cit.
> > > > How do I "simulate" a mkdir(2) configfs -> make_group() call coming from
> > > > the fabric module itself..?   This would be assuming that both mkdir(2)
> > > 
> > > 	That's precisely what you don't do with configfs.  It's a
> > > defined "not to be done" thing.  So there's no preferred way, there's no
> > > way at all.
> > > 	What you want do to is drive this from mkdir().  The
> > > make_group() will look up the sub-module it needs and return the
> > > appropriate item.
> > > 
> > 
> > Whew, good thing I asked about this case first..  :-)
> 
> 	Can you give me a more complete description of what you're
> trying to do?  that way I can maybe help with some suggestions.
> 

Sure, the process to get the things up and running would look like:

# Load in the generic target's configfs infrastructure
modprobe target_core_configfs

*) $CONFIGFS/target is created with configfs_register_subsystem()

*) $CONFIGFS/target/core is created as a default group under struct
configfs_subsystem->su_group to interact with generic target mode
engine's storage objects (eg: SCSI HCTL referenced devices, LVM UUID, MD
UUID). 

...........

 # Load LIO-Target using function symbols from target_core_configfs
modprobe iscsi_target_mod

module_init() from iscsi_target_mod (eg: the fabric module) calls
target_fabric_configfs_register() in target_core_configfs.ko, which is a
small wrapper for calling sys_mkdir($CONFIGFS/target/$FABRIC) to kick
off the struct config_group_operations->make_group() to create a struct
config_item for /sys/kernel/config/target/iscsi (or whatever the fabric
is called).

config_item_get() is also called in target_fabric_configfs_register()
and returns the newly allocated struct config_item to
iscsi_target_mod.ko code to then create new struct config_groups for
iSCSI target fabric specific abstractions and LUN mappings between
$CONFIGFS/target/core/$STORAGE_OBJECT and Fabric dependent code. I think
the latter would be done with symlinks between $FABRIC <-> Generic
Target Core Storage Object.

Anyways, knowing that make_group() and drop_item() will *NEVER* be
called internally clears up alot for me.  I will keep working on this
setup and let you know if I run into any more head scratchers.

Thanks again Joel!

--nab


