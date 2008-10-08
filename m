From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE]: ConfigFS enabled Generic Target Mode and
	iSCSI	Target Stack on v2.6.27-rc7
Date: Wed, 08 Oct 2008 00:22:01 -0700
Message-ID: <1223450521.15764.349.camel@haakon2.linux-iscsi.org>
References: <1222716101.4296.41.camel@haakon2.linux-iscsi.org>
	 <48E3B529.4060406@vlnb.net>
	 <1222907050.15764.56.camel@haakon2.linux-iscsi.org>
	 <48E4FE3F.2080707@vlnb.net>
	 <1222982972.15764.118.camel@haakon2.linux-iscsi.org>
	 <48EB325E.6050907@vlnb.net>
	 <1223412658.15764.306.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:45884 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752244AbYJHHWn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2008 03:22:43 -0400
In-Reply-To: <1223412658.15764.306.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-iscsi-target-dev@googlegroups.com, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, Greg KH <greg@kroah.com>, Jerome Martin <tramjoe.merin@gmail.com>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Joel Becker <joel.becker@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>

On Tue, 2008-10-07 at 17:01 -0700, Nicholas A. Bellinger wrote:

<SNIP>

> > > The the Initiator Port ACLs need to go
> > > under /sys/kernel/config/target/$FABRIC because the struct fabric_acl *
> > > will always contain fabric dependent config items.  For example, Since
> > > these struct fabric_acl_t do *NOT* symlink directly back to
> > > target_core_mod under /sys/kernel/config/target/core/$HBA/$DEV, but to
> > > fabric_lun_t (iscsi_lun_t in my case) to Symlink to
> > > a /sys/kernel/config/target/core/$HBA/$DEV that has been registered with
> > > the generic target configfs infrastructure.
> > > 
> > > Here is what I am thinking wrt /sys/kernel/config/target/iscsi and iSCSI
> > > Initiator Node ACLs to iSCSI Portal Groups and iSCSI LUNs attached to
> > > those Portal Groups.  There are two cases:
> > > 
> > > *) The production case with with user creating those ACLs under $FABRIC
> > > (which is what I will focus on now).
> > > 
> > > * And "Demo Mode" case where any Initiator logging into
> > > $FABRIC/$ENDPOINT/$PORTAL can have access to all
> > > $FABRIC/$ENDPOINT/lun/lun_*/*my_ports*
> > > 
> > > The production ACL case would look like:
> > > 
> > > export CONFIGFS=/sys/kernel/config/
> > > export TARGET=/sys/kernel/config/target/core/
> > > export FABRIC=/sys/kernel/config/target/iscsi/
> > > 
> > > TARGET_IQN=iqn.2003-01.org.linux-iscsi.ps3-cell.ppc64:sn.f8f651bd5fec
> > > INITIATOR_IQN=iqn.1993-08.org.debian:01.f82074ca555f
> > > 
> > > <Setup $STORAGE_OBJECTs under $TARGET>
> > > 
> > > # Create the LIO-target endpoint
> > > mkdir -p "$FABRIC/$TARGET_IQN/tpgt_1/np/172.16.201.137:3260"
> > > mkdir -p "$FABRIC/$TARGET_IQN/tpgt_1/lun/lun_0"
> > > 
> > > <Setup Port Symlinks from $TARGET to $TARGET_IQN/tpgt_1/lun/lun_0>
> > > 
> > > # Create the Initiator ACL under $TARGET_IQN/tpgt_1
> > > mkdir -p $"FABRIC/$TARGET_IQN/tpgt_1/initiators/$INITIATOR_IQN"
> > > # Allow $INITIATOR_IQN access to tpgt_1/lun/lun_0/
> > > ln -s "$FABRIC/$TARGET_IQN/tpgt_1/lun/lun_0" \
> > > 	"$FABRIC/$TARGET_IQN/tpgt_1/initiators/$INITIATOR_IQN/lun_0"
> > > 
> > >>From there, you don't have to worry about PAGE_SIZE limitiations w/o, I
> > > can simply use use:
> > > 
> > > cat $FABRIC/iqn*/tpgt*/initiators/*/session
> > > 
> > > to see which acl'ed iSCSI Initiators are logged in on all iSCSI Target
> > > Ports.
> > > 
> > > Also I should add that I am currently using /proc/scsi_target/mib
> > > and /proc/iscsi_target_mib for READ-ONLY data with target_core_mod.ko
> > > and iscsi_target_mod.ko respectively.  For the other "Demo Mode" case
> > > mentioned above, I am currently using /proc/iscsi_target/mib/sess_attr
> > > to see the active sessions for LIO-Target.
> > 
> > Sorry for the delay. I didn't have a chance to look at it sufficiently 
> > close.
> > 
> > Basically the idea about how to manage ACLs is good, but I don't like, 
> > that with it *ALL* the target drivers would have to implement the 
> > necessary code. It shouldn't be so, management of all security stuff 
> > should be purely duty of the mid-layer.
> 
> By the "mid-layer" I assume you mean the generic target mode engine, and
> not the SCSI mid layer, yes..?
> 
> Point taken however that $TARGET_MOD could, and probably should have
> some manner of generic ACL infrastructure available through FABRIC <->
> TARGET API.  I will have a look at scst_register() and
> scst_register_session() and see where it should be adapted to
> target_core_mod.
> 
> Btw, saying that "management of all security stuff should be purely duty
> of the mid-layer" is incorrect however.  The generic target engine needs
> to make it *EASIER* for $FABRIC to allow those initiator ports access to
> Mapped LUNs through fabric *DEPENDENT* endpoints, but trying to put all
> fabric depepdent ACL endpoint logic in target_core_mod is IMHO a bad
> idea.  
> 
> Since each SCSI fabric's method of attaching SCSI LUN to Initiator Port
> Endpoints in $FABRIC_MOD to SCSI Device (I have been calling
> this /sys/kernel/config/target/core/$STORAGE_OBJECT for target_core_mod)
> to create the SCSI Target Port is different.  The reference I use for
> iscsi_target_mod (and hence wrt target_core_mod) is proper T10/SCSI
> terminlogy AFAIK.  Lets reference the objects in
> http://www.haifa.il.ibm.com/satran/ips/EddyQuicksall-iSCSI-in-diagrams/portal_groups.pdf 
> for the discussion so we can make sure we are on the same page..
> 
> For example, just because iSCSI uses TargetName + TargetPortalGroupTag
> to attach target_core_mod's $STORAGE_OBJECTs at iSCSI Logical Units to,
> does not mean that SAS, or another SCSI based target fabric know
> anything about TargetName or TargetPortalGroupTag.  In iSCSI, this is
> defined in Section 2.1: 
> 
>      The I_T nexus can be identified by the conjunction of the SCSI port
>      names; that is, the I_T nexus identifier is the tuple (iSCSI
>      Initiator Name + ',i,'+ ISID, iSCSI Target Name + ',t,'+ Portal 
>      Group Tag).
> 
> Obviously the Initiator and Target Ports wrt iSCSI fabric are more
> "symbolic" than devices attached to say a legacy Parallel SCSI bus
> because of IP storage having multiple IP network portals across multiple
> independent backbone providers and subnets (if you are using MC/S or
> SCTP), etc, etc.  This is this reason I think it does not make sense to
> try to locate fabric dependent ACLs
> under /sys/kernel/config/target/core/$STORAGE_OBJECT.  
> 
> The type of things that need to be under $STORAGE_OBJECT, and that do
> have a direct effect for $FABRIC mapped LUN endpoints are things like
> device_type, max_sectors, sector_size, queue_depth and global READ-ONLY.
> Of course, we want to be able to see *ALL* of
> the /sys/kernel/config/target/$FABRIC dependent ACLs that have been
> symlinked to said $STORAGE_OBJECT (this is one of the items on my list,
> but not implemented in my current work).
> 
> >  And this is exactly implemented 
> > in SCST. All what target drivers should do with it is to pass target's 
> > name on its registration in scst_register() and then while registering a 
> > session with remote initiator using scst_register_session() pass to it 
> > the initiator's name. Everything else is done by the SCST core.
> > 
> 
> At registration, I assume you mean admin wants to add an endpoint ACL
> for a Initiator Port through $FABRIC/endpoint through $FABRIC_MOD..?
> 
> > Thus, I believe, all the ACL management should be done not in $FABRIC/, 
> > but in $TARGET/. It would remove all the corresponding configfs 
> > headaches from the target drivers writers.
> > 
> 
> I am not sure what "corresponding configfs headaches" you have in mind,
> but please be specific and I will address them. :-)
> 
> > But, in fact, I asked about completely different thing. SCSI target 
> > mid-layer in some cases needs to export in user space amount of data, 
> > which doesn't fit one page. /proc/scsi_tgt/sessions is one example. What 
> > should we do for it?
> > 
> 
> I did address point above in my work, and my commits
> under /sys/kernel/config/target/iscsi implement how I get around the
> PAGE_SIZE limitiations, which was something that I ran into (moving from
> IOCTL and all, which requires overly complex kernel level information
> code to get lots of output), to using ConfigFS, which has the same as
> procfs and sysfs limits that you need to use seq_file() for > PAGE_SIZE.
> Anyways, I did not end up using seq_file() for iscsi_target_mod current
> configfs code, here is what I am using to address your above example wrt
> getting all of session output:
> 
> >>From there, you don't have to worry about PAGE_SIZE limitiations w/o >
> > > I can simply use use:
> > > 
> > > cat $FABRIC/iqn*/tpgt*/initiators/*/session
> > > 
> 
> This ended up being `cat $FABRIC/iqn*/tpgt*/acls/*/info` to view all of
> the active iSCSI Sessions on all iSCSI Target fabric endpoints..
> 
> The point is that regardless of kernel <-> user information output
> method, it makes sense to break up large pieces of kernel level
> information code and rely upon access through the VFS and cat to obtain
> bulk output.
> 
> However, Joel has discussed removing the > PAGE_SIZE limitation for all
> of the virtual filesystems, so I am sure he would be more than happy to
> take a  patch that addressed your concern if it is really that big of a
> deal for the SCSI control path.  With my current work with
> target_core_mod and iscsi_target_mod wrt configfs I am not running into
> this problem, so me producing this patch is not very high on my list..
> 
> > > I will be implementing this model over the next days..  I will post the
> > > commit once its up and you can have a look..
> > > 
> 
> Ok, I ended up using a slightly different model for ACLs
> under /sys/kernel/config/target/iscsi that the one I mentioned from last
> week to get things up and running.  I will be posting the commit and
> info shortly.
> 

Ok, here is the commit:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commit;h=d1dc1c1da8375c1b9099166d7d93f7f45477f892

In the example I am using two iSCSI Initiators (one Debian and one
OpenSuse) that both have TPG LUN 0 and 1 mapped to their Initiator LUN 0
and 1 under $FABRIC/$IQN/tpgt_1.

Here is what it looks like from the CLI:

export TARGET=/sys/kernel/config/target/core/
export FABRIC=/sys/kernel/config/target/iscsi/

<Setup target_core_mod storage objects..>

DEF_IQN="iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0"

# The first mkdir(2) to $FABRIC will load iscsi_target_mod
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/np/172.16.201.137:3260"
# Create TPG LUN 0 and symlink $STORAGE_OBJECT from target_core_mod
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0"
ln -s $TARGET/iblock_0/lvm_test0 "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0/lio_west_port"
# Create TPG LUN 1 and symlink $STORAGE_OBJECT from target_core_mod
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1"
ln -s $TARGET/pscsi_0/sdd "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1/lio_east_port"

INITIATOR_DEBIAN="iqn.1993-08.org.debian:01:2dadf92d0ef"

# Create Node and two LUN ACL Symlinks for Debian Initiator
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_0"
ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_0/."
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_1"
ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_DEBIAN/lun_1/."

INITIATOR_SUSE="iqn.1996-04.de.suse:01:1661f9ee7b5"

# Create Node and two LUN ACL Symlinks for Suse Initiator
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_0"
ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_0" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_0/."
mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_1"
ln -s "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1" "$FABRIC/$DEF_IQN/tpgt_1/acls/$INITIATOR_SUSE/lun_1/."

# Enable the $FABRIC endpoint so it can accept new iSCSI sessions.
echo 1 > $FABRIC/$DEF_IQN/tpgt_1/enable


And running....


target:/sys/kernel/config# tree $FABRIC
/sys/kernel/config/target/iscsi/
|-- iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
|   `-- tpgt_1
|       |-- acls
|       |   |-- iqn.1993-08.org.debian:01:2dadf92d0ef
|       |   |   |-- control
|       |   |   |-- info
|       |   |   |-- lun_0
|       |   |   |   `-- lun_0 -> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_0
|       |   |   `-- lun_1
|       |   |       `-- lun_1 -> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_1
|       |   `-- iqn.1996-04.de.suse:01:1661f9ee7b5
|       |       |-- control
|       |       |-- info
|       |       |-- lun_0
|       |       |   `-- lun_0 -> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_0
|       |       `-- lun_1
|       |           `-- lun_1 -> ../../../../../../../target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0/tpgt_1/lun/lun_1
|       |-- control
|       |-- enable
|       |-- lun
|       |   |-- lun_0
|       |   |   |-- control
|       |   |   |-- info
|       |   |   `-- lio_west_port -> ../../../../../../target/core/iblock_0/lvm_test0
|       |   `-- lun_1
|       |       |-- control
|       |       |-- info
|       |       `-- lio_east_port -> ../../../../../../target/core/pscsi_0/sdd
|       `-- np
|           `-- 172.16.201.137:3260
|               `-- portal_info
`-- lio_version

20 directories, 12 files

Note that iSCSI Initiator LUN ACL Symlinks are done on a per TPGT
context and are only allowed for TPG LUNs under the same
$FABRIC/$IQN/$TPGT path.

--------------------------------------------------------------------------------

Dump information for all running iSCSI Sessons on all iSCSI Target
endpoints..:

target:/sys/kernel/config# cat $FABRIC/iqn*/tpgt*/acls/*/info

InitiatorName: iqn.1993-08.org.debian:01:2dadf92d0ef
InitiatorAlias: ubuntu
LIO Session ID: 2   ISID: 0x00 02 3d 05 00 00  TSIH: 2  SessionType: Normal
Cmds in Session Pool: 1  Session State: TARG_SESS_STATE_LOGGED_IN
---------------------[iSCSI Session Values]-----------------------
  CmdSN/WR  :  CmdSN/WC  :  ExpCmdSN  :  MaxCmdSN  :     ITT    :     TTT
 0x00000010   0x00000010   0x00000042   0x00000051   0x090a0040   0x000000e7
----------------------[iSCSI Connections]-------------------------
CID: 0  Connection State: TARG_CONN_STATE_LOGGED_IN
   Address 172.16.201.129 TCP  StatSN: 0x0000006c
InitiatorName: iqn.1996-04.de.suse:01:1661f9ee7b5
InitiatorAlias: opensuse
LIO Session ID: 13   ISID: 0x00 02 3d 01 00 00  TSIH: 13  SessionType: Normal
Cmds in Session Pool: 1  Session State: TARG_SESS_STATE_LOGGED_IN
---------------------[iSCSI Session Values]-----------------------
  CmdSN/WR  :  CmdSN/WC  :  ExpCmdSN  :  MaxCmdSN  :     ITT    :     TTT
 0x00000010   0x00000010   0x00000022   0x00000031   0x040a0000   0x00000003
----------------------[iSCSI Connections]-------------------------
CID: 0  Connection State: TARG_CONN_STATE_LOGGED_IN
   Address 172.16.201.136 TCP  StatSN: 0x00000003


Anyways, you get the idea.  The primary functionality is up for getting
ACLs iSCSI Initiator Nodes and LUNs symlinked to TPG LUNs symlinked to
$STORAGE_OBJECTs from target_core_mod.   I will be continuing to convert
stuff from the IOCTL, mostly things that need to be made into configfs
attributes.  I am going to focus on the getting the remaining stuff
under configfs up for iscsi_target_mod, and start looking at the much
larger todo item of seeing how we can merge target_core_mod and scst
core..  Please have a look and let me know what you think (espically the
target_core_mod parts), and I will pull the latest SCST code and start
looking at the FABRIC <-> TARGET you mentioned..

--nab

