From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 4.6-rc2
Date: Wed, 11 May 2016 13:01:40 -0700
Message-ID: <1462996900.2356.65.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50120 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750984AbcEKUBm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2016 16:01:42 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a couple of small fixes: one is a potential uninitialised error
variable in the alua code, potentially causing spurious failures and
the other is a problem caused by the conversion of SCSI to hostwide
tags which resulted in the qla1280 driver always failing in host
initialisation.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Dan Carpenter (1):
      scsi_dh_alua: uninitialized variable in alua_rtpg()

Johannes Thumshirn (1):
      qla1280: Don't allocate 512kb of host tags

And the diffstat:

 drivers/scsi/device_handler/scsi_dh_alua.c | 1 +
 drivers/scsi/qla1280.c                     | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

With full diff below.

James

---

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 8eaed05..a655cf2 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -532,6 +532,7 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 		return SCSI_DH_DEV_TEMP_BUSY;
 
  retry:
+	err = 0;
 	retval = submit_rtpg(sdev, buff, bufflen, &sense_hdr, pg->flags);
 
 	if (retval) {
diff --git a/drivers/scsi/qla1280.c b/drivers/scsi/qla1280.c
index 5d0ec42..634254a 100644
--- a/drivers/scsi/qla1280.c
+++ b/drivers/scsi/qla1280.c
@@ -4214,7 +4214,7 @@ static struct scsi_host_template qla1280_driver_template = {
 	.eh_bus_reset_handler	= qla1280_eh_bus_reset,
 	.eh_host_reset_handler	= qla1280_eh_adapter_reset,
 	.bios_param		= qla1280_biosparam,
-	.can_queue		= 0xfffff,
+	.can_queue		= MAX_OUTSTANDING_COMMANDS,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.use_clustering		= ENABLE_CLUSTERING,
