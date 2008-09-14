From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: ConfigFS + Target Mode Engine API discussion
Date: Sat, 13 Sep 2008 18:56:45 -0700
Message-ID: <1221357405.3401.167.camel@haakon2.linux-iscsi.org>
References: <1221087547.27831.165.camel@haakon2.linux-iscsi.org>
	 <20080910233107.GC23864@mail.oracle.com>
	 <1221097366.27831.216.camel@haakon2.linux-iscsi.org>
	 <20080911021331.GA12902@mail.oracle.com>
	 <1221107358.27831.289.camel@haakon2.linux-iscsi.org>
	 <20080911063846.GB16583@mail.oracle.com>
	 <1221123529.27831.343.camel@haakon2.linux-iscsi.org>
	 <20080912201541.GA26469@mail.oracle.com>
	 <1221258477.3401.81.camel@haakon2.linux-iscsi.org>
	 <20080913044948.GA31135@mail.oracle.com>
	 <1221333732.3401.143.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753828AbYINB5B@vger.kernel.org>
In-Reply-To: <1221333732.3401.143.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: Joel Becker <Joel.Becker@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, SCST-Devel <scst-devel@lists.sourceforge.net>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, 2008-09-13 at 12:22 -0700, Nicholas A. Bellinger wrote:
> On Fri, 2008-09-12 at 21:49 -0700, Joel Becker wrote:
> > On Fri, Sep 12, 2008 at 03:27:57PM -0700, Nicholas A. Bellinger wrote:
> > > On Fri, 2008-09-12 at 13:15 -0700, Joel Becker wrote:
> > > > 	No, you don't do this.  Like I said, configfs clients let
> > > > userspace create and destroy items.  Not kernelspace.  Do not call
> > > > sys_mkdir()/sys_rmdir() from your modules.
> > > 
> > > Well, the startup 'fabric registration' is only case where I figured
> > > vfs_mkdir($CONFIGFS/target/$FABRIC) being called in order to have the
> > > fabric struct config_item appear at modprobe $FABRIC_MOD *BEFORE* the
> > > user did anything would be beneficial at all.   If vfs_mkdir() was not
> > > called from transport_fabric_register_configfs(), it only means user
> > > would have call mkdir $CONFIGFS/target/$FABRIC and/or mkdir -p
> > > $CONFIGFS/target/$FABRIC/endpoint to kick off one common make_group()
> > > for $FABRIC (that lives in target_core_configfs.c) and then make_group()
> > > that likes inside of $FABRIC_MOD who's parent is $CONFIGFS/target.  In
> > > LIO-Target's case, this would be creating a new iSCSI Qualified Name
> > > with mkdir $CONFIGFS/target/iscsi/iqn.superturobdiskarry
> > 
> > 	I'm still totally unclear as to why $FABRIC has to live under
> > target/.
> 
> Well, I figured that since $FABRIC would be depending upon LUN mappings
> to target/core/$STORAGE_OBJECT struct config_items , it would make sense
> sense for $FABRIC to appear under a common target mode engine..
> 
> Having $CONFIGFS/target/core for storage objects and
> $CONFIG/$FABRIC/endpoint/lun_0 and setting up symlinks between the two
> entities is what I think you have in mind.  This setup you mention may
> have other advantages/disadvantages when it goes to a generic target
> mode, but I have been focused on getting the initial setup (see below..)
> up and running, sooo.. :-) Obviously if things can be done easier I am
> all for it.  Also I think for debugging and [PROC,IOCTL] -> ConfigFS
> conversion purposes, being able to call my do_configfs_[mkdir,rmdir]
> wrappers when existing legacy target functionality get called to
> add/remove the ConfigFS entries may have some value as well..  At least
> to make it easier for kernel level $FABRIC_MOD maintainers to see how
> generic kernel target mode configfs works... Just wanted to mention
> that..
> 
> >   I'm not clear if there can be more than one $FABRIC at a time.
> 
> Absoulutely.  Current each $FABRIC_MOD that registers itself with the
> common target engine calls the target_fabric_configfs_register() that
> creates its own struct config_group with fabric dependent configfs
> ops/abstractions.  This could very well be hidden behind the actual non
> configfs related target engine infrastructure when $FABRIC_MOD does
> actual fabric registration.  Also having common code for $FABRIC_MOD to
> use to allow those LUN mappings across multiple independent $FABRIC_MODs
> from target/core/$STORAGE_OBJECT is the main idea, but point taken that
> $FABRIC does not necessary need to be hanging directly off
> $CONFIGS/target to function..
> 
> Also why I think having $FABRIC under $CONFIGFS/target/ makes sense, I
> would like to be able to do rm -rf $CONFIGFS/target to shutdown all LUN
> mappings on all fabrics on all storage objects instead of rm -rf
> $CONFIGFS/iscsi ; rm -rf $CONFIGFS/sas ; rm -rf $CONFIGFS/pscsi ; rm -rf
> $CONFIGFS/target.. :-)
> 
> > etc.  That's what I'm trying to understand so I can help you out.
> > 
> 
> :-)
> 
> So, as of this morning I have basic iqn.foo/tpgt_1 ConfigFS
> functionality for LIO-Target.. Here is what it looks like..
> 
> <snip>
> 
> # Create some 
> 
> target:/sys/kernel/config/target/iscsi# mkdir -p iqn.iscsi-hd.renderbox/tpgt_1
> target:/sys/kernel/config/target/iscsi# mkdir -p iqn.lio-production/tpgt_1
> target:/sys/kernel/config/target/iscsi# mkdir -p iqn.upstreamtargetmodestorage/tpgt_1
> target:/sys/kernel/config/target/iscsi# mkdir -p iqn.superturbodiskarray/tpgt_1
> target:/sys/kernel/config/target/iscsi# mkdir -p `iscsi-name`/tpgt_1
> target:/sys/kernel/config/target/iscsi# mkdir -p `iscsi-name`/tpgt_1
> target:/sys/kernel/config/target/iscsi# mkdir -p `iscsi-name`/tpgt_1
> target:/sys/kernel/config/target/iscsi# mkdir -p `iscsi-name`/tpgt_1
> target:/sys/kernel/config/target/iscsi# tree
> .
> |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.11c045e90b
> |   `-- tpgt_1
> |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.acc810f5a2fc
> |   `-- tpgt_1
> |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.b341232f3595
> |   `-- tpgt_1
> |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.b5ada4ff123a
> |   `-- tpgt_1
> |-- iqn.iscsi-hd.renderbox
> |   `-- tpgt_1
> |-- iqn.lio-production
> |   `-- tpgt_1
> |-- iqn.superturbodiskarray
> |   `-- tpgt_1
> |-- iqn.upstreamtargetmodestorage
> |   `-- tpgt_1
> `-- lio_version
> 
> 16 directories, 1 file
> 
> # Notice the module count..
> target:/sys/kernel/config/target/iscsi# lsmod
> Module                  Size  Used by
> iscsi_target_mod      369004  17 
> target_core_configfs    11416  18 iscsi_target_mod
> configfs               24216  3 iscsi_target_mod,target_core_configfs
> 
> # Delete the IQNs and TPGTs created with /sbin/iscsi-name prefix.. 
> target:/sys/kernel/config/target/iscsi# rm -rf iqn.2003-01.org.linux-iscsi.target.i686\:sn.*
> 
> target:/sys/kernel/config/target/iscsi# tree
> .
> |-- iqn.iscsi-hd.renderbox
> |   `-- tpgt_1
> |-- iqn.lio-production
> |   `-- tpgt_1
> |-- iqn.superturbodiskarray
> |   `-- tpgt_1
> |-- iqn.upstreamtargetmodestorage
> |   `-- tpgt_1
> `-- lio_version
> 
> 8 directories, 1 file
> 
> # And the module counts..
> target:/sys/kernel/config/target/iscsi# lsmod
> Module                  Size  Used by
> iscsi_target_mod      369004  9 
> target_core_configfs    11416  10 iscsi_target_mod
> configfs               24216  3 iscsi_target_mod,target_core_configfs
> 

