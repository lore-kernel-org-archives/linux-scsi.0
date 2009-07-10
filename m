From: Eddie Williams <Eddie.Williams@steeleye.com>
Subject: Re: [dm-devel] Re: [PATCH 0/3] scsi_dh: Add ability to set
 parameters for scsi device handler
Date: Fri, 10 Jul 2009 09:21:37 -0400
Message-ID: <1247232097.3591.13.camel@eddie-laptop>
References: <20090702031308.28354.73353.sendpatchset@chandra-ubuntu>
	 <1246563299.8018.9.camel@eddie-laptop>
	 <1246566564.8018.21.camel@eddie-laptop>
	 <1246567622.7381.7.camel@chandra-ubuntu>
	 <1246970082.6646.9.camel@eddie-laptop>
	 <1247169346.28322.0.camel@chandra-ubuntu>
	 <1247174184.6367.237.camel@eddie-laptop>
	 <1247191145.28322.10.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p02c12o145.mxlogic.net ([208.65.145.78]:46612 "EHLO
	p02c12o145.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZGJNVu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jul 2009 09:21:50 -0400
In-Reply-To: <1247191145.28322.10.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@linux.vnet.ibm.com
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, agk@redhat.com


I had taken the patches you sent earlier and tried them on the SLES 11.
There were a couple of collisions but not much.  I am able to set the
parameters in hardware handler with the patches.  This also now allows
multipath to handle path failures correctly where reservations are
involved, aka honor reservations set on trespass command.  I will do
more testing but so far so good.

I made one type cast change in scsi_dh_emc.c to avoid a warning
	char *p = (char *)params;

I will look at your patches to make sure I reconciled the conflicts
correctly.

Eddie

On Thu, 2009-07-09 at 18:59 -0700, Chandra Seetharaman wrote:
> Eddie,
> 
> Here is the set of patches ported to sles11.
> 
> It applies cleanly on linux-2.6.27.23-0.1
> 
> Anyways, you have to test the mainline version for it to be pushed
> upstream. (this patch is just for verification purposes).
> 
> series:
> sles11_scsi_dh_params
> sles11_emc_parameters
> sles11_parameters_fix_for_dmmpath
> 
> chandra
> On Thu, 2009-07-09 at 17:16 -0400, Eddie Williams wrote:
> > I have not tried to patch the 2.6.27-23 kernel.  Given that the patches
> > were against 31-RC1 I assumed that there would be other changes I would
> > need to pull in.  I have been looking at why the 31-RC1 was panicing as
> > well as working with my EMC contacts to see if they already had a
> > working 31-RC1 environment they could verify the patch in.
> > Unfortunately I have been mostly in meetings...
> > 
> > I will give it a try.  I should have results in the morning.
> > 
> > Eddie
> > 
> > On Thu, 2009-07-09 at 12:55 -0700, Chandra Seetharaman wrote:
> > > Did you try to port/apply my patches to the SLES11 tree and see if it
> > > works ?
> > > 
> > > On Tue, 2009-07-07 at 08:34 -0400, Eddie Williams wrote:
> > > > I was testing with the SLES 11 kernel.  Initially I was using
> > > > 2.6.27.19-5 and also verified the same issue with their errata kernel
> > > > 2.6.27.23-0.1.
> > > > 
> > > > Eddie
> > > > On Thu, 2009-07-02 at 13:47 -0700, Chandra Seetharaman wrote:
> > > > > On Thu, 2009-07-02 at 16:29 -0400, Eddie Williams wrote:
> > > > > > On Thu, 2009-07-02 at 15:34 -0400, Eddie Williams wrote:
> > > > > > > I have tried to set this up but have run into a problem probably due to
> > > > > > > my error.  It has been a while since I have had to build kernels...
> > > > > > > 
> > > > > > > I pulled 2.6.31-rc1, applied the two patches below and then applied the
> > > > > > > 3 patches for the interface.  The new kernel loads fine but when a
> > > > > > > trespass command is sent I get an panic.  I am looking though how I
> > > > > > > built the kernel and perhaps build with your 3 patches to see if it
> > > > > > > happened before.  
> > > > > > 
> > > > > > I backed out the 3 patches with the same panic.
> > > > > > 
> > > > > Which version of the kernel were you originally testing with ? (when you
> > > > > found the feature was gone).
> > > > > 
> > > > 
> > > > --
> > > > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > > > the body of a message to majordomo@vger.kernel.org
> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> > 
> > --
> > dm-devel mailing list
> > dm-devel@redhat.com
> > https://www.redhat.com/mailman/listinfo/dm-devel

