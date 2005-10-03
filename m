From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 2/3] Add disk hotswap support to libata RESEND #5
Date: Mon, 03 Oct 2005 11:53:26 -0400
Message-ID: <434153F6.2050405@pobox.com>
References: <355e5e5e05092618018840fc3@mail.gmail.com>	 <433AEAAE.2070003@pobox.com>	 <1127949651.26686.11.camel@localhost.localdomain> <355e5e5e0510030819od4ef8e5l93708588990081da@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:21916 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S932310AbVJCPxc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Oct 2005 11:53:32 -0400
In-Reply-To: <355e5e5e0510030819od4ef8e5l93708588990081da@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lukasz Kosewski <lkosewsk@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org

Lukasz Kosewski wrote:
> How about this; I want this SATA hotswapping stuff to be tested, so
> I'll commit my patches for 'SATA only' for the time being.  I'll stare
> at them for a while and then see what kind of PATA-specific if
> statements and hooks are necessary in the code?

Ideally we should just create hooks for any SATA-specific behavior, and 
ensure that nothing SATA-specific is written into any of the core paths.

One of the SATA controllers, Intel ICH5 & ICH6, does not have a hotplug 
interrupt, but yet supports "coldplug":

	* user indicates to kernel, to disable the SATA port
	* kernel says "OK, it's disabled"
	* user disconnects hard drive
and
	* SATA port is disabled
	* user connects hard drive
	* user indicates to kernel, to enable SATA port
	* kernel says "OK, I've turned it on" and probes it

This is a real-world, high-volume SATA case, yet it functionally behaves 
like PATA.

So that causes us to consider various entry points:

* {something}, be it a hot-unplug interrupt or user write(2) to sysfs, 
tells us a device is gone
* {something}, be it a hot-plug interrupt or user write(2) to sysfs, 
tells us a new device appeared

So for either SATA or PATA, it should look similar in the core:  we just 
need a "kick", a function call that triggers one of these two actions. 
The handling of those actions [your code] should hopefully be pretty 
generic.  ;-)

Thanks for working on this!

	Jeff


