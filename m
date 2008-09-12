From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: ConfigFS + Target Mode Engine API discussion
Date: Fri, 12 Sep 2008 15:27:57 -0700
Message-ID: <1221258477.3401.81.camel@haakon2.linux-iscsi.org>
References: <1221087547.27831.165.camel@haakon2.linux-iscsi.org>
	 <20080910233107.GC23864@mail.oracle.com>
	 <1221097366.27831.216.camel@haakon2.linux-iscsi.org>
	 <20080911021331.GA12902@mail.oracle.com>
	 <1221107358.27831.289.camel@haakon2.linux-iscsi.org>
	 <20080911063846.GB16583@mail.oracle.com>
	 <1221123529.27831.343.camel@haakon2.linux-iscsi.org>
	 <20080912201541.GA26469@mail.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:28662 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752558AbYILWyj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2008 18:54:39 -0400
In-Reply-To: <20080912201541.GA26469@mail.oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joel Becker <Joel.Becker@oracle.com>
Cc: "Linux-iSCSI.org Target Dev" <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, SCST-Devel <scst-devel@lists.sourceforge.net>

On Fri, 2008-09-12 at 13:15 -0700, Joel Becker wrote:
> On Thu, Sep 11, 2008 at 01:58:49AM -0700, Nicholas A. Bellinger wrote:
> > *) $CONFIGFS/target is created with configfs_register_subsystem()
> > 
> > *) $CONFIGFS/target/core is created as a default group under struct
> > configfs_subsystem->su_group to interact with generic target mode
> > engine's storage objects (eg: SCSI HCTL referenced devices, LVM UUID, MD
> > UUID). 
> > 
> > ...........
> > 
> >  # Load LIO-Target using function symbols from target_core_configfs
> > modprobe iscsi_target_mod
> > 
> > module_init() from iscsi_target_mod (eg: the fabric module) calls
> > target_fabric_configfs_register() in target_core_configfs.ko, which is a
> > small wrapper for calling sys_mkdir($CONFIGFS/target/$FABRIC) to kick
> > off the struct config_group_operations->make_group() to create a struct
> > config_item for /sys/kernel/config/target/iscsi (or whatever the fabric
> > is called).
> 
> 	No, you don't do this.  Like I said, configfs clients let
> userspace create and destroy items.  Not kernelspace.  Do not call
> sys_mkdir()/sys_rmdir() from your modules.
> 	If you don't do this, you also don't need your lookup_hash()
> export.  Your code should be behaving as if it didn't know the
> filesystem view existed.
> 	I'm trying to understand what you're actually doing.  Not the
> "I want iscsi_target_mod to appear under target/iscsi" part, but why it
> needs to be there in the first place.  how it all connects together.
> 

Well, the startup 'fabric registration' is only case where I figured
vfs_mkdir($CONFIGFS/target/$FABRIC) being called in order to have the
fabric struct config_item appear at modprobe $FABRIC_MOD *BEFORE* the
user did anything would be beneficial at all.   If vfs_mkdir() was not
called from transport_fabric_register_configfs(), it only means user
would have call mkdir $CONFIGFS/target/$FABRIC and/or mkdir -p
$CONFIGFS/target/$FABRIC/endpoint to kick off one common make_group()
for $FABRIC (that lives in target_core_configfs.c) and then make_group()
that likes inside of $FABRIC_MOD who's parent is $CONFIGFS/target.  In
LIO-Target's case, this would be creating a new iSCSI Qualified Name
with mkdir $CONFIGFS/target/iscsi/iqn.superturobdiskarry

The only real reason I am stuck on this is so that the modprobe $FABRIC
does not need to be followed by a user *REQUIRED* mkdir -p
$CONFIGFS/target/$FABRIC, before a normal operation like: mkdir
$CONFIGFS/target/$FABRIC/endpoint to kick off the expected two
make_groups() and the attributes in $CONFIGFS/target/$FABRIC to be
possibily tuned *BEFORE* the $FABRIC/$endpoint before the userspace
mkdir -p.  Which is not a big deal I suppose, as everything will be
there after mkdir -p $CONFIGFS/target/iscsi/iqn.superturobdiskarry
anyways, but I thought it could be useful.

Anyways, once the $FABRIC's struct config_item appears, everything from
that point is done in userspace as you (as the configfs author) would
expect with configfs structs located in $FABRIC_MOD driven by userspace
ops.  It is this method of automatic ops at modprobe $FABRIC_MOD for
struct config_item's particular struct target_fabric_configfs hanging of
the generic target's struct configfs_subsystem where any possible
benefit for automation of setup for a configfs enabled Generic Target
Engine many lie.  Same with the shutdown case for $FABRIC_MOD and
calling transport_fabric_deregister_configfs() at rmmod $FABRIC_MID.  If
vfs_rmdir() was NOT called, the user would be expected to call rmdir
$CONFIGFS/target/$FABRIC before rmmod $FABRIC_MOD.  It could be thought
of as:

A special case where vfs_mkdir() or vfs_rmdir() being called in order to
create the "multi-module" configfs subsystem containing struct
config_item_types() and struct config_*_operations in different kernel
modules..  As I don't believe the examples in
Documentation/filesystems/configfs or working code in
fs/ocfs2/cluster/nodemanager.c have this requirement AFAICT, it could be
considered a new use for configfs... :-)

I will be working on filling in target-ctl IOCTL parts in
iscsi_target_configfs.c, which look like expected configfs (not the
special case above) until you get to that other special case mentioned
earlier:  Wanting to creat a LUN mapping from a storage object from a
T10 EVPD Unit Serial to a registered
$CONFIGFS/target/$FABRIC/endpoint/lun when the
$CONFIGFS/target/core/$T10_EVPD_UNIT_SERIAL does not exist..

Thanks Joel!

--nab



> Joel
> 

