From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 05/10] hpsa: Fix problem with MSA2xxx devices
Date: Thu, 19 Jan 2012 14:01:04 -0600
Message-ID: <20120119200104.17835.29536.stgit@beardog.cce.hp.com>
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

Upgraded firmware on Smart Array P7xx (and some others) made them show up as
SCSI revision 5 devices and this caused the driver to fail to map MSA2xxx
logical drives to the correct bus/target/lun.  A symptom of this would be that
the target ID of the logical drives as presented by the external storage array
is ignored, and all such logical drives are assigned to target zero,
differentiated only by LUN.  Some multipath software reportedly does not deal
well with this behavior, failing to recognize different paths to the same
device as such.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Scott Teel <scott.teel@hp.com>
---
 drivers/scsi/hpsa.c |   34 +++++++++++++++-------------------
 1 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 129655a..b30033b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1635,30 +1635,26 @@ static void figure_bus_target_lun(struct ctlr_info *h,
 
 	if (is_logical_dev_addr_mode(lunaddrbytes)) {
 		/* logical device */
-		if (unlikely(is_scsi_rev_5(h))) {
-			/* p1210m, logical drives lun assignments
-			 * match SCSI REPORT LUNS data.
+		lunid = le32_to_cpu(*((__le32 *) lunaddrbytes));
+		if (is_msa2xxx(h, device)) {
+			/* msa2xxx way, put logicals on bus 1
+			 * and match target/lun numbers box
+			 * reports.
 			 */
-			lunid = le32_to_cpu(*((__le32 *) lunaddrbytes));
-			*bus = 0;
-			*target = 0;
-			*lun = (lunid & 0x3fff) + 1;
+			*bus = 1;
+			*target = (lunid >> 16) & 0x3fff;
+			*lun = lunid & 0x00ff;
 		} else {
-			/* not p1210m... */
-			lunid = le32_to_cpu(*((__le32 *) lunaddrbytes));
-			if (is_msa2xxx(h, device)) {
-				/* msa2xxx way, put logicals on bus 1
-				 * and match target/lun numbers box
-				 * reports.
-				 */
-				*bus = 1;
-				*target = (lunid >> 16) & 0x3fff;
-				*lun = lunid & 0x00ff;
+			if (likely(is_scsi_rev_5(h))) {
+				/* All current smart arrays (circa 2011) */
+				*bus = 0;
+				*target = 0;
+				*lun = (lunid & 0x3fff) + 1;
 			} else {
-				/* Traditional smart array way. */
+				/* Traditional old smart array way. */
 				*bus = 0;
-				*lun = 0;
 				*target = lunid & 0x3fff;
+				*lun = 0;
 			}
 		}
 	} else {
