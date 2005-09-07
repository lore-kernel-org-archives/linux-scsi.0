From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Wed, 7 Sep 2005 13:00:41 -0700
Message-ID: <20050907200041.GB26071@us.ibm.com>
References: <431F3486.4060704@adaptec.com> <Pine.LNX.4.44L0.0509071519080.4988-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48856 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751278AbVIGUCB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2005 16:02:01 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j87K17DB023597
	for <linux-scsi@vger.kernel.org>; Wed, 7 Sep 2005 16:01:07 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j87K17gh102800
	for <linux-scsi@vger.kernel.org>; Wed, 7 Sep 2005 16:01:07 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j87K16qB005855
	for <linux-scsi@vger.kernel.org>; Wed, 7 Sep 2005 16:01:06 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0509071519080.4988-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 7 Sep 2005, Luben Tuikov wrote:
> 
> > On 09/07/05 14:27, Alan Stern wrote:
> 
> > > I'm going to argue strongly about this.  scsi_remove_host should _not_
> > > wait for error recovery to complete -- to do so will invite deadlocks.  
> > > (Suppose the error handler is waiting for a bus reset, but the bus reset
> > > routine requires a semaphore held by the LLD during the call to
> > > scsi_remove_host?)  Furthermore, error recovery can potentially take quite
> > > a long time -- much longer than we want to wait during a removal event.  
> > > Instead, the error handler should not be allowed to make the transition to
> > > RUNNING once the removal has started.
> > 
> > Alan, this tells me one thing: the _layering_ infrastructure is broken,
> > and in this case, it looks like is not SCSI Core.
> > 
> > E.g. why is the LLDD messing with semas of the host? (rhetorical, please
> > do not answer as this would go into another thread...)
> > 
> > BTW, since the eh is a _function of the host_, James is correct that
> > scsi_remove_host should wait for the eh to finish.
> 
> That's a very good point.  It hadn't occurred to me before, but you're
> absolutely right.  scsi_remove_host should indeed wait for the error
> handler to finish.  But first it should set things up so that the
> everything the error handler does will fail-fast, so that the eh can
> return quickly.  That will include putting the device into the SDEV_CANCEL
> state, so it remains true that the error handler better not try to move
> from CANCEL back to RUNNING.
> 

Well the scsi_device_set_state function / model will not let us move a
device from SDEV_CANCEL to SDEV_RUNNING again.

To fail faster (I assumed you mean the concept not the flag) we would need
to add a few checks during the start of some of the functions. It would be
good to make these as efficient as possibly, but I guess we are already in
the error handler so we have take a time hit already.

-andmike
--
Michael Anderson
andmike@us.ibm.com
