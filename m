From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/3] Unblock SCSI devices even if the LLD is being unloaded
Date: Thu, 16 Mar 2017 13:56:47 -0700
Message-ID: <20170316205650.3322-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:65199 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751954AbdCPVKW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Mar 2017 17:10:22 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Bart Van Assche <bart.vanassche@sandisk.com>

scsi_target_unblock() must unblock SCSI devices even if this function
is called after unloading of the LLD that created these devices has
started. This is necessary to prevent that __scsi_remove_device() hangs
on the SYNCHRONIZE CACHE command issued by the sd driver during shutdown.

Bart Van Assche (3):
  __scsi_iterate_devices(): Make the get and put functions arguments
  Introduce starget_for_all_devices() and shost_for_all_devices()
  Ensure that scsi_target_unblock() examines all devices

 drivers/scsi/scsi.c        | 60 +++++++++++++++++++++++++++++++++++++++++-----
 drivers/scsi/scsi_lib.c    | 22 ++++++++++++++---
 include/scsi/scsi_device.h | 29 ++++++++++++++++++----
 3 files changed, 97 insertions(+), 14 deletions(-)

-- 
2.12.0
