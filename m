From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH RESEND 1/2] Drivers: scsi: storvsc: Set the scsi result correctly when SRB status is INVALID
Date: Sun, 18 Mar 2012 13:00:16 -0700
Message-ID: <1332100817-25646-1-git-send-email-kys@microsoft.com>
References: <1332100789-25594-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1332100789-25594-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

Currently Windows hosts only support a subset of scsi commands and for commands
that are not supported, the host returns a generic SRB failure status.
However, they have agreed to change the return value to indicate that
the command is not supported. In preparation for that, handle the
SRB_STATUS_INVALID_REQUEST return value correctly.

I would like to thank Jeff Garzik <jgpobox@gmail.com> and
Douglas Gilbert <dgilbert@interlog.com> for suggesting the correct approach
here.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 44c7a48..d5448e8 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -202,6 +202,7 @@ enum storvsc_request_type {
 #define SRB_STATUS_INVALID_LUN	0x20
 #define SRB_STATUS_SUCCESS	0x01
 #define SRB_STATUS_ERROR	0x04
+#define SRB_STATUS_INVALID_REQUEST 0x06
 
 /*
  * This is the end of Protocol specific defines.
@@ -779,6 +780,17 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
 	}
 
 	/*
+	 * If the host returns with an invalid request, set
+	 * the scsi command result correctly.
+	 */
+	if (vm_srb->srb_status == SRB_STATUS_INVALID_REQUEST) {
+		scmnd->result = ((DRIVER_SENSE << 24) |
+                                 SAM_STAT_CHECK_CONDITION);
+		scsi_build_sense_buffer(0, scmnd->sense_buffer,
+					ILLEGAL_REQUEST, 0x20, 0);
+	}
+
+	/*
 	 * If there is an error; offline the device since all
 	 * error recovery strategies would have already been
 	 * deployed on the host side.
-- 
1.7.4.1
