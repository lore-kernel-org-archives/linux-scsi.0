From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 17/18] srp_transport: Add transport layer recovery
 support
Date: Mon, 16 Jul 2012 18:44:54 -0400
Message-ID: <1342478694.25927.15.camel@frustration.ornl.gov>
References: <3109536.qySrY1Ts3e@asus> <2536946.Diyz1JQnfo@asus>
	 <500490A5.7020202@cs.wisc.edu>
	 <1342477710.25927.10.camel@frustration.ornl.gov>
	 <500497E3.1090109@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta01.ornl.gov ([128.219.14.70]:21429 "EHLO mta01.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab2GPWoz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2012 18:44:55 -0400
In-Reply-To: <500497E3.1090109@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>

On Mon, 2012-07-16 at 18:38 -0400, Mike Christie wrote:
> On 07/16/2012 04:28 PM, David Dillow wrote:
> > On Mon, 2012-07-16 at 18:07 -0400, Mike Christie wrote:
> >> For the ping code, does it use TUR because there is not a transport way
> >> to test the path/port/transport/interconnect?
> > 
> > Yes, SRP does not have a way to test connectivity on a transport level
> > ala iSCSI NOPs. I'm not at all inclined to add the ping functionality to
> > the SRP initiator, as I see it as duplicative of the existing multipathd
> > functionality in userspace, and it can kill the entire nexus even if
> > only one LUN is having issues.
> > 
> 
> I am not in favor of a tur in the transport class too.
> 
> What about when multipath is not used or are you saying we should use it
> for srp even when there is only one path (for iscsi we have told people
> to do something like this if they want mpaths queue_if_no_path behavior).

If they want to quickly detect and fail idle paths, then perhaps.
Otherwise, the loss of the connection will only be noticed on the next
command.

We can also get notifications from the fabric when a device leaves, so
we can use that to start the dev_loss_tmo and prune the stale
connections.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


