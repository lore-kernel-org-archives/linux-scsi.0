From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] scsi host/scsi device ref count cleanup 0/4
Date: Tue, 8 Jul 2003 15:24:47 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030708222447.GA2232@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:64925 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S267734AbTGHWHK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Jul 2003 18:07:10 -0400
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e33.co.us.ibm.com (8.12.9/8.12.2) with ESMTP id h68MLkkj211454
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jul 2003 18:21:46 -0400
Received: from dyn9-47-17-195 (DYN318017.beaverton.ibm.com [9.47.17.83])
	by westrelay01.boulder.ibm.com (8.12.9/NCO/VER6.5) with ESMTP id h68MLjgH145324
	for <linux-scsi@vger.kernel.org>; Tue, 8 Jul 2003 16:21:45 -0600
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch set is against scsi-misc-2.5

This set contains the following patches.
	stern_present - refresh of Alan's previous patch.
	shost_present - reduce users of shost_present.
	shost_state - Add some state flags and reorder cleanup.
	sdev_state - Add some state flags and reorder cleanup.

I still have a couple of outstanding issues 
	- sd_shutdown errors on surprise removal.
	- scsi_remove_single_device / scsi_remove_device cleanup around
	  the usage of access_count.

I tested the surprise removal using the scsi_debug add_host attribute.
I created two tgts on each host. One target I created a file system and
the other target I ran dd's. Post "-1" into add_host I did a umount -f
on the mounted file system while monitoring ref counts. I also checked the
reboot notifier list on shutdown to ensure it appeared correct.

-andmike
--
Michael Anderson
andmike@us.ibm.com

