From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH] scsi_dh: allow 3rd party multipath drivers to
 scsi_dh_detach
Date: Thu, 15 Dec 2011 16:44:40 -0500
Message-ID: <20111215214440.GA17677@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44373 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759541Ab1LOVoo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Dec 2011 16:44:44 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

Some scsi_dh modules are known to conflict with with 3rd party multipath
drivers (e.g. scsi_dh_emc conflicts with EMC PowerPath).

Allow 3rd party multipath drivers to programatically detach a scsi_dh
using the scsi_dh_detach() interface rather than require writing
'detach' to /sys/block/sdX/queue/dh_state

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/scsi/device_handler/scsi_dh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

[begs the question: why are _any_ of the scsi_dh symbols
EXPORT_SYMBOL_GPL?  Linux would benefit from more 3rd party use of
scsi_dh*.  As it stands, Linux is being held back from having better
default handling of multipath LUNs purely because 3rd parties may not
play nicely with scsi_dh* being attached]

diff --git a/drivers/scsi/device_handler/scsi_dh.c b/drivers/scsi/device_handler/scsi_dh.c
index 23149b9..a550de1 100644
--- a/drivers/scsi/device_handler/scsi_dh.c
+++ b/drivers/scsi/device_handler/scsi_dh.c
@@ -578,7 +578,7 @@ void scsi_dh_detach(struct request_queue *q)
 	}
 	put_device(&sdev->sdev_gendev);
 }
-EXPORT_SYMBOL_GPL(scsi_dh_detach);
+EXPORT_SYMBOL(scsi_dh_detach);
 
 static struct notifier_block scsi_dh_nb = {
 	.notifier_call = scsi_dh_notifier
