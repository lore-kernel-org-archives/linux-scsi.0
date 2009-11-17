From: akpm@linux-foundation.org
Subject: [patch 12/18] st: fix test of value range in st_set_options()
Date: Tue, 17 Nov 2009 14:53:22 -0800
Message-ID: <200911172253.nAHMrMHU019953@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756768AbZKQW4W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2009 17:56:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, osst@riede.org

From: Roel Kluin <roel.kluin@gmail.com>

value cannot logically be less than START and greater than BUFFERSIZE.

#define EXTENDED_SENSE_START  18

// vi include/scsi/scsi_cmnd.h +105
#define SCSI_SENSE_BUFFERSIZE 	96

[akpm@linux-foundation.org: fix warning]
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: Willem Riede <osst@riede.org>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/st.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/st.c~st-fix-test-of-value-range-in-st_set_options drivers/scsi/st.c
--- a/drivers/scsi/st.c~st-fix-test-of-value-range-in-st_set_options
+++ a/drivers/scsi/st.c
@@ -2280,7 +2280,8 @@ static int st_set_options(struct scsi_ta
 	} else if (code == MT_ST_SET_CLN) {
 		value = (options & ~MT_ST_OPTIONS) & 0xff;
 		if (value != 0 &&
-		    value < EXTENDED_SENSE_START && value >= SCSI_SENSE_BUFFERSIZE)
+			(value < EXTENDED_SENSE_START ||
+				value >= SCSI_SENSE_BUFFERSIZE))
 			return (-EINVAL);
 		STp->cln_mode = value;
 		STp->cln_sense_mask = (options >> 8) & 0xff;
_
