From: Sitsofe Wheeler <sitsofe@gmail.com>
Subject: [PATCH v2 3/3] [SCSI] Make LBP quirk skip lbpme checks tests
Date: Thu, 24 Jul 2014 13:22:23 +0100
Message-ID: <20140724122223.GA31798@sucs.org>
References: <20140724075815.GD15127@sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
In-Reply-To: <20140724075815.GD15127@sucs.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
Cc: linux-scsi@vger.kernel.org, gregkh@linuxfoundation.org, jasowang@redhat.com, ohering@suse.com, jbottomley@parallels.com, linux-kernel@vger.kernel.org, hch@infradead.org, apw@canonical.com, devel@linuxdriverproject.org
List-Id: linux-scsi@vger.kernel.org

v1 -> v2: Fix incorrectly named variable.

Some block devices (such as Hyper-V passthrough SSDs) support logical
block provisioning (e.g. via UNMAP) but don't set lbpme thus disabling
discard. If the try_lbp quirk is in use skip lbpme checks that lead up
to the logical block provisioning tests.

Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8249e51..8bf34bc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2559,7 +2559,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 
 		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&buffer[36]);
 
-		if (!sdkp->lbpme)
+		if (!sdkp->lbpme && !sdkp->device->try_lbp)
 			goto out;
 
 		lba_count = get_unaligned_be32(&buffer[20]);
@@ -2633,7 +2633,7 @@ static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 	unsigned char *buffer;
 	const int vpd_len = 8;
 
-	if (sdkp->lbpme == 0)
+	if (sdkp->lbpme == 0 && sdkp->device->try_lbp == 0)
 		return;
 
 	buffer = kmalloc(vpd_len, GFP_KERNEL);
-- 
1.9.3
