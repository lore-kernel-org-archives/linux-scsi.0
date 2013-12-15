From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH v3.13-rc3]  firewire: sbp2: bring back WRITE SAME support
Date: Sun, 15 Dec 2013 16:40:43 +0100
Message-ID: <20131215164043.0e341695@stein>
References: <20121125184525.0b7967c4@stein>
	<yq18v9nsz3q.fsf@sermon.lab.mkp.net>
	<20121202191654.59117ac2@stein> <20131215155238.6016b038@stein>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20131215155238.6016b038@stein>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Commit 54b2b50c20a6 "[SCSI] Disable WRITE SAME for RAID and virtual
host adapter drivers" disabled WRITE SAME support for all SBP-2 attached
targets.  But as described in the changelog of commit b0ea5f19d3d8
"firewire: sbp2: allow WRITE SAME and REPORT SUPPORTED OPERATION CODES",
it is not required to blacklist WRITE SAME.

Bring the feature back by reverting the sbp2.c hunk of commit 54b2b50c20a6.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: stable@kernel.org
---
 drivers/firewire/sbp2.c | 1 -
 1 file changed, 1 deletion(-)

--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1623,7 +1623,6 @@ static struct scsi_host_template scsi_driver_template = {
 	.cmd_per_lun		= 1,
 	.can_queue		= 1,
 	.sdev_attrs		= sbp2_scsi_sysfs_attrs,
-	.no_write_same		= 1,
 };
 
 MODULE_AUTHOR("Kristian Hoegsberg <krh@bitplanet.net>");


-- 
Stefan Richter
-=====-===-= ==-- -====
http://arcgraph.de/sr/

------------------------------------------------------------------------------
Rapidly troubleshoot problems before they affect your business. Most IT 
organizations don't have a clear picture of how application performance 
affects their revenue. With AppDynamics, you get 100% visibility into your 
Java,.NET, & PHP application. Start your 15-day FREE TRIAL of AppDynamics Pro!
http://pubads.g.doubleclick.net/gampad/clk?id=84349831&iu=/4140/ostg.clktrk
