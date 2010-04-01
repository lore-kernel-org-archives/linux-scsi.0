From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH] sd: retry read_capacity on UNIT_ATTENTION
Date: Thu, 01 Apr 2010 15:44:28 +0200
Message-ID: <20100401134428.7E4D1337C5@ochil.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:48671 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253Ab0DANo3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2010 09:44:29 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.221.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx1.suse.de (Postfix) with ESMTP id CBA6994746
	for <linux-scsi@vger.kernel.org>; Thu,  1 Apr 2010 15:44:28 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org


Hazard testing uncovered yet another bug in sd. Under heavy
reset activity the retry counter might be exhausted and
the command will be returned with sense UNIT_ATTENTION/0x29/00
(POWER ON, RESET, OR BUS DEVICE RESET OCCURRED). In those
cases we should just increase the retry counter again,
retrying one more to clear up this Unit Attention state.

Signed-off-by: Hannes Reinecke <hare@suse.de>

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 1962bea..7d75a21 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1454,8 +1454,15 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 		if (media_not_present(sdkp, &sshdr))
 			return -ENODEV;
 
-		if (the_result)
+		if (the_result) {
 			sense_valid = scsi_sense_valid(&sshdr);
+			if (sense_valid &&
+			    sshdr.sense_key == UNIT_ATTENTION &&
+			    sshdr.asc = 0x29 && sshdr.asq == 0x00)
+			    /* Device reset might occur several times,
+			     * give it one more chance */
+			    retries++;
+		}
 		retries--;
 
 	} while (the_result && retries);
