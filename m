From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: [PATCH] Fix aic7xxx del_timer_sync() deadlock
Date: Fri, 27 Feb 2004 12:23:58 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3462370000.1077909838@aslan.btc.adaptec.com>
References: <1077906383.2157.98.camel@mulgrave>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:41878 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262995AbUB0TYJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Feb 2004 14:24:09 -0500
In-Reply-To: <1077906383.2157.98.camel@mulgrave>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>

> The best fix, I think is to eliminate this timer from the driver.  All
> it was doing was providing a time limited queue freeze for the BUSY and
> QUEUE_FULL on no outstanding commands cases.  These are handled
> correctly by the mid-layer, so there's no need for the driver do try to
> handle them on it's own.

There are two flaws with your analysis:

1) The mid-layer doesn't correctly handle this situation.  The mid-layer
   uses blk_plug_device() to implement this behavior rather than
   blk_stop_queue().  The leaves the implementation vulnerable to
   any code that does a manual unplug (e.g. the SCSI scan code) or a
   blk_run_queues() (e.g. MD) which can alter the duration of the delay.
   While the host may be able to tune the delay to HZ, the default values
   are not.  I'm also not sure that leaving the default blk_unplug delay
   as 0 gives you a deterministic jiffy long delay before the request
   function will be hit again.

2) These drivers both include Domain Validation support.  These commands
   do not go through the mid-layer at all yet require proper queue full
   and busy handling.

--
Justin

