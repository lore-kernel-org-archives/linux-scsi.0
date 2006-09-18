From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Subject: issue with scan and SDEV_DEV devices
Date: Mon, 18 Sep 2006 12:45:12 +0200
Message-ID: <450E78B8.1050308@ext.bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47019 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP id S965647AbWIRKpU
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 18 Sep 2006 06:45:20 -0400
Received: from localhost (localhost [127.0.0.1])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 9B59F19D937
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 12:45:15 +0200 (CEST)
Received: from ecfrec.frec.bull.fr ([127.0.0.1])
 by localhost (ecfrec.frec.bull.fr [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 30522-03 for <linux-scsi@vger.kernel.org>;
 Mon, 18 Sep 2006 12:45:13 +0200 (CEST)
Received: from ecn002.frec.bull.fr (ecn002.frec.bull.fr [129.183.4.6])
	by ecfrec.frec.bull.fr (Postfix) with ESMTP id 55F1719D92B
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 12:45:13 +0200 (CEST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by openx3.frec.bull.fr (Postfix) with ESMTP id CE24B2B0EB
	for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2006 12:45:12 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello,


There's an issue when using multipath (dm) and SDEV_DEL devices:

When a link come down and after the device tmo has been fired, sdev state is set 
to SDEV_DEL, but sdev isn't removed from the kernel because references haven't 
been released (scsi device has been open by multipath and hasn't been released).

Then, when the link come up, scsi_device_lookup_by_target is called.
sdev can be retrived from the kernel (__scsi_device_lookup_by_target) but 
scsi_device_get will return error because the device state is SDEV_DEL.
Doing so:
- scsi_device_lookup_by_target return a NULL sdev
- scsi_probe_and_add_lun will create a new sdev
- scsi_sysfs_add_sdev fail because there an already existing sdev with same 
host:target:bus:lun

This issue has been encountered when using Emulex and QLogic drivers with kernel 
 >=2.6.16 (since sdev ref counting is working nice ??? )

Note: similar issue when using mounted FS with scsi devices (if devices have 
SDEV_DEL state)

Any workaround/patch about this issue ?

Best regards

-- 
Frederic TEMPORELLI
