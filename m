From: Chandra Seetharaman <sekharan@us.ibm.com>
Subject: Re: [PATCH 0/3] scsi_dh: Make scsi device handler modules
	automatically inserted
Date: Mon, 06 Jul 2009 15:30:50 -0700
Message-ID: <1246919450.4685.18.camel@chandra-ubuntu>
References: <20090427180609.22758.93035.sendpatchset@chandra-ubuntu>
	 <4A369320.2080202@redhat.com>  <1245365306.4286.27.camel@mulgrave.site>
	 <1245440234.7393.36.camel@chandra-ubuntu>
Reply-To: sekharan@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e37.co.us.ibm.com ([32.97.110.158]:47281 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753606AbZGFW2O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Jul 2009 18:28:14 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e37.co.us.ibm.com (8.13.1/8.13.1) with ESMTP id n66MRPVp021256
	for <linux-scsi@vger.kernel.org>; Mon, 6 Jul 2009 16:27:25 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n66MSARr199346
	for <linux-scsi@vger.kernel.org>; Mon, 6 Jul 2009 16:28:10 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n66MS9wI029828
	for <linux-scsi@vger.kernel.org>; Mon, 6 Jul 2009 16:28:10 -0600
In-Reply-To: <1245440234.7393.36.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Peter Jones <pjones@redhat.com>, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, hare@suse.de

James,

Any updates on this ?

thanks

chandra
On Fri, 2009-06-19 at 12:37 -0700, Chandra Seetharaman wrote:
> Hi James,
> 
> Thanks for getting back on this.
> 
> On Thu, 2009-06-18 at 17:48 -0500, James Bottomley wrote:
> 
> > > 
> > > Was there ever any followup to this?
> > 
> > OK, since I've forgotten where we are, let me summarise what I think the
> > situation is (correct me if I misstate any of the facts):
> > 
> > This code adds no functional value to the kernel because dm already
> > autoloads the correct handlers based on the inquiry strings
> 
> First point of clarification:
> 
> The main purpose of moving the device handlers from the dm-layer to scsi
> layer was that the time at which dm-layer comes in is too late.
> 
> SCSI-DH was added mainly to make sure that scsi layer recognize that
> these are special devices and has to be handled differently.
> 
> (Original problem was that during device probing lot of ios are sent to
> passive paths which caused boot time delays and tons of errors messages.
> These increase linearly with the number of luns and the number of
> passive paths, i.e more redundant the system is, more time it takes to
> boot and more error messages it spits out).
> 
> To paraphrase, if we were willing to wait till dm layer loads
> appropriate device handler modules, there would be no need for us to
> move the device handlers to SCSI layer.
> 
> With that clarification....
> 
> Having device handlers in SCSI is useful _only_ if we have the
> appropriate device handler modules in initrd. Otherwise, the user will
> go thru all the sufferings (boot delay and error messages) that they
> went thru when the device handlers were in dm-layer voiding the very
> benefit of moving the handlers to SCSI layer.
> 
> As of today (actually since scsi dh was in the kernel), I suggest the
> users of scsi device handler modules to create a new initrd with the
> required scsi_dh module
> (http://sources.redhat.com/lvm2/wiki/MultipathUsageGuide#head-fb3efbb82fa69ca86b7db26423c235ae6c280caa)
> 
> Ideal way to solve this problem is to make sure the
> appropriate/necessary modules are built into the initrd image
> automatically (as is the case with all other devices that need a
> driver), without the user/admin doing it .
> 
> Hence this patch.
> > 
> > The only value it adds is that by overloading the module table with the
> > inquiry strings, mkinitrd pulls in the correct dm handlers for the state
> > the system was in.
> > 
> > the unaddressed problems are:
> > 
> > The kernel now tries to load the dm handler for the device dynamically
> > whether or not the user is actually deploying multi-path (previously dm
> > does this and if it's not loaded, that doesn't happen).  It's entirely
> > unclear whether this would interfere with proprietary multipath handlers
> > or even cause problems in single path systems which were designed that
> > way.
> 
> This is by design (of SCSI DH). We do want the device to be attached to
> its handler _irrespective_ of whether multipath comes along or not.
> 
> BTW, there is _no_ infrastructure in multipath for handlers. They were
> removed from multipath when scsi dh came along. So, no worries about
> proprietary multipath handlers. Also, multipath _can_ attach a device to
> a different (SCSI) device handler if it finds that the one that is
> already attached is not the right one.
> 
> SCSI DH is implemented to make accessing the devices better (as is the
> case with any device specific driver over generic one). So, the effect
> of scsi dh handler on single path system is towards betterment
> than being problematic.
> 
> > So as I see it, the functional benefit to a running kernel is zero and
> > the functional risk exists but is unquantified, so it seems far better
> > simply to solve this issue in mkinitrd.
> 
> I do not agree. This functionality makes the scsi devices behave the
> same way as the other devices, and hence make the system admin's life
> easier.
> 
> I hope you consider this feature in a better light now :)
> 
> chandra
> > 
> > James
> > 
> > 

