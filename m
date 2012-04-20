From: Mike Snitzer <snitzer@redhat.com>
Subject: [RESEND][PATCH] [SCSI] scsi_dh: allow 3rd party multipath drivers to
 use scsi_dh_detach
Date: Fri, 20 Apr 2012 10:45:38 -0400
Message-ID: <20120420144538.GB8155@redhat.com>
References: <20111215214440.GA17677@redhat.com>
 <4EF039D5.5010201@suse.de>
 <20120405144721.GA18437@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120405144721.GA18437@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Allow 3rd party multipath drivers to programatically detach a scsi_dh
using the scsi_dh_detach() interface.  This is as improvement over
requiring them to write 'detach' to /sys/block/sdX/queue/dh_state

End result is both Linux and 3rd party multipath drivers can coexist
without compromising Linux's default handling of multipath LUNs.

Linux has suffered from races associated with attaching a scsi_dh to a
device too late (after an HBA driver has started the SCSI device scan).
Attaching a scsi_dh too late results in default sense handling that does
not silently fail IO to passive paths, which creates excessive delays
and IO errors during normal boot on a system with hundreds of LUNs.

To fix this the appropriate scsi_dh must be attached before the HBA
driver(s) are even loaded.  But some scsi_dh are known to conflict with
3rd party multipath drivers (e.g. both scsi_dh_alua and scsi_dh_emc
conflict with EMC PowerPath).  This patch allows 3rd party drivers to
resolve the conflict by detaching an attached scsi_dh.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Hannes Reinecke <hare@suse.de>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

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
