From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 0/7] convert semaphore to mutex in struct class
Date: Mon, 07 Jan 2008 18:13:37 +0100
Message-ID: <47825DC1.3090102@s5r6.in-berlin.de>
References: <20080103055019.GA4885@darkstar.te-china.tietoenator.com>	<20080107020944.GA3637@darkstar.te-china.tietoenator.com>	<20080107084528.GA8365@suse.de>	<200801070101.15168.david-b@pacbell.net>	<478227D5.8050402@s5r6.in-berlin.de> <20080107154404.GA10880@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:55303 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999AbYAGROg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jan 2008 12:14:36 -0500
In-Reply-To: <20080107154404.GA10880@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: James.Bottomley@hansenpartnership.com, dbrownell@users.sourceforge.net, Dave Young <hidave.darkstar@gmail.com>, linux-scsi@vger.kernel.org, a.zummo@towertech.it, peterz@infradead.org, cbou@mail.ru, linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>, krh@redhat.com, stern@rowland.harvard.edu, rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net, linux1394-devel@lists.sourceforge.net, dwmw2@infradead.org, davem@davemloft.net, jarkao2@gmail.com

Greg KH wrote:
> On Mon, Jan 07, 2008 at 02:23:33PM +0100, Stefan Richter wrote:
>> David Brownell wrote:
>> > On Monday 07 January 2008, Greg KH wrote:
>> >> Most of the non-driver core code should be converted to not use the
>> >> lock in the class at all.  They should use a local lock instead.
>> > 
>> > Or better yet, that yet-to-be-written class_for_each_instance()
>> > iterator ... :)
>> 
>> By far most of the usages of class.semaphore or class.mutex in drivers
>> are to protect the class.devices list.  The only? right thing to do
>> there is to keep using the class.{semaphore,mutex}.  The more elegant
>> variation of this would be David's class_for_each_instance() iterator
>> which would allow us to hide the locking details from the drivers.
> 
> If such functionality is needed, fine, I have no objection to that
> change to move the locking logic into the driver core.

It's already in the driver core to the most part.  It remains to be seen
what is less complicated in the end:  Transparent mutex-protected list
accesses provided by driver core (requires the iterator), or all the
necessary locking done by the drivers themselves (requires some more
lock-taking but perhaps fewer lock instances overall in the drivers, and
respective redefinitions and documentation of the driver core API).

Semi off-topic:  What about struct device.sem?  Is there any chance to
rip this out of the driver core and let drivers serialize everything?  I
suppose not...
-- 
Stefan Richter
-=====-==--- ---= --===
http://arcgraph.de/sr/
