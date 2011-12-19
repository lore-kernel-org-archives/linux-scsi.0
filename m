From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 14/14] ib_srp: Allow SRP disconnect through sysfs
Date: Sun, 18 Dec 2011 23:03:34 -0500
Message-ID: <1324267414.17849.98.camel@obelisk.thedillows.org>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012013.33246.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:37282 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab1LSEDo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 18 Dec 2011 23:03:44 -0500
In-Reply-To: <201112012013.33246.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, Roland Dreier <roland@purestorage.com>, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>

On Thu, 2011-12-01 at 20:13 +0100, Bart Van Assche wrote:
> Make it possible to disconnect via sysfs the IB RC connection used by the
> SRP protocol to communicate with a target.
> 
> Let the SRP transport layer create a sysfs "delete" attribute for
> initiator drivers that support this functionality.

This will be a nice feature to have, but I wonder about the proper
behavior. I had thought about having a 'drain' state, where we wouldn't
start new commands and would let existing ones complete or timeout
before killing the connection. That may be in addition to a 'kill it
now' variant.

Though perhaps my gentler delete is best done by having a user script
walk all of the devices under the host and set them to offline, wait for
scsi_host/hostX/host_busy to drop to zero, then hit the SRP delete attr.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

