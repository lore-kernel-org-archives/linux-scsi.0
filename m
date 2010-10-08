From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 05/13] hpsa: do not reset unknown boards on reset_devices
Date: Fri, 08 Oct 2010 15:06:27 -0500
Message-ID: <20101008200627.24279.64398.stgit@beardog.cce.hp.com>
References: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101008200453.24279.6638.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, James.Bottomley@HansenPartnership.com
Cc: akpm@linux-foundation.org, thenzl@redhat.com, mike.miller@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

This is to prevent hpsa from resetting older boards
which the cciss driver may be controlling.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ba2becc..d618432 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3163,7 +3163,11 @@ static __devinit int hpsa_kdump_hard_reset_controller(struct pci_dev *pdev)
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
 
