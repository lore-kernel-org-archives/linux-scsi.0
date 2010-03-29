From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] sd: spurious error messages in READ_CAPACITY(16)
Date: Mon, 29 Mar 2010 09:29:24 +0200
Message-ID: <20100329072924.1DB8F337C3@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:46651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab0C2H3Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Mar 2010 03:29:25 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	by mx2.suse.de (Postfix) with ESMTP id 30C8A86A2E
	for <linux-scsi@vger.kernel.org>; Mon, 29 Mar 2010 09:29:24 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org


sd always tries to submit a READ_CAPACITY(16) CDB,
regardless whether the host actually supports it.
queuecommand() will then return DID_ABORT, which is
not qualified enough to detect the true cause here.
So better check in sd_try_rc16 first if the cdblen
is supported.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9c8f4b5..1962bea 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1484,6 +1484,8 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 static int sd_try_rc16_first(struct scsi_device *sdp)
 {
+	if (sdp->host->max_cmd_len < 16)
+		return 0;
 	if (sdp->scsi_level > SCSI_SPC_2)
 		return 1;
 	if (scsi_device_protection(sdp))
