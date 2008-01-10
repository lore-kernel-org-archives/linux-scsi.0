From: Greg KH <gregkh@suse.de>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Thu, 10 Jan 2008 10:39:17 -0800
Message-ID: <20080110183917.GA20188@suse.de>
References: <20080107154404.GA10880@suse.de> <47825DC1.3090102@s5r6.in-berlin.de> <20080107172009.GA25943@suse.de> <a8e1da0801072305x3378c195qeb0bb7027030254c@mail.gmail.com> <20080108224837.GA19623@suse.de> <a8e1da0801081732i3677245chef1fda1fea65f7cf@mail.gmail.com> <20080109061316.GA3249@darkstar.te-china.tietoenator.com> <a8e1da0801082237x37d2a56eqee6db19017499dbc@mail.gmail.com> <a8e1da0801082239h198c4d45i5cd7cf183472a166@mail.gmail.com> <20080110094843.GA3014@darkstar.te-china.tietoenator.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55359 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753887AbYAJSjL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jan 2008 13:39:11 -0500
Content-Disposition: inline
In-Reply-To: <20080110094843.GA3014@darkstar.te-china.tietoenator.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>, krh@redhat.com, stern@rowland.harvard.edu, rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com

On Thu, Jan 10, 2008 at 05:48:43PM +0800, Dave Young wrote:
> The patches are done on my side, please help to check. 

Along with all of the other comments from people, I have a few.

> This is the first one of the series about driver core changes. 
> If this one is accepted and there's no other problem I will post the others for maintainer's review (they need your comment and help because I don't know well about the specific driver logic).
> 
> Thanks a lot in advance.
> ---
> 
> 1. convert class semaphore to mutex.
> 2. add class iterater functions to encapsulate the detail of class devices/children list iterating :
> 	class_for_each_device
> 	class_find_device
> 	class_for_each_child
> 	class_find_child

No, please create 1 patch per type-of-change.

So in this case you would have a series of patches:
	1) add the class iterator functions
	2-n) convert the existing places in the kernel using the
	     class->semaphore to use the new iterator functions
	n+1) convert class semaphore to mutex, which should only touch
	     the driver core

That way everything builds along the way, and it's easy to understand
and review.

Oh, and please start a new thread when you create a new patch like this
so it doesn't get burried in people's inboxes...

thanks,

greg k-h
