From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 12752] megaraid-sas driver performance worse than on-board
 sata_nv
Date: Fri, 10 Jun 2011 23:05:04 GMT
Message-ID: <201106102305.p5AN54hl028552@demeter2.kernel.org>
References: <bug-12752-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter2.kernel.org ([140.211.167.42]:56606 "EHLO
	demeter2.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214Ab1FJXFF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2011 19:05:05 -0400
Received: from demeter2.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter2.kernel.org (8.14.4/8.14.4) with ESMTP id p5AN54Pv028553
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jun 2011 23:05:04 GMT
In-Reply-To: <bug-12752-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=12752


Adam Radford <aradford@gmail.com> changed:

           What    |Removed                     |Added
----------------------------------------------------------------------------
                 CC|                            |aradford@gmail.com




--- Comment #2 from Adam Radford <aradford@gmail.com>  2011-06-10 23:05:02 ---
devsk,

I'm sorry about you not getting a response from the previous megaraid_sas
developer.  He was probably not watching bugzilla.kernel.org.

There is nothing in the driver that will 'throttle' the I/O on your PERC5
controller.

The software raid code sets various read-ahead values in the block layer
request_queues it sets up:

# grep -i "ra_pages" *
raid0.c:         * If an individual device has an ra_pages greater than the
raid0.c:                if (mddev->queue->backing_dev_info.ra_pages < 2*
stripe)
raid0.c:                        mddev->queue->backing_dev_info.ra_pages = 2*
stripe;
raid10.c:               if (mddev->queue->backing_dev_info.ra_pages < 2*
stripe)
raid10.c:                       mddev->queue->backing_dev_info.ra_pages = 2*
stripe;
raid5.c:                if (mddev->queue->backing_dev_info.ra_pages < 2 *
stripe)
raid5.c:                        mddev->queue->backing_dev_info.ra_pages = 2 *
stripe;
raid5.c:                        if
(conf->mddev->queue->backing_dev_info.ra_pages < 2 * stripe)
raid5.c:                               
conf->mddev->queue->backing_dev_info.ra_pages = 2 * stripe;

Can you try setting some OS read-ahead values (on top of the controller doing
read-ahead) for the scsi device attached to your PERC5 controller and
re-running 
your tests?

i.e.:

/sbin/blockdev --getra /dev/sda (See what you have set currently)
/sbin/blockdev --setra 8192 /dev/sda (Set read ahead for sda to 8192 sectors)
/sbin/blockdev --setra 16834 /dev/sda (Set read ahead for sda to 16384 sectors)

This may cause more I/O to be issued to the card from the OS and may improve
your bonnie++ results.

-Adam

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
