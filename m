From: Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v6 2/3] libata: async resume
Date: Fri, 14 Mar 2014 13:52:54 -0700
Message-ID: <20140314205254.1269.44479.stgit@viggo.jf.intel.com>
References: <20140314205204.1269.44402.stgit@viggo.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20140314205204.1269.44402.stgit@viggo.jf.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: tj@kernel.org, JBottomley@Parallels.com
Cc: Len Brown <len.brown@intel.com>, linux-scsi@vger.kernel.org, Phillip Susi <psusi@ubuntu.com>, linux-ide@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>, Todd Brandt <todd.e.brandt@linux.intel.com>
List-Id: linux-scsi@vger.kernel.org

From: Todd Brandt <todd.e.brandt@linux.intel.com>

Improve overall system resume time by making libata link recovery
actions asynchronous relative to other resume events.

Link resume operations are performed using the scsi_eh thread, so
commands, particularly the sd resume start/stop command, will be held
off until the device exits error handling.  Libata already flushes eh
with ata_port_wait_eh() in the port teardown paths, so there are no
concerns with async operation colliding with the end-of-life of the
ata_port object.  Also, libata-core is already careful to flush
in-flight pm operations before another round of pm starts on the given
ata_port.

Reference: https://01.org/suspendresume/blogs/tebrandt/2013/hard-disk-resume-optimization-simpler-approach

Cc: Len Brown <len.brown@intel.com>
Cc: Phillip Susi <psusi@ubuntu.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Todd Brandt <todd.e.brandt@linux.intel.com>
[djbw: rebase on cleanup patch, changelog wordsmithing]
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/ata/libata-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 66110ed2c1c0..c37eb02c7136 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5450,7 +5450,7 @@ static void ata_port_resume_async(struct ata_port *ap, pm_message_t mesg)
 
 static int ata_port_pm_resume(struct device *dev)
 {
-	ata_port_resume(to_ata_port(dev), PMSG_RESUME);
+	ata_port_resume_async(to_ata_port(dev), PMSG_RESUME);
 	pm_runtime_disable(dev);
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);

