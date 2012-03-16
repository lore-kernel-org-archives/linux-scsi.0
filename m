From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/2] Drivers: scsi: storvsc: Set the scsi result correctly when SRB status is INVALID
Date: Fri, 16 Mar 2012 13:24:31 -0700
Message-ID: <1331929472-6877-1-git-send-email-kys@microsoft.com>
References: <1331929448-6838-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:44961
	"HELO p3plsmtps2ded01-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932458Ab2CPURn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 Mar 2012 16:17:43 -0400
In-Reply-To: <1331929448-6838-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>

Currently Windows hosts only support a subset of scsi commands and for commands
that are not supported, the host returns a generic SRB failure status.
However, they have agreed to change the return value to indicate that
the command is not supported. In preparation for that, handle the 
SRB_STATUS_INVALID_REQUEST return value correctly.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 44c7a48..8b967c9 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -202,6 +202,7 @@ enum storvsc_request_type {
 #define SRB_STATUS_INVALID_LUN	0x20
 #define SRB_STATUS_SUCCESS	0x01
 #define SRB_STATUS_ERROR	0x04
+#define SRB_STATUS_INVALID_REQUEST 0x06
 
 /*
  * This is the end of Protocol specific defines.
@@ -779,6 +780,13 @@ static void storvsc_command_completion(struct storvsc_cmd_request *cmd_request)
 	}
 
 	/*
+	 * If the host returns with an invalid request, set
+	 * the scsi command result correctly.
+	 */
+	if (vm_srb->srb_status == SRB_STATUS_INVALID_REQUEST)
+		scmnd->result = ILLEGAL_REQUEST << 16;
+
+	/*
 	 * If there is an error; offline the device since all
 	 * error recovery strategies would have already been
 	 * deployed on the host side.
-- 
1.7.4.1

