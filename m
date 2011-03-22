From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Tue, 22 Mar 2011 12:26:47 +0900
Message-ID: <20110322122657W.fujita.tomonori@lab.ntt.co.jp>
References: <1300753577.21880.183.camel@haakon2.linux-iscsi.org>
	<20110322093249A.fujita.tomonori@lab.ntt.co.jp>
	<1300760921.21880.249.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:42879 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab1CVD1G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Mar 2011 23:27:06 -0400
In-Reply-To: <1300760921.21880.249.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, brking@linux.vnet.ibm.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, jxm@risingtidesystems.com, mwf@risingtidesystems.com

On Mon, 21 Mar 2011 19:28:41 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> On Tue, 2011-03-22 at 09:32 +0900, FUJITA Tomonori wrote:
> > On Mon, 21 Mar 2011 17:26:17 -0700
> > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > 
> > > On Tue, 2011-03-22 at 08:55 +0900, FUJITA Tomonori wrote:
> > > > On Mon, 21 Mar 2011 16:50:14 -0700
> > > > "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> > > > 
> > > > > On Tue, 2011-03-22 at 08:20 +0900, FUJITA Tomonori wrote:
> > > > > > On Mon, 21 Mar 2011 16:24:58 -0500
> > > > > > Brian King <brking@linux.vnet.ibm.com> wrote:
> > > > > > 
> > > > > > > > If could send along the original misconfigured configfs layout that is
> > > > > > > > causing the OOPs in handle_crq(), I would be happy to have a quick look.
> > > > > > > 
> > > > > > > Here it is. As you can see, there is no ./target/ibmvscsis directory created. In order
> > > > > > 
> > > > > > I suspect something like that. The driver can't crash with any
> > > > > > configurations though.
> > > > > > 
> > > > > > 
> > > > > > > to get it to work, I did the following. Please let me know if there is a better way
> > > > > > > to do this...
> > > > > > 
> > > > > > As I said long before, this kinda hardware configuration should
> > > > > > automatically show up when we load the driver module. But the target
> > > > > > core is broken in this regard.
> > > > > > 
> > > > > 
> > > > > It's possible to move the I_T nexus creation into VIO context code, but
> > > > > we still want to be able to define the actual target endpoint definition
> > > > > from userspace to get the proper VFS reference counting for fabric data
> > > > > structures containing struct config_group that reference the
> > > > > config_groups from the rest of the target stack.
> > > > 
> > > > Hmm, what can we configure for the ibmvscsis? I think that there is
> > > > nothing. Everything is configured via the firmware before the kernel
> > > > boots. So I don't see any point to configure something from the user
> > > > space. That just wastes user's time like Brian.
> > > > --
> > > 
> > > Yes, but the user still needs to configure the fabric Port/LUNs in order
> > > to build the the view of the target backends, right..? 
> > 
> > As I said before, there is no 'Port' to configure for the ibmvscsis.
> > 
> > So only LUNs. But before confuging LUNs, the target should work, that
> > is, telling an initiator that there is no LUNs.
> 
> Ok, this is where I was getting originally confused, thank you for the
> clarification.
> 
> Then we should be able to do something like this together with earlier
> patch to handle reporting no available LUNs because "target endpoint has
> not been configured.  I will revist my patch from this afternoon to fix
> up the REPORT_LUNs emulation to allow this, and error out in
> ibmvscsis.c:tcm_queuecommand() and send out in proper form to review.
> 
> > 
> > > In this particular case for ibmvscsis since we already know the target
> > > endpoint names from sysfs attributes, using a small amount of scripting
> > > code in lio-utils to automatically setup the endpoints for the user is
> > > really simple, and we still expect the user to define which backend
> > > devices from /sys/kernel/config/target/$HBA/$DEV will be configured as
> > > Port/LUNs for the fabric endpoint.
> > 
> > Why does users bother to run the script? We know that the kernel can
> > configure everything to make the target work.
> 
> The type of script is an example of driving the typical configuration
> layout for normal usage (eg: with TCM backends).  For a HW target mode
> case like with w/ ibmvscsis, the user should be presented with a list of
> available backends and un-configured target HW fabric endpoints

You are still confused. Nothing to configure about fabric endpoints
for ibmvscsis.

I've not used the script. I don't want.

The hardware information needs to show up automatically. You are
against it?
