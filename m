From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 21 Mar 2011 17:26:17 -0700
Message-ID: <1300753577.21880.183.camel@haakon2.linux-iscsi.org>
References: <4D87C22A.6070301@linux.vnet.ibm.com>
	 <20110322082013O.fujita.tomonori@lab.ntt.co.jp>
	 <1300751414.21880.146.camel@haakon2.linux-iscsi.org>
	 <20110322085530P.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40863 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab1CVAd3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2011 20:33:29 -0400
In-Reply-To: <20110322085530P.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: brking@linux.vnet.ibm.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, jxm@risingtidesystems.com, mwf@risingtidesystems.com

On Tue, 2011-03-22 at 08:55 +0900, FUJITA Tomonori wrote:
> On Mon, 21 Mar 2011 16:50:14 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > On Tue, 2011-03-22 at 08:20 +0900, FUJITA Tomonori wrote:
> > > On Mon, 21 Mar 2011 16:24:58 -0500
> > > Brian King <brking@linux.vnet.ibm.com> wrote:
> > > 
> > > > > If could send along the original misconfigured configfs layout that is
> > > > > causing the OOPs in handle_crq(), I would be happy to have a quick look.
> > > > 
> > > > Here it is. As you can see, there is no ./target/ibmvscsis directory created. In order
> > > 
> > > I suspect something like that. The driver can't crash with any
> > > configurations though.
> > > 
> > > 
> > > > to get it to work, I did the following. Please let me know if there is a better way
> > > > to do this...
> > > 
> > > As I said long before, this kinda hardware configuration should
> > > automatically show up when we load the driver module. But the target
> > > core is broken in this regard.
> > > 
> > 
> > It's possible to move the I_T nexus creation into VIO context code, but
> > we still want to be able to define the actual target endpoint definition
> > from userspace to get the proper VFS reference counting for fabric data
> > structures containing struct config_group that reference the
> > config_groups from the rest of the target stack.
> 
> Hmm, what can we configure for the ibmvscsis? I think that there is
> nothing. Everything is configured via the firmware before the kernel
> boots. So I don't see any point to configure something from the user
> space. That just wastes user's time like Brian.
> --

Yes, but the user still needs to configure the fabric Port/LUNs in order
to build the the view of the target backends, right..? 

In this particular case for ibmvscsis since we already know the target
endpoint names from sysfs attributes, using a small amount of scripting
code in lio-utils to automatically setup the endpoints for the user is
really simple, and we still expect the user to define which backend
devices from /sys/kernel/config/target/$HBA/$DEV will be configured as
Port/LUNs for the fabric endpoint.

--nab

