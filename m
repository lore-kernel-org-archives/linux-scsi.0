From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND V2 7/7] scsi: storvsc: Set the error code correctly in failure conditions
Date: Thu, 13 Aug 2015 08:43:52 -0700
Message-ID: <1439480632-11144-7-git-send-email-kys@microsoft.com>
References: <1439480609-11099-1-git-send-email-kys@microsoft.com>
 <1439480632-11144-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1439480632-11144-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, vkuznets@redhat.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
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
