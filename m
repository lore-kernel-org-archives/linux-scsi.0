From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] Check for deleted device in scsi_device_online()
Date: Tue, 16 Dec 2008 16:33:51 +0100
Message-ID: <20081216153352.27D4318C75E@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58099 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755930AbYLPPdy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 16 Dec 2008 10:33:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org


scsi_device_online() is not just a negation of SDEV_OFFLINE,
also devices in state SDEV_CANCEL and SDEV_DEL are
actually offline.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 include/scsi/scsi_device.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index e96daf6..63b58d2 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -401,7 +401,9 @@ static inline unsigned int sdev_id(struct scsi_device *sdev)
  */
 static inline int scsi_device_online(struct scsi_device *sdev)
 {
-	return sdev->sdev_state != SDEV_OFFLINE;
+	return (sdev->sdev_state != SDEV_OFFLINE &&
+		sdev->sdev_state != SDEV_CANCEL &&
+		sdev->sdev_state != SDEV_DEL);
 }
 static inline int scsi_device_blocked(struct scsi_device *sdev)
 {
-- 
1.5.3.2

