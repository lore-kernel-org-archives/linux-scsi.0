From: 'Christoph Hellwig' <hch@infradead.org>
Subject: Re: [ANNOUNCE] Emulex lpfcdriver v8.0.7 available
Date: Tue, 27 Jul 2004 13:09:24 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040727130924.A19273@infradead.org>
References: <20040723211529.GQ20738@ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:38663 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S265139AbUG0MJ1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2004 08:09:27 -0400
Content-Disposition: inline
In-Reply-To: <20040723211529.GQ20738@ma.emulex.com>; from Jamie.Wellnitz@emulex.com on Fri, Jul 23, 2004 at 05:15:29PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Cc: linux-scsi@vger.kernel.org

There's some more issues with timer useag in the driver:

 - never to timer->expires = 0, the proper way to stop a timer
   is del_timer, or del_timer_sync if you need to ensure the handler
   isn't running anymore when your finished (typically only needed
   when you free the containing object afterwards)
 - if you just want to modify the timeout use mod_timer, due to using
   del_timer_sync instead of del_timer your delete/change/add cycles
   actually are safe but not otimal, del_timer_sync is very bad on
   large systems. 
 - you can call del_timer/del_timer_sync/mod_timer on any timer object
   init_timer has been called on, no need to check whether it's actually
   running before
 - for the remaining few cases where you need to check that use timer_pending

As a tule of thumb of the above: never poke into timer->expires for a running
timer.

Also the timer data should usually set just after calling timer_init unless
it may change over the lifetime of the timer object which isn't trivial to
get right.
