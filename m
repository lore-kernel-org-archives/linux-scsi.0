From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Tue, 22 Mar 2011 18:35:36 -0700
Message-ID: <1300844136.21880.406.camel@haakon2.linux-iscsi.org>
References: <1300747720.21880.95.camel@haakon2.linux-iscsi.org>
	 <4D889BB4.4010102@linux.vnet.ibm.com>
	 <1300831607.21880.365.camel@haakon2.linux-iscsi.org>
	 <20110323074921X.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:33233 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab1CWBmr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Mar 2011 21:42:47 -0400
In-Reply-To: <20110323074921X.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: brking@linux.vnet.ibm.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org

On Wed, 2011-03-23 at 07:49 +0900, FUJITA Tomonori wrote:
> On Tue, 22 Mar 2011 15:06:47 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Tue, 2011-03-22 at 07:53 -0500, Brian King wrote:
> > > On 03/21/2011 05:48 PM, Nicholas A. Bellinger wrote:
> > > > On Mon, 2011-03-21 at 17:31 -0500, Brian King wrote:
> > > >> Just hit another potential issue. I was mapping / unmapping disks a couple times,
> > > >> so that might have helped trigger the issue. I had a file backed disk mapped
> > > >> to a vscsi lun, then unmapped it, mapped a ramdisk lun, then switched back to
> > > >> the filebacked lun after running into issues with the ramdisk lun and saw this:
> > > >>
> > > >>
> > > > 
> > > > By mapping/unmapping here do you mean unlinking+linking the Port/LUNs
> > > > w/o removing the active VIO I_T Nexus, or actually rmdir'ing the whole
> > > > $VIO_TARGET_FULLPATH/tpgt_1/ struct config_group..?
> > > 
> > > I just did an rm -r $VIO_TARGET_FULLPATH/tpgt_1/lun/lun_0
> > > 
> > 
> > Ok, thanks for the clarification here..
> > 
> > I am pretty certain this backtrace is related to active I/O LUN shutdown
> > with TPG demo mode operation and ibmvscsis.  I will need to take a
> > deeper look to determine that this is working as expected w/o explict
> > MappedLUN ACLs provided by target_core_fabric_configfs.c make_nodeacl
> > and drop_nodeacl() struct target_core_fabric_ops vectors, or if there is
> > some additional ibmvscsis / libsrp specific logic that needs to be made
> > to address the active I/O TCM backend Port/LUN unlink.
> 
> Why does a driver need to take care of this?
> 
> I thought that preventing the removal of a logical unit having
> outstanding I/Os is the responsibility of the target core.

Yes this should be the case.  However with TPG demo mode and active I/O
shutdown case w/o ->port_link + ->port_unlink usage, or an fabric
endpoint disable attribute (to clear the I_T Nexus for the endpoint) we
may be running into problems here when removing TPG LUNs in demo-mode
with an active I_T Nexus.

I will take a deeper look and see if there is some breakage wrt to
target core or something else externally, and will try to reproduce with
some other fabric modules that support TPG demo mode.

--nab

