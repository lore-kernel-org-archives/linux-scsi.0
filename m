From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 5/7] scsi: storvsc: Fix a bug in copy_from_bounce_buffer()
Date: Fri, 27 Mar 2015 00:27:18 -0700
Message-ID: <1427441240-29314-5-git-send-email-kys@microsoft.com>
References: <1427441219-29275-1-git-send-email-kys@microsoft.com>
 <1427441240-29314-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1427441240-29314-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We may exit this function without properly freeing up the maapings
we may have acquired. Fix the bug.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Long Li <longli@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index cdf048b..f8e4dd9 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -754,21 +754,22 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 			if (bounce_sgl[j].length == PAGE_SIZE) {
 				/* full..move to next entry */
 				sg_kunmap_atomic(bounce_addr);
+				bounce_addr = 0;
 				j++;
+			}
 
-				/* if we need to use another bounce buffer */
-				if (srclen || i != orig_sgl_count - 1)
-					bounce_addr = sg_kmap_atomic(bounce_sgl,j);
+			/* if we need to use another bounce buffer */
+			if (srclen && bounce_addr == 0)
+				bounce_addr = sg_kmap_atomic(bounce_sgl, j);
 
-			} else if (srclen == 0 && i == orig_sgl_count - 1) {
-				/* unmap the last bounce that is < PAGE_SIZE */
-				sg_kunmap_atomic(bounce_addr);
-			}
 		}
 
 		sg_kunmap_atomic(src_addr - orig_sgl[i].offset);
 	}
 
+	if (bounce_addr)
+		sg_kunmap_atomic(bounce_addr);
+
 	local_irq_restore(flags);
 
 	return total_copied;
-- 
1.7.4.1
