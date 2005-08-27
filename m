From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: error processing + rw 6 byte fix
Date: Fri, 26 Aug 2005 23:26:43 -0400
Message-ID: <430FDD73.6050200@pobox.com>
References: <430994BC.4060102@torque.net> <20050823071338.GA11233@suse.de> <430B1799.1060800@torque.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090904010706020204080405"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:46764 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030287AbVH0D0w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Aug 2005 23:26:52 -0400
In-Reply-To: <430B1799.1060800@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Jens Axboe <axboe@suse.de>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

This is a multi-part message in MIME format.
--------------090904010706020204080405
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Does the attached look OK to everybody?

	Jeff




--------------090904010706020204080405
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/scsi/libata-scsi.c b/drivers/scsi/libata-scsi.c
--- a/drivers/scsi/libata-scsi.c
+++ b/drivers/scsi/libata-scsi.c
@@ -581,6 +581,12 @@ static unsigned int ata_scsi_rw_xlat(str
 
 	if (scsicmd[0] == READ_6 || scsicmd[0] == WRITE_6) {
 		qc->nsect = tf->nsect = scsicmd[4];
+		if (!qc->nsect) {
+			qc->nsect = 256;
+			if (lba48)
+				tf->hob_nsect = 1;
+		}
+
 		tf->lbal = scsicmd[3];
 		tf->lbam = scsicmd[2];
 		tf->lbah = scsicmd[1] & 0x1f; /* mask out reserved bits */

--------------090904010706020204080405--
