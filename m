From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 6/6] scsi: storvsc: Allow write_same when host is windows 10
Date: Fri, 29 May 2015 13:29:19 -0700
Message-ID: <1432931359-14473-6-git-send-email-kys@microsoft.com>
References: <1432931336-14434-1-git-send-email-kys@microsoft.com>
 <1432931359-14473-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1432931359-14473-1-git-send-email-kys@microsoft.com>
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
Cc: "keith.mange@microsoft.com" <keith.mange@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

From: keith.mange@microsoft.com <keith.mange@microsoft.com>

Allow WRITE_SAME for Windows10 and above hosts.

Tested-by: Alex Ng <alexng@microsoft.com>
Signed-off-by: Keith Mange <keith.mange@microsoft.com>
Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 58fa47a..021cbdf 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1488,7 +1488,8 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 
 	/*
 	 * If the host is WIN8 or WIN8 R2, claim conformance to SPC-3
-	 * if the device is a MSFT virtual device.
+	 * if the device is a MSFT virtual device.  If the host is
+	 * WIN10 or newer, allow write_same.
 	 */
 	if (!strncmp(sdevice->vendor, "Msft", 4)) {
 		switch (vmstor_proto_version) {
@@ -1497,6 +1498,9 @@ static int storvsc_device_configure(struct scsi_device *sdevice)
 			sdevice->scsi_level = SCSI_SPC_3;
 			break;
 		}
+
+		if (vmstor_proto_version >= VMSTOR_PROTO_VERSION_WIN10)
+			sdevice->no_write_same = 0;
 	}
 
 	return 0;
-- 
1.7.4.1
