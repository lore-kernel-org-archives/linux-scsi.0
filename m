From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH] hpsa: do not sleep in atomic context in rmmod path.
Date: Thu, 05 Jan 2012 10:15:31 -0600
Message-ID: <20120105161531.14632.81997.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Don't call kthread_stop with a spin lock held and interrupts
disabled because kthread_stop will sleep waiting for the thread
to stop.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 865d452..a0ba29d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4269,7 +4269,9 @@ static void stop_controller_lockup_detector(struct ctlr_info *h)
 	remove_ctlr_from_lockup_detector_list(h);
 	/* If the list of ctlr's to monitor is empty, stop the thread */
 	if (list_empty(&hpsa_ctlr_list)) {
+		spin_unlock_irqrestore(&lockup_detector_lock, flags);
 		kthread_stop(hpsa_lockup_detector);
+		spin_lock_irqsave(&lockup_detector_lock, flags);
 		hpsa_lockup_detector = NULL;
 	}
 	spin_unlock_irqrestore(&lockup_detector_lock, flags);
