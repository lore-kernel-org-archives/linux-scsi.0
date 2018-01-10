From: Long Li <longli@exchange.microsoft.com>
Subject: [PATCH v2] storvsc: do not assume SG list is continuous when doing
 bounce buffers (for 4.1 and prior stable kernels)
Date: Wed, 10 Jan 2018 13:21:29 -0700
Message-ID: <20180110202129.28730-1-longli@exchange.microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: "K . Y . Srinivasan" <kys@microsoft.com>, Haiyang Zhang <haiyangz@microsoft.com>, "James E . J . Bottomley" <JBottomley@odin.com>, devel@linuxdriverproject.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

The original patch was made for stable 4.1 and was Acked on 08/22/2017, but for
some reason it never made it to the stable tree.

Change from v1:
Changed comment that this patch is for linux-stable 4.1 and all prior stable
kernels.

storvsc checks the SG list for gaps before passing them to Hyper-v device.
If there are gaps, data is copied to a bounce buffer and a continuous data
buffer is passed to Hyper-V.

The check on gaps assumes SG list is continuous, and not chained. This is
 not always true. Failing the check may result in incorrect I/O data
passed to the Hyper-v device.

This code path is not used post Linux 4.1.

Signed-off-by: Long Li <longli@microsoft.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

---
 drivers/scsi/storvsc_drv.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 6c52d14..14dc5c6 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -584,17 +584,18 @@ static int do_bounce_buffer(struct scatterlist *sgl, unsigned int sg_count)
 	for (i = 0; i < sg_count; i++) {
 		if (i == 0) {
 			/* make sure 1st one does not have hole */
-			if (sgl[i].offset + sgl[i].length != PAGE_SIZE)
+			if (sgl->offset + sgl->length != PAGE_SIZE)
 				return i;
 		} else if (i == sg_count - 1) {
 			/* make sure last one does not have hole */
-			if (sgl[i].offset != 0)
+			if (sgl->offset != 0)
 				return i;
 		} else {
 			/* make sure no hole in the middle */
-			if (sgl[i].length != PAGE_SIZE || sgl[i].offset != 0)
+			if (sgl->length != PAGE_SIZE || sgl->offset != 0)
 				return i;
 		}
+		sgl = sg_next(sgl);
 	}
 	return -1;
 }
-- 
2.7.4
