From: Doug Ledford <dledford@redhat.com>
Subject: [PATCH] sym53c8xx PPR negotiation fix
Date: Wed, 29 Oct 2003 12:07:01 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067447221.3112.336.camel@compaq.xsintricity.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Bb0ziU4aM2kDNuZqU+ni"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50192 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S262076AbTJ2RH5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2003 12:07:57 -0500
List-Id: linux-scsi@vger.kernel.org
To: Marcelo Tosatti <marcelo@conectiva.com.br>, James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi mailing list <linux-scsi@vger.kernel.org>


--=-Bb0ziU4aM2kDNuZqU+ni
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Marcelo,

I've verified that this problem still exists as of 2.4.23-pre8.  The
sym53c8xx driver doesn't bother to check that a device should support
PPR negotiation messages before attempting to use them on Ultra160
controllers.  PPR negotiations were added to the SCSI-3 standard (they
are required to negotiate Ultra160 or higher speeds) and should be
limited to SCSI-3 devices.  For back compatibility some modern devices
that support Ultra160 or above speeds still need to report themselves as
SCSI-2 devices.  Those devices are required to signal that they know
about PPR messages by setting the DT bit in the device's INQUIRY data. 
This patch adds that check.

Why add this check?  Two reasons.  One, correctness.  It's the right
thing to do.  Two, it fixes a bug with some DVD drives (the drives don't
report that they support PPR, but if the driver tries to use PPR then
the drive will accept it and respond in kind, but the drive fails to
actually properly set the sync speed after the PPR negotiation is
complete and the bus locks up as a result).

I haven't checked if this is applicable to 2.6 as well.  James?

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


--=-Bb0ziU4aM2kDNuZqU+ni
Content-Disposition: attachment; filename=sym.patch
Content-Type: text/x-patch; name=sym.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

diff -urNp linux-5420/drivers/scsi/sym53c8xx.c linux-5430/drivers/scsi/sym53c8xx.c
--- linux-5420/drivers/scsi/sym53c8xx.c
+++ linux-5430/drivers/scsi/sym53c8xx.c
@@ -11981,6 +11981,19 @@ static lcb_p ncr_setup_lcb (ncb_p np, u_
 		inq_byte7 |= INQ7_SYNC;
 
 	/*
+	**	Don't do PPR negotiations on SCSI-2 devices unless
+	**	they set the DT bit (0x04) in byte 57 of the INQUIRY
+	**	return data.
+	*/
+	if (((inq_data[2] & 0x07) < 3) && (inq_data[4] < 53 ||
+					   !(inq_data[56] & 0x04))) {
+		if (tp->minsync < 10)
+			tp->minsync = 10;
+		if (tp->usrsync < 10)
+			tp->usrsync = 10;
+	}
+
+	/*
 	**	Prepare negotiation if SIP capabilities have changed.
 	*/
 	tp->inq_done = 1;

--=-Bb0ziU4aM2kDNuZqU+ni--

