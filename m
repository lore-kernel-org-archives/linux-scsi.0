From: malahal@us.ibm.com
Subject: Re: BUG in sas event handling mechanism???
Date: Fri, 22 Sep 2006 11:32:28 -0700
Message-ID: <20060922183228.GA3639@us.ibm.com>
References: <20060922174046.GA18715@us.ibm.com> <1158949037.5718.3.camel@alexis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:26247 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S964876AbWIVSca (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 14:32:30 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e2.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8MIWTaK001567
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 14:32:29 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8MIWU8F276458
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 14:32:30 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8MIWT9h023710
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 14:32:29 -0400
Content-Disposition: inline
In-Reply-To: <1158949037.5718.3.camel@alexis>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Alexis Bruemmer [alexisb@us.ibm.com] wrote:
> On Fri, 2006-09-22 at 10:40 -0700, malahal@us.ibm.com wrote: 
> > I see a PORTE_BYTES_DMAED event, followed by a PHYE_LOSS_OF_SIGNAL event
> > and then followed by a PORTE_BYTES_DMAED event on the same phy. The code
> > seems to just drop the last event because of the not yet processed first
> > event. So, it just processes the first two events in that order. In
> > other words, the link doesn't get used at all!
> I am seeing a very similar issue with hot-plugging on the x260 systems
> with the internal expanders.  If a disk is pulled and plugged back in
> right away then the  PORTE_BROADCAST_RCVD event that was triggered when
> the disk is plugged back in is dropped, causing the disk to never be
> rediscovered.  If there is enough of a delay between unplugging and
> plugging then both PORTE_BROADCAST_RCVD events are processed correctly.
> 
> Any ideas on what would cause these events to be dropped?

The code in sas_queue_event() drops an event if there is one already in
the work queue. I don't know enough about PORTE_BROADCAST_RCVD event to
say if that is OK to to drop the event if one is pending already...

Thanks, Malahal.
