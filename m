From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Wed, 23 Mar 2011 03:00:03 -0700
Message-ID: <1300874403.21880.519.camel@haakon2.linux-iscsi.org>
References: <1300844136.21880.406.camel@haakon2.linux-iscsi.org>
	 <20110323141225N.fujita.tomonori@lab.ntt.co.jp>
	 <1300868790.21880.499.camel@haakon2.linux-iscsi.org>
	 <20110323174843I.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37714 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756065Ab1CWKHP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 06:07:15 -0400
In-Reply-To: <20110323174843I.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: brking@linux.vnet.ibm.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, jlbec@evilplan.org

On Wed, 2011-03-23 at 17:48 +0900, FUJITA Tomonori wrote:
> On Wed, 23 Mar 2011 01:26:30 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > Demo-mode means that a struct se_node_acl will be dynamically allocated
> > when core_tpg_check_initiator_node_acl() is called for an unknown SCSI
> > Initiator WWN in the process of creating a new I_T nexus (struct
> > se_session) when struct target_core_fabric_ops->tpg_check_demo_mode()=1
> > is set.
> 
> Again, acl is not irrelevant for ibmvscsis. So I shoundn't set up
> it.
> 
> All I asking for is simply accepting any initiators and exporting all
> the luns in a target.
> 
> 

Yes, I understand this.  But driving (from kernel-level) a default set
of fabric TPG LUN exports for all available target_core_mod backend
export is not a manageable way for /sys/kernel/config/target/$HBA/$DEV
backend export.  This needs to be driven from python library code for
userspace applications automatically without interaction from end user
for ibmvscsis or any other fabric module.

> > > I don't know if the similar bug is also in the non-demo mode but why
> > > can't we integrate them well instead of having two totally different
> > > paths?
> > > 
> > 
> > These are not different codepaths paths from the perspective of current
> > I/O path code for access to backend target core struct se_device.  We
> > still create each struct se_node_acl->device_list[] based upon the
> > default set of TPG LUN mappings that allows the SCSI Initiator access to
> > the target core backend devices once the I_T nexus has been established
> > via transport_get_lun_for_cmd().
> > 
> > With explict NodeACLs these can be initiator context specific MappedLUNs
> > that can optionally be different from default TPG LUN layout and have
> > Write Protected (WP=1) access.
> 
> Sounds like that non-demo mode has the similar bug that Brian saw.
> 
> 

No, we have been able to verify with the following patch that active I/O
shutdown with Explict NodeACLs and MappedLUNs is now working as expected
for .38 stable:

target: Fix t_transport_aborted handling in LUN_RESET + active I/O shutdown
http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commitdiff;h=52208ae3fc60cbcb214c10fb8b82304199e2cc3a

> > > I just don't want to play with TPG since there is no TPG concept in
> > > SRP (and ibmvscsis). And I also don't play with any security stuff
> > > about it because it's also irrelevant for ibmvscsis.
> > > 
> > 
> > This is where I think we have an misunderstanding.
> > 
> > Currently we use user-space driven TPG LUN configfs symlinks from fabric
> > module data structures into a seperate module (target_core_mod) in order
> > to represent the backend exports for fabric TPG LUN layout.
> > 
> > In the past we have tried patches for driving the configfs layout via
> > kernel-space as well, which does function with mkdir and rmdir ops with
> > some VFS level changes, but has been firmly reject by the configfs
> > maintainer back in 2009 and dropped in modern lio-core-2.6.git code.
> > (jlbec CC'ed)
> > 
> > So that said I don't have an issue with ibmvscsis allowing fabric
> > dependent TPG data structure's allocation to be driven by kernel-level
> > code for the special case where no TPG has yet been configured.  However
> > this still requires the explict setup of fabric TPG endpoint @
> > /sys/kernel/config/target/ibmvscsis/$VIO_TARGET/tpgt_1/ in order to
> > access the $VIO_TARGET/tpgt_1/lun/ group as a destination for TPG LUNs
> > symlinks into target core configfs backends.
> > 
> > But in the end I think we still want to be able to drive the creation of
> > configfs symlinks for fabric TPG LUN <-> target core backend usage from
> > userspace driven code.
>   We can do the creation of a configfs layout
> > using a small amount of interpreted userspace code that would require a
> > larger amount kernel code complexity in order to function.  I personally
> > do not see a hard-requirement for doing TPG LUN <-> target core symlink
> > configuration from kernel space for my own code, but if really think
> > this is required and convience folks like Joel Greg-KH with patches, I
> > would be happy to consider a new look at a hybrid target user-level +
> > kernel-level driven control plane.
> 
> We definitely need to set up the hardware information in kernel space.
> 
> For example, even after loading the kernel module, creating
> /sys/kernel/config/target/ibmvscsi directory by hand makes sense for
> you?
> 

No, not by hand.  We expect rtslib-gpl python library code to drive all
of this for userspace level applications for all fabric modules using
the generic target_core_fabric_configfs.c control plane.

> If configfs doesn't fit the bill, needs to create something new.
> --

Yes, I am open to suggestions for a hybrid approach for userspace and
kernelspace driven control plane for target mode, and adapting
rtslib-gpl to work with it.  However,  I still think that driving the
creation of target core struct config_group from userspace with configfs
symlinks to an external module target core backends is the cleanest
kernel control plane from a kernel code perspective.

--nab


