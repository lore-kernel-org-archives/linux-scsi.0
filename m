From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] [SCSI] scsi_dh: change scsi_dh_detach export to
 EXPORT_SYMBOL
Date: Fri, 20 Apr 2012 13:34:05 -0400
Message-ID: <20120420173405.GA8846@redhat.com>
References: <20111215214440.GA17677@redhat.com>
 <4EF039D5.5010201@suse.de>
 <20120405144721.GA18437@redhat.com>
 <20120420144538.GB8155@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120420144538.GB8155@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Chandra Seetharaman <sekharan@us.ibm.com>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Allow a proprietary non-GPL multipath driver, like EMC PowerPath, to
detach a scsi_dh using scsi_dh_detach.  This is an improvement over
requiring them to write 'detach' to /sys/block/sdX/queue/dh_state

End result is Linux and PowerPath can coexist without compromising
Linux's default handling of multipath LUNs.

Linux has suffered from the race where a scsi_dh is not available to be
attached to a SCSI device until too late (after an HBA driver has
started the SCSI device scan that may attach a scsi_dh).  Attaching a
scsi_dh too late results in default sense handling that does not
silently end IO to passive paths, which creates excessive delays and IO
errors during normal boot of a system with hundreds of LUNs.

To fix this the appropriate scsi_dh must be available to be attached
before an HBA driver's SCSI device scan.  But once attached, both
scsi_dh_alua and scsi_dh_emc are known to conflict with PowerPath --
allowing PowerPath to use scsi_dh_detach resolves such conflicts.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Acked-by: Hannes Reinecke <hare@suse.de>
Acked-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
 drivers/scsi/device_handler/scsi_dh.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

v2: header tweaks, added Chandra's Acked-by
    p.s. James, if you still think I'm too indirect or long-winded
    please feel free to change the header accordingly.  Thanks!

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
