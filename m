From: Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 1/2] scsi: hyper-v storvsc switch up to SPC-3
Date: Fri, 16 May 2014 16:39:07 +0100
Message-ID: <1400254748-21573-2-git-send-email-abbotti@mev.co.uk>
References: <1400254748-21573-1-git-send-email-abbotti@mev.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1400254748-21573-1-git-send-email-abbotti@mev.co.uk>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: driverdev-devel-bounces@linuxdriverproject.org
To: linux-scsi@vger.kernel.org, devel@linuxdriverproject.org
Cc: Andy Whitcroft <apw@canonical.com>, Haiyang Zhang <haiyangz@microsoft.com>, Tim Gardner <tim.gardner@canonical.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
List-Id: linux-scsi@vger.kernel.org

From: Andy Whitcroft <apw@canonical.com>

Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andy Whitcroft <apw@canonical.com>
---
Original patch title changed slightly by Ian Abbott <abbotti@mev.co.uk>
due to typo.
---
 drivers/scsi/storvsc_drv.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 9969fa1..3903c8a 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1441,6 +1441,14 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	sdevice->no_write_same = 1;
 
+	/*
+	 * hyper-v lies about its capabilities indicating it is only SPC-2
+	 * compliant, but actually implements the core SPC-3 features.
+	 * If we pretend to be SPC-3, we send RC16 which activates trim and
+	 * will query the appropriate VPD pages to enable trim.
+	 */
+	sdevice->scsi_level = SCSI_SPC_3;
+
 	return 0;
 }
 
-- 
1.9.2
