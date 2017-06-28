From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 18/47] mptfc: open-code mptfc_block_error_handler() for bus reset
Date: Wed, 28 Jun 2017 10:32:44 +0200
Message-ID: <1498638793-44672-19-git-send-email-hare@suse.de>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53783 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751609AbdF1IdU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 04:33:20 -0400
In-Reply-To: <1498638793-44672-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

When calling bus_reset we have potentially several ports to be
reset, so this patch open-codes the existing mptfc_block_error_handler()
to wait for all ports attached to this bus.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/message/fusion/mptfc.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/message/fusion/mptfc.c b/drivers/message/fusion/mptfc.c
index da9e060..ff886bc 100644
--- a/drivers/message/fusion/mptfc.c
+++ b/drivers/message/fusion/mptfc.c
@@ -263,12 +263,23 @@
 mptfc_bus_reset(struct scsi_cmnd *SCpnt)
 {
 	struct Scsi_Host *shost = SCpnt->device->host;
-	struct fc_rport *rport = starget_to_rport(scsi_target(SCpnt->device));
 	MPT_SCSI_HOST *hd = shost_priv(shost);
+	int channel = SCpnt->device->channel;
+	struct mptfc_rport_info *ri;
 	int rtn;
 
-	rtn = mptfc_block_error_handler(rport);
-	if (rtn == SUCCESS) {
+	list_for_each_entry(ri, &hd->ioc->fc_rports, list) {
+		if (ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED) {
+			VirtTarget *vtarget = ri->starget->hostdata;
+
+			if (!vtarget || vtarget->channel != channel)
+				continue;
+			rtn = fc_block_scsi_eh(ri->rport);
+			if (rtn != 0)
+				break;
+		}
+	}
+	if (rtn == 0) {
 		dfcprintk (hd->ioc, printk(MYIOC_s_DEBUG_FMT
 			"%s.%d: %d:%llu, executing recovery.\n", __func__,
 			hd->ioc->name, shost->host_no,
-- 
1.8.5.6
