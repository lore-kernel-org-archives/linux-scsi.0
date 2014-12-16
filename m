From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3/4] Drivers: scsi: storvsc: Fix a bug in storvsc limits
Date: Tue, 16 Dec 2014 13:21:44 -0800
Message-ID: <1418764905-11250-3-git-send-email-kys@microsoft.com>
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

Commit 4cd83ecdac20d30725b4f96e5d7814a1e290bc7e changed the limits to
reflect the values on the host. It turns out that WS2008R2 cannot
correctly handle these new limits. Fix this bug by setting the limits
based on the host.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index a7163c6..fdc5164 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1782,6 +1782,9 @@ static int storvsc_probe(struct hv_device *device,
 	bool dev_is_ide = ((dev_id->driver_data == IDE_GUID) ? true : false);
 	int target = 0;
 	struct storvsc_device *stor_device;
+	int max_luns_per_target;
+	int max_targets;
+	int max_channels;
 
 	/*
 	 * Based on the windows host we are running on,
@@ -1795,12 +1798,18 @@ static int storvsc_probe(struct hv_device *device,
 		vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
 		vmstor_current_major = VMSTOR_WIN7_MAJOR;
 		vmstor_current_minor = VMSTOR_WIN7_MINOR;
+		max_luns_per_target = STORVSC_IDE_MAX_LUNS_PER_TARGET;
+		max_targets = STORVSC_IDE_MAX_TARGETS;
+		max_channels = STORVSC_IDE_MAX_CHANNELS;
 		break;
 	default:
 		sense_buffer_size = POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
 		vmscsi_size_delta = 0;
 		vmstor_current_major = VMSTOR_WIN8_MAJOR;
 		vmstor_current_minor = VMSTOR_WIN8_MINOR;
+		max_luns_per_target = STORVSC_MAX_LUNS_PER_TARGET;
+		max_targets = STORVSC_MAX_TARGETS;
+		max_channels = STORVSC_MAX_CHANNELS;
 		break;
 	}
 
@@ -1848,9 +1857,9 @@ static int storvsc_probe(struct hv_device *device,
 		break;
 
 	case SCSI_GUID:
-		host->max_lun = STORVSC_MAX_LUNS_PER_TARGET;
-		host->max_id = STORVSC_MAX_TARGETS;
-		host->max_channel = STORVSC_MAX_CHANNELS - 1;
+		host->max_lun = max_luns_per_target;
+		host->max_id = max_targets;
+		host->max_channel = max_channels - 1;
 		break;
 
 	default:
-- 
1.7.4.1
