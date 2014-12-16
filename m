From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 4/4] Drivers: scsi: storvsc: Force SPC-3 compliance on win8
 and win8 r2 hosts
Date: Tue, 16 Dec 2014 13:21:45 -0800
Message-ID: <1418764905-11250-4-git-send-email-kys@microsoft.com>
References: <1418764880-11183-1-git-send-email-kys@microsoft.com>
 <1418764905-11250-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1418764905-11250-1-git-send-email-kys@microsoft.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On win8 and win8 r2 hosts force SPC-3 compliance for MSFT virtual disks.
Ubuntu has been carrying a similar patch outside the tree for a while now.
Starting with win10, the host will support SPC-3 compliance. Based on all
the testing that has been done on win8 and win8 r2 hosts, we are comfortable
claiming SPC-3 compliance on these hosts as well. This will enable TRIM
support on these hosts.

Suggested by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index fdc5164..7487e07 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1468,6 +1468,19 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 	 */
 	sdevice->sdev_bflags |= msft_blist_flags;
 
+	/*
+	 * If the host is WIN8 or WIN8 R2, claim conformance to SPC-3
+	 * if the device is a MSFT virtual device.
+	 */
+	if (!strncmp(sdevice->vendor, "Msft", 4)) {
+		switch (vmbus_proto_version) {
+		case VERSION_WIN8:
+		case VERSION_WIN8_1:
+			sdevice->scsi_level = SCSI_SPC_3;
+			break;
+		}
+	}
+
 	return 0;
 }
 
-- 
1.7.4.1
