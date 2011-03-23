From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Wed, 23 Mar 2011 01:26:30 -0700
Message-ID: <1300868790.21880.499.camel@haakon2.linux-iscsi.org>
References: <1300831607.21880.365.camel@haakon2.linux-iscsi.org>
	 <20110323074921X.fujita.tomonori@lab.ntt.co.jp>
	 <1300844136.21880.406.camel@haakon2.linux-iscsi.org>
	 <20110323141225N.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:46534 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab1CWIdo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 04:33:44 -0400
In-Reply-To: <20110323141225N.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: brking@linux.vnet.ibm.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, Joel Becker <jlbec@evilplan.org>

On Wed, 2011-03-23 at 14:12 +0900, FUJITA Tomonori wrote:
> On Tue, 22 Mar 2011 18:35:36 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Wed, 2011-03-23 at 07:49 +0900, FUJITA Tomonori wrote:
> > > On Tue, 22 Mar 2011 15:06:47 -0700
> > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > 
> > > > On Tue, 2011-03-22 at 07:53 -0500, Brian King wrote:
> > > > > On 03/21/2011 05:48 PM, Nicholas A. Bellinger wrote:
> > > > > > On Mon, 2011-03-21 at 17:31 -0500, Brian King wrote:
> > > > > >> Just hit another potential issue. I was mapping / unmapping disks a couple times,
> > > > > >> so that might have helped trigger the issue. I had a file backed disk mapped
> > > > > >> to a vscsi lun, then unmapped it, mapped a ramdisk lun, then switched back to
> > > > > >> the filebacked lun after running into issues with the ramdisk lun and saw this:
> > > > > >>
> > > > > >>
> > > > > > 
> > > > > > By mapping/unmapping here do you mean unlinking+linking the Port/LUNs
> > > > > > w/o removing the active VIO I_T Nexus, or actually rmdir'ing the whole
> > > > > > $VIO_TARGET_FULLPATH/tpgt_1/ struct config_group..?
> > > > > 
> > > > > I just did an rm -r $VIO_TARGET_FULLPATH/tpgt_1/lun/lun_0
> > > > > 
> > > > 
> > > > Ok, thanks for the clarification here..
> > > > 
> > > > I am pretty certain this backtrace is related to active I/O LUN shutdown
> > > > with TPG demo mode operation and ibmvscsis.  I will need to take a
> > > > deeper look to determine that this is working as expected w/o explict
> > > > MappedLUN ACLs provided by target_core_fabric_configfs.c make_nodeacl
> > > > and drop_nodeacl() struct target_core_fabric_ops vectors, or if there is
> > > > some additional ibmvscsis / libsrp specific logic that needs to be made
> > > > to address the active I/O TCM backend Port/LUN unlink.
> > > 
> > > Why does a driver need to take care of this?
> > > 
> > > I thought that preventing the removal of a logical unit having
> > > outstanding I/Os is the responsibility of the target core.
> > 
> > Yes this should be the case.  However with TPG demo mode and active I/O
> > shutdown case w/o ->port_link + ->port_unlink usage, or an fabric
> > endpoint disable attribute (to clear the I_T Nexus for the endpoint) we
> > may be running into problems here when removing TPG LUNs in demo-mode
> > with an active I_T Nexus.
> 
> What are the differences of the demo mode and the non-demo mode?
> 

Demo-mode means that a struct se_node_acl will be dynamically allocated
when core_tpg_check_initiator_node_acl() is called for an unknown SCSI
Initiator WWN in the process of creating a new I_T nexus (struct
se_session) when struct target_core_fabric_ops->tpg_check_demo_mode()=1
is set.

Using explict NodeACLs (eg: non demo-mode) means that each se_node_acl
is created in /sys/kernel/config/target/$FABRIC/$TARGET_WWN/tpgt_1/acls/
before fabric module level call to core_tpg_check_initiator_node_acl(),
and will fail upon the reception of an unknown SCSI Initiator WWN when
the fabric is setting target_core_fabric_ops->tpg_check_demo_mode()=0.

Dynamically created se_node_acls can also be converted to an explict
NodeACL, which requires that TPG LUN -> MappedLUN layout be configured
as well.  (This can currently happen w/o disruption to the existing I_T
nexus)

> I don't know if the similar bug is also in the non-demo mode but why
> can't we integrate them well instead of having two totally different
> paths?
> 

These are not different codepaths paths from the perspective of current
I/O path code for access to backend target core struct se_device.  We
still create each struct se_node_acl->device_list[] based upon the
default set of TPG LUN mappings that allows the SCSI Initiator access to
the target core backend devices once the I_T nexus has been established
via transport_get_lun_for_cmd().

With explict NodeACLs these can be initiator context specific MappedLUNs
that can optionally be different from default TPG LUN layout and have
Write Protected (WP=1) access.

> I just don't want to play with TPG since there is no TPG concept in
> SRP (and ibmvscsis). And I also don't play with any security stuff
> about it because it's also irrelevant for ibmvscsis.
> 

This is where I think we have an misunderstanding.

Currently we use user-space driven TPG LUN configfs symlinks from fabric
module data structures into a seperate module (target_core_mod) in order
to represent the backend exports for fabric TPG LUN layout.

In the past we have tried patches for driving the configfs layout via
kernel-space as well, which does function with mkdir and rmdir ops with
some VFS level changes, but has been firmly reject by the configfs
maintainer back in 2009 and dropped in modern lio-core-2.6.git code.
(jlbec CC'ed)

So that said I don't have an issue with ibmvscsis allowing fabric
dependent TPG data structure's allocation to be driven by kernel-level
code for the special case where no TPG has yet been configured.  However
this still requires the explict setup of fabric TPG endpoint @
/sys/kernel/config/target/ibmvscsis/$VIO_TARGET/tpgt_1/ in order to
access the $VIO_TARGET/tpgt_1/lun/ group as a destination for TPG LUNs
symlinks into target core configfs backends.

But in the end I think we still want to be able to drive the creation of
configfs symlinks for fabric TPG LUN <-> target core backend usage from
userspace driven code.  We can do the creation of a configfs layout
using a small amount of interpreted userspace code that would require a
larger amount kernel code complexity in order to function.  I personally
do not see a hard-requirement for doing TPG LUN <-> target core symlink
configuration from kernel space for my own code, but if really think
this is required and convience folks like Joel Greg-KH with patches, I
would be happy to consider a new look at a hybrid target user-level +
kernel-level driven control plane.

> Also please rename 'demo-mode'. I don't think that it's a good name
> since it doesn't tell anything.
> --

With iscsi_target_mod this logic is controlled via a fabric dependent
attribute @ target/iscsi/$TARGET_IQN/tpgt_1/attrib/generate_node_acls.

I am happy to change the *_demo_mode*() suffixes in target core, does a
suffix like *_dynamic_nodeacl*() work for you..?

--nab


