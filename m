From: Dan Williams <dan.j.williams@intel.com>
Subject: [set5 PATCH 3/6] scsi: queue async scan work to an async_schedule
 domain
Date: Thu, 21 Jun 2012 23:47:12 -0700
Message-ID: <20120622064712.21538.21140.stgit@dwillia2-linux.jf.intel.com>
References: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>, Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org, James Bottomley <JBottomley@parallels.com>
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
index 2e5fe58..a381fa2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1842,14 +1842,13 @@ static void do_scsi_scan_host(struct Scsi_Host *shost)
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
@@ -1858,7 +1857,6 @@ static int do_scan_async(void *_data)
  **/
 void scsi_scan_host(struct Scsi_Host *shost)
 {
-	struct task_struct *p;
 	struct async_scan_data *data;
 
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
@@ -1873,9 +1871,11 @@ void scsi_scan_host(struct Scsi_Host *shost)
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
