From: "Surekha.PC" <surekhap@cisco.com>
Subject: iSCSI device naming issues
Date: Thu, 1 Jul 2004 19:28:03 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <!~!UENERkVCMDkAAQACAAAAAAAAAAAAAAAAABgAAAAAAAAANoIxZIFzbEaqwjJgytz2AeKAAAAQAAAAXdSfMOoTnU6X86O4sbqWzAEAAAAA@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ind-iport-1-sec.cisco.com ([64.104.129.9]:46886 "EHLO
	ind-iport-1.cisco.com") by vger.kernel.org with ESMTP
	id S265286AbUGAN6K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Jul 2004 09:58:10 -0400
Received: from ind-mira-01.cisco.com (IDENT:mirapoint@ind-mira-01.cisco.com [64.104.129.12])
	by india-core-1.cisco.com (8.12.10/8.12.6) with ESMTP id i61Dvu8I019705
	for <linux-scsi@vger.kernel.org>; Thu, 1 Jul 2004 06:57:56 -0700 (PDT)
List-Id: linux-scsi@vger.kernel.org
To: 'SCSI Mailing List' <linux-scsi@vger.kernel.org>


Whenever an iSCSI device is configured in the system, a hotplug
event is generated which invokes udev for device node creation.
iSCSI driver has a CALLOUT rule for udev to generate a unique
name for iSCSI devices.

The iSCSI callout program receives a sysfs device path like
/sys/block/sdc whenever a block device is added. From the device
symlink under /sys/block/sdc, it obtains the corresponding device
path under /sys/devices/.. . It extracts the device quadruple
(c,b,t,l) and identifies iSCSI device by parsing the path
/sys/class/scsi_host/iscsi/c:b:t:l. For c:b:t:l as 0:0:0:0,
iSCSI device name will be /udev/iscsib0t0l0.
P.S: <hostX> is replaced by "iscsi" above to lookup for iSCSI devices.

So, we are overwriting <hostX> as "iscsi" to help in device lookup,
which is not a good idea as pointed by Mike Christie and trying to
find out best way to achieve the same. Here are few options:
 
1) Having an iSCSI pseudo bus.
This will create a fake iscsi bus as "/sys/bus/iscsi" and all devices
will be under this pseudo bus. This can be used to lookup iSCSI
devices. I don't see any other use of this fake bus. Is it still
ok to pursue with this approach?
 
2) Having an attribute for iSCSI host which displays the name of
iSCSI driver as shown:

$cat /sys/class/scsi_host/hostX/hostname
"iSCSI SFnet Driver"

This can be used for lookup purpose. Is this acceptable?
 
3) Make use of scsi_id.
scsi_id can be used to get unique name instead of parsing sysfs
path for device name creation. However scsi_id is helpful only
for block devices, and there is no way to handle unique naming
for tape devices. So this will not make a complete solution.

Thoughts?


