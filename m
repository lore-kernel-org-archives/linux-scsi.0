From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 3/4] scsi: queue async scan work to an async_schedule domain
Date: Fri, 25 May 2012 00:50:38 -0700
Message-ID: <20120525075037.21933.69967.stgit@dwillia2-linux.jf.intel.com>
References: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120525074813.21933.91876.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mroos@linux.ee
Cc: Len Brown <len.brown@intel.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James Bottomley <JBottomley@parallels.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

This is preparation to enable async_synchronize_full() to be used as a
replacement for scsi_complete_async_scans(), i.e. to stop leaking scsi
internal details where they are not needed.

Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Len Brown <len.brown@intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: James Bottomley <JBottomley@parallels.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/scsi_scan.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 5e00e09..fb42aa0 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1847,14 +1847,13 @@ static void do_scsi_scan_host(struct Scsi_Host *shost)
 	}
 }
 
-static int do_scan_async(void *_data)
+static void do_scan_async(void *_data, async_cookie_t c)
 {
 	struct async_scan_data *data = _data;
 	struct Scsi_Host *shost = data->shost;
 
 	do_scsi_scan_host(shost);
 	scsi_finish_async_scan(data);
-	return 0;
 }
 
 /**
@@ -1863,7 +1862,6 @@ static int do_scan_async(void *_data)
  **/
 void scsi_scan_host(struct Scsi_Host *shost)
 {
-	struct task_struct *p;
 	struct async_scan_data *data;
 
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
@@ -1878,9 +1876,11 @@ void scsi_scan_host(struct Scsi_Host *shost)
 		return;
 	}
 
-	p = kthread_run(do_scan_async, data, "scsi_scan_%d", shost->host_no);
-	if (IS_ERR(p))
-		do_scan_async(data);
+	/* register with the async subsystem so wait_for_device_probe()
+	 * will flush this work
+	 */
+	async_schedule(do_scan_async, data);
+
 	/* scsi_autopm_put_host(shost) is called in scsi_finish_async_scan() */
 }
 EXPORT_SYMBOL(scsi_scan_host);
