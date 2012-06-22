From: Dan Williams <dan.j.williams@intel.com>
Subject: [set5 PATCH 5/6] Revert "[SCSI] fix async probe regression"
Date: Thu, 21 Jun 2012 23:47:22 -0700
Message-ID: <20120622064722.21538.62310.stgit@dwillia2-linux.jf.intel.com>
References: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Meelis Roos <mroos@linux.ee>, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This reverts commit 43a8d39d0137612c336aa8bbb2cb886a79772ffb.

Commit 43a8d39d fixed the fact that wait_for_device_probe() was unable
to flush sd probe work.  Now that sd probe work is once again flushable
via wait_for_device_probe() this workaround is no longer needed.

Cc: Meelis Roos <mroos@linux.ee>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/scsi_scan.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 2731c81..03ebb37 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -147,7 +147,7 @@ int scsi_complete_async_scans(void)
 
 	do {
 		if (list_empty(&scanning_hosts))
-			goto out;
+			return 0;
 		/* If we can't get memory immediately, that's OK.  Just
 		 * sleep a little.  Even if we never get memory, the async
 		 * scans will finish eventually.
@@ -179,11 +179,8 @@ int scsi_complete_async_scans(void)
 	}
  done:
 	spin_unlock(&async_scan_lock);
-	kfree(data);
-
- out:
-	async_synchronize_full_domain(&scsi_sd_probe_domain);
 
+	kfree(data);
 	return 0;
 }
 
