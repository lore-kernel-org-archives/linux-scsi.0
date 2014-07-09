From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/8] Drivers: scsi: storvsc: Filter commands based on the
 storage protocol version
Date: Tue,  8 Jul 2014 17:46:46 -0700
Message-ID: <1404866812-26950-2-git-send-email-kys@microsoft.com>
References: <1404866789-26910-1-git-send-email-kys@microsoft.com>
 <1404866812-26950-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1404866812-26950-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org
Cc: stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Going forward it is possible that some of the commands that are not currently
implemented will be implemented on future Windows hosts. Make command filtering
depend on the host version.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 2e4131c..759853c 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1556,9 +1556,14 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 	struct vmscsi_request *vm_srb;
 	struct stor_mem_pools *memp = scmnd->device->hostdata;
 
-	if (!storvsc_scsi_cmd_ok(scmnd)) {
-		scmnd->scsi_done(scmnd);
-		return 0;
+	if (vmstor_current_major <= VMSTOR_WIN8_MAJOR) {
+		/*
+		 * On legacy hosts filter unimplemented commands.
+		 */
+		if (!storvsc_scsi_cmd_ok(scmnd)) {
+			scmnd->scsi_done(scmnd);
+			return 0;
+		}
 	}
 
 	request_size = sizeof(struct storvsc_cmd_request);
-- 
1.7.4.1
