From: Arjan van de Ven <arjan@infradead.org>
Subject: Re: scsi_track_queue_full function - static values ?
Date: Fri, 10 Mar 2006 19:39:50 +0100
Message-ID: <1142015990.2876.94.camel@laptopd505.fenrus.org>
References: <440D8B7C.9020001@ext.bull.net>
	 <20060310164027.GA6397@infradead.org>  <20060310182032.GA1841@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:22475 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1751976AbWCJSjw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 13:39:52 -0500
In-Reply-To: <20060310182032.GA1841@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-scsi@vger.kernel.org, Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>, Christoph Hellwig <hch@infradead.org>


> QUEUE_FULLs happen in bunches.  When you have 10 commands waiting to go to a
> drive, and you fill its queue, depending on the driver you will either block
> the remaining 9 commands or all 10 commands will end up getting sent back to
> back and all 10 will QUEUE_FULL out.  You want these mass QUEUE_FULL events
> to be treated as a single QUEUE_FULL for the purpose of tracking the
> device's queue depth.  In addition, you want to know the depth the device
> was at, not how many commands the mid layer has created.  Only the driver
> can now that since different drivers queue things differently internally,

drivers no longer queue thankfully ;)

> there may be commands that are paused and not yet sent to the device but are
> present on the card, etc. 

that'll be hard to find out anyway


> command outstanding at a time, any driver that sets cmd_per_lun > 1 must, by
> definition, be able to do it's own internal queueing and respect the limit
> of 1 command at a time on untagged devices. 


Hmmmmmmmm are you sure?


