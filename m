From: Joshua Daniel Franklin <joshuadfranklin@yahoo.com>
Subject: Re: [PATCH] 3w-xxxx: Add tw_sysfs_init() so udev will create /dev/twe* devices.
Date: Fri, 6 Jul 2007 18:58:30 -0700 (PDT)
Message-ID: <982443.90869.qm@web37903.mail.mud.yahoo.com>
References: <b1bc6a000707061658q15cdf1c6jfe399f6a31112d06@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web37903.mail.mud.yahoo.com ([209.191.91.165]:32401 "HELO
	web37903.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752753AbXGGB6b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jul 2007 21:58:31 -0400
In-Reply-To: <b1bc6a000707061658q15cdf1c6jfe399f6a31112d06@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linuxraid@amcc.com

--- adam radford wrote:
> I have one problem with this patch:
> 
> You are calling "class_device_create()" from 0 to "TW_MAX_UNITS"
> which is 16...
> shouldn't you be calling this only once per each controller instance
> that is discovered
> via twa_probe() ?

Well, I was just trying to emulate what the userspace tools do,
which is create all 16 devices whether or not they're physically
present. I actually tried with only twe0 (I have only one card in my
test system) and smartd seems to try to find twe1-15 anyway. I'm
not sure what it's doing, but I assume it's talking to the driver.

> Also, no other scsi LLDD drivers are calling "class_device_create()",
> so I wonder if
> this is acceptable to scsi maintainers?

I wondered the same thing. I think perhaps the only issue is with
SELinux mentioned below which is rare and so it's a low priority 
to use sysfs. There may be other reasons I'm not aware of, though.

> Right now we have our userspace tools creating the /dev/tweX devices.

Yes, unfortunately that leaves the /dev/tweX devices with the 
wrong SELinux security context and harald@redhat suggested this
approach:
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=232218
I'd be happy to hear alternative solutions, but it sounds like
they do not want to use a custom udev rule.


       
____________________________________________________________________________________
Get the free Yahoo! toolbar and rest assured with the added security of spyware protection.
http://new.toolbar.yahoo.com/toolbar/features/norton/index.php
