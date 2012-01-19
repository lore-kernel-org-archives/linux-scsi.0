From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 06/10] hpsa: make target and lun match what SCSI REPORT LUNs
	returns
Date: Thu, 19 Jan 2012 14:01:09 -0600
Message-ID: <20120119200109.17835.48500.stgit@beardog.cce.hp.com>
References: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120119200042.17835.93058.stgit@beardog.cce.hp.com>
Sender: linux-kernel-owner@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, stephenmcameron@gmail.com, thenzl@redhat.com, scott.teel@hp.com, akpm@linux-foundation.org, stable@kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Some distros have a "rescan-scsi-bus.sh" script which depends on
SCSI REPORT LUNs not reporting something different than what the
driver tells the kernel, even if the driver uses scan_start and
scan_finished methods of the SCSI host template to override the
usual SCSI midlayer discovery code.  Previously, 1 was added to
the LUN to make room to insert the RAID controller device at
LUN 0.  Now, the RAID controller is moved to bus 3, and 1 is no
longer added to the LUN.  However, SCSI REPORT LUNS on Smart Array
doesn't report physical devices like tape drives or auto-loaders
as it turns out, so those particular device types still won't match.
Generally the logical drives are reported first however, so at
least those should match.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   25 +++++--------------------
 1 files changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index b30033b..c52bc76 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1645,30 +1645,15 @@ static void figure_bus_target_lun(struct ctlr_info *h,
 			*target = (lunid >> 16) & 0x3fff;
 			*lun = lunid & 0x00ff;
 		} else {
-			if (likely(is_scsi_rev_5(h))) {
-				/* All current smart arrays (circa 2011) */
-				*bus = 0;
-				*target = 0;
-				*lun = (lunid & 0x3fff) + 1;
-			} else {
-				/* Traditional old smart array way. */
-				*bus = 0;
-				*target = lunid & 0x3fff;
-				*lun = 0;
-			}
+			*bus = 0;
+			*target = 0;
+			*lun = (lunid & 0x3fff);
 		}
 	} else {
-		/* physical device */
 		if (is_hba_lunid(lunaddrbytes))
-			if (unlikely(is_scsi_rev_5(h))) {
-				*bus = 0; /* put p1210m ctlr at 0,0,0 */
-				*target = 0;
-				*lun = 0;
-				return;
-			} else
-				*bus = 3; /* traditional smartarray */
+			*bus = 3; /* controller */
 		else
-			*bus = 2; /* physical disk */
+			*bus = 2; /* physical device */
 		*target = -1;
 		*lun = -1; /* we will fill these in later. */
 	}
