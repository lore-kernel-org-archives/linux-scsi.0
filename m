From: Douglas Gilbert <dougg@torque.net>
Subject: sbp2 driver in 2.5.72
Date: Wed, 18 Jun 2003 22:46:20 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3EF05F1C.6050001@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:50951 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S265060AbTFRMcl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jun 2003 08:32:41 -0400
Received: from torque.net (d-242-38.stlucia.uq.net.au [203.101.242.38])
	by bunyip.cc.uq.edu.au (8.12.9/8.12.9) with ESMTP id h5ICkZhp031273
	for <linux-scsi@vger.kernel.org>; Wed, 18 Jun 2003 22:46:36 +1000 (GMT+1000)
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

It works on my hardware in 2.5.72 but when the sbp2 module
is loaded, there is a 20 second delay followed by this in
/var/log/messages:
   ieee1394: sbp2: Error logging into SBP-2 device -
                   login timed-out
It immediately retries the login which works and then
all is well. Additionally the sbp2 driver doesn't like
the CONFIG_DEBUG_SPINLOCK_SLEEP option set in the kernel
build. Perhaps a spinlock is being held during that 20
second delay.


 From dmesg:
ohci1394_0: SelfID received, but NodeID invalid (probably new bus reset 
occurred): 0800FFC0
ieee1394: Node added: ID:BUS[0-00:1023]  GUID[00043b000000071d]
ieee1394: Node 00:1023 changed to 01:1023
scsi2 : SCSI emulation for IEEE-1394 SBP-2 Devices
ieee1394: sbp2: Error logging into SBP-2 device - login timed-out
ieee1394: sbp2: Logged into SBP-2 device
ieee1394: sbp2: Node[00:1023]: Max speed [S400] - Max payload [2048]
   Vendor: QUANTUM   Model: FIREBALL ST3.2A   Rev:
   Type:   Direct-Access                      ANSI SCSI revision: 06
SCSI device sdb: 6306048 512-byte hdwr sectors (3229 MB)
sdb: cache data unavailable
sdb: assuming drive cache: write through
  sdb: sdb1 sdb2
Attached scsi disk sdb at scsi2, channel 0, id 0, lun 0

Doug Gilbert

