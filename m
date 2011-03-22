From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 21 Mar 2011 19:28:41 -0700
Message-ID: <1300760921.21880.249.camel@haakon2.linux-iscsi.org>
References: <1300751414.21880.146.camel@haakon2.linux-iscsi.org>
	 <20110322085530P.fujita.tomonori@lab.ntt.co.jp>
	 <1300753577.21880.183.camel@haakon2.linux-iscsi.org>
	 <20110322093249A.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:34927 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756329Ab1CVCfw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2011 22:35:52 -0400
In-Reply-To: <20110322093249A.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: brking@linux.vnet.ibm.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, jxm@risingtidesystems.com, mwf@risingtidesystems.com

On Tue, 2011-03-22 at 09:32 +0900, FUJITA Tomonori wrote:
> On Mon, 21 Mar 2011 17:26:17 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Tue, 2011-03-22 at 08:55 +0900, FUJITA Tomonori wrote:
> > > On Mon, 21 Mar 2011 16:50:14 -0700
> > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > 
> > > > On Tue, 2011-03-22 at 08:20 +0900, FUJITA Tomonori wrote:
> > > > > On Mon, 21 Mar 2011 16:24:58 -0500
> > > > > Brian King <brking@linux.vnet.ibm.com> wrote:
> > > > > 
> > > > > > > If could send along the original misconfigured configfs layout that is
> > > > > > > causing the OOPs in handle_crq(), I would be happy to have a quick look.
> > > > > > 
> > > > > > Here it is. As you can see, there is no ./target/ibmvscsis directory created. In order
> > > > > 
> > > > > I suspect something like that. The driver can't crash with any
> > > > > configurations though.
> > > > > 
> > > > > 
> > > > > > to get it to work, I did the following. Please let me know if there is a better way
> > > > > > to do this...
> > > > > 
> > > > > As I said long before, this kinda hardware configuration should
> > > > > automatically show up when we load the driver module. But the target
> > > > > core is broken in this regard.
> > > > > 
> > > > 
> > > > It's possible to move the I_T nexus creation into VIO context code, but
> > > > we still want to be able to define the actual target endpoint definition
> > > > from userspace to get the proper VFS reference counting for fabric data
> > > > structures containing struct config_group that reference the
> > > > config_groups from the rest of the target stack.
> > > 
> > > Hmm, what can we configure for the ibmvscsis? I think that there is
> > > nothing. Everything is configured via the firmware before the kernel
> > > boots. So I don't see any point to configure something from the user
> > > space. That just wastes user's time like Brian.
> > > --
> > 
> > Yes, but the user still needs to configure the fabric Port/LUNs in order
> > to build the the view of the target backends, right..? 
> 
> As I said before, there is no 'Port' to configure for the ibmvscsis.
> 
> So only LUNs. But before confuging LUNs, the target should work, that
> is, telling an initiator that there is no LUNs.

Ok, this is where I was getting originally confused, thank you for the
clarification.

Then we should be able to do something like this together with earlier
patch to handle reporting no available LUNs because "target endpoint has
not been configured.  I will revist my patch from this afternoon to fix
up the REPORT_LUNs emulation to allow this, and error out in
ibmvscsis.c:tcm_queuecommand() and send out in proper form to review.

> 
> > In this particular case for ibmvscsis since we already know the target
> > endpoint names from sysfs attributes, using a small amount of scripting
> > code in lio-utils to automatically setup the endpoints for the user is
> > really simple, and we still expect the user to define which backend
> > devices from /sys/kernel/config/target/$HBA/$DEV will be configured as
> > Port/LUNs for the fabric endpoint.
> 
> Why does users bother to run the script? We know that the kernel can
> configure everything to make the target work.

The type of script is an example of driving the typical configuration
layout for normal usage (eg: with TCM backends).  For a HW target mode
case like with w/ ibmvscsis, the user should be presented with a list of
available backends and un-configured target HW fabric endpoints, and
selects one of more of the backends to create the running layout and can
optionally save this persistently, have it generated for them based on
sysfs layout+attributes, etc.

But in the end what rtsadmin has done thus far successfully is abstract
away the enduser notion of configfs symlinks and really all direct
configfs interaction from the end user in the high level shell, and use
python library (rtslib) to drive the configuration of that layout.  This
gives us a method to handle potential future configfs layout changes in
target_core_fabric_configfs.c and target_core_configfs.c inside of a
python library, instead of breaking userspace script that depends upon a
particular /sys/kernel/config/target/ layout for each major future
target rev.

This is also the method that we are intending to release GPL with
rtsadmin-v2 to allow new fabric module code (and authors :-) to get the
complete userspace package for their target mode developments.

--nab

