From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE]: ConfigFS enabled Generic Target Mode and iSCSI
	Target Stack on v2.6.27-rc7
Date: Fri, 03 Oct 2008 16:14:17 -0700
Message-ID: <1223075657.15764.178.camel@haakon2.linux-iscsi.org>
References: <1222716101.4296.41.camel@haakon2.linux-iscsi.org>
	 <48E3B529.4060406@vlnb.net>
	 <1222907050.15764.56.camel@haakon2.linux-iscsi.org>
	 <48E4FE3F.2080707@vlnb.net>
	 <1222982972.15764.118.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp119.sbc.mail.sp1.yahoo.com ([69.147.64.92]:31981 "HELO
	smtp119.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752110AbYJCXOV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Oct 2008 19:14:21 -0400
In-Reply-To: <1222982972.15764.118.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, iet-dev <iscsitarget-devel@lists.sourceforge.net>, Greg KH <greg@kroah.com>, Jerome Martin <tramjoe.merin@gmail.com>, LKML <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, SCST-Devel <scst-devel@lists.sourceforge.net>, Joel Becker <joel.becker@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>

On Thu, 2008-10-02 at 14:29 -0700, Nicholas A. Bellinger wrote:
> On Thu, 2008-10-02 at 21:00 +0400, Vladislav Bolkhovitin wrote:
> > Nicholas A. Bellinger wrote:
> > >>> # Add some more HBA and storage Objects
> > >>> target:~# mkdir -p $TARGET/fileio_0/file_object
> > >>> target:~# mkdir -p $TARGET/rd_mcp_0/ramdisk0
> > >>> target:~# mkdir -p $TARGET/rd_dr_0/ramdisk0
> > >>>
> > >>> target:~# mkdir -p $TARGET/pscsi_0/sdd
> > >>> target:~# echo scsi_channel_id=0,scsi_target_id=3,scsi_lun_id=0 > $TARGET/pscsi_0/sdd/dev_control   
> > >>> target:~# echo 1 > $TARGET/pscsi_0/sdd/dev_enable 
> > >>>
> > >>> # Now, create LUN 1 and another Port Symlink to a new device on the same $IQN/tpgt_1
> > >>> mkdir -p "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1"
> > >>> # Create the iSCSI Target Port Mapping for $DEF_IN/tpgt_1 LUN 1
> > >>> # to lvm_test0 and give it the port symbolic name of lio_east_port
> > >>> ln -s $TARGET/pscsi_0/sdd/ "$FABRIC/$DEF_IQN/tpgt_1/lun/lun_1/lio_east_port"
> > >>>
> > >>> target:~# tree $CONFIGFS
> > >>> /sys/kernel/config/
> > >>> `-- target
> > >>>     |-- core
> > >>>     |   |-- fileio_0
> > >>>     |   |   |-- file_object
> > >>>     |   |   |   |-- dev_control
> > >>>     |   |   |   |-- dev_enable
> > >>>     |   |   |   `-- dev_info
> > >>>     |   |   `-- hba_info
> > >>>     |   |-- iblock_0
> > >>>     |   |   |-- hba_info
> > >>>     |   |   `-- lvm_test0
> > >>>     |   |       |-- dev_control
> > >>>     |   |       |-- dev_enable
> > >>>     |   |       `-- dev_info
> > >>>     |   |-- pscsi_0
> > >>>     |   |   |-- hba_info
> > >>>     |   |   `-- sdd
> > >>>     |   |       |-- dev_control
> > >>>     |   |       |-- dev_enable
> > >>>     |   |       `-- dev_info
> > >>>     |   |-- rd_dr_0
> > >>>     |   |   |-- hba_info
> > >>>     |   |   `-- ramdisk0
> > >>>     |   |       |-- dev_control
> > >>>     |   |       |-- dev_enable
> > >>>     |   |       `-- dev_info
> > >>>     |   `-- rd_mcp_0
> > >>>     |       |-- hba_info
> > >>>     |       `-- ramdisk0
> > >>>     |           |-- dev_control
> > >>>     |           |-- dev_enable
> > >>>     |           `-- dev_info
> > >>>     |-- iscsi
> > >>>     |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.e475ed6fcdd0
> > >>>     |   |   `-- tpgt_1
> > >>>     |   |       |-- lun
> > >>>     |   |       |   |-- lun_0
> > >>>     |   |       |   |   |-- lio_west_port -> ../../../../../../target/core/iblock_0/lvm_test0
> > >>>     |   |       |   |   |-- port_control
> > >>>     |   |       |   |   `-- port_info
> > >>>     |   |       |   `-- lun_1
> > >>>     |   |       |       |-- lio_east_port -> ../../../../../../target/core/pscsi_0/sdd
> > >>>     |   |       |       |-- port_control
> > >>>     |   |       |       `-- port_info
> > >>>     |   |       |-- np
> > >>>     |   |       |   `-- 172.16.201.137:3260
> > >>>     |   |       |       `-- portal_info
> > >>>     |   |       |-- tpg_control
> > >>>     |   |       `-- tpg_enable
> > >>>     |   `-- lio_version
> > >>>     `-- version
> > >>>
> > >>> 22 directories, 29 files
> > >> It's good, I like it. The only thing concerns me that, considering how 
> > >> much time *I* spent to understand it, for an average user understanding 
> > >> it can be an unbearable nightmare ;)
> > >>
> > > 
> > > Well, the idea is not necessarily making the configfs interface the
> > > easiest to use in the world by user directly through $CONFIGFS, but to
> > > make the CLI scripts that speak $CONFIGFS/target CLI, and of course the
> > > actual UIs for user that interact with generic target core and
> > > $FABRIC_MODs be as simple and elegent as possible.  
> > > 
> > > That is what I believe the balance that a configfs enabled generic
> > > target core provides to both the $CONFIGFS/target API and to $FABRIC_MOD
> > > maintainers looking to port their code to use a generic control
> > > infrastructure.  :-)
> > > 
> > >> In a few days I'll write a proposed configfs hierarchy for existing SCST 
> > >> /proc interface.
> > > 
> > > Sounds good!  Please let me know if you have questions.
> > 
> > There's one unsolved problem. As I've already written, SCST core needs 
> > an ability to provide to user space a large amount of data, which may 
> > not fit to a single page.
> >
> > A list of connected initiators ("sessions" 
> > file in /proc), for instance. Each initiator in that list has a number 
> > of attributes: initiator name, target template name, count of 
> > outstanding commands, etc. The logical way for that would be to create a 
> > subdirectory for each initiator, like:
> > 
> > /sys/kernel/config/
> > `-- target
> >      `-- sessions
> >          `-- session1
> >          |   |-- initiator_name
> >          |   |-- template_name
> >          |   `-- commands
> >          |
> >          `-- session2
> >              |-- initiator_name
> >              `-- template_name
> >              `-- commands
> >
> 
> The the Initiator Port ACLs need to go
> under /sys/kernel/config/target/$FABRIC because the struct fabric_acl *
> will always contain fabric dependent config items.  For example, Since
> these struct fabric_acl_t do *NOT* symlink directly back to
> target_core_mod under /sys/kernel/config/target/core/$HBA/$DEV, but to
> fabric_lun_t (iscsi_lun_t in my case) to Symlink to
> a /sys/kernel/config/target/core/$HBA/$DEV that has been registered with
> the generic target configfs infrastructure.
> 
> Here is what I am thinking wrt /sys/kernel/config/target/iscsi and iSCSI
> Initiator Node ACLs to iSCSI Portal Groups and iSCSI LUNs attached to
> those Portal Groups.  There are two cases:
> 
> *) The production case with with user creating those ACLs under $FABRIC
> (which is what I will focus on now).
> 
> * And "Demo Mode" case where any Initiator logging into
> $FABRIC/$ENDPOINT/$PORTAL can have access to all
> $FABRIC/$ENDPOINT/lun/lun_*/*my_ports*
> 
> The production ACL case would look like:
> 
> export CONFIGFS=/sys/kernel/config/
> export TARGET=/sys/kernel/config/target/core/
> export FABRIC=/sys/kernel/config/target/iscsi/
> 
> TARGET_IQN=iqn.2003-01.org.linux-iscsi.ps3-cell.ppc64:sn.f8f651bd5fec
> INITIATOR_IQN=iqn.1993-08.org.debian:01.f82074ca555f
> 
> <Setup $STORAGE_OBJECTs under $TARGET>
> 
> # Create the LIO-target endpoint
> mkdir -p "$FABRIC/$TARGET_IQN/tpgt_1/np/172.16.201.137:3260"
> mkdir -p "$FABRIC/$TARGET_IQN/tpgt_1/lun/lun_0"
> 
> <Setup Port Symlinks from $TARGET to $TARGET_IQN/tpgt_1/lun/lun_0>
> 
> # Create the Initiator ACL under $TARGET_IQN/tpgt_1
> mkdir -p $"FABRIC/$TARGET_IQN/tpgt_1/initiators/$INITIATOR_IQN"
> # Allow $INITIATOR_IQN access to tpgt_1/lun/lun_0/
> ln -s "$FABRIC/$TARGET_IQN/tpgt_1/lun/lun_0" \
> 	"$FABRIC/$TARGET_IQN/tpgt_1/initiators/$INITIATOR_IQN/lun_0"
> 
> >From there, you don't have to worry about PAGE_SIZE limitiations w/o, I
> can simply use use:
> 
> cat $FABRIC/iqn*/tpgt*/initiators/*/session
> 
> to see which acl'ed iSCSI Initiators are logged in on all iSCSI Target
> Ports.
> 
> Also I should add that I am currently using /proc/scsi_target/mib
> and /proc/iscsi_target_mib for READ-ONLY data with target_core_mod.ko
> and iscsi_target_mod.ko respectively.  For the other "Demo Mode" case
> mentioned above, I am currently using /proc/iscsi_target/mib/sess_attr
> to see the active sessions for LIO-Target.
> 
> I will be implementing this model over the next days..  I will post the
> commit once its up and you can have a look..
> 

Ok, here is the commit diff for adding Initiator ACLS to
iscsi/$IQN/$TPGT/ under the acls/ subdirectory (instead of "initiators"
in the example above).

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commitdiff;h=0a451affbe236b5538e5de06242372715e3ac52c;hp=374e8ace84ca58490be22d881f017d48c6742b50

Other than the name change, everything is functioning in the commit as
described in the example above.  I am able to successfully mkdir(2) and
rmdir(2) iscsi/$IQN/$TPGT/acls/$INITIATOR_IQN, as well as create the
SymLinks from iscsi/$IQN/$TPGT/lun/lun_* to
iscsi/$IQN/$TPGT/acls/$INITIATOR_IQN/lun_* to create the Initiator TPGT
LUN Mappings.

There are a couple of remaining items that I am still working on WRT the
Initiator ACL code.  One is that the CmdSN Queue Depth for the Initiator
is hardcoded.  This needs to be a configfs attribute under
iscsi/$IQN/$TPGT/acls/$INITIATOR_NAME/, and then enabled with a
attribute under the same $INITIATOR_NAME directory.  Another is
assigning READ-ONLY (its hardcoded to R/W for now) access to one of the
initiator's TPG LUN mappings.  I was thinking name in the TPG LUN
Symlink destination name, we could include "lun_0:RO" in order to make
this Initiator's LUN be READ-ONLY.

Anyways, this are pretty minor and I should be commiting the remaining
pieces over the weekend.

--nab

