From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/2] RFC: The be2iscsi driver support for bsg
Date: Mon, 22 Mar 2010 17:57:27 +0900
Message-ID: <20100322175704Y.fujita.tomonori@lab.ntt.co.jp>
References: <4BA294FC.3030400@cs.wisc.edu>
	<20100319081016W.fujita.tomonori@lab.ntt.co.jp>
	<4BA3747E.4020104@emulex.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:57298 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab0CVI5v (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Mar 2010 04:57:51 -0400
In-Reply-To: <4BA3747E.4020104@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.smart@emulex.com
Cc: fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu, jayamohank@serverengines.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, open-iscsi@googlegroups.com

On Fri, 19 Mar 2010 08:56:30 -0400
James Smart <james.smart@emulex.com> wrote:

> > I still want to know why vendors can't do this via the existing
> > netlink interface. open-iscsi uses the netlink interface for some pdu
> > so I guess that having a different channel for management might be a
> > good idea.
> 
> Separate this request into two needs:
> 
> The first need is for the iscsi driver to have some kind of entry point to 
> kick off a vendor specific thing - primarily diagnostics and internal f/w and 
> flash mgmt items. Here, using the same mechanism that we had on the FC side, 
> which also supports dma payloads, made a lot of sense. I like and prefer the 
> symmetry.
> 
> The second need is for "common iscsi link/stack mgmt". All vendors would be 
> expected to implement the same items the same way - thus the formalization of 
> the api in the transport.  It also makes sense that all use of these common 
> interfaces comes via the open-iscsi mgmt utilities.  Given the data set, it 
> could be done by netlink or bsg.  I gave some pros/cons on the interfaces in 
> (http://marc.info/?l=linux-scsi&m=124811693510903&w=2). In my mind, the main 
> reason these settings ended up in bsg vs netlink is - the functionality is 
> typically migrating from a vendor-specific ioctl set, which maps rather easily 
> to the bsg model. Not that netlink is that more difficult (although to NLA_ or 
> not may confuse some of the contributors). And, if you already had the bsg 
> infrastructure for the first need, you had to add very little to support it.
> 
> Thus, the main reason they are together is one of expediency. The first had to 
> be done, so it was very easy to use the same methodology for the second.

If vendors use the common data structures via bsg, it's totally fine
by me. I see why bsg is preferable. The only thing that I care about
is managing any iSCSI HBA with iscsiadm instead of various vendor
specific utilities.

About the implementation, I think that it's better to have the common
library code rather than just copying the fs bsg code into iscsi.
