From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 9872] Driver 'sd' needs updating - please use bus_type methods
Date: Sun,  4 May 2008 07:34:36 -0700 (PDT)
Message-ID: <20080504143436.A901B108060@picon.linux-foundation.org>
References: <bug-9872-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128AbYEDOei (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 4 May 2008 10:34:38 -0400
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m44EYa9s021992
	for <linux-scsi@vger.kernel.org>; Sun, 4 May 2008 07:34:38 -0700
In-Reply-To: <bug-9872-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=9872





------- Comment #1 from anonymous@kernel-bugs.osdl.org  2008-05-04 07:34 -------
Reply-To: James.Bottomley@HansenPartnership.com

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


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
