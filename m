From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] scsi: missing braces in scsi_extd_sense_format()
Date: Wed, 5 Nov 2014 23:38:37 +0300
Message-ID: <20141105203837.GA26314@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

There were missing curly braces so we always return the first
additional2[] string.

Fixes: 7046d2fa6dbd ('scsi: use sdev as argument for sense code printing')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index a1a7fca..0cf43f6 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1282,9 +1282,10 @@ scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
 	for (i = 0; additional2[i].fmt; i++) {
 		if (additional2[i].code1 == asc &&
 		    ascq >= additional2[i].code2_min &&
-		    ascq <= additional2[i].code2_max)
+		    ascq <= additional2[i].code2_max) {
 			*fmt = additional2[i].fmt;
 			return additional2[i].str;
+		}
 	}
 #endif
 	return NULL;
