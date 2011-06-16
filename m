From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Thu, 16 Jun 2011 20:40:23 +0200
Message-ID: <20110616184023.GA2362@osiris.boeblingen.de.ibm.com>
References: <20110615112016.GA4227@osiris.boeblingen.de.ibm.com>
 <20110616160155.GB3843@osiris.boeblingen.de.ibm.com>
 <1308242275.2436.56.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:58099 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab1FPSkc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jun 2011 14:40:32 -0400
Received: from d06nrmr1507.portsmouth.uk.ibm.com (d06nrmr1507.portsmouth.uk.ibm.com [9.149.38.233])
	by mtagate7.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p5GIeOtp031610
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2011 18:40:24 GMT
Received: from d06av07.portsmouth.uk.ibm.com (d06av07.portsmouth.uk.ibm.com [9.149.37.248])
	by d06nrmr1507.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p5GIeOpO2531340
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2011 19:40:24 +0100
Received: from d06av07.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av07.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p5GIeNqD017956
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jun 2011 12:40:24 -0600
Content-Disposition: inline
In-Reply-To: <1308242275.2436.56.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

On Thu, Jun 16, 2011 at 12:37:55PM -0400, James Bottomley wrote:
> On Thu, 2011-06-16 at 18:01 +0200, Heiko Carstens wrote:
> > cc'ing Jens (full quote of the original bug report at the end).
> > 
> > I patched the SLUB debugging code so that it includes full call traces
> > instead of just the address of the caller of kfree/kmalloc. So here is
> > yet another incarnation of what I think is the same use-after-free bug:
> > 
> > What we can see here: while scsi_dispatch_cmd() operates on a scsi_cmnd
> > it gets freed via blk_done_softirq().
> > In this specific case scsi_send_log() crashes while trying to dereference
> > the SLAB/SLUB poison value.
> 
> But you're crashing in the submit path, not the completion path.
> scsi_send_log() is called *before* we dispatch the command, so how on
> earth did the command get freed in the completion (softirq) path?

Well, I was hoping you would point to something obviously wrong ;)
So the only way I can think this could have happened then seems to
be something like this sequence:

User A -- allocs command
User A -- somehow frees command (but still has a reference)
User B -- submit path allocs command (gets freed slab again)
User A -- frees it again
User B -- submit path crashes

So looks like I need to add more trace and/or debug code. Sigh.
Dunno.. maybe zfcp returns the command twice or something like that; even
though there is code in place which should prevent exactly this scenario.
