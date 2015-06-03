From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 7/7] scsi: storvsc: Set the error code correctly in failure
 conditions
Date: Wed,  3 Jun 2015 15:34:32 -0700
Message-ID: <1433370872-3302-7-git-send-email-kys@microsoft.com>
References: <1433370839-3240-1-git-send-email-kys@microsoft.com>
 <1433370872-3302-1-git-send-email-kys@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1433370872-3302-1-git-send-email-kys@microsoft.com>
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
List-Id: linux-scsi@vger.kernel.org

In the function storvsc_channel_init(), error code was not getting
set correctly in some of the failure cases. Fix this issue.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/scsi/storvsc_drv.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 021cbdf..aac8297 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -960,8 +960,10 @@ static int storvsc_channel_init(struct hv_device *device)
 	}
 
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0)
+	    vstor_packet->status != 0) {
+		ret = -EINVAL;
 		goto cleanup;
+	}
 
 
 	for (i = 0; i < VMSTOR_NUM_PROTOCOLS; i++) {
@@ -1040,8 +1042,10 @@ static int storvsc_channel_init(struct hv_device *device)
 	}
 
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0)
+	    vstor_packet->status != 0) {
+		ret = -EINVAL;
 		goto cleanup;
+	}
 
 	/*
 	 * Check to see if multi-channel support is there.
@@ -1078,8 +1082,10 @@ static int storvsc_channel_init(struct hv_device *device)
 	}
 
 	if (vstor_packet->operation != VSTOR_OPERATION_COMPLETE_IO ||
-	    vstor_packet->status != 0)
+	    vstor_packet->status != 0) {
+		ret = -EINVAL;
 		goto cleanup;
+	}
 
 	if (process_sub_channels)
 		handle_multichannel_storage(device, max_chns);
-- 
1.7.4.1
