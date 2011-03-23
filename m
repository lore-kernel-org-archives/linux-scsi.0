From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Wed, 23 Mar 2011 14:12:25 +0900
Message-ID: <20110323141225N.fujita.tomonori@lab.ntt.co.jp>
References: <1300831607.21880.365.camel@haakon2.linux-iscsi.org>
	<20110323074921X.fujita.tomonori@lab.ntt.co.jp>
	<1300844136.21880.406.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama500.ecl.ntt.co.jp ([129.60.39.148]:52738 "EHLO
	tama500.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755259Ab1CWFUI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Mar 2011 01:20:08 -0400
In-Reply-To: <1300844136.21880.406.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, brking@linux.vnet.ibm.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Tue, 22 Mar 2011 18:35:36 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> On Wed, 2011-03-23 at 07:49 +0900, FUJITA Tomonori wrote:
> > On Tue, 22 Mar 2011 15:06:47 -0700
> > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > 
> > > On Tue, 2011-03-22 at 07:53 -0500, Brian King wrote:
> > > > On 03/21/2011 05:48 PM, Nicholas A. Bellinger wrote:
> > > > > On Mon, 2011-03-21 at 17:31 -0500, Brian King wrote:
> > > > >> Just hit another potential issue. I was mapping / unmapping disks a couple times,
> > > > >> so that might have helped trigger the issue. I had a file backed disk mapped
> > > > >> to a vscsi lun, then unmapped it, mapped a ramdisk lun, then switched back to
> > > > >> the filebacked lun after running into issues with the ramdisk lun and saw this:
> > > > >>
> > > > >>
> > > > > 
> > > > > By mapping/unmapping here do you mean unlinking+linking the Port/LUNs
> > > > > w/o removing the active VIO I_T Nexus, or actually rmdir'ing the whole
> > > > > $VIO_TARGET_FULLPATH/tpgt_1/ struct config_group..?
> > > > 
> > > > I just did an rm -r $VIO_TARGET_FULLPATH/tpgt_1/lun/lun_0
> > > > 
> > > 
> > > Ok, thanks for the clarification here..
> > > 
> > > I am pretty certain this backtrace is related to active I/O LUN shutdown
> > > with TPG demo mode operation and ibmvscsis.  I will need to take a
> > > deeper look to determine that this is working as expected w/o explict
> > > MappedLUN ACLs provided by target_core_fabric_configfs.c make_nodeacl
> > > and drop_nodeacl() struct target_core_fabric_ops vectors, or if there is
> > > some additional ibmvscsis / libsrp specific logic that needs to be made
> > > to address the active I/O TCM backend Port/LUN unlink.
> > 
> > Why does a driver need to take care of this?
> > 
> > I thought that preventing the removal of a logical unit having
> > outstanding I/Os is the responsibility of the target core.
> 
> Yes this should be the case.  However with TPG demo mode and active I/O
> shutdown case w/o ->port_link + ->port_unlink usage, or an fabric
> endpoint disable attribute (to clear the I_T Nexus for the endpoint) we
> may be running into problems here when removing TPG LUNs in demo-mode
> with an active I_T Nexus.

What are the differences of the demo mode and the non-demo mode?

I don't know if the similar bug is also in the non-demo mode but why
can't we integrate them well instead of having two totally different
paths?

I just don't want to play with TPG since there is no TPG concept in
SRP (and ibmvscsis). And I also don't play with any security stuff
about it because it's also irrelevant for ibmvscsis.

Also please rename 'demo-mode'. I don't think that it's a good name
since it doesn't tell anything.
