From: Jamie Lenehan <lenehan@twibble.org>
Subject: [PATCH] dc395x [0/6] - description
Date: Thu, 21 Aug 2003 20:13:48 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030821101348.GA7570@twibble.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tuon.twibble.org ([203.217.29.157]:22674 "EHLO tuon.twibble.org")
	by vger.kernel.org with ESMTP id S262543AbTHUKNx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Aug 2003 06:13:53 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: dc395x@twibble.org

Hi,

here's a few more dc395x patches. These clean up the allocation and
release of devices, adapters and scsi host information and a few
minor changes.

NOTE: This is against 2.6.0-test3-bk7. During the last merge DaveM
      fixed the breakage (caused by a prototype change I missed) and
      pushed it directly to Linus while the change that Christoph
      send to linux-scsi get lost. (It's only 4 lines difference). 
      Anyway, this is against 2.6.0-test3-bk7 in which the mess was
      resolved... (How do other people deal with this sort of thing?)


20030818-#4-make-functions-static.patch

 I forgot to make some of the new functions added during the list
 cleanups static. This patch just declares those new functions static.


20030818-#5-cleanup-devices.patch

 This cleans up the device management. It makes the init and cleanup
 seperate functions that basically do the opposite type things in
 reverse order. Makes it clear which functions remove a device and
 which ones free a device (or devices.)
                                                                                                                             

20030818-#6-cleanup-adapter-init.patch

 Cleanup of the adapter initialization sequence. Now it's clear what
 is going on and what has been done at any point. It also keeps the
 initialization of various things together and not spread out over a
 bunch of different functions. This then made it possible to ensure
 that appropriate the resources were correctly released in the event
 of failure.
                                                                                                                             

20030820-#7-cleanup-adapter-uninit.patch

 Clean up the initialization sequence for the adapter. Makes it easier
 to follow.


20030820-#8-check-for-device.patch

 After searching for a device to free, only free it if it was found.


20030820-#9-use-resource-len.patch

 Instead of hard coding the number of io ports (to the wrong value no
 less) use the pci_resource_length to determine the number.
                                                                                                                             

-- 
 Jamie Lenehan <lenehan@twibble.org>
