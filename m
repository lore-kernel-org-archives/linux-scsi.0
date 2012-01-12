From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 09/15] Staging: hv: storvsc: Rename the context field in hv_storvsc_request
Date: Thu, 12 Jan 2012 12:38:02 -0800
Message-ID: <1326400688-13544-9-git-send-email-kys@microsoft.com>
References: <1326400637-13494-1-git-send-email-kys@microsoft.com>
 <1326400688-13544-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:34403
	"HELO p3plsmtps2ded03-01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751981Ab2ALUwf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2012 15:52:35 -0500
In-Reply-To: <1326400688-13544-1-git-send-email-kys@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, virtualization@lists.osdl.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>

Rename the context field in hv_storvsc_request. As part of this change
fix the type of this field.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/staging/hv/storvsc_drv.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 7c9fa19..0515707 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -275,7 +275,7 @@ struct hv_storvsc_request {
 	struct completion wait_event;
 
 	unsigned char *sense_buffer;
-	void *context;
+	struct storvsc_cmd_request  *cmd;
 	struct hv_multipage_buffer data_buffer;
 
 	struct vstor_packet vstor_packet;
@@ -785,8 +785,7 @@ cleanup:
 
 static void storvsc_command_completion(struct hv_storvsc_request *request)
 {
-	struct storvsc_cmd_request *cmd_request =
-		(struct storvsc_cmd_request *)request->context;
+	struct storvsc_cmd_request *cmd_request = request->cmd;
 	struct scsi_cmnd *scmnd = cmd_request->cmd;
 	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
 	void (*scsi_done_fn)(struct scsi_cmnd *);
@@ -1315,7 +1314,7 @@ static int storvsc_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *scmnd)
 		break;
 	}
 
-	request->context = cmd_request;/* scmnd; */
+	request->cmd = cmd_request;
 
 	vm_srb->port_number = host_dev->port;
 	vm_srb->path_id = scmnd->device->channel;
-- 
1.7.4.1

