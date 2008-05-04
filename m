From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bug 9872] Driver 'sd' needs updating - please use bus_type
	methods
Date: Sun, 04 May 2008 09:34:21 -0500
Message-ID: <1209911661.16283.16.camel@localhost.localdomain>
References: <20080504002244.D924910805F@picon.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40153 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029AbYEDOe2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 10:34:28 -0400
In-Reply-To: <20080504002244.D924910805F@picon.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bugme-daemon@bugzilla.kernel.org
Cc: linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>

On Sat, 2008-05-03 at 17:22 -0700, bugme-daemon@bugzilla.kernel.org
wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=9872

This isn't a bug.  There have been numerous discussions about fixing it.

The warning comes out of here in drivers/base/driver.c:

	if ((drv->bus->probe && drv->probe) ||
	    (drv->bus->remove && drv->remove) ||
	    (drv->bus->shutdown && drv->shutdown))
		printk(KERN_WARNING "Driver '%s' needs updating - please use "
			"bus_type methods\n", drv->name);

The problem is that SCSI drivers have both: SCSI uses the bus methods to
trigger the probe and remove (as it must having a bus method) but it
also uses the individual struct driver probe and remove methods to
rethrow the events to the ULDs.

According to Kay and Greg, this is a legitimate way of operating, and
they're not going to remove the driver methods (otherwise we'd just take
them into struct scsi_driver), so we're stuck trying to find a way to
prevent the base warning about this.

James


