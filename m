From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: correct deregistration from scsi_transport_fc
Date: Mon, 29 Aug 2005 10:38:17 +0200
Message-ID: <20050829083817.GA7013@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:1244 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750744AbVH2Ik1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Aug 2005 04:40:27 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id j7T8eQd7188104
	for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2005 08:40:26 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j7T8eMQg058444
	for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2005 10:40:26 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j7T8eLkj021386
	for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2005 10:40:22 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

Hi,

What is the correct sequence to register and deregister host/rport/scsi_devices
at the scsi stack?

ZFCP's sequence is like follows:

scsi_add_host
fc_remote_port_add (if port succesfully configured/opened in/by zfcp)
scsi_add_device (if unit successfully configured/opened in/by zfcp)

If a zfcp-adapter is set offline I do the following to get rid of the
entries within /sys/class/fc_*:

fc_remote_port_delete (for each rport registered for this adapter)
fc_remove_host
scsi_remove_host

Setting zfcp adapters offline it happens that the entries target0:0:0
for the old host_id 0 are still present in /sys/class/fc_transport.
The symlink "device" points to a non-existent directory
../../../devices/css0/0.0.000f/0.0.50d3/host0/rport-0:0-0/target0:0:0
of the removed host.

I observed the same behaviour when trying to delete the SCSI device
using its delete attribute before removing the host.  Furthermore I
put some printk into the release function for the SCSI device
(scsi_device_dev_release in scsi_scan.c) but this funtion is never
called -- neither if the delete attribute was used nor when the host
was completely removed.

Is there a problem with proper deregistration of kobjects for SCSI
devices in the SCSI subsystem if fc_transport is used? Or is this
obvious memory leak caused by a wrong usage of the scsi_transport_fc
interface?

Any thoughts about this problem?


Regards,

Andreas

