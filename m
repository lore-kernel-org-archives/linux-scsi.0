From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [PATCH] 0/2 use sysfs bus dev_attrs for scsi_device attributes
Date: Wed, 2 Mar 2005 11:44:32 -0800
Message-ID: <20050302194432.GA9743@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from e33.co.us.ibm.com ([32.97.110.131]:58816 "EHLO
	e33.co.us.ibm.com") by vger.kernel.org with ESMTP id S262445AbVCBToo
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Mar 2005 14:44:44 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e33.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j22Jif0D046868
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2005 14:44:41 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j22JifdB142014
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2005 12:44:41 -0700
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j22Jiedr021624
	for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2005 12:44:41 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org, Greg KH <greg@kroah.com>, Kay Sievers <kay.sievers@vrfy.org>

A couple patches so that when pending changes to sysfs/hotplug are made,
patches discussed here:

	http://marc.theaimsgroup.com/?t=110939742700002&r=1&w=2

We will get the hotplug event for a scsi_device only after all the default
scsi_device attributes are created.

The removal of the attr_changed_internally() was done so queue_type can
more easily be used as a default attribute (using the bus dev_attrs, there
is no way for some devices to create it read only, and for others to
create it as read write).

Tested with qla2300 and qla1280 drivers - neither currently support
writable queue_depth or queue_type.

The attr_overridden (and post these patches, scsi_sysfs_sdev_attrs) should
someday be removed, the only attribute being overridden (versus a host
specific scsi_device attribute) today is queue_depth, and we have
shost->change_queue_depth that can be used instead.

-- Patrick Mansfield
