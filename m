From: Alan <gnomes@lxorguk.ukuu.org.uk>
Subject: [PATCH RESEND] scsi: Fix crash on out of memory with MAC SCSI
Date: Tue, 17 Dec 2013 15:06:47 +0000
Message-ID: <20131217150620.29475.79924.stgit@alan.etchedpixels.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44661 "EHLO
	alan.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753733Ab3LQPHJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Dec 2013 10:07:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org

From: Alan <alan@gnomes@lxorguk.ukuu.org.uk>

Missing check on scsi_register

Signed-off-by: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
---
 drivers/scsi/mac_scsi.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/mac_scsi.c b/drivers/scsi/mac_scsi.c
index 8580757..f5cdc68 100644
--- a/drivers/scsi/mac_scsi.c
+++ b/drivers/scsi/mac_scsi.c
@@ -260,6 +260,8 @@ int __init macscsi_detect(struct scsi_host_template * tpnt)
     /* Once we support multiple 5380s (e.g. DuoDock) we'll do
        something different here */
     instance = scsi_register (tpnt, sizeof(struct NCR5380_hostdata));
+    if (instance == NULL)
+	return 0;
 
     if (macintosh_config->ident == MAC_MODEL_IIFX) {
 	mac_scsi_regp  = via1+0x8000;

