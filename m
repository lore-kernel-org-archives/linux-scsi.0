From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2 0/3] fcoe: fixup device_del() inversion
Date: Fri, 15 Sep 2017 13:12:11 +0200
Message-ID: <1505473934-123915-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43539 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751213AbdIOLMX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 15 Sep 2017 07:12:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

when shutting down an FCoE target system one is greeted with a flood
of kernel warnings about

sysfs group ffffffff81eff0e0 not found for kobject 'XXX'

Reason here is that the fcoe driver tries to remove devices from
a workqueue, but the NETDEV_UNREGISTER notification expects any
calls to be synchronous as it will tear down the device once
the notifications return.
With this patch device removals are done synchronously, so the
correct ordering is respected and the warnings are gone.

As usual, comments and reviews are welcome.

Hannes Reinecke (3):
  fcoe: move fcoe_interface_remove() out of fcoe_interface_cleanup()
  fcoe: separate out fcoe_vport_remove()
  fcoe: open-code fcoe_destroy_work() for NETDEV_UNREGISTER

 drivers/scsi/fcoe/fcoe.c | 81 ++++++++++++++++++++++++++++++------------------
 1 file changed, 51 insertions(+), 30 deletions(-)

-- 
1.8.5.6
