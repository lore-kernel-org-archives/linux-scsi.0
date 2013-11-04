From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 2/3] scsi: improved eh timeout handler
Date: Mon, 4 Nov 2013 14:50:17 +0000
Message-ID: <1383576617.2485.6.camel@dabdike>
References: <1383224573-113346-1-git-send-email-hare@suse.de>
	  <1383224573-113346-3-git-send-email-hare@suse.de>
	  <20131031154905.GA10451@infradead.org> <5277A2C1.6020407@suse.de>
	 <1383575122.2485.4.camel@dabdike> <5277B346.201@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:45524 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab3KDOuV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2013 09:50:21 -0500
In-Reply-To: <5277B346.201@suse.de>
Content-Language: en-US
Content-ID: <4EFCBF64D03A2B4BADA7110E9FDAE9B2@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

On Mon, 2013-11-04 at 15:46 +0100, Hannes Reinecke wrote:
> On 11/04/2013 03:25 PM, James Bottomley wrote:
> > On Mon, 2013-11-04 at 14:36 +0100, Hannes Reinecke wrote:
> >> On 10/31/2013 04:49 PM, Christoph Hellwig wrote:
> >>> Looks reasonable to me, but a few minor nitpicks:
> >>>
> >>>> +	spin_lock_irqsave(sdev->host->host_lock, flags);
> >>>> +	if (scsi_host_eh_past_deadline(sdev->host)) {
> >>>
> >>> I don't have the implementation of scsi_host_eh_past_deadline in my
> >>> local tree, but do we really need the host lock for it?
> >>>
> >> Yes. The eh_deadline variable might be set from an interrupt context
> >> or from userland, so we need to protect access to it.
> > 
> > That's not really true.  on all our supported architectures 32 bit
> > reads/writes are atomic, which means that if one CPU writes a word at
> > the same time another reads one, the reader is guaranteed to see either
> > the old or the new data.  Given the expense of lock cache line bouncing
> > on the newer architectures, we really want to avoid a spinlock where
> > possible.
> > 
> > In this case, the problem with the implementation is that the writer
> > might set eh_deadline to zero, but this is fixable in
> > scsi_host_eh_past_deadline() by checking for zero before and after the
> > time_before (for the zero to non-zero and non-zero to zero cases).
> > 
> IE you mean something like that attached patch?

Yes (except that there should be a comment explaining why we do the read
twice), I think the cost of the extra read check is much less than the
spinlock on all of our platforms.

James

