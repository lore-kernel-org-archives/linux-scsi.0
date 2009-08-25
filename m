From: Roel Kluin <roel.kluin@gmail.com>
Subject: [PATCH] st: fix test of value range in st_set_options()
Date: Tue, 25 Aug 2009 15:14:12 +0200
Message-ID: <4A93E3A4.2020605@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:48674 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbZHYNPR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Aug 2009 09:15:17 -0400
Received: by ewy2 with SMTP id 2so402341ewy.17
        for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2009 06:15:18 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

value cannot logically be less than START and greater than BUFFERSIZE.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
// vi drivers/scsi/st.h +215
#define EXTENDED_SENSE_START  18

// vi include/scsi/scsi_cmnd.h +105
#define SCSI_SENSE_BUFFERSIZE 	96

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index b33d042..cb79e39 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -2280,7 +2280,7 @@ static int st_set_options(struct scsi_tape *STp, long options)
 	} else if (code == MT_ST_SET_CLN) {
 		value = (options & ~MT_ST_OPTIONS) & 0xff;
 		if (value != 0 &&
-		    value < EXTENDED_SENSE_START && value >= SCSI_SENSE_BUFFERSIZE)
+		    value < EXTENDED_SENSE_START || value >= SCSI_SENSE_BUFFERSIZE)
 			return (-EINVAL);
 		STp->cln_mode = value;
 		STp->cln_sense_mask = (options >> 8) & 0xff;
