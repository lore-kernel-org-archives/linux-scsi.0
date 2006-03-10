From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: scsi_track_queue_full function - static values ?
Date: Fri, 10 Mar 2006 20:28:23 +0100
Message-ID: <1142018904.2876.96.camel@laptopd505.fenrus.org>
References: <440D8B7C.9020001@ext.bull.net>
	 <20060310164027.GA6397@infradead.org> <20060310182032.GA1841@redhat.com>
	 <1142015990.2876.94.camel@laptopd505.fenrus.org>
	 <20060310191619.GC1841@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:1420 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1752039AbWCJT21 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 14:28:27 -0500
In-Reply-To: <20060310191619.GC1841@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org, Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>, Christoph Hellwig <hch@infradead.org>

On Fri, 2006-03-10 at 14:16 -0500, Doug Ledford wrote:
> > 
> > > command outstanding at a time, any driver that sets cmd_per_lun > 1 must, by
> > > definition, be able to do it's own internal queueing and respect the limit
> > > of 1 command at a time on untagged devices. 
> > 
> > 
> > Hmmmmmmmm are you sure?
> 
> Try sending more than 1 untagged command to a device at a time.  Instant
> error.  So, of course if cmd_per_lun is > 1 and the device is untagged it
> must be queued somewhere. 

sure

>  Where may be a question now, but it used to be
> either in the driver or the hardware.  In my case, it was the driver and
> that was specifically so that on command completion of an untagged command I
> would have the next command ready to go and could stick it in the cards
> QIN_FIFO during the interrupt handler, thereby improving things like round
> trip time on tape drives so as to not interrupt streaming.  If it's at the
> mid layer level now, then you've taken away a driver's ability to do what I
> just mentioned.

drivers nowadays do NOT have queues (or if they do, they're left over
and should be fixed). Of course a hardware based queue doesn't count in
this sense...


