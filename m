From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v2] scsi: fix async probe regression
Date: Fri, 25 May 2012 10:55:07 -0700
Message-ID: <20120525175140.22423.21697.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: Meelis Roos <mroos@linux.ee>, Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, David Miller <davem@davemloft.net>
List-Id: linux-scsi@vger.kernel.org

Commit a7a20d1 "[SCSI] sd: limit the scope of the async probe domain"
moved sd probe work out of reach of wait_for_device_probe().  Allow it
to be synced via scsi_complete_async_scans().

Cc: David Miller <davem@davemloft.net>
Cc: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Meelis Roos <mroos@linux.ee>
Tested-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 v2: James: don't wrapper scsi_complete_async_scans()

 Kept the Tested-by tag since this is equivalent to v1.

 --
 Dan

 drivers/scsi/scsi_scan.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 01b0374..2e5fe58 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -147,7 +147,7 @@ int scsi_complete_async_scans(void)
 
 	do {
 		if (list_empty(&scanning_hosts))
-			return 0;
+			goto out;
 		/* If we can't get memory immediately, that's OK.  Just
 		 * sleep a little.  Even if we never get memory, the async
 		 * scans will finish eventually.
@@ -179,8 +179,11 @@ int scsi_complete_async_scans(void)
 	}
  done:
 	spin_unlock(&async_scan_lock);
-
 	kfree(data);
+
+ out:
+	async_synchronize_full_domain(&scsi_sd_probe_domain);
+
 	return 0;
 }
 
