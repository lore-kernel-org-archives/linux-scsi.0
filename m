From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 07/11] hpsa: do not reset unknown boards on reset_devices
Date: Thu, 06 Jan 2011 14:48:18 -0600
Message-ID: <20110106204818.10753.52995.stgit@beardog.cce.hp.com>
References: <20110106204429.10753.92575.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110106204429.10753.92575.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This is to prevent hpsa from resetting older boards
which the cciss driver may be controlling.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 688b243..5b9cd41 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3140,7 +3140,11 @@ static __devinit int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
 	 * likely not be happy.  Just forbid resetting this conjoined mess.
 	 * The 640x isn't really supported by hpsa anyway.
 	 */
-	hpsa_lookup_board_id(pdev, &board_id);
+	rc = hpsa_lookup_board_id(pdev, &board_id);
+	if (rc < 0) {
+		dev_warn(&pdev->dev, "Not resetting device.\n");
+		return -ENODEV;
+	}
 	if (board_id == 0x409C0E11 || board_id == 0x409D0E11)
 		return -ENOTSUPP;
 
