From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: error processing + rw 6 byte fix
Date: Sat, 27 Aug 2005 04:20:54 -0400
Message-ID: <43102266.7040001@pobox.com>
References: <430994BC.4060102@torque.net> <20050823071338.GA11233@suse.de> <430B1799.1060800@torque.net> <430FDD73.6050200@pobox.com> <430FF537.7010705@torque.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020604080703050800010205"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:41645 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030342AbVH0IVE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 27 Aug 2005 04:21:04 -0400
In-Reply-To: <430FF537.7010705@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net, Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

This is a multi-part message in MIME format.
--------------020604080703050800010205
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Here is the patch I just checked in.

	Jeff




--------------020604080703050800010205
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/scsi/libata-scsi.c b/drivers/scsi/libata-scsi.c
--- a/drivers/scsi/libata-scsi.c
+++ b/drivers/scsi/libata-scsi.c
@@ -630,11 +630,19 @@ static unsigned int ata_scsi_rw_xlat(str
 		tf->lbah = scsicmd[3];
 
 		VPRINTK("ten-byte command\n");
+		if (qc->nsect == 0) /* we don't support length==0 cmds */
+			return 1;
 		return 0;
 	}
 
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
@@ -674,6 +682,8 @@ static unsigned int ata_scsi_rw_xlat(str
 		tf->lbah = scsicmd[7];
 
 		VPRINTK("sixteen-byte command\n");
+		if (qc->nsect == 0) /* we don't support length==0 cmds */
+			return 1;
 		return 0;
 	}
 

--------------020604080703050800010205--
