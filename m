From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 04/11] IB/srp: keep processing commands during host
 removal
Date: Mon, 26 Nov 2012 22:16:16 -0500
Message-ID: <1353986176.28917.3.camel@obelisk.thedillows.org>
References: <cover.1353903448.git.dillowda@ornl.gov>
	 <8715294a23dded5879b3a327c470d9b6a39ddbc4.1353903448.git.dillowda@ornl.gov>
	 <50B339C8.2000104@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:52219 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757937Ab2K0DQY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Nov 2012 22:16:24 -0500
In-Reply-To: <50B339C8.2000104@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, roland@purestorage.com

On Mon, 2012-11-26 at 10:43 +0100, Bart Van Assche wrote:
> On 11/26/12 05:44, David Dillow wrote:
> > From: Bart Van Assche <bvanassche@acm.org>
> > 
> > Some SCSI upper layer drivers, e.g. sd, issue SCSI commands from
> > inside scsi_remove_host() (see also the sd_shutdown() call in
> > sd_remove()). Make sure that these commands have a chance to reach
> > the SCSI device.

> Hi Dave,
> 
> After I posted the patch on which the above patch has been based I
> realized that it can be simplified. Since the patch called "Eliminate
> state SRP_TARGET_CONNECTING" blocks the SCSI host as long as the RDMA
> RC connection is being reconnected srp_queuecommand() won't be invoked
> during the "disconnected" or "error" state. How about adding the patch
> below just after the patch that eliminates the state
> SRP_TARGET_CONNECTING ?

Right, I left off out the part of that patch that blocks the target as I
wanted to think about its implications a bit more. I think it is
probably the right thing to do, and will likely add that functionality
back.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

