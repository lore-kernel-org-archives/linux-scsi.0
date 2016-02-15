From: Alan <gnomes@lxorguk.ukuu.org.uk>
Subject: [PATCH] esas2r: Fix array overrun
Date: Mon, 15 Feb 2016 19:01:29 +0000
Message-ID: <20160215190123.11294.22634.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44870 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752229AbcBOTBk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2016 14:01:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: thenzl@redhat.com, linux-scsi@vger.kernel.org

Check the array size *before* dereferencing it with a user provided offset

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/scsi/esas2r/esas2r_ioctl.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_ioctl.c b/drivers/scsi/esas2r/esas2r_ioctl.c
index baf9130..3e84834 100644
--- a/drivers/scsi/esas2r/esas2r_ioctl.c
+++ b/drivers/scsi/esas2r/esas2r_ioctl.c
@@ -1360,14 +1360,15 @@ int esas2r_ioctl_handler(void *hostdata, int cmd, void __user *arg)
 	if (ioctl->header.channel == 0xFF) {
 		a = (struct esas2r_adapter *)hostdata;
 	} else {
-		a = esas2r_adapters[ioctl->header.channel];
-		if (ioctl->header.channel >= MAX_ADAPTERS || (a == NULL)) {
+		if (ioctl->header.channel >= MAX_ADAPTERS ||
+			esas2r_adapters[ioctl->header.channel] == NULL) {
 			ioctl->header.return_code = IOCTL_BAD_CHANNEL;
 			esas2r_log(ESAS2R_LOG_WARN, "bad channel value");
 			kfree(ioctl);
 
 			return -ENOTSUPP;
 		}
+		a = esas2r_adapters[ioctl->header.channel];
 	}
 
 	switch (cmd) {