Ok, just commited first working code for ops for targetname, target
portal group and Network Portal <-> target portal group logic under
$CONFIGFS/target/iscsi/$IQN/

Here is what it looks like:

export CONFIGFS=/sys/kernel/config/
export FABRIC=/sys/kernel/config/target/iscsi

# Create four iSCSI Target Nodes with Target Portal Group Tag: 1
target:/# mkdir -p $FABRIC/`iscsi-name`/tpgt_1
target:/# mkdir -p $FABRIC/`iscsi-name`/tpgt_1
target:/# mkdir -p $FABRIC/`iscsi-name`/tpgt_1
target:/# mkdir -p $FABRIC/`iscsi-name`/tpgt_1
target:/# cd $CONFIGFS
target:/sys/kernel/config# tree
.
`-- target
    |-- iscsi
    |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.4b471a663865
    |   |   `-- tpgt_1
    |   |       |-- lun
    |   |       `-- np
    |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.60a44da1dea
    |   |   `-- tpgt_1
    |   |       |-- lun
    |   |       `-- np
    |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.7c988087f45c
    |   |   `-- tpgt_1
    |   |       |-- lun
    |   |       `-- np
    |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.ed63ac2a3da7
    |   |   `-- tpgt_1
    |   |       |-- lun
    |   |       `-- np
    |   `-- lio_version
    `-- version
18 directories, 2 files

# Create some iSCSI network portals on the first two targetname+tpgt tuples
target:/sys/kernel/config# mkdir target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686\:sn.4b471a663865/tpgt_1/np/172.16.201.137:3260
target:/sys/kernel/config# mkdir target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686\:sn.4b471a663865/tpgt_1/np/172.16.201.137:3261
target:/sys/kernel/config# mkdir target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686\:sn.4b471a663865/tpgt_1/np/172.16.201.137:3262
target:/sys/kernel/config# mkdir target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686\:sn.4b471a663865/tpgt_1/np/172.16.201.137:3263
target:/sys/kernel/config# mkdir target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686\:sn.60a44da1dea/tpgt_1/np/172.16.201.137:3260
target:/sys/kernel/config# mkdir target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686\:sn.60a44da1dea/tpgt_1/np/172.16.201.137:3261
target:/sys/kernel/config# mkdir target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686\:sn.60a44da1dea/tpgt_1/np/172.16.201.137:3262
target:/sys/kernel/config# mkdir target/iscsi/iqn.2003-01.org.linux-iscsi.target.i686\:sn.60a44da1dea/tpgt_1/np/172.16.201.137:3263

target:/sys/kernel/config# tree
.
`-- target
    |-- iscsi
    |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.4b471a663865
    |   |   `-- tpgt_1
    |   |       |-- lun
    |   |       `-- np
    |   |           |-- 172.16.201.137:3260
    |   |           |   `-- portal_info
    |   |           |-- 172.16.201.137:3261
    |   |           |   `-- portal_info
    |   |           |-- 172.16.201.137:3262
    |   |           |   `-- portal_info
    |   |           `-- 172.16.201.137:3263
    |   |               `-- portal_info
    |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.60a44da1dea
    |   |   `-- tpgt_1
    |   |       |-- lun
    |   |       `-- np
    |   |           |-- 172.16.201.137:3260
    |   |           |   `-- portal_info
    |   |           |-- 172.16.201.137:3261
    |   |           |   `-- portal_info
    |   |           |-- 172.16.201.137:3262
    |   |           |   `-- portal_info
    |   |           `-- 172.16.201.137:3263
    |   |               `-- portal_info
    |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.7c988087f45c
    |   |   `-- tpgt_1
    |   |       |-- lun
    |   |       `-- np
    |   |-- iqn.2003-01.org.linux-iscsi.target.i686:sn.ed63ac2a3da7
    |   |   `-- tpgt_1
    |   |       |-- lun
    |   |       `-- np
    |   `-- lio_version
    `-- version

26 directories, 10 files

Here is the commit:

http://git.kernel.org/?p=linux/kernel/git/nab/lio-core-2.6.git;a=commit;h=4098f1bcbe8406b882c4e265427f54a35f3c8b40

--nab
