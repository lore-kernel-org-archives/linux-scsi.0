From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v9 07/10] block: add a new interface to block events
Date: Mon, 19 Nov 2012 06:50:09 -0800
Message-ID: <20121119145009.GA15971@htj.dyndns.org>
References: <20121118233531.GC25790@mtj.dyndns.org>
 <Pine.LNX.4.44L0.1211182058450.10879-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:58319 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab2KSOuO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Nov 2012 09:50:14 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1211182058450.10879-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Aaron Lu <aaron.lu@intel.com>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org

On Sun, Nov 18, 2012 at 09:07:22PM -0500, Alan Stern wrote:
> Hey...

Hey, again. :P

> > So, at least for SATA, I think what autopm can do is...
> > 
> > * Trigger zpodd if possible.
> > 
> > * Trigger suspend iff polling isn't happening on the device.
> 
> That sums it up nicely.  Of course, the PM core is unaware of details
> such as media polling.  What we can do is have the SATA runtime-idle
> method return -EBUSY if the device isn't a ZPODD and if polling is
> enabled.  Unfortunately I don't think there's any way currently to
> trigger autopm when the user turns off polling.  Maybe something could
> be added to the appropriate sysfs handler.

Given that genhd event polling and PM are likely to interact with each
other, I think it would be a good idea to implement a proper way for
the two to communicate.  Dunno what it should be tho.  The tricky part
would be mapping the block device to the underlying hardware one.

Thanks.

-- 
tejun
