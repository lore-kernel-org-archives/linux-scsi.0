From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] sd: sd should not modify read capacity, cache type or
 write protect flag on rescan when there is a transport error
Date: Mon, 28 Feb 2011 09:34:50 -0600
Message-ID: <1298907291.2487.18.camel@mulgrave.site>
References: <D8C50530D6022F40A817A35C40CC06A706576F76F2@DUBX7MCDUB01.EMEA.DELL.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59311 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899Ab1B1Pe4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2011 10:34:56 -0500
In-Reply-To: <D8C50530D6022F40A817A35C40CC06A706576F76F2@DUBX7MCDUB01.EMEA.DELL.COM>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Menny_Hamburger@Dell.com
Cc: linux-scsi@vger.kernel.org

On Sun, 2011-02-27 at 14:21 +0000, Menny_Hamburger@Dell.com wrote:
> From: Menny Hamburger <Menny_Hamburger@Dell.com>
> 
> When sd scan fails in apprehending capacity, cache_type or write protect flag
> property from the device, it automatically assigns a default value to the
> failed property. When rescanning, in case of transport/host error, this default 
> value is invalid since the problem is with the connection to the device and not in 
> the device itself that may (in most cases) still be intact. Applying a default value
> when failing may lead to problems when connection is re-established since the default
> value persists unless an additional rescan is performed.

That's correct.  Zero means we know there's something there but we
couldn't get the necessary information.  A zero size device can't be
read from or written to.

> This problem was witnessed when running in a iSCSI environment under multipath
> (with I/O on the active path). In this case we get a ping-ping effect where
> multipathd switches between alternate paths forever (until rescan) because the
> path checker states that the device is OK, and I/O fails immediately because of
> the 0 capacity (assigned to the device when rescanning while the device was 
> disconnected from the storage).
> 
> Reproduction over ISCSI environment:
> 1) dd if=/dev/dm-0 of=/dev/zero bs=64 count=10000
> 2) ifdown ethN, ethM, ethK, ... (where ethX is an interface from which the
>    machine establishes connection to the storage array).
> 3) iscsiadm -m session -R
> 4) ifup ethN, ethM, ethK, ...

This really doesn't look like a good idea.  It's a layering violation in
that the SCSI mid layer now has to try to determine if certain command
failures are the result of host disruption.

The idea of believing a prior value if a READ_CAPACITY fails also
doesn't look to be such a good one.  This could lead to volume
corruption if the disruption is part of an array configuration.

The correct fix looks to be to initiate a rescan when the host is active
via hotplug, and just teach the path checker about zero size devices?

James


