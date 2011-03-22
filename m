From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Wed, 23 Mar 2011 07:49:30 +0900
Message-ID: <20110323074921X.fujita.tomonori@lab.ntt.co.jp>
References: <1300747720.21880.95.camel@haakon2.linux-iscsi.org>
	<4D889BB4.4010102@linux.vnet.ibm.com>
	<1300831607.21880.365.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:37856 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751850Ab1CVWtn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2011 18:49:43 -0400
In-Reply-To: <1300831607.21880.365.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: brking@linux.vnet.ibm.com, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Tue, 22 Mar 2011 15:06:47 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> On Tue, 2011-03-22 at 07:53 -0500, Brian King wrote:
> > On 03/21/2011 05:48 PM, Nicholas A. Bellinger wrote:
> > > On Mon, 2011-03-21 at 17:31 -0500, Brian King wrote:
> > >> Just hit another potential issue. I was mapping / unmapping disks a couple times,
> > >> so that might have helped trigger the issue. I had a file backed disk mapped
> > >> to a vscsi lun, then unmapped it, mapped a ramdisk lun, then switched back to
> > >> the filebacked lun after running into issues with the ramdisk lun and saw this:
> > >>
> > >>
> > > 
> > > By mapping/unmapping here do you mean unlinking+linking the Port/LUNs
> > > w/o removing the active VIO I_T Nexus, or actually rmdir'ing the whole
> > > $VIO_TARGET_FULLPATH/tpgt_1/ struct config_group..?
> > 
> > I just did an rm -r $VIO_TARGET_FULLPATH/tpgt_1/lun/lun_0
> > 
> 
> Ok, thanks for the clarification here..
> 
> I am pretty certain this backtrace is related to active I/O LUN shutdown
> with TPG demo mode operation and ibmvscsis.  I will need to take a
> deeper look to determine that this is working as expected w/o explict
> MappedLUN ACLs provided by target_core_fabric_configfs.c make_nodeacl
> and drop_nodeacl() struct target_core_fabric_ops vectors, or if there is
> some additional ibmvscsis / libsrp specific logic that needs to be made
> to address the active I/O TCM backend Port/LUN unlink.

Why does a driver need to take care of this?

I thought that preventing the removal of a logical unit having
outstanding I/Os is the responsibility of the target core.
