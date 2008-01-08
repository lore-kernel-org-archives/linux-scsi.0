From: "Dave Young" <hidave.darkstar@gmail.com>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Tue, 8 Jan 2008 15:05:10 +0800
Message-ID: <a8e1da0801072305x3378c195qeb0bb7027030254c@mail.gmail.com>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>
	 <20080107020944.GA3637@darkstar.te-china.tietoenator.com>
	 <20080107084528.GA8365@suse.de>
	 <200801070101.15168.david-b@pacbell.net>
	 <478227D5.8050402@s5r6.in-berlin.de> <20080107154404.GA10880@suse.de>
	 <47825DC1.3090102@s5r6.in-berlin.de> <20080107172009.GA25943@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.245]:12414 "EHLO
	hs-out-2122.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751115AbYAHHFL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 02:05:11 -0500
Received: by hs-out-2122.google.com with SMTP id 54so5551775hsz.5
        for <linux-scsi@vger.kernel.org>; Mon, 07 Jan 2008 23:05:10 -0800 (PST)
In-Reply-To: <20080107172009.GA25943@suse.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, James.Bottomley@hansenpartnership.com, dbrownell@users.sourceforge.net, linux-scsi@vger.kernel.org, a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>, krh@redhat.com, stern@rowland.harvard.edu, rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com

On Jan 8, 2008 1:20 AM, Greg KH <gregkh@suse.de> wrote:
> On Mon, Jan 07, 2008 at 06:13:37PM +0100, Stefan Richter wrote:
> > It's already in the driver core to the most part.  It remains to be seen
> > what is less complicated in the end:  Transparent mutex-protected list
> > accesses provided by driver core (requires the iterator), or all the
> > necessary locking done by the drivers themselves (requires some more
> > lock-taking but perhaps fewer lock instances overall in the drivers, and
> > respective redefinitions and documentation of the driver core API).
>
> I favor changing the driver core api and doing this kind of thing there.
> It keeps the drivers simpler and should hopefully make their lives
> easier.

What about this?

#define class_for_each_dev(pos, head, member) \
        for (mutex_lock(&(container_of(head, struct class, devices))->mutex), po
s = list_entry((head)->next, typeof(*pos), member); \
        prefetch(pos->member.next), &pos->member != (head) ? 1 : (mutex_unlock(&
(container_of(head, struct class, devices))->mutex), 0); \
        pos = list_entry(pos->member.next, typeof(*pos), member))

>
> > Semi off-topic:  What about struct device.sem?  Is there any chance to
> > rip this out of the driver core and let drivers serialize everything?  I
> > suppose not...
>
> See the previous long threads about this very topic, that is what caused
> this class.sem patches :)
>
> thanks,
>
> greg k-h
>
